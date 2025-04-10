import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "drawer", "cover", "title", "addedBy", "pages", "rating",
    "reviewCount", "description", "bookId", "ratingStars",
    "reviewForm", "userReviewSection", "userReviewContent", "userReviewRating",
    "allReviewsSection", "allReviewsList"
  ];
  
  connect() {
    this.resetDrawer();
  }

  resetDrawer() {
    const drawerCheckbox = document.getElementById("review-drawer");
    if (drawerCheckbox) {
      drawerCheckbox.checked = false;
    }
  }

  open(event) {
    if (this.shouldSkipOpen(event)) {
      return;
    }
    
    const bookId = event.currentTarget.dataset.bookId;
    this.fetchBookDetails(bookId);
  }

  shouldSkipOpen(event) {
    return event.currentTarget.classList.contains('card') && window.innerWidth >= 768;
  }

  fetchBookDetails(bookId) {
    fetch(`/books/${bookId}/details`, {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => {
      this.updateBookDetails(data);
      this.loadReviewData(bookId);
      this.openDrawer();
    });
  }

  updateBookDetails(data) {
    this.updateCoverImage(data.cover_url);
    this.updateTextContent(data);
    this.updateRatingDisplay(data.rating_count || 0);
    this.bookIdTarget.value = data.id;
  }

  updateCoverImage(coverUrl) {
    if (this.hasCoverTarget) {
      this.coverTarget.src = coverUrl || "";
    }
  }

  updateTextContent(data) {
    this.titleTarget.textContent = data.title;
    this.addedByTarget.textContent = data.added_by;
    this.pagesTarget.textContent = data.pages || "0";
    this.reviewCountTarget.textContent = data.review_count || "0";
    this.descriptionTarget.textContent = data.description;
  }

  updateRatingDisplay(ratingCount) {
    const rating = Math.round(ratingCount);
    this.ratingTarget.textContent = rating.toFixed(0);
    this.renderStars(rating);
  }

  loadReviewData(bookId) {
    this.checkExistingReview(bookId);
    this.fetchAllReviews(bookId);
  }

  openDrawer() {
    document.getElementById("review-drawer").checked = true;
  }

  fetchAllReviews(bookId) {
    fetch(`/books/${bookId}/all_reviews`, {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => this.displayAllReviews(data));
  }
  
  displayAllReviews(data) {
    const container = this.allReviewsListTarget;
    container.innerHTML = "";

    if (data.reviews.length === 0) {
      this.displayNoReviewsMessage(container);
      return;
    }

    data.reviews.forEach(review => {
      container.appendChild(this.createReviewElement(review));
    });
  }

  displayNoReviewsMessage(container) {
    container.innerHTML = "<p class='text-sm text-gray-500'>No reviews yet.</p>";
  }

  createReviewElement(review) {
    const reviewDiv = document.createElement("div");
    reviewDiv.classList.add("p-4", "bg-white", "rounded-lg", "shadow");

    reviewDiv.innerHTML = `
      <div class="flex justify-between items-center mb-2">
        <p class="font-semibold">${review.user}</p>
        <div class="rating rating-sm">
          ${this.renderStaticStars(review.rating)}
        </div>
      </div>
      <p class="text-gray-700">${review.content}</p>
    `;

    return reviewDiv;
  }
  
  renderStaticStars(rating) {
    let stars = "";
    for (let i = 1; i <= 5; i++) {
      stars += `<input type="radio" class="mask mask-star-2 bg-orange-400" disabled ${i <= rating ? "checked" : ""} />`;
    }
    return stars;
  }
  
  stopPropagation(event) {
    event.stopPropagation();
  }

  checkExistingReview(bookId) {
    fetch(`/books/${bookId}/user_review`, {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => this.updateUserReviewSection(data));
  }

  updateUserReviewSection(data) {
    if (data.review) {
      this.showExistingReview(data.review);
    } else {
      this.showReviewForm();
    }
  }

  showExistingReview(review) {
    this.reviewFormTarget.classList.add('hidden');
    this.userReviewSectionTarget.classList.remove('hidden');
    this.userReviewContentTarget.textContent = review.content;
    this.renderUserRating(review.rating);
  }

  showReviewForm() {
    this.reviewFormTarget.classList.remove('hidden');
    this.userReviewSectionTarget.classList.add('hidden');
  }

  renderStars(rating) {
    this.renderStarsInContainer(this.ratingStarsTarget, rating);
  }

  renderUserRating(rating) {
    this.renderStarsInContainer(this.userReviewRatingTarget, rating);
  }

  renderStarsInContainer(container, rating) {
    container.innerHTML = '';
    for (let i = 1; i <= 5; i++) {
      const star = this.createStarElement(i, rating);
      container.appendChild(star);
    }
  }

  createStarElement(position, rating) {
    const star = document.createElement('input');
    star.type = 'radio';
    star.disabled = true;
    star.classList.add('mask', 'mask-star-2', 'bg-orange-400');
    star.ariaLabel = `${position} star`;
    if (rating >= position) {
      star.checked = true;
    }
    return star;
  }
}