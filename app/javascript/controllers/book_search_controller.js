import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "sort"];

  connect() {
    if (this.hasButtonTarget) {
      this.buttonTarget.addEventListener("click", this.performSearch.bind(this));
    }

    if (this.hasInputTarget) {
      this.inputTarget.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {
          event.preventDefault();
          this.performSearch();
        }
      });
    }

    if (this.hasSortTarget) {
      this.sortTarget.addEventListener("change", this.updateSort.bind(this));
    }
  }

  performSearch() {
    const query = this.inputTarget.value.trim();
    const urlParams = new URLSearchParams(window.location.search);
    const sortBy = urlParams.get("sort_by") || "";

    urlParams.set("query", query);

    if (sortBy) {
      urlParams.set("sort_by", sortBy);
    }

    window.location.href = `?${urlParams.toString()}`;
  }

  updateSort() {
    const sortBy = this.sortTarget.value;
    const urlParams = new URLSearchParams(window.location.search);
    const currentQuery = urlParams.get("query");

    urlParams.set("sort_by", sortBy);

    if (currentQuery) {
      urlParams.set("query", currentQuery);
    }

    window.location.href = `?${urlParams.toString()}`;
  }
}
