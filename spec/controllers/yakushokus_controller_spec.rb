require 'rails_helper'

RSpec.describe YakushokusController, type: :controller do
  let(:attributes) {  { code: "code", name: "name" } }
  
  describe "GET .index" do
    it "assigns all Yakushokus as @yakushokus" do      
      get :index      
      expect(assigns(:yakushokus)).to eq(Yakushoku.all)
    end
  end

  describe "POST .create" do
    context "with valid params" do
      it "creates a new Yakushoku" do
        expect {
          post :create, :format => 'js', params: { :yakushoku => attributes }
        }.to change(Yakushoku, :count).by(1)
      end

      it "assigns a newly created Yakushoku as @yakushoku" do
        post :create, :format => 'js', params: { :yakushoku => attributes }
        expect(assigns(:yakushoku)).to be_a(Yakushoku)
        expect(assigns(:yakushoku)).to be_persisted
      end      
    end

    context "with invalid params" do
      before do
        Yakushoku.create(attributes)
      end
      it "assigns a newly created but unsaved Yakushoku as @yakushoku" do
        post :create, :format => 'js', params: { :yakushoku => attributes }
        expect(assigns(:yakushoku)).to be_a_new(Yakushoku)
        expect(assigns(:yakushoku).errors.any?).to eq true
      end
    end
  end

  describe "PUT .update" do
    let(:new_attributes) { {code: "new_code", name: "new_name" } }
    context "with valid params" do      
      it "updates the requested Yakushoku" do
        yakushoku = Yakushoku.create(code: "code", name: "name")
        put :update, :format => 'js' , params: {:id => yakushoku.id, :yakushoku => new_attributes }
        yakushoku.reload        
        expect(yakushoku.code).to eq("new_code")
        expect(yakushoku.name).to eq("new_name")
      end
    end

    context "with invalid params" do
      it "assigns the Yakushoku as @yakushoku" do
        Yakushoku.create(code: "new_code", name: "new_name")
        yakushoku = Yakushoku.create(code: "code", name: "name")
        put :update, :format => 'js', params: { :id => yakushoku.id, :yakushoku => new_attributes }
        expect(assigns(:yakushoku)).to eq(yakushoku)
      end
    end
  end

  describe "DELETE .destroy" do
    before do
      Yakushoku.create(code: "code", name: "name")
    end
    it "destroys the requested Yakushoku" do
      yakushoku = Yakushoku.first
      expect {
        delete :destroy, :format => 'js', params: { :id => yakushoku.to_param }
      }.to change(Yakushoku, :count).by(-1)
    end
  end
end
