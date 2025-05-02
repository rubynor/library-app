// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// PDF metadata extraction functionality
document.addEventListener('turbo:load', function() {
  console.log("Turbo load event fired, setting up PDF listener");
  
  const pdfFileInput = document.querySelector('input[type="file"][accept="application/pdf"]');
  
  if (pdfFileInput) {
    
    pdfFileInput.addEventListener('change', function(event) {
      
      if (this.files && this.files[0]) {
        const pdfFile = this.files[0];
        
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
        .then(response => {
          return response.json();
        })
        .then(data => {
          if (data.success && data.metadata) {
            const titleField = document.querySelector('input[name="book[title]"]');
            const authorField = document.querySelector('input[name="book[author]"]');
            const pagesField = document.querySelector('input[name="book[pages]"]');
            
            if (data.metadata.title && titleField) {
              titleField.value = data.metadata.title;
            }
            
            if (data.metadata.author && authorField) {
              authorField.value = data.metadata.author;
            }
            
            if (data.metadata.pages && pagesField) {
              pagesField.value = data.metadata.pages;
            }
          } else {
            console.log('No metadata or error in response:', data.error || 'Unknown error');
          }
        })
        .catch(error => {
          console.error('Error extracting PDF metadata:', error);
        });
      }
    });
  } else {
    console.log("PDF file input not found on this page");
  }
});