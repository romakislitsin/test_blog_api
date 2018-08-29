describe User, type: :model do
  it { is_expected.to have_secure_password }

  it { should validate_presence_of :nickname }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_length_of(:password).is_at_least(8).is_at_most(72) }
  it { should validate_confirmation_of :password }

  it { should have_many :posts }
  it { should have_many :comments }

  it { should accept_nested_attributes_for :posts }
end