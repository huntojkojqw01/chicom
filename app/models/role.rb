class Role < ApplicationRecord
  validates :code, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :name, presence: true, length: { maximum: 40 }

  alias_attribute :ロールコード, :code
  alias_attribute :ロール名, :name
  alias_attribute :序列, :rank

  ATTRS = %w(ロールコード ロール名 序列)
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      hash = row.to_hash.slice(*ATTRS)
      role = Role.find_by_code(hash['ロールコード'])
      if role
        role.update(hash)
      else
        Role.create(hash)
      end
    end
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ATTRS
      all.each do |role|
        csv << ATTRS.map{ |attr| role.send(attr) }
      end
    end
  end
end
