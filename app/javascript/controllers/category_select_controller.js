import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    this.token = document.querySelector(
      'meta[name="csrf-token"]'
    ).content;
  }

  updateChart(e) {
    const transaction_id = e.target.dataset.id
    const category_id = e.currentTarget.value

    fetch("/transactions/" + transaction_id + "/update_chart", {
      body: JSON.stringify(
        {
          transaction: {
            category_id: category_id
          }
        }
      ),
      method: "PATCH",
      credentials: "include",
      dataType: "script",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-type": "application/json"
       },
    }).then (response => response.text())
    .then(html => Turbo.renderStreamMessage(html));
  }
}