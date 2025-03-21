import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  previewImages() {
    this.previewTarget.innerHTML = "" 
    const files = this.inputTarget.files

    Array.from(files).forEach(file => {
      const reader = new FileReader()

      reader.onload = (e) => {
        const img = document.createElement("img")
        img.src = e.target.result
        img.className = "w-24 h-24 object-cover rounded-lg shadow-md mr-2"
        this.previewTarget.appendChild(img)
      }

      reader.readAsDataURL(file)
    })
  }
}
