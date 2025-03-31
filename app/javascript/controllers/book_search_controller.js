import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "sort", "order", "checkbox"];

  connect() {
    this.inputTargets.forEach(input => {
      input.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {
          event.preventDefault();
          this.performSearch();
        }
      });
    });

    if (this.hasButtonTarget) {
      this.buttonTargets.forEach(button => {
        button.addEventListener("click", () => {
          this.performSearch();
        });
      });
    }

    if (this.hasSortTarget) {
      this.sortTargets.forEach(sortDropdown => {
        sortDropdown.addEventListener("change", () => {
          this.performSort();
        });
      });
    }

    if (this.hasOrderTarget) {
      this.orderTargets.forEach(orderRadio => {
        orderRadio.addEventListener("change", () => {
          this.performSort();
        });
      });
    }

    if (this.hasCheckboxTarget) {
      this.checkboxTargets.forEach(checkbox => {
        checkbox.addEventListener("change", () => {
          this.performSearch();
        });
      });
    }
  }

  performSearch() {
    const query = this.inputTargets[0]?.value.trim();
    const urlParams = new URLSearchParams(window.location.search);

    if (query) {
      urlParams.set("query", query);
    } else {
      urlParams.delete("query");
    }

    const selectedCategories = this.checkboxTargets
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);

    if (selectedCategories.length > 0) {
      urlParams.set("categories", selectedCategories.join(","));
    } else {
      urlParams.delete("categories");
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
