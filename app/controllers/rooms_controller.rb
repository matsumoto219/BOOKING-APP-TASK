class RoomsController < ApplicationController
  before_action :authenticate_user!

  # READ
  def index
  end

  # READ
  def show
  end

  # CREATE
  def new
    @room = Room.new
  end

  # CREATE
  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to rooms_path, notice: "施設を登録しました"
    else
      render :new
    end
  end

  # UPDATE
  def edit
  end

  # UPDATE
  def update
  end

  # DELETE
  def destroy
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image_name)
  end
end
