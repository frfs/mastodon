# frozen_string_literal: true

module RebfavConcern
  extend ActiveSupport::Concern

  REBFAV_ACCOUNTS_LIMIT = 400

  def set_reblogged_accounts
    @reblogged_accounts = Account
      .includes(:statuses, :account_stat)
      .references(:statuses)
      .merge(Status
          .where(reblog_of_id: @status.id)
          .where(visibility: [:public, :unlisted])
          .order(created_at: :desc)
          .limit(REBFAV_ACCOUNTS_LIMIT))
      .reverse
  end

  def set_favourited_accounts
    @favourited_accounts = Account
      .includes(:favourites, :account_stat)
      .references(:favourites)
      .where(favourites: { status_id: @status.id })
      .merge(Favourite
        .order(created_at: :desc)
        .limit(REBFAV_ACCOUNTS_LIMIT))
      .reverse
  end
end
