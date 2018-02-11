require 'rails_helper'

RSpec.describe ShozokusController, type: :controller do  
  let(:attributes) {  { code: "code", name: "name" } }
  
  describe "GET .index" do
    it "assigns all Shozokus as @shozokus" do      
      get :index      
      expect(assigns(:shozokus)).to eq(Shozoku.all)
    end
  end

  describe "POST .create" do
    context "with valid params" do
      it "creates a new Shozoku" do
        expect {
          post :create, :format => 'js', params: { :shozoku => attributes }
        }.to change(Shozoku, :count).by(1)
      end

      it "assigns a newly created Shozoku as @shozoku" do
        post :create, :format => 'js', params: { :shozoku => attributes }
        expect(assigns(:shozoku)).to be_a(Shozoku)
        expect(assigns(:shozoku)).to be_persisted
      end      
    end

    context "with invalid params" do
      before do
        Shozoku.create(attributes)
      end
      it "assigns a newly created but unsaved Shozoku as @shozoku" do
        post :create, :format => 'js', params: { :shozoku => attributes }
        expect(assigns(:shozoku)).to be_a_new(Shozoku)
        expect(assigns(:shozoku).errors.any?).to eq true
      end
    end
  end

  describe "PUT .update" do
    let(:new_attributes) { {code: "new_code", name: "new_name" } }
    context "with valid params" do      
      it "updates the requested Shozoku" do
        shozoku = Shozoku.create(code: "code", name: "name")
        put :update, :format => 'js' , params: {:id => shozoku.id, :shozoku => new_attributes }
        shozoku.reload        
        expect(shozoku.code).to eq("new_code")
        expect(shozoku.name).to eq("new_name")
      end
    end

    context "with invalid params" do
      it "assigns the Shozoku as @shozoku" do
        Shozoku.create(code: "new_code", name: "new_name")
        shozoku = Shozoku.create(code: "code", name: "name")
        put :update, :format => 'js', params: { :id => shozoku.id, :shozoku => new_attributes }
        expect(assigns(:shozoku)).to eq(shozoku)
      end
    end
  end

  describe "DELETE .destroy" do
    before do
      Shozoku.create(code: "code", name: "name")
    end
    it "destroys the requested Shozoku" do
      shozoku = Shozoku.first
      expect {
        delete :destroy, :format => 'js', params: { :id => shozoku.to_param }
      }.to change(Shozoku, :count).by(-1)
    end
  end
end
