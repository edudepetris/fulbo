class TeamsController < ApplicationController
  respond_to :html

  before_filter :verfify_team, only: [:new]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.create_team(params[:team])
    if @team.save
      flash[:success] = "Successfully created team."
    end
    respond_with @team
  end

  def show
    @team = Team.find(params[:id])
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    flash[:notice] = "Successfully destroyed team."
    respond_with(@team)
  end

  private

    def verfify_team
      redirect_to teams_path, notice: "you has a team" unless current_user.team.blank?
    end

end