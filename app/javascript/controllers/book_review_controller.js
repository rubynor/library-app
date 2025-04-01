import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["drawer", "cover", "title", "addedBy", "pages", "rating", "reviewCount", "description", "bookId", "ratingStars"];

  open(event) {
    const bookId = event.currentTarget.dataset.bookId;

    fetch(`/books/${bookId}/details`, {
      headers: { "Accept": "application/json" }
    })
      .then(response => response.json())
      .then(data => {

        if (this.hasCoverTarget) {
          this.coverTarget.src = data.cover_url || "";
        }

        this.titleTarget.textContent = data.title;
        this.addedByTarget.textContent = data.added_by;
        this.pagesTarget.textContent = data.pages || "0";

        const rating = Math.round((data.rating_count || 0));
        this.ratingTarget.textContent = rating.toFixed(0);

        this.renderStars(rating);

        this.reviewCountTarget.textContent = data.review_count || "0";
        this.descriptionTarget.textContent = data.description;
        this.bookIdTarget.value = data.id;

        document.getElementById("review-drawer").checked = true;
      });
  }

  renderStars(rating) {
    const starsContainer = this.ratingStarsTarget;
    starsContainer.innerHTML = '';

    for (let i = 1; i <= 5; i++) {
      const star = document.createElement('input');
      star.type = 'radio';
      star.disabled = true;
      star.classList.add('mask', 'mask-star-2', 'bg-orange-400');
      star.ariaLabel = `${i} star`;
      if (rating >= i) {
        star.checked = true;
      }
      starsContainer.appendChild(star);
    }
  }
}
