import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button"];

  connect() {
    this.inputTargets.forEach(input => {
      input.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {
          event.preventDefault();
          this.performSearch(input);
        }
      });
    });

    if (this.hasButtonTarget) {
      this.buttonTargets.forEach(button => {
        button.addEventListener("click", () => {
          const associatedInput = button.closest('.input').querySelector('input[type="search"]');
          this.performSearch(associatedInput);
        });
      });
    }
  }

  performSearch(inputElement) {
    const query = inputElement.value.trim();
    const urlParams = new URLSearchParams(window.location.search);
    const sortBy = urlParams.get("sort_by") || "";

    urlParams.set("query", query);

    if (sortBy) {
      urlParams.set("sort_by", sortBy);
    }

    window.location.href = `?${urlParams.toString()}`;
  }
}