require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :controller do
  render_views
  describe 'check_captcha' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user_logged_in(nil)
    end
    let(:user) { create(:user) }

    context 'verified recaptcha' do
      it "renders create action" do
        allow(controller).to receive(:verify_recaptcha) { true }
        post :create, user: user.attributes
      end
    end

    context 'unverified recaptcha' do
      it "renders new action" do
        # TODO: user_logged_in is not working here. :S
        allow(controller).to receive(:verify_recaptcha) { false }
        post :create, user: { username: "user",
          email: "email_1@example.org", password: "password",
          password_confirmation: "password" }
        expect(response).to render_template("new")
        expect(response.body).to include(I18n.t(:recaptcha_error))
      end
    end
  end
end
