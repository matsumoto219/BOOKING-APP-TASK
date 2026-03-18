class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_correct_user, only: [ :edit, :update, :destroy ]

  # READ
  def index
    @rooms = current_user.rooms
  end

  # READ
  def show
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
    if @room.update(room_params)
      redirect_to room_path(@room), notice: "施設情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "施設を削除しました"
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def ensure_correct_user
    redirect_to rooms_path, alert: "権限がありません" unless @room.user == current_user
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
