module JT::Rails::Tokenizable::Tokenize
	extend ActiveSupport::Concern

	included do |base|
		before_validation :jt_rails_generate_tokens_if_missing, on: :create

		base.class_eval do

			# jt_rails_token_fields is shared only by a class and its subclass
			def self.jt_rails_token_fields
				class_variable_set(:@@jt_rails_token_fields, HashWithIndifferentAccess.new) if !class_variable_defined?(:@@jt_rails_token_fields)
				class_variable_get(:@@jt_rails_token_fields)
			end

		end
	end

	class_methods do

		def tokenize(field, options = {})		
			jt_rails_token_fields[field.to_sym] = options

			if options.fetch(:valiations, true)
				validates field, presence: true, uniqueness: true
			end
		end

	end

	def jt_rails_generate_tokens_if_missing
		for field in self.class.jt_rails_token_fields.keys
			generate_new_token(field) if self[field.to_sym].blank?
		end
	end

	def jt_rails_generate_tokens
		for field in self.class.jt_rails_token_fields.keys
			generate_new_token(field)
		end
	end

	def generate_new_token(field)
		size = self.class.jt_rails_token_fields[field.to_sym].fetch(:size, 32)
		only_digits = self.class.jt_rails_token_fields[field.to_sym].fetch(:only_digits, false)

		self[field.to_sym] = loop do
			random_token = only_digits ? format("%.#{size}d", SecureRandom.random_number(10**size)) : SecureRandom.hex(size)
			break random_token unless self.class.exists?(field => random_token)
		end
	end

	def generate_new_token!(field)
		generate_new_token(field)
		save!
	end

end
