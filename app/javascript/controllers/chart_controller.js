//
// https://github.com/stimulus-components/stimulus-chartjs
//
import { Controller } from "@hotwired/stimulus";
import Chart from 'chart.js/auto';

export default class extends Controller {
  connect() {
    const element = this.hasCanvasTarget ? this.canvasTarget : this.element

    this.chart = new Chart(element.getContext('2d'), {
      type: this.type || 'line',
      data: this.data,
      options: this.options,
      plugins: this.plugins
    })
  }

  disconnect () {
    this.chart.destroy()
    this.chart = undefined
  }
}