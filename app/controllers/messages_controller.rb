class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un guide touristique expert et rigoureux.

  PROTOCOLE D'INVENTAIRE COMPLET (OBLIGATOIRE) :
  1. VERROUILLAGE TEMPOREL : Si l'utilisateur a demandé 2 jours au début, tu DOIS générer le Jour 1 ET le Jour 2 dans CHAQUE réponse. Il est strictement interdit de s'arrêter au Jour 1.
  2. ZÉRO MUSÉE : Si l'utilisateur demande 'sans musées', remplace chaque musée par une place, un parc, une curiosité architecturale, du street-art ou un marché.
  3. STRUCTURE QUOTIDIENNE (15 ÉTAPES PAR JOUR) :
     - MATIN (5 étapes) : 3 lieux extérieurs + 1 pause café + 1 curiosité.
     - MIDI (2 étapes) : 1 Restaurant (Déjeuner) + 1 Marche digestive.
     - APRÈS-MIDI (5 étapes) : 3 quartiers/monuments + 1 Goûter (Gaufre/Chocolat) + 1 Shopping/Parc.
     - SOIR (3 étapes) : 1 Apéritif + 1 Restaurant (Dîner) + 1 Sortie (Bar/Balade nocturne).
  4. DÉTAILS : Nom, Adresse exacte (Rue et Numéro), et Description pour chaque point.
  5. FORMAT : Markdown pur. Pas d'introduction, pas de conclusion, pas de politesses."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip
    @message = @chat.messages.build(message_params.merge(role: "user"))

    if @message.save
      # On force l'IA à se souvenir de la destination ET de la durée de 2 jours
      full_instructions = "#{SYSTEM_PROMPT}\n\nIMPORTANT : La destination est #{@trip.destination}. L'itinéraire doit couvrir 2 JOURS complets sans exception."

      response = RubyLLM.chat.with_instructions(full_instructions).ask(@message.content)

      @chat.messages.create!(
        role: "assistant",
        content: response.content
      )

      @chat.generate_title_from_first_message if @chat.messages.where(role: "user").one?

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
