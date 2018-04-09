require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:attributes) {  { code: "code", name: "name", rank: 1 } }
  
  describe "GET .index" do
    it "assigns all Roles as @roles" do      
      get :index      
      expect(assigns(:roles)).to eq(Role.all)
    end
  end

  describe "POST .create" do
    context "with valid params" do
      it "creates a new Role" do
        expect {
          post :create, :format => 'js', params: { :role => attributes }
        }.to change(Role, :count).by(1)
      end

      it "assigns a newly created Role as @role" do
        post :create, :format => 'js', params: { :role => attributes }
        expect(assigns(:role)).to be_a(Role)
        expect(assigns(:role)).to be_persisted
      end      
    end

    context "with invalid params" do
      before do
        Role.create(attributes)
      end
      it "assigns a newly created but unsaved Role as @role" do
        post :create, :format => 'js', params: { :role => attributes }
        expect(assigns(:role)).to be_a_new(Role)
        expect(assigns(:role).errors.any?).to eq true
      end
    end
  end

  describe "PUT .update" do
    let(:new_attributes) { {code: "new_code", name: "new_name", rank: 1 } }
    context "with valid params" do      
      it "updates the requested Role" do
        role = Role.create(code: "code", name: "name", rank: 0)
        put :update, :format => 'js' , params: {:id => role.id, :role => new_attributes }
        role.reload        
        expect(role.code).to eq("new_code")
        expect(role.name).to eq("new_name")
        expect(role.rank).to eq(1)
      end
    end

    context "with invalid params" do
      it "assigns the Role as @role" do
        Role.create(code: "new_code", name: "new_name", rank: 1)
        role = Role.create(code: "code", name: "name")
        put :update, :format => 'js', params: { :id => role.id, :role => new_attributes }
        expect(assigns(:role)).to eq(role)
      end      
    end
  end

  describe "DELETE .destroy" do
    before do
      Role.create(code: "code", name: "name", rank: 1)
    end
    it "destroys the requested Role" do
      role = Role.first
      expect {
        delete :destroy, :format => 'js', params: { :id => role.to_param }
      }.to change(Role, :count).by(-1)
    end
  end
end
