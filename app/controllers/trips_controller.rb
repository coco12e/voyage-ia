class TripsController < ApplicationController
  before_action :set_trip, only: %i[show edit update destroy]

  def index
    @trips = current_user.trips.order(created_at: :desc)
  end

  def show
  end

  def new
    @trip = current_user.trips.build
  end

  def create
    @trip = current_user.trips.build(trip_params)

    if @trip.save
      redirect_to @trip, notice: "Voyage vers #{@trip.destination} créé avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Voyage mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip.destroy!
    redirect_to trips_path, notice: "Conversation supprimée."
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to trips_path, alert: "Voyage introuvable."
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :number_of_travelers)
  end
end
