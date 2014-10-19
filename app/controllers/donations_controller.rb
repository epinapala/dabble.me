class DonationsController < ApplicationController
  before_action :authenticate_user!
  before_filter :require_permission

  def index
    @donations = Donation.all.order("id DESC").order("date DESC")
  end

  def new
    @donation = Donation.new
  end

  def create

    if params[:user_email].present?
      user = User.find_by_email(params[:user_email])
      params[:donation][:user_id] = user.id if user.present?
    end

    @donation = Donation.create(entry_params)

    if @donation.save
      flash[:notice] = "Donation added successfully!"
      redirect_to donations_path
    else
      render 'new'
    end
  end

  def edit
    @donation = Donation.find(params[:id])
  end

  def update
    @donation = Donation.find(params[:id])
    if params[:user_email].present?
      user = User.find_by_email(params[:user_email])
      params[:donation][:user_id] = user.id if user.present?
    end

    if @donation.update(entry_params)
      flash[:notice] = "Donation successfully updated!"
      redirect_to donations_path
    else
      render 'edit'
    end
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
    flash[:notice] = "Donation deleted successfully."
    redirect_to donations_path
  end

  private
    def entry_params
      params.require(:donation).permit(:amount, :date, :user_id,  :comments)
    end

    def require_permission
      unless current_user.is_admin?
        flash[:alert] = "Not authorized"
        redirect_to past_entries_path
      end
    end
end
