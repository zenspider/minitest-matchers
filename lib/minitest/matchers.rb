require "minitest/spec"

module MiniTest::Matchers
  VERSION = "1.1.0" # :nodoc:

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
    # See MiniTest::Matchers::Assertions#assert_must
    #
    #     user.must have_valid(:email).when("user@example.com")
    #
    # :method: must

    infect_an_assertion :assert_must, :must

    ##
    # See MiniTest::Matchers::Assertions#assert_wont
    #
    #     user.wont have_valid(:email).when("bad@email")
    #
    # :method: wont

    infect_an_assertion :assert_wont, :wont
  end

  def must &block
    matcher = yield
    MiniTest::Matchers.check_matcher matcher

    it "must #{matcher.description}" do
      fail "Please set subject" unless self.respond_to? :subject

      assert_must matcher, subject
    end

    matcher
  end

  def wont &block
    matcher = yield
    MiniTest::Matchers.check_matcher matcher

    it "wont #{matcher.description}" do
      fail "Please set subject" unless self.respond_to? :subject

      assert_wont matcher, subject
    end

    matcher
  end

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

module MiniTest::Assertions # :nodoc:
  include MiniTest::Matchers::Assertions
end

module MiniTest::Expectations # :nodoc:
  include MiniTest::Matchers::Expectations
end

class MiniTest::Spec # :nodoc:
  extend MiniTest::Matchers
end
