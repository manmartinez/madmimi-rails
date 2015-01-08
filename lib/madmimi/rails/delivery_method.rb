require 'madmimi'
module Madmimi
  module Rails
    class Madmimi::Rails::DeliveryMethod
      class InvalidOptions < StandardError; end;

      attr_accessor :settings

      def initialize(config = {})
        fail(InvalidOptions, "Missing configuration") if config[:email].nil? || config[:api_key].nil?
        self.settings = config
      end

      def deliver!(mail)
        options = options_from_mail(mail)
        raw = html_from_mail(mail)

        mail.to.each do |recipient|
          deliver_to_recipient(recipient, raw, options)
        end
      end

      protected

        def mimi
          @mimi ||= MadMimi.new(settings[:email], settings[:api_key])
        end

        def html_from_mail(mail)
          if mail.parts.any?
            mail.html_part.body.raw_source
          else
            mail.body.raw_source
          end
        end

        def options_from_mail(mail)
          {
            'promotion_name' => mail['promotion'].try(:to_s) || mail.subject,
            'from' => mail.from.join(','),
            'subject' => mail.subject,
            'remove_unsubscribe' => true
          }
        end

        def deliver_to_recipient(recipient, raw_html, options)
          options['recipients'] = recipient
          result = mimi.send_html(options, raw_html)
          ::Rails.logger.info "[INFO] sent email to Madmimi, mailing id is: #{result}"
        end
    end
  end
end
