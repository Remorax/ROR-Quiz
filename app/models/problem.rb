class Problem < ApplicationRecord
	validates :question, presence: true, allow_blank: false
	validates :a, presence: true, allow_blank: false
	validates :b, presence: true, allow_blank: false
	validates :c, presence: true, allow_blank: false
	validates :d, presence: true, allow_blank: false
	validates :questionType, presence: true, allow_blank: false
	validates :answer, presence: true, allow_blank: false

	def next
    	Problem.where("id > ?", id).first
  	end

  	 def prev
    	Problem.where("id < ?", id).last
  	end
end
