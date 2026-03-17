class MessagesController < ApplicationController
  SYSTEM_PROMPT = " Tu es un guide touristique.\n\n je suis une personne qui a envie de voyager.\n\n suggère moi les activités à faire pour un voyage donné.\n\n repond de façon concise en markdown."
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @trip = @chat.trip

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

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
