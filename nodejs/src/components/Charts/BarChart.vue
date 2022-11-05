<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  name: "BarChart",
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