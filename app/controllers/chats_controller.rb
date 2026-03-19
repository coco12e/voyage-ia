class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show destroy]

  def create
    @trip = current_user.trips.find(params[:trip_id])
    @chat = @trip.chats.new(title: "Untitled", user: current_user)

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @trip.chats.where(user: current_user)
      render "trips/show", status: :unprocessable_entity
    end
  end

  def show
    @message = Message.new
  end

  def destroy
    @trip = @chat.trip
    @chat.destroy
    redirect_to trip_path(@trip), status: :see_other
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end
end
