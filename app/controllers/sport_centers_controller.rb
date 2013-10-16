  class SportCentersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!, :check_ownership, except: [:show, :index]

  def index
    @sport_centers = SportCenter.all
  end

  def edit
    @sport_center = SportCenter.find(params[:id])
  end

  def update
    if @sport_center.update_attributes(params[:sport_center])
      flash[:notice] = t('flash.sport_center', message: t('flash.updated'))
      if params[:sport_center][:avatar].present? and (params[:sport_center][:remove_avatar] != "1")
         #render :crop para que seria????
      else
        redirect_to sport_center_path(@sport_center), notice: "Successfully updated profile."
      end
    end
    respond_with @sport_center
  end

  def show
    @sport_center = SportCenter.find(params[:id])
  end

  private

  def check_ownership
    other_sport_center = SportCenter.find(params[:id])
    @sport_center = current_user.sport_center

    unless other_sport_center && @sport_center.id == other_sport_center.id
      redirect_to sport_centers_path,
                  notice: t('.flash.permission_sport_center')
    end
  end
end
