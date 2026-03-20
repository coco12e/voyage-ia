class MessagesController < ApplicationController
  SYSTEM_PROMPT = "Tu es un guide touristique.\n\nje suis une personne qui a envie de voyager.\n\nsuggère moi les activités à faire pour un voyage donné.\n\nPour chaque lieu cité, donne l'adresse exacte.\n\nStructure ta réponse sous forme d'un itinéraire jour par jour.\n\nrepond de façon concise en markdown."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      full_instructions = "#{SYSTEM_PROMPT}\n\nDestination : #{@trip.destination}"

      response = ruby_llm_chat.with_instructions(full_instructions).ask(@message.content)

      Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat
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
en
