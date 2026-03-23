class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un guide touristique expert.

  RÈGLES D'OR (NE JAMAIS DÉROGER) :
  1. CONSTANCE DE LA DURÉE : Si l'utilisateur a initialement demandé 7 jours, l'itinéraire DOIT TOUJOURS faire 7 jours. Interdiction de réduire la durée lors d'une modification.
  2. STRUCTURE PAR CRÉNEAU : Chaque jour doit obligatoirement avoir trois sections : 'Matin', 'Midi' et 'Soir'.
  3. REMPLACEMENT OBLIGATOIRE : Si l'utilisateur demande 'sans musées' ou retire une activité, remplace chaque élément supprimé par une nouvelle activité (monument, parc, quartier, vue panoramique, marché). Le nombre total d'activités doit rester IDENTIQUE.
  4. FOCUS SOIRÉE : Propose systématiquement des activités spécifiques pour le 'Soir' (bars à bières, illuminations, quartiers animés, spectacles, dîners thématiques).
  5. DÉTAILS SYSTÉMATIQUES : Pour CHAQUE lieu, fournis :
     - Nom de l'activité
     - Adresse postale complète et exacte
     - Description détaillée de l'intérêt du lieu.
  6. FORMAT : Markdown strict. Pas de phrases d'introduction ni de conclusion."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip
    @message = @chat.messages.build(message_params.merge(role: "user"))

    if @message.save
      full_instructions = "#{SYSTEM_PROMPT}\n\nDestination : #{@trip.destination}"

      # L'historique permet à l'IA de se souvenir qu'on était sur une base de 7 jours
      response = RubyLLM.chat.with_instructions(full_instructions).ask(@message.content)

      @chat.messages.create!(
        role: "assistant",
        content: response.content
      )

      @chat.generate_title_from_first_message if @chat.messages.where(role: "user").count == 1

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
