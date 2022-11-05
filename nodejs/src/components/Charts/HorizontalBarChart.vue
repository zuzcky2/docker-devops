<script>
import { HorizontalBar } from 'vue-chartjs'
export default {
  extends: HorizontalBar,
  name: "HorizontalBarChart",
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