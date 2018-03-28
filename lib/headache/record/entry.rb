module Headache
  module Record
    class Entry < Headache::Record::Base
      include Definition::Entry

      attr_accessor :routing_number, :account_number, :amount,
                    :internal_id, :trace_number, :individual_name,
                    :document, :batch, :discretionary, :transaction_type,
                    :check_digit, :routing_identification


  def transaction_code
	  return '22' if transaction_type == :credit_to_checking
	  return '27' if transaction_type == :debit_from_checking
	  return '32' if transaction_type == :credit_to_savings
	  return '37' if transaction_type == :debit_from_savings
      fail Headache::UnknownTransactionCode, "unknown batch type: #{transaction_type.inspect} (expecting :credit_to_checking, :debit_from_checking, :debit_from_savings, :credit_to_savings)"
			    
	end

    def self.type_from_transaction_code(code)
	    return :credit_to_checking if code.to_s =='22'
	    return :debit_from_checking if code.to_s =='27'
	    return :credit_to_savings if code.to_s =='32'
	    return :debit_from_savings if code.to_s =='37'
      fail Headache::UnknownServiceCode, "unknown service code: #{code.inspect} (expecting 22,27,32,37)"
    end
      def check_digit=(value)
        rval = (@check_digit = value)
        assemble_routing_number
        rval
      end

      def generate(*args)
        fail ArgumentError, 'transaction_code cannot be blank' unless transaction_code.present?
        super(*args)
      end

      def routing_identification=(value)
        rval = (@routing_identification = value)
        assemble_routing_number
        rval
      end

      def assemble_routing_number
        if @routing_identification.present? && @check_digit.present?
          @routing_number = "#{@routing_identification}#{@check_digit}"
        end
      end

      def to_h
        new_hsh = {}
        super.each_pair do |key, value|
          next if key == :check_digit
          if key == :routing_identification
            key   = :routing_number
            value = @routing_number
          end
          new_hsh[key] = value
        end
        new_hsh
      end

      def routing_identification
        @routing_identification || routing_number.to_s.first(8)
      end

      def check_digit
        @check_digit || routing_number.to_s.last(1)
      end

      def initialize(batch = nil, document = nil)
        @batch    = batch
        @document = document

      end
    end
  end
end
