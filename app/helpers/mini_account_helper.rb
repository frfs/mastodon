# frozen_string_literal: true

module MiniAccountHelper
  def mini_account(account, path: nil)
    content_tag(:div, class: 'mini-avatar') do
      content_tag(:div, class: 'account__avatar-wrapper') do
        link_to(path || ActivityPub::TagManager.instance.url_for(account), class: 'account__display-name') do
          image_tag(
            full_asset_url(current_account&.user&.setting_auto_play_gif ? account.avatar_original_url : account.avatar_static_url),
            class: 'account__avatar account__avatar-inline',
          )
        end
      end
    end
  end
end
