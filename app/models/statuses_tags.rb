# frozen_string_literal: true
# == Schema Information
#
# Table name: statuses_tags
#
#  status_id  :bigint(8)        not null
#  tag_id     :bigint(8)        not null
#

class StatusesTags < ApplicationRecord
  belongs_to :status
  belongs_to :tag

  validates :status_id, uniqueness: { scope: :tag_id }

  before_validation :set_follow

  scope :tags_status_ids, ->(tags) { where(tag_id: tags) }

  scope :paginate_by_max_id, ->(limit, max_id = nil, since_id = nil) {
    query = order(arel_table[:status_id].desc).limit(limit)
    query = query.where(arel_table[:status_id].lt(max_id)) if max_id.present?
    query = query.where(arel_table[:status_id].gt(since_id)) if since_id.present?
    query
  }

  # Differs from :paginate_by_max_id in that it gives the results immediately following min_id,
  # whereas since_id gives the items with largest id, but with since_id as a cutoff.
  # Results will be in ascending order by id.
  scope :paginate_by_min_id, ->(limit, min_id = nil) {
    query = reorder(arel_table[:status_id]).limit(limit)
    query = query.where(arel_table[:status_id].gt(min_id)) if min_id.present?
    query
  }

  scope :paginate_by_id, ->(limit, options = {}) {
    if options[:min_id].present?
      paginate_by_min_id(limit, options[:min_id]).reverse
    else
      paginate_by_max_id(limit, options[:max_id], options[:since_id])
    end
  }
end
