class Product < ApplicationRecord
    before_validation :set_status_based_on_stock

    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    belongs_to :category
    validates :category_id, presence: true

    has_many_attached :image
    # validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }
    # validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
    validate :image_or_url_present
    
    private

    def set_status_based_on_stock
        self.status = stock.to_i > 0 ? "พร้อมส่ง" : "สินค้าหมด"
    end

    def image_or_url_present
        # เช็คว่ามีรูปภาพ หรือ URL อย่างน้อย 1 รายการ
        if image.blank? && image_url.blank?
          errors.add(:base, "ต้องอัปโหลดรูปภาพหรือใส่ลิงก์รูปภาพอย่างน้อยหนึ่งรายการ")
        end
    
        # เช็คว่า URL เป็นลิงก์ที่ถูกต้อง
        if image_url.present? && !(image_url =~ URI::DEFAULT_PARSER.make_regexp(%w[http https]))
          errors.add(:image_url, "ต้องเป็นลิงก์ที่ถูกต้อง (http หรือ https)")
        end
    
        # เช็คว่าไฟล์ที่อัปโหลดเป็นรูปภาพ และขนาดไม่เกิน 5MB
        image.each do |image|
          if !image.content_type.in?(%w[image/png image/jpg image/jpeg])
            errors.add(:images, "ต้องเป็นไฟล์รูปภาพนามสกุล .png, .jpg, .jpeg เท่านั้น")
          end
    
          if image.byte_size > 5.megabytes
            errors.add(:images, "ขนาดไฟล์ต้องไม่เกิน 5MB")
          end
        end
    end
end
