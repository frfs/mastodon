# frozen_string_literal: true
# == Schema Information
#
# Table name: list_accounts
#
#  id         :bigint(8)        not null, primary key
#  list_id    :bigint(8)        not null
#  account_id :bigint(8)        not null
#  follow_id  :bigint(8)        not null
#

class ListAccount < ApplicationRecord
  belongs_to :list
  belongs_to :account
  belongs_to :follow

  validates :account_id, uniqueness: { scope: :list_id }

  before_validation :set_follow

  scope :followed_lists, ->(account) { ListAccount.includes(:follow).where(follows: { account_id: account.id }).select(:list_id).uniq }

  private

  def set_follow
    self.follow = Follow.find_by(account_id: list.account_id, target_account_id: account.id)
  end
end
