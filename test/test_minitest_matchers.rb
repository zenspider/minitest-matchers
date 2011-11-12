gem "minitest"
require "minitest/spec"
require "minitest/autorun"
require "minitest/matchers"

class BadMatcher; end

class KindOfMatcher
  def initialize klass
    @klass = klass
  end

  def description
    "be kind of #{@klass}"
  end

  def matches? subject
    subject.kind_of? @klass
  end

  def failure_message_for_should
    "expected to " + description
  end

  def failure_message_for_should_not
    "expected not to " + description
  end
end

def be_kind_of klass
  KindOfMatcher.new klass
end

describe MiniTest::Unit::TestCase do
  it "needs to verify assert_must" do
    assert_must(be_kind_of(Array), []).must_equal true
    proc { assert_must be_kind_of(String), [] }.must_raise MiniTest::Assertion
  end

  it "needs to verify assert_wont" do
    assert_wont(be_kind_of(String), []).must_equal false
    proc { assert_wont be_kind_of(Array), [] }.must_raise MiniTest::Assertion
  end
end

describe MiniTest::Spec do
  it "needs to verify must" do
    [].must(be_kind_of(Array)).must_equal true
    proc { [].must be_kind_of(String) }.must_raise MiniTest::Assertion
  end

  it "needs to verify wont" do
    [].wont(be_kind_of(String)).must_equal false
    proc { [].wont be_kind_of(Array) }.must_raise MiniTest::Assertion
  end

  it "needs to verify must with implicit subject" do
    spec_class = Class.new(MiniTest::Spec) do
      subject { [1, 2, 3] }

      it { must be_kind_of(String) }
    end

    spec = spec_class.new("A spec")

    proc { spec.send spec_class.test_methods.first}.must_raise MiniTest::Assertion
  end

  it "needs to verify wont with implicit subject" do
    spec_class = Class.new(MiniTest::Spec) do
      subject { [1, 2, 3] }

      it { wont be_kind_of(Array) }
    end

    spec = spec_class.new("A spec")

    proc { spec.send spec_class.test_methods.first}.must_raise MiniTest::Assertion
  end
end
