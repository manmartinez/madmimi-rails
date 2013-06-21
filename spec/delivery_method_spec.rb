require 'spec_helper'
describe DeliveryMethod do
  describe '.new' do
    context 'Without options' do
      it { expect{ DeliveryMethod.new }.to raise_error DeliveryMethod::InvalidOptions}
      it { expect{ DeliveryMethod.new(email: 'test@test.com') }.to raise_error DeliveryMethod::InvalidOptions }
      it { expect{ DeliveryMethod.new(api_key: 'api_secret') }.to raise_error DeliveryMethod::InvalidOptions }
    end
    it { expect{ DeliveryMethod.new(api_key: 'api_secret', email: 'test@test.com') }.to_not raise_error }
  end
end