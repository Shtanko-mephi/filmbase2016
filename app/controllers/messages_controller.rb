class MessagesController < ApplicationController
  before_action :check_authentication
  before_action :check_banned, only: [:new, :create]
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @dialog =  Dialog.find(message_params[:dialog_id])
    if @dialog && @dialog.users.any? {|user| user.id == @current_user.id}
      if !@dialog.users.any? {|user| user != @current_user}
        redirect_to dialog_path(message_params[:dialog_id]), notice: 'Нельзя отправлять сообщение самому себе'
        return
      end
      @message = Message.new(message_params)
      @message.update(:user_id => @current_user.id)
      if (@message.save)
        redirect_to dialog_path(message_params[:dialog_id]), notice: 'Сообщение отправлено'
      else
        redirect_to dialog_path(message_params[:dialog_id])
      end
    else
      flash[:danger] = 'Доступ запрещен'
      redirect_to root_path
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:dialog_id, :content)
    end
end
