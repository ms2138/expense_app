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
      plugins: {
        ...this.defaultPlugins,
        ...this.pluginsValue
      }
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
    return {}
  }

  get defaultPlugins() {
    return {}
  }
}