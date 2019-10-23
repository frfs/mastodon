# == Schema Information
#
# Table name: keyword_subscribes
#
#  id         :bigint(8)        not null, primary key
#  account_id :bigint(8)
#  keyword    :string           not null
#  ignorecase :boolean          default(TRUE)
#  regexp     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class KeywordSubscribe < ApplicationRecord
  belongs_to :account, inverse_of: :keyword_subscribes, required: true

  before_validation :prepare_keyword

  validates :keyword, presence: true
  validate :validate_keyword_subscribes_limit, on: :create
  validate :validate_keyword_regexp_syntax
  validate :validate_keyword_uniqueness_in_account, on: :create

  scope :without_local_followed, ->(account) { where.not(account: account.followers.local).where.not(account: account.subscribers.local) }

  def match?(text)
    to_regexp&.match?(text)
  end

  def to_regexp
    Regexp.new(regexp ? keyword : "(?<![\/\.#])(#{keyword.split(',').map do |k|
      sb = k =~ /\A[A-Za-z0-9]/ ? '\b' : ''
      eb = k =~ /[A-Za-z0-9]\z/ ? '\b' : ''

      /(?m#{ignorecase ? 'i': ''}x:#{sb}#{Regexp.escape(k)}#{eb})/
    end.join('|')})(?![\/\.])", ignorecase)
  end

  private

  def prepare_keyword
    keyword&.gsub!(/^[\s,]*(.*?)[\s,]*$/, '\1').gsub!(/[\s,]+/, ',') unless regexp
  end

  def validate_keyword_regexp_syntax
    return unless regexp

    begin
      Regexp.compile(keyword, ignorecase)
    rescue RegexpError => exception
      errors.add(:base, I18n.t('keyword_subscribes.errors.regexp', message: exception.message))
    end
  end

  def validate_keyword_subscribes_limit
    errors.add(:base, I18n.t('keyword_subscribes.errors.limit')) if account.keyword_subscribes.count >= 10
  end

  def validate_keyword_uniqueness_in_account
    errors.add(:base, I18n.t('keyword_subscribes.errors.duplicate')) if account.keyword_subscribes.find_by(keyword: keyword)
  end
end