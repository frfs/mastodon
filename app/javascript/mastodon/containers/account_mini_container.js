import { connect } from 'react-redux';
import { injectIntl } from 'react-intl';
import { makeGetAccount } from '../selectors';
import AccountMini from '../components/account_mini';

const makeMapStateToProps = () => {
  const getAccount = makeGetAccount();

  const mapStateToProps = (state, props) => ({
    accounts: props.accountIds.map(id => getAccount(state, id)),
  });

  return mapStateToProps;
};

export default injectIntl(connect(makeMapStateToProps)(AccountMini));
