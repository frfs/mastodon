import { connect } from 'react-redux';
import ColumnsArea from '../components/columns_area';

const mapStateToProps = state => ({
  columns: state.getIn(['settings', 'columns']),
  isModalOpen: !!state.get('modal').modalType,
  swipeableThreshold: state.getIn(['compose', 'swipeable_threshold']),
});

export default connect(mapStateToProps, null, null, { forwardRef: true })(ColumnsArea);
