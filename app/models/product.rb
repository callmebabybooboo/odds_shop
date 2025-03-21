class Product < ApplicationRecord
    before_validation :set_status_based_on_stock

    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    belongs_to :category
    validates :category_id, presence: true

    has_many_attached :images
    validates :images, presence: { message: "ต้องแนบรูปอย่างน้อย 1 รูป" }
    validate :validate_image_file
    validate :validate_images_count

    private

    def set_status_based_on_stock
        self.status = stock.to_i > 0 ? "พร้อมส่ง" : "สินค้าหมด"
    end

    def validate_image_file
      images.each do |image|
        unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif image/webp])
          errors.add(:images, "รูปภาพต้องเป็นไฟล์ประเภท PNG, JPG, JPEG, GIF, หรือ WEBP เท่านั้น")
        end
        if image.byte_size > 10.megabytes
          errors.add(:images, "ไฟล์รูปภาพต้องมีขนาดไม่เกิน 10MB")
        end
      end
    end

    def validate_images_count
      if images.count > 5
        errors.add(:images, "รูปภาพต้องไม่เกิน 5 รูป")
      end
    end
end
