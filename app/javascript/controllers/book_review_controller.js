import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["drawer", "cover", "title", "addedBy", "rating", "pages", "ratingCount", "reviewCount", "description", "bookId"];

  open(event) {
    const bookId = event.currentTarget.dataset.bookId;

    fetch(`/book/${bookId}/details`, {
      headers: { "Accept": "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        this.coverTarget.src = data.cover_image_url;
        this.titleTarget.textContent = data.title;
        this.addedByTarget.textContent = data.user_email;
        this.ratingTarget.textContent = data.average_rating || "0.0";
        this.pagesTarget.textContent = data.pages || "0";
        this.ratingCountTarget.textContent = data.rating_count || "0";
        this.reviewCountTarget.textContent = data.review_count || "0";
        this.descriptionTarget.textContent = data.description;
        this.bookIdTarget.value = data.id;

        // Open the drawer
        document.getElementById("review-drawer").checked = true;
      });
  }
}
