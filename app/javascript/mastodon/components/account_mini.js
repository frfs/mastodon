import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Avatar from './avatar';
import ImmutablePureComponent from 'react-immutable-pure-component';

export default class AccountMini extends ImmutablePureComponent {

  static propTypes = {
    account: ImmutablePropTypes.map.isRequired,
  };

  render () {
    const { account } = this.props;
    if (!account) {
      return <div />;
    }
    return (
      <div className='mini-avatar'>
        <div className='account__avatar-wrapper' title={account.get('acct')}>
          <Avatar account={account} size={24} inline />
        </div>
      </div>
    );
  }

}
