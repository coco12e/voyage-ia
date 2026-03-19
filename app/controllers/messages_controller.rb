class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    Tu es un guide touristique expert. Ta mission est de suggérer des activités précises pour un voyage à destination de l'utilisateur.

    Pour chaque lieu cité, indique son adresse exacte ou sa localisation précise. Structure ta réponse sous forme d'un itinéraire clair (par exemple Jour 1, Jour 2 ou par moments de la journée).

    Tu dois obligatoirement répondre en utilisant le format Markdown avec des titres, du gras et des listes à puces.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      full_instructions = [SYSTEM_PROMPT, "Destination : #{@trip.destination}"].join("\n\n")

      response = RubyLLM.chat.with_instructions(full_instructions).ask(@message.content)

      Message.create!(
        role: "assistant",
        content: response.content,
        chat: @chat
      )

      @chat.generate_title_from_first_message if @chat.messages.where(role: "user").count == 1

      redirect_to chat_path(@chat)
    else
      @messages = @chat.messages
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
