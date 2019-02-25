# frozen_string_literal: true

class Api::V1::PollsController < Api::BaseController
  before_action -> { doorkeeper_authorize! :write, :'write:statuses' }
  before_action :require_user!

  respond_to :json

  def create
    @poll = current_account.polls.create!(poll_params)
    render json: @poll, serializer: REST::PollSerializer
  end

  private

  def poll_params
    params.permit(:options, :multiple, :hide_totals, :expires_at)
  end
end
