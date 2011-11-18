require "minitest/spec"

module MiniTest::Matchers
  VERSION = "1.1.1" # :nodoc:
end

module MiniTest
  module Assertions
    ##
    # Fails unless matcher.matches?(subject) returns true
    #
    # Example:
    #
    #   def test_validations
    #     assert_must be_valid, @user
    #   end

    def assert_must matcher, subject, msg = nil
      result = matcher.matches? subject

      msg = message(msg) do
        if matcher.respond_to? :failure_message
          matcher.failure_message
        else
          matcher.failure_message_for_should
        end
      end

      assert result, msg
    end

    ##
    # Fails if matcher.matches?(subject) returns true
    #
    # Example:
    #
    #   def test_validations
    #     assert_wont be_valid, @user
    #   end

    def assert_wont matcher, subject, msg = nil
      msg = message(msg) do
        if matcher.respond_to? :negative_failure_message
          matcher.negative_failure_message
        else
          matcher.failure_message_for_should_not
        end
      end

      if matcher.respond_to? :does_not_match?
        assert matcher.does_not_match?(subject), msg
      else
        refute matcher.matches?(subject), msg
      end
    end
  end

  module Expectations
    ##
    # See MiniTest::Assertions#assert_must
    #
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

class MiniTest::Spec
  ##
  # Define a `must` expectation for implicit subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     it { must have_valid(:title).when("Good") }
  #   end

  def must(*args, &block)
    if respond_to?(:subject)
      subject.must(*args, &block)
    else
      super
    end
  end

  ##
  # Define a `wont` expectation for implicit subject
  #
  # Example:
  #
  #   describe Post do
  #     subject { Post.new }
  #
  #     it { wont have_valid(:title).when("") }
  #   end

  def wont(*args, &block)
    if respond_to?(:subject)
      subject.wont(*args, &block)
    else
      super
    end
  end
end

class MiniTest::Spec # :nodoc:
  include MiniTest::Matchers
end
