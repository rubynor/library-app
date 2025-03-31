import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "sort", "order"];

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
          this.performSort();
        });
      });
    }

    // Add event listeners for sort order (ascending/descending)
    if (this.hasOrderTarget) {
      this.orderTargets.forEach(orderRadio => {
        orderRadio.addEventListener("change", () => {
          this.performSort();
        });
      });
    }
  }

  performSearch(inputElement) {
    const query = inputElement.value.trim();
    const urlParams = new URLSearchParams(window.location.search);
    
    if (query) {
      urlParams.set("query", query);
    } else {
      urlParams.delete("query");
    }

    window.location.href = `?${urlParams.toString()}`;
  }

  performSort() {
    const urlParams = new URLSearchParams(window.location.search);
    const selectedSort = this.sortTargets.find(radio => radio.checked)?.value;
    const selectedOrder = this.orderTargets.find(radio => radio.checked)?.value;

    if (selectedSort) {
      urlParams.set("sort_by", selectedSort);
    }
    
    if (selectedOrder) {
      urlParams.set("sort_order", selectedOrder);
    }

    window.location.href = `?${urlParams.toString()}`;
  }
}
