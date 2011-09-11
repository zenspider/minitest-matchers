require "minitest/spec"

module MiniTest::Matchers
  VERSION = "1.1.0" # :nodoc:

  ##
  # Every matcher must respond to following methods:
  #   - #description
  #   - #matches?
  #   - #failure_message
  #   - #negative_failure_message

  def self.check_matcher matcher
    [:description, :matches?, :failure_message, :negative_failure_message].each do |m|
      unless matcher.respond_to? m
        fail "Matcher must respond to #{m}."
      end
    end
  end
end

module MiniTest
  module Assertions
    ##
    # Fails unless matcher.matches?(subject) returns true

    def assert_must matcher, subject, msg = nil
      MiniTest::Matchers.check_matcher matcher
      result = matcher.matches? subject

      msg = message(msg) { matcher.failure_message }

      assert result, msg
    end

    ##
    # Fails if matcher.matches?(subject) returns true

    def assert_wont matcher, subject, msg = nil
      MiniTest::Matchers.check_matcher matcher
      result = matcher.matches? subject

      msg = message(msg) { matcher.negative_failure_message }

      refute result, msg
    end
  end

  module Expectations
    ##
    # See MiniTest::Assertions#assert_must
    #     user.must have_valid(:email).when("user@example.com")
    #
    # :method: must

    infect_an_assertion :assert_must, :must

    ##
    # See MiniTest::Assertions#assert_wont
    #
    #     user.wont have_valid(:email).when("bad@email")
    #
    # :method: wont

    infect_an_assertion :assert_wont, :wont
  end
end

class MiniTest::Spec # :nodoc:
  extend MiniTest::Matchers
end
