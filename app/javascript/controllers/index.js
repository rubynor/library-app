// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Make sure the import path and controller name match your file structure
import BookReviewController from "./book_review_controller";
import BookSearchController from "./book_search_controller";
import PdfMetadataController from "./pdf_metadata_controller";

application.register("book-review", BookReviewController);
application.register("book-search", BookSearchController);
application.register("pdf-metadata", PdfMetadataController);