module JT
	module Rails
	end
end

module JT::Rails::Tokenizable
	extend ActiveSupport::Concern

	included do
		before_validation :generate_tokens, on: :create

		mattr_accessor :jt_rails_token_fields do
			{}
		end
	end

	module ClassMethods

		def tokenize(field, options = {})
			jt_rails_token_fields[field.to_sym] = options

			if options.fetch(:valiations, true)
				validates field, presence: true, uniqueness: true
			end
		end

	end

	def generate_tokens
		for field in jt_rails_token_fields.keys
			generate_new_token(field)
		end
	end

	def generate_new_token(field)
		size = jt_rails_token_fields[field.to_sym].fetch(:size, 128)

		self[field.to_sym] = loop do
			random_token = SecureRandom.hex(size)
			break random_token unless self.class.exists?(field => random_token)
		end
	end

end
