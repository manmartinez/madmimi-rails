class Madmimi::Rails::Railtie < Rails::Railtie  
  ActionMailer::Base.add_delivery_method :madmimi, Madmimi::Rails::DeliveryMethod
end
