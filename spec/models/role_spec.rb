require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { Role.new(code: 'abc',name: 'def', rank: 1) }

  describe '#create' do
    context 'with valid attr' do
      before do
        role.save
      end
      it 'then insert success' do
        expect(Role.count).to eq 1
      end
    end

    context 'with invalid attr' do
      before do
        Role.new(name: 'def').save
      end
      it 'then insert failed' do
        expect(Role.count).to eq 0
      end
    end
  end

  describe '#import' do
    context 'with valid file' do
      before do
        headers = %w(ロールコード ロール名 序列)
        csv_file = CSV.open('import_file', 'w') do |f|
          f << headers
          5.times do |i|
            f << ["code_i#{i}", "name_#{i}", i]
          end
          f
        end
        Role.import(csv_file)
      end
      after do
        FileUtils.remove('import_file')
      end
      it 'then insert success' do
        expect(Role.count).to eq(5)
      end
    end

    context 'with empty file' do
      before do
        headers = %w(ロールコード ロール名 序列)
        csv_file = CSV.open('import_file', 'w') do |f|
          f << headers          
          f
        end
        Role.import(csv_file)
      end
      after do
        FileUtils.remove('import_file')
      end
      it 'then no insert' do
        expect(Role.count).to eq(0)
      end
    end
  end

  describe '#export' do
    context 'all datas' do
      before do
        3.times { |i| Role.create(code: "code_#{i}", name: "name_#{i}", rank: i)}
      end
      it 'then number of line is exactly' do
        expect(Role.to_csv.split("\n").size).to eq(4)
      end
    end
  end
end
