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
    @keyword = params[:keyword]
    @rooms = Room.all

    if @keyword.present?
      @rooms = @rooms.where(
        "address LIKE ? OR name LIKE ? OR description LIKE ?",
        "%#{@keyword}%",
        "%#{@keyword}%",
        "%#{@keyword}%"
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
    params.require(:room).permit(:name, :description, :price, :address, :image_name)
  end
end
