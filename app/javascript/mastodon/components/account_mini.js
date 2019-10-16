import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import Avatar from './avatar';
import Permalink from './permalink';
import ImmutablePureComponent from 'react-immutable-pure-component';
import Icon from 'mastodon/components/icon';
import classNames from 'classnames';

export default class AccountMini extends ImmutablePureComponent {

  static propTypes = {
    reblog: PropTypes.bool,
    accounts: ImmutablePropTypes.list.isRequired,
  };

  render () {
    const { reblog, accounts } = this.props;

    if (!accounts || accounts.size < 1) {
      return <div />;
    }

    const avatars = accounts.map(account => (
      <Permalink
        key={account.get('id')}
        className='account__avatar'
        title={account.get('acct')}
        href={account.get('url')}
        to={`/accounts/${account.get('id')}`}
      >
        <div className='account__avatar-wrapper'>
          <Avatar account={account} size={18} inline />
        </div>
      </Permalink>
    ));

    return (
      <div className='mini-avatars'>
        <div className={classNames('title', reblog ? 'reblog' : 'favourite')}>
          <Icon id={reblog ? 'retweet' : 'star'} />
        </div>
        <div className='avatars'>
          {avatars}
        </div>
      </div>
    );
  }

}
