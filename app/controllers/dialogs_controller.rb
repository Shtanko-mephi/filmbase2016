class DialogsController < ApplicationController
  before_action :check_authentication
  before_action :check_banned, only: [:new, :create]
  before_action :set_dialog, only: [:show, :edit, :update, :destroy]


  # GET /dialogs
  # GET /dialogs.json
  def index
    @dialogs = Dialog.joins(:users).where('users.id' => @current_user.id).ordering.page(params[:page]).per(10)
    #@dialogs = Dialog.joins(:users).where(:users => {:user_id => @current_user.id}).ordering.page(params[:page]).per(10)
  end

  # GET /dialogs/1
  # GET /dialogs/1.json
  def show
    @message = Message.new
    @messages = @dialog.messages.includes(:user)
  end

  # GET /dialogs/new
  def new
    @dialog = Dialog.new
    @message = @dialog.messages.new
  end

  # GET /dialogs/1/edit
  def edit
  end

  # POST /dialogs
  # POST /dialogs.json
  def create
    @dialog = Dialog.new(dialog_params)
    @dialog.messages[0].update(:user_id => @current_user.id)
    if !(@dialog.users.any? {|user| user.id == @current_user.id})
      @dialog.users << @current_user
    end
    if @dialog.save
      redirect_to @dialog, notice: 'Диалог создан'
    else
      render :new
    end
  end

  # PATCH/PUT /dialogs/1
  # PATCH/PUT /dialogs/1.json
  def update
    respond_to do |format|
      if @dialog.update(dialog_params)
        format.html { redirect_to @dialog, notice: 'Dialog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dialog }
      else
        format.html { render :edit }
        format.json { render json: @dialog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dialogs/1
  # DELETE /dialogs/1.json
  def destroy
    @dialog.destroy
    respond_to do |format|
      format.html { redirect_to dialogs_url, notice: 'Dialog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dialog
      @dialog = Dialog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dialog_params
      attrs = [:title, :user_tokens, messages_attributes: [:content]]
      params.require(:dialog).permit(attrs)
    end
end
