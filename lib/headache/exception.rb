module Headache
  class Exception < ::RuntimeError
  end

  class InvalidRecordType < Headache::Exception
  end

  class AmbiguousBatch < Headache::Exception
  end

  class UnknownServiceCode < Headache::Exception
  end

  class UnknownTransactionCode < Headache::Exception
  end
  class UnknownBatchType < Headache::Exception
  end
end
