import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "drawer", "cover", "title", "addedBy", "pages", "rating",
    "reviewCount", "description", "bookId", "ratingStars",
    "reviewForm", "userReviewSection", "userReviewContent", "userReviewRating"
  ];

  connect() {
    const drawerCheckbox = document.getElementById("review-drawer");
    if (drawerCheckbox) {
      drawerCheckbox.checked = false;
    }
  }

  open(event) {
    if (event.currentTarget.classList.contains('card') && window.innerWidth >= 768) {
      return;
    }
    
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
      this.checkExistingReview(bookId);
      document.getElementById("review-drawer").checked = true;
    });
  }

  stopPropagation(event) {
    event.stopPropagation();
  }

  checkExistingReview(bookId) {
    fetch(`/books/${bookId}/user_review`, {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => {
      if (data.review) {
        this.reviewFormTarget.classList.add('hidden');
        this.userReviewSectionTarget.classList.remove('hidden');
        this.userReviewContentTarget.textContent = data.review.content;
        this.renderUserRating(data.review.rating);
      } else {
        this.reviewFormTarget.classList.remove('hidden');
        this.userReviewSectionTarget.classList.add('hidden');
      }
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

  renderUserRating(rating) {
    const starsContainer = this.userReviewRatingTarget;
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