require "minitest/spec"

module MiniTest::Assertions
  def assert_must matcher, subject, msg = nil
    MiniTest::Matchers.check_matcher matcher
    result = matcher.matches? subject

    msg ||= if matcher.respond_to? :failure_message
              matcher.failure_message
            else
              "expected to " + matcher.description
            end

    assert result, msg
  end

  def assert_wont matcher, subject, msg = nil
    MiniTest::Matchers.check_matcher matcher
    result = matcher.matches? subject

    msg ||= if matcher.respond_to? :negative_failure_message
              matcher.negative_failure_message
            else
              "expected not to " + matcher.description
            end

    refute result, msg
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_must, :must
  infect_an_assertion :assert_wont, :wont
end

module MiniTest::Matchers
  VERSION = "1.1.0"

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

  def self.check_matcher matcher
    [:description, :matches?].each do |m|
      if !matcher.respond_to?(m) || matcher.send(:description).nil?
        fail "Matcher must respond to #{m}."
      end
    end
  end
end

class MiniTest::Spec
  extend MiniTest::Matchers
end
