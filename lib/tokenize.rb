module JT::Rails::Tokenizable::Tokenize
	extend ActiveSupport::Concern

	included do
		before_validation :jt_rails_generate_tokens, on: :create
	end

	class_methods do

		def tokenize(field, options = {})
			jt_rails_token_fields[field.to_sym] = options

			if options.fetch(:valiations, true)
				validates field, presence: true, uniqueness: true
			end
		end

		def jt_rails_token_fields
			@jt_rails_token_fields ||= {}
		end

	end

	def jt_rails_generate_tokens
		for field in self.class.jt_rails_token_fields.keys
			generate_new_token(field)
		end
	end

	def generate_new_token(field)
		size = self.class.jt_rails_token_fields[field.to_sym].fetch(:size, 32)

		self[field.to_sym] = loop do
			random_token = SecureRandom.hex(size)
			break random_token unless self.class.exists?(field => random_token)
		end
	end

end
