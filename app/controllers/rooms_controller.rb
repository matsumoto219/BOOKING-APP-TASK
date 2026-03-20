class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :search ]
  before_action :set_room, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_correct_user, only: [ :edit, :update, :destroy ]

  # READ
  def index
    @rooms = current_user.rooms
  end

  # READ
  def search
    @area_keyword = params[:area_keyword]
    @freeword = params[:freeword]
    @city = params[:city]
    @rooms = Room.all

    @rooms = filter_by_city(@rooms, @city) if @city.present?

    if @area_keyword.present?
      @rooms = @rooms.where("address LIKE ?", "%#{@area_keyword}%")
    end

    if @freeword.present?
      @rooms = @rooms.where(
        "name LIKE ? OR description LIKE ? OR address LIKE ?",
        "%#{@freeword}%",
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

  def filter_by_city(rooms, city)
    keywords =
      case city
      when "tokyo"
        [ "東京", "tokyo" ]
      when "osaka"
        [ "大阪", "osaka" ]
      when "kyoto"
        [ "京都", "kyoto" ]
      when "sapporo"
        [ "札幌", "sapporo" ]
      else
        []
      end

    return rooms if keywords.empty?

    conditions = keywords.map { "address LIKE ?" }.join(" OR ")
    values = keywords.map { |keyword| "%#{keyword}%" }
    rooms.where(conditions, *values)
  end
end
