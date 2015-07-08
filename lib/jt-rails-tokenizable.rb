module JT
	module Rails
	end
end

module JT::Rails::Tokenizable
	extend ActiveSupport::Concern

	included do
		before_validation :generate_tokens, on: :create

		mattr_accessor :jt_rails_token_fields do
			[]
		end
	end

	module ClassMethods

		def tokenize(field)
			jt_rails_token_fields << field

			validates field, presence: true, uniqueness: true
		end

	end

	def generate_tokens
		for field in jt_rails_token_fields
			generate_new_token(field)
		end
	end

	def generate_new_token(field)
		self[field] = loop do
			random_token = SecureRandom.hex(128)
			break random_token unless self.class.exists?(field => random_token)
		end
	end

end
