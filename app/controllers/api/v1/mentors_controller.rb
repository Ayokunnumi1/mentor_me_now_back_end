class Api::V1::MentorsController < ApplicationController
  # Before action callback to set the mentor for the show action
  before_action :set_mentor, only: [:show]

  # GET /api/v1/mentors
  # Action to list all mentors
  def index
    @mentors = Mentor.where(remove: false)
    render json: @mentors
  end

  # List all removed mentors
  # GET /api/v1/removed_mentors
  def removed_mentors
    @mentors = Mentor.where(remove: true)
    render json: @mentors
  end

  # Show details of a specific mentor
  # GET /api/v1/mentors/:id
  def show
    render json: @mentor
  end

  # Create a new mentor
  # POST /api/v1/mentors
  def create
    @mentor = Mentor.new(mentor_params)

    if @mentor.save
      render json: @mentor, status: :created
    else
      render json: @mentor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/mentors/:id
  # Action to delete a mentor
  def destroy
    @mentor = Mentor.find(params[:id])
    if @mentor.destroy
      render json: { message: 'Mentor successfully deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete mentor' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Mentor not found' }, status: :not_found
  end

  # PATCH/PUT /api/v1/mentors/:id/remove_mentor
  def remove_mentor
    @mentor = Mentor.find(params[:id])
    @mentor.update(remove: !@mentor.remove)
    render json: { message: 'Mentor marked for removal' }, status: :ok
  end

  private

  # Private method to set the mentor using the id parameter
  def set_mentor
    @mentor = Mentor.find(params[:id])
  end

  # Private method to whitelist mentor parameters
  def mentor_params
    params.require(:mentor).permit(:name, :occupation, :about, :hourly_fee, :year_of_experience, :location, :skills,
                                   :photo_url)
  end
end
