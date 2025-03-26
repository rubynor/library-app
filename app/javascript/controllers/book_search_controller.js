import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "sort"];

  connect() {
    // Add event listeners for search input
    this.inputTargets.forEach(input => {
      input.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {
          event.preventDefault();
          this.performSearch(input);
        }
      });
    });

    // Add event listeners for search button
    if (this.hasButtonTarget) {
      this.buttonTargets.forEach(button => {
        button.addEventListener("click", () => {
          const associatedInput = button.closest('.input').querySelector('input[type="search"]');
          this.performSearch(associatedInput);
        });
      });
    }

    // Add event listeners for sort dropdowns
    if (this.hasSortTarget) {
      this.sortTargets.forEach(sortDropdown => {
        sortDropdown.addEventListener("change", () => {
          this.performSort(sortDropdown);
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

  performSort(sortDropdown) {
    const sortValue = sortDropdown.value;
    const urlParams = new URLSearchParams(window.location.search);
    const query = urlParams.get("query") || "";

    urlParams.set("sort_by", sortValue);
    if (query) {
      urlParams.set("query", query);
    }

    window.location.href = `?${urlParams.toString()}`;
  }
}