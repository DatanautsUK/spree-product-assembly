module Spree
  module Stock
    class AssemblyQuantifier
      attr_reader :variant

      def initialize(variant)
        @variant = variant
      end

      def total_on_hand
        quantifiers.map(&:total_on_hand).min
      end

      def backorderable?
        return false unless backordering_allowed?
        quantifiers.all?(&:backorderable?)
      end

      def can_supply?(required = 1)
        return false unless variant.available?
        return true if backorderable?
        assemblies_with_quantifiers.all? do |assembly, quantifier|
          quantifier.can_supply?(required * assembly.count)
        end
      end

      private

      def backordering_allowed?
        ENV['ASSEMBLIES_BACKORDERABLE'].present?
      end

      def quantifiers
        @quantifiers ||= assemblies_with_quantifiers.values
      end

      def assemblies_with_quantifiers
        @assemblies_with_quantifiers ||= variant.parts_variants
                                                .includes(:part)
                                                .each_with_object({}) do |pv, h|
          h[pv] = AssemblyPartQuantifier.new(pv.part)
        end
      end
    end
  end
end
