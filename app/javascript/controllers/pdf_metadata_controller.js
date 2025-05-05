import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "title", "author", "pages"]

  connect() {
    console.log("PDFMetadataController connected");
  }

  extractMetadata() {
    const pdfFile = this.fileInputTarget.files[0];
    if (!pdfFile) return;

    const formData = new FormData();
    formData.append('pdf_file', pdfFile);

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    fetch('/books/extract_pdf_metadata', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    })
      .then(response => response.json())
      .then(data => {
        if (data.success && data.metadata) {
          if (data.metadata.title && this.hasTitleTarget) this.titleTarget.value = data.metadata.title;
          if (data.metadata.author && this.hasAuthorTarget) this.authorTarget.value = data.metadata.author;
          if (data.metadata.pages && this.hasPagesTarget) this.pagesTarget.value = data.metadata.pages;
        } else {
          console.log('No metadata or error in response:', data.error || 'Unknown error');
        }
      })
      .catch(error => {
        console.error('Error extracting PDF metadata:', error);
      });
  }
}
