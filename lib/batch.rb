module DeftPayments
  # A pay file has one of more batches of tansactions.
  # A batch can have 0 or more transactions.
  class Batch < Treetop::Runtime::SyntaxNode 
    def transactions
      ts.elements
    end
  end
end