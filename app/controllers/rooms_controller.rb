class RoomsController < ApplicationController
  before_action :authenticate_user!

  # READ
  def index
    @rooms = current_user.rooms
  end

  # READ
  def show
    @room = Room.find(params[:id])
  end

  # READ
  def search
    @area_keyword = params[:area_keyword]
    @freeword = params[:freeword]
    @rooms = Room.all

    if @area_keyword.present?
      @rooms = @rooms.where("address LIKE ?", "%#{@area_keyword}%")
    end

    if @freeword.present?
      @rooms = @rooms.where(
        "name LIKE ? OR description LIKE ?",
        "%#{@freeword}%",
        "%#{@freeword}%"
      )
    end
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
      render :new, status: :unprocessable_entity
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
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
