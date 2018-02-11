require 'rails_helper'
require 'csv'

RSpec.describe Shozoku, type: :model do  
  # thiết lập cho biến user nhận giá trị này:
  let(:shozoku) { Shozoku.new(code: 'abc',name: 'def') }

  describe '#create' do
    context 'with valid attr' do
      before do
        shozoku.save
      end
      it 'then insert success' do
        expect(Shozoku.count).to eq 1
      end
    end

    context 'with invalid attr' do
      before do
        Shozoku.new(name: 'def').save
      end
      it 'then insert failed' do
        expect(Shozoku.count).to eq 0
      end
    end
  end

  describe '#import' do
    context 'with valid file' do
      before do
        headers = %w(所属コード 所属名)
        csv_file = CSV.open('import_file', 'w') do |f|
          f << headers
          5.times do |i|
            f << ["code_i#{i}", "name_#{i}"]
          end
          f
        end
        Shozoku.import(csv_file)
      end
      after do
        FileUtils.remove('import_file')
      end
      it 'then insert success' do
        expect(Shozoku.count).to eq(5)
      end
    end

    context 'with empty file' do
      before do
        headers = %w(所属コード 所属名)
        csv_file = CSV.open('import_file', 'w') do |f|
          f << headers          
          f
        end
        Shozoku.import(csv_file)
      end
      after do
        FileUtils.remove('import_file')
      end
      it 'then no insert' do
        expect(Shozoku.count).to eq(0)
      end
    end
  end

  describe '#export' do
    context 'all datas' do
      before do
        3.times { |i| Shozoku.create(code: "code_#{i}", name: "name_#{i}")}
      end
      it 'then number of line is exactly' do
        expect(Shozoku.to_csv.split("\n").size).to eq(4)
      end
    end
  end
end
