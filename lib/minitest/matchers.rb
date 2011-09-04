require "minitest/spec"

module MiniTest::Matchers
  VERSION = "1.0.2"

  def must &block
    matcher = yield
    check_matcher matcher

    it "must #{matcher.description}" do
      result = matcher.matches? subject

      failure_message = if matcher.respond_to? :failure_message
                          matcher.failure_message
                        else
                          "expected to " + matcher.description
                        end

      assert result, failure_message
    end

    matcher
  end

  def wont &block
    matcher = yield
    check_matcher matcher

    it "wont #{matcher.description}" do
      result = if matcher.respond_to? :does_not_match?
                 result = matcher.does_not_match?(subject)
               else
                 result = !matcher.matches?(subject)
               end

      failure_message = if matcher.respond_to? :negative_failure_message
                          matcher.negative_failure_message
                        else
                          "expected not to " + matcher.description
                        end

      assert result, failure_message
    end

    matcher
  end

  def check_matcher matcher
    [:description, :matches?].each do |m|
      if !matcher.respond_to?(m) || matcher.send(:description).nil?
        fail "Matcher must respond to #{m}"
      end
    end
  end
end

class MiniTest::Spec
  extend MiniTest::Matchers
end
