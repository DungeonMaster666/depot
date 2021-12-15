require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    @last_request = SupportRequest.last
    mail = SupportRequestMailer.respond(@last_request)
    assert_equal "Re: #{@last_request.subject}", mail.subject
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["support@example.com"], mail.from
    assert_match "Please try again.", mail.body.encoded
  end

end
