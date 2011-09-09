require "minitest/autorun"
require "minitest/matchers"

class BadSpec < MiniTest::Spec; end

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
  it "needs to verify must" do
    [].must(be_kind_of(Array)).must_equal true
    proc { [].must be_kind_of(String) }.must_raise MiniTest::Assertion
  end

  it "needs to verify wont" do
    [].wont(be_kind_of(String)).must_equal false
    proc { [].wont be_kind_of(Array) }.must_raise MiniTest::Assertion
  end
end

describe MiniTest::Matchers do
  describe "must" do
    let(:spec_class) do
      Class.new(MiniTest::Spec) do
        must { KindOfMatcher.new String }
      end
    end
    let(:spec) { spec_class.new "A spec" }

    it "defines must expectation" do
      spec_class.test_methods.grep(/must_be_kind_of/).size.must_equal 1
    end

    it "rejects without subject" do
      proc { spec.send(spec_class.test_methods.first) }.must_raise RuntimeError
    end

    it "verifies match" do
      spec_class.send(:subject) { "hello" }
      spec.send(spec_class.test_methods.first).must_equal true
    end

    it "verifies mismatch" do
      spec_class.send(:subject) { 1 }
      proc { spec.send spec_class.test_methods.first }.must_raise MiniTest::Assertion
    end
  end

  describe "wont" do
    let(:spec_class) do
      Class.new(MiniTest::Spec) do
        wont { KindOfMatcher.new String }
      end
    end
    let(:spec) { spec_class.new "A spec" }

    it "defines wont expectation" do
      spec_class.test_methods.grep(/wont_be_kind_of/).size.must_equal 1
    end

    it "rejects without subject" do
      proc { spec.send(spec_class.test_methods.first) }.must_raise RuntimeError
    end

    it "verifies match" do
      spec_class.send(:subject) { "hello" }
      proc { spec.send spec_class.test_methods.first }.must_raise MiniTest::Assertion
    end

    it "verifies mismatch" do
      spec_class.send(:subject) { 1 }
      spec.send(spec_class.test_methods.first).must_equal false
    end
  end
end
