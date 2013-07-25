require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                           password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when name is too long (exceeds 50 characters)" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  describe "when email is too long (exceeds 50 characters)" do
    before { @user.email = "a" * 51 }
    it { should_not be_valid }
  end
  describe "when email has invalid format" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com foo@b..a.r.com
                    foo@b.a..r.com foo@b.a.r..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.j a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  describe "when email is not unique (case sensitive)" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  describe "when email is not unique (case insensitive)" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@ex.org",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password does not match confirmation" do
    before do
      @user = User.new(name: "Example User", email: "user@ex.org",
                       password: "123", password_confirmation: "321")
    end
    it { should_not be_valid }
  end

  describe "when password is wrong length" do
    it "should be invalid" do
      passwords = %w[12345 12345678901234567]
      passwords.each do |invalid_password|
        @user.password = invalid_password
        @user.password_confirmation = invalid_password
        expect(@user).to_not be_valid
      end
    end
  end

  describe "when password is right length" do
    it "should be valid" do
      passwords = %w[123456 1234567890123456]
      passwords.each do |valid_password|
        @user.password = valid_password
        @user.password_confirmation = valid_password
        expect(@user).to be_valid
      end
    end
  end

  describe "return value of authenticate" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
