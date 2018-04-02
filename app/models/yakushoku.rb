class Yakushoku < ApplicationRecord
  validates :code, :name, presence: true
  validates :code, uniqueness: true

  alias_attribute :役職コード, :code
  alias_attribute :役職名, :name

  ATTRS = %w(役職コード 役職名)
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      hash = row.to_hash.slice(*ATTRS)
      yakushoku = Yakushoku.find_by_code(hash['役職コード'])
      if yakushoku
        yakushoku.update(hash)
      else
        Yakushoku.create(hash)
      end
    end
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ATTRS
      all.each do |yakushoku|
        csv << ATTRS.map{ |attr| yakushoku.send(attr) }
      end
    end
  end
end
