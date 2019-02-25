# frozen_string_literal: true

# == Schema Information
#
# Table name: poll_votes
#
#  id         :bigint(8)        not null, primary key
#  account_id :bigint(8)
#  poll_id    :bigint(8)
#  choice     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PollVote < ApplicationRecord
  belongs_to :account
  belongs_to :poll, inverse_of: :votes

  validates :choice, presence: true
end
