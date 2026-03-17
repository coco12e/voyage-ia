class ChatsController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])

    @chat = Chat.new(title: "Untitled")
    @chat.trip = @trip
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @trip.chats.where(user: current_user)
      render "trip/show"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end
end
