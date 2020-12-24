class Book < ApplicationRecord

    enum sales_status: {
        reservation: 0, # 予約受付
        now_on_sale: 1, # 発売中
        end_of_print: 2, # 販売終了
    }

    scope :costly, -> {where("price > ?", 3000)}
    scope :written_about, -> (theme) {where("name like ?", "%#{theme}")}
    default_scope -> {order("published_on desc")}

    belongs_to :publisher
    has_many :book_authors
    # 中間テーブルの指定をthroughでしている
    has_many :authors, through: :book_authors

    validates :name, presence: true
    validates :name, length: { maximum: 25 }
    validates :price, numericality: { greater_than_or_equel_to: 0 }

    # 独自のバリデーションを定義する例
    validate do |book|
        if book.name.include?("exercise")
            book.errors[:name] << "I don't like exercise."
        end
    end

    before_validation do
        self.name = self.name.gsub(/Cat/) do |matched|
            "lovely #{matched}"
        end
    end

    after_destroy do
        Rails.logger.info "Book is deleted: #{self.attributes}"
    end

    after_destroy :if => :high_price? do
        Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
        Rails.logger.warn "Please check!"
    end

    def high_price?
        price >= 5000
    end
end