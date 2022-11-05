export default {
  available: (value) => {
    value = typeof value === 'string' ? value.trim() : value
    return value !== null && typeof value !== 'undefined' && value !== '';
  },
  reform: (value, basic = null) => {
    value = typeof value === 'string' ? value.trim() : value
    return (value !== null && typeof value !== 'undefined' && value !== '') ? value : basic;
  }
}