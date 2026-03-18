class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy ]

  # CREATE
  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(
      check_in: params[:check_in],
      check_out: params[:check_out],
      people: params[:people]
    )
  end

  # 予約確認
  def confirm
    @room = Room.find(reservation_params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room = @room

    if @reservation.valid?
      @stay_days = @reservation.stay_days
      @total_price = @reservation.calculated_total_price
    else
      @room = Room.find(reservation_params[:room_id])
      render :new, status: :unprocessable_entity
    end
  end

  # CREATE
  def create
    @room = Room.find(reservation_params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.total_price = @reservation.calculated_total_price

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
  end

  # UPDATE
  def edit
    @room = @reservation.room
  end

  # UPDATE
  def update
    @room = @reservation.room
    @reservation.assign_attributes(reservation_params)
    @reservation.total_price = @reservation.calculated_total_price

    if @reservation.save
      redirect_to reservations_path, notice: "予約を変更しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "予約を削除しました"
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end


  def reservation_params
    params.require(:reservation).permit(:room_id, :check_in, :check_out, :people)
  end
end
