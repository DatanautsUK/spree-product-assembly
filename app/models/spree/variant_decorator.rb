Spree::Variant.class_eval do
  has_many :parts_variants, class_name: "Spree::AssembliesPart", foreign_key: "assembly_id"
  has_many :assemblies_variants, class_name: "Spree::AssembliesPart", foreign_key: "part_id"

  has_many :assemblies, through: :assemblies_variants, class_name: "Spree::Variant", dependent: :destroy
  has_many :parts, through: :parts_variants, class_name: "Spree::Variant", dependent: :destroy

  def assemblies_for(products)
    assemblies.where(id: products)
  end

  def part?
    assemblies.exists?
  end

  def quantifier
    if parts.any?
      Spree::Stock::AssemblyQuantifier.new(self)
    else
      Spree::Stock::Quantifier.new(self)
    end
  end
end
