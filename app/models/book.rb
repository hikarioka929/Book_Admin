class Book < ApplicationRecord
    scope :costly, -> {where("price > ?", 3000)}
    scope :written_about, -> (theme) {where("name like ?", "%#{theme}")}
    default_scope -> {order("published_on desc")}

    belongs_to :publisher
    has_many :book_authors
    # 中間テーブルの指定をthroughでしている
    has_many :authors, through: :book_authors
end
