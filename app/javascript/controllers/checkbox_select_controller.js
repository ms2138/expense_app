import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit", "child"];
  
  checked() {
    if (this.childTargets.map(x => x.checked).includes(true)) {
      if (this.submitTarget.classList.contains("hidden")) {
        this.submitTarget.classList.remove('hidden')
      }
    } else {
      this.submitTarget.classList.add('hidden')
    }
  }
}