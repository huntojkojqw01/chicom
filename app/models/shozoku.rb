class Shozoku < ApplicationRecord
	validates :code, :name, presence: true
  validates :code, uniqueness: true

  alias_attribute :所属コード, :code
  alias_attribute :所属名, :name

  ATTRS = %w(所属コード 所属名)
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      hash = row.to_hash.slice(*ATTRS)
      shozoku = Shozoku.find_by_code(hash['所属コード'])
      if shozoku
      	shozoku.update(hash)
      else
      	Shozoku.create(hash)
      end
    end
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ATTRS
      all.each do |shozoku|
        csv << ATTRS.map{ |attr| shozoku.send(attr) }
      end
    end
  end
end
