# frozen_string_literal: true

class Api::V1::Timelines::PublicController < Api::BaseController
  before_action :require_user!, only: [:show], if: :require_auth?
  after_action :insert_pagination_headers, unless: -> { @statuses.empty? }

  def show
    @statuses = load_statuses
    render json: @statuses, each_serializer: REST::StatusSerializer, relationships: StatusRelationshipsPresenter.new(@statuses, current_user&.account_id)
  end

  private

  def require_auth?
    !Setting.timeline_preview
  end

  def load_statuses
    cached_public_statuses_page
  end

  def cached_public_statuses_page
    cache_collection_paginated_by_id(
      public_statuses,
      Status,
      limit_param(DEFAULT_STATUSES_LIMIT),
      params_slice(:max_id, :since_id, :min_id)
    )
  end

  def public_statuses
    statuses = public_timeline_statuses

    if truthy_param?(:only_media)
      statuses.joins(:media_attachments).group(:id)
    else
      statuses
    end
  end

  def public_timeline_statuses
    if truthy_param?(:local)
      Status.as_tag_timeline(Rails.configuration.x.default_hashtag_id, current_account, false)
    elsif params[:domain].present?
      Status.as_domain_timeline(current_account, params[:domain])
    else
      Status.as_public_timeline(current_account, truthy_param?(:remote) ? :remote : truthy_param?(:local))
    end
  end

  def insert_pagination_headers
    set_pagination_headers(next_path, prev_path)
  end

  def pagination_params(core_params)
    params.slice(:local, :remote, :limit, :only_media).permit(:local, :remote, :limit, :only_media).merge(core_params)
  end

  def next_path
    api_v1_timelines_public_url pagination_params(max_id: pagination_max_id)
  end

  def prev_path
    api_v1_timelines_public_url pagination_params(min_id: pagination_since_id)
  end

  def pagination_max_id
    @statuses.last.id
  end

  def pagination_since_id
    @statuses.first.id
  end
end
