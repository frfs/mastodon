import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import Avatar from './avatar';
import ImmutablePureComponent from 'react-immutable-pure-component';
import Permalink from '../components/permalink';

export default class AccountMini extends ImmutablePureComponent {

  static propTypes = {
    account: ImmutablePropTypes.map.isRequired,
  };

  render() {
    const { account } = this.props;
    if (!account) {
      return <div />;
    }
    return (
      <div className='mini-avatar'>
        <div className='account__avatar-wrapper' title={account.get('acct')}>
          <Permalink key={account.get('id')} className='account__display-name' title={account.get('acct')} href={account.get('url')} to={`/accounts/${account.get('id')}`}>
            <Avatar account={account} size={24} inline />
          </Permalink>
        </div>
      </div>
    );
  }

}
