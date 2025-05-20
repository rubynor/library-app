import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];

  connect() {
    this.setupEventListeners();
  }

  setupEventListeners() {
    this.setupCheckboxListeners();
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
    this.updateCategoriesParam(urlParams);
    this.navigateToUrl(urlParams);
  }


  getUrlParams() {
    return new URLSearchParams(window.location.search);
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


  navigateToUrl(urlParams) {
    window.location.href = `?${urlParams.toString()}`;
  }
}