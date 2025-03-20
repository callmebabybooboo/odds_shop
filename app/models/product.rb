class Product < ApplicationRecord
    before_validation :set_status_based_on_stock

    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    belongs_to :category
    validates :category_id, presence: true

    has_many_attached :images
    validate :image_or_url_present
    validate :validate_image_file
    validate :validate_image_urls

    private

    def set_status_based_on_stock
        self.status = stock.to_i > 0 ? "พร้อมส่ง" : "สินค้าหมด"
    end

    def image_or_url_present
      unless images.attached? || image_urls.present?
        errors.add(:base, "ต้องมีรูปภาพอย่างน้อย 1 รูป")
      end
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

    def validate_image_urls
      return if image_urls.blank?

      valid_image_extensions = %w[jpg jpeg png gif webp]

      Array(image_urls).each do |url|
        unless url.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
          errors.add(:image_urls, "ต้องเป็นลิงก์ที่ถูกต้องและขึ้นต้นด้วย http หรือ https")
        end

        unless valid_image_extensions.any? { |ext| url.downcase.end_with?(".#{ext}") }
          errors.add(:image_urls, "ต้องเป็นลิงก์ที่ชี้ไปยังไฟล์รูปภาพ (png, jpg, jpeg, gif, webp) เท่านั้น")
        end
      end
    end
end
