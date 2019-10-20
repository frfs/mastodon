# frozen_string_literal: true

module MiniAccountHelper
  def mini_account(account, size: 24, path: nil)
    content_tag(:div, class: 'mini-avatar') do
      content_tag(:div, class: 'account__avatar-wrapper') do
        link_to(path || ActivityPub::TagManager.instance.url_for(account), class: 'account__display-name') do
          content_tag(:div, '', class: 'account__avatar account__avatar-inline', style: "width: #{size}px; height: #{size}px; background-size: #{size}px #{size}px; background-image: url(#{full_asset_url(current_account&.user&.setting_auto_play_gif ? account.avatar_original_url : account.avatar_static_url)})")
        end
      end
    end
  end
end
