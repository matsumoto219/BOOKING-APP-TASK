class ReservationsController < ApplicationController
  # CREATE
  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  # CREATE
  def create
    @room = Room.find(reservation_params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)

    if @reservation.save
      redirect_to reservations_path, notice: "予約しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # READ
  def index
    @reservations = current_user.reservations.includes(:room)
  end

  # READ
  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  private

  def reservation_params
    params.require(:reservation).permit(:room_id, :check_in, :check_out, :people, :total_price)
  end
end
