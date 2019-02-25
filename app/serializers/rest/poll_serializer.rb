# frozen_string_literal: true

class REST::PollSerializer < ActiveModel::Serializer
  attributes :id, :expires_at, :multiple

  has_many :loaded_options, key: :options, serializer: OptionSerializer

  def id
    object.id.to_s
  end

  class OptionSerializer < ActiveModel::Serializer
    attributes :title, :votes
  end
end
