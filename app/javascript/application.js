// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener('turbo:load', function() {

    const radioButtons = document.querySelectorAll('.nombre-radio');
  
    radioButtons.forEach(function(radioButton) {
      radioButton.addEventListener('change', function() {
        // Elimina la clase 'seleccionado' de todos los radio buttons
        radioButtons.forEach(function(rb) {
          rb.parentElement.classList.remove('seleccionado');
        });
  
        // Agrega la clase 'seleccionado' al radio button seleccionado
        if (this.checked) {
          this.parentElement.classList.add('seleccionado');
        }
      });
    });
  });
