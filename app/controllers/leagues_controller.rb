class LeaguesController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_user!, only: [:new, :edit, :update]
  before_filter :verify_has_sport_center, only: [:new, :edit, :create, :update]
  before_filter :verify_edit_permission, only: [:edit, :update]

  def new
    @league = League.new
    @league.build_point_system
  end

  def create
    @sport_center = current_user.sport_center
    @league = @sport_center.leagues.build(params[:league])
    if @league.save
      flash[:success] = t('flash.league', message: t('flash.created'), name: @league.name)
    end
      respond_with @league
  end

  def show
    @league = League.find(params[:id])
    if request.path != league_path(@league)
      redirect_to @league, status: :moved_permanently
    end
    @point = @league.point_system
    @teams = @league.teams
    @request_inscription = RequestInscription.new()
  end

  def index
    @leagues = League.all
  end

  def edit
    @league = League.find(params[:id])
    @inscription_requests = @league.inscription_requests.where(status: :waiting)
                                                        .map(&:requester)
    @teams = @league.teams
  end

  def update
    @league = League.find(params[:id])
    if @league.update_attributes(params[:league])
      flash[:notice] = t('flash.league',
                         message: t('flash.updated'),
                         name: @league.name)
    else
      @inscription_requests = @league.inscription_requests.where(status: :waiting)
                                                          .map(&:requester)
      @teams = @league.teams
    end
    respond_with @league
  end

  def destroy
    @league = League.find(params[:id])
    @league.destroy
    flash[:notice] = t('flash.league', message: t('flash.destroyed'), name: @league.name)
    respond_with(@league)
  end

  private
    def verify_has_sport_center
      redirect_to(leagues_path, notice: t('flash.permission_league')) if current_user.sport_center.blank?
    end

    def verify_edit_permission
      @league = League.find(params[:id])
      sport_center = current_user.sport_center
      redirect_to(leagues_path, notice: t('flash.permission_league')) unless @league.organizer == sport_center
    end
end
