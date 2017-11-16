module Spree
  module Stock
    class AssemblyPartQuantifier < Quantifier
      def backorderable?
        backordering_allowed? && stock_items.any?(&:backorderable)
      end

      def backordering_allowed?
        ENV['ASSEMBLIES_BACKORDERABLE'].present?
      end
    end
  end
end
