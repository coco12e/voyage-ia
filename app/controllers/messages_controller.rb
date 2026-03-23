class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un guide touristique expert.

  LOIS IMPÉRATIVES (CONTEXTE ET VOLUME) :
  1. MÉMOIRE DE LA DURÉE : Tu dois TOUJOURS respecter la durée de voyage mentionnée au tout début de la conversation (ex: si l'utilisateur a dit 2 jours ou 7 jours, CHAQUE réponse doit couvrir TOUTE cette durée). Interdiction de réduire à 1 jour lors d'une modification.
  2. DENSITÉ STRICTE : Si l'utilisateur demande un nombre d'activités (ex: '5 activités'), cela signifie 5 activités PAR CRÉNEAU (Matin, Après-midi, Soir) ou au minimum 10 à 15 par jour. Ne réduis jamais la liste totale.
  3. STRUCTURE DE GRILLE : Divise chaque jour en :
     - Matin (Plusieurs lieux + pause café)
     - Midi (Déjeuner + marche digestive)
     - Après-midi (Plusieurs lieux + shopping/parc)
     - Soir (Apéritif + Dîner + Sortie nocturne)
  4. REMPLACEMENT LOGIQUE : Si l'utilisateur dit 'sans musées' ou 'sans tel lieu', remplace chaque élément par une nouvelle suggestion pour garder le MÊME nombre total d'activités.
  5. DÉTAILS OBLIGATOIRES : Chaque point doit avoir : Nom, Adresse postale exacte, et Description complète.
  6. FORMAT : Réponds uniquement en Markdown. Pas d'introduction ('Voici votre itinéraire'), pas de conclusion."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip
    @message = @chat.messages.build(message_params.merge(role: "user"))

    if @message.save
      # On rappelle systématiquement la destination dans les instructions
      full_instructions = "#{SYSTEM_PROMPT}\n\nDestination actuelle : #{@trip.destination}"

      # L'historique des messages est envoyé ici pour que l'IA voit qu'au début, tu avais demandé 2 jours.
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
