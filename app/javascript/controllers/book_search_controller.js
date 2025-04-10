import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "sort", "order", "checkbox"];

  connect() {
    this.setupEventListeners();
  }

  setupEventListeners() {
    this.setupInputListeners();
    this.setupButtonListeners();
    this.setupSortListeners();
    this.setupOrderListeners();
    this.setupCheckboxListeners();
  }

  setupInputListeners() {
    this.inputTargets.forEach(input => {
      input.addEventListener("keypress", (event) => {
        if (event.key === "Enter") {
          event.preventDefault();
          this.performSearch();
        }
      });
    });
  }

  setupButtonListeners() {
    if (this.hasButtonTarget) {
      this.buttonTargets.forEach(button => {
        button.addEventListener("click", () => this.performSearch());
      });
    }
  }

  setupSortListeners() {
    if (this.hasSortTarget) {
      this.sortTargets.forEach(sortDropdown => {
        sortDropdown.addEventListener("change", () => this.performSort());
      });
    }
  }

  setupOrderListeners() {
    if (this.hasOrderTarget) {
      this.orderTargets.forEach(orderRadio => {
        orderRadio.addEventListener("change", () => this.performSort());
      });
    }
  }

  setupCheckboxListeners() {
    if (this.hasCheckboxTarget) {
      this.checkboxTargets.forEach(checkbox => {
        checkbox.addEventListener("change", () => this.performSearch());
      });
    }
  }

  performSearch() {
    const urlParams = this.getUrlParams();
    this.updateQueryParam(urlParams);
    this.updateCategoriesParam(urlParams);
    this.navigateToUrl(urlParams);
  }

  performSort() {
    const urlParams = this.getUrlParams();
    this.updateSortParams(urlParams);
    this.navigateToUrl(urlParams);
  }
  
  getUrlParams() {
    return new URLSearchParams(window.location.search);
  }

  updateQueryParam(urlParams) {
    const query = this.inputTargets[0]?.value.trim();
    
    if (query) {
      urlParams.set("query", query);
    } else {
      urlParams.delete("query");
    }
  }

  updateCategoriesParam(urlParams) {
    const selectedCategories = this.getSelectedCategories();
    
    if (selectedCategories.length > 0) {
      urlParams.set("categories", selectedCategories.join(","));
    } else {
      urlParams.delete("categories");
    }
  }

  getSelectedCategories() {
    return this.checkboxTargets
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value);
  }

  updateSortParams(urlParams) {
    const selectedSort = this.sortTargets.find(radio => radio.checked)?.value;
    const selectedOrder = this.orderTargets.find(radio => radio.checked)?.value;

    if (selectedSort) {
      urlParams.set("sort_by", selectedSort);
    }
 
    if (selectedOrder) {
      urlParams.set("sort_order", selectedOrder);
    }
  }
  
  navigateToUrl(urlParams) {
    window.location.href = `?${urlParams.toString()}`;
  }
}