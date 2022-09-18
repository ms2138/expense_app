//
// https://github.com/stimulus-components/stimulus-chartjs
//
import { Controller } from "@hotwired/stimulus";
import Chart from 'chart.js/auto';

export default class extends Controller {
  static values = {
    type: String,
    data: Object,
    options: Object,
    plugins: Object
  }

  connect() {
    const element = this.hasCanvasTarget ? this.canvasTarget : this.element

    this.chart = new Chart(element.getContext('2d'), {
      type: this.typeValue || 'line',
      data: this.chartData,
      options: {
        ...this.defaultOptions,
        ...this.optionsValue
      },
      plugins: [
        this.defaultPlugins,
        this.pluginsValue
      ]
    })
  }

  disconnect () {
    this.chart.destroy()
    this.chart = undefined
  }

  get chartData () {
    if (!this.hasDataValue) {
      console.warn('Chart requires JSON data')
    }

    return this.dataValue
  }

  get defaultOptions() {
    return {
      maintainAspectRatio: false,
      plugins: {
        tooltip: {
          callbacks: {
            label: function(context) {
              let formatConfig = {
                style: "currency",
                currency: "USD",
                currencySign: 'accounting',
              }
              let label = context.label + ": " + 
                          new Intl.NumberFormat('en-US', formatConfig).format(context.formattedValue.replace(/,/g, ""))
              return label;
           }
          }
        },
      },
    }
  }

  get defaultPlugins() {
    return {
      afterDraw: function(chart, args, options) {
        const { datasets } = chart.data;

        if (datasets[0].data.length < 1) {
          let ctx = chart.ctx;
          let width = chart.width;
          let height = chart.height;

          chart.clear();
          ctx.save();

          ctx.textAlign = 'center';
          ctx.textBaseline = 'middle';
          ctx.font = "30px Arial";
          ctx.fillStyle = "#adadad";
          ctx.fillText('No data to display', width / 2, height / 2);
          ctx.restore();
        }
      }
    }
  }
}