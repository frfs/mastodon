# frozen_string_literal: true

class Api::V1::Polls::VotesController < Api::BaseController
  include Authorization

  before_action -> { doorkeeper_authorize! :write, :'write:statuses' }
  before_action :require_user!
  before_action :set_poll

  respond_to :json

  def create
    ApplicationRecord.transaction do
      vote_params[:choices].each do |choice|
        @poll.votes.create!(account: current_account, choice: choice)
      end
    end

    render json: @poll, serializer: REST::PollSerializer
  end

  private

  def set_poll
    @poll = Poll.attached.find(params[:id])
    authorize @poll.status, :show?
  rescue Mastodon::NotPermittedError
    raise ActiveRecord::RecordNotFound
  end

  def vote_params
    params.permit(choices: [])
  end
end
