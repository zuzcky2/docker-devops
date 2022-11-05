<script>
import { Scatter } from 'vue-chartjs'
export default {
  extends: Scatter,
  name: "ScatterChart",
  props: {
    chartdata: {
      type: Object,
      default: null
    },
    options: {
      type: Object,
      default: null
    }
  },
  mounted () {
    this.renderChart(this.chartdata, this.options)
  },
  methods: {
    reloadChart () {
      this.renderChart(this.chartdata, this.options)
    }
  }
}
</script>