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
    subject.kind_of?  @klass
  end

  def failure_message
    "expected to " + description
  end

  def negative_failure_message
    "expected not to " + description
  end
end

def be_kind_of klass
  KindOfMatcher.new klass
end

describe MiniTest::Unit::TestCase do
  it "needs to verify matcher has #description and #matches?" do
    proc { assert_must BadMatcher.new, [] }.must_raise RuntimeError
  end

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
  it "needs to verify matcher has #description and #matches?" do
    proc { [].must BadMatcher.new, [] }.must_raise RuntimeError
  end

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

      it("1") { must be_kind_of(Array) }
      it("2") { must be_kind_of(String) }
    end

    spec = spec_class.new("A spec")

    spec.send "test_0001_1"
    proc { spec.send "test_0002_2"}.must_raise MiniTest::Assertion
  end

  it "needs to verify wont with implicit subject" do
    spec_class = Class.new(MiniTest::Spec) do
      subject { [1, 2, 3] }

      it("1") { wont be_kind_of(String) }
      it("2") { wont be_kind_of(Array) }
    end

    spec = spec_class.new("A spec")

    spec.send "test_0001_1"
    proc { spec.send "test_0002_2"}.must_raise MiniTest::Assertion
  end
end
