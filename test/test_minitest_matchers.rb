require "minitest/autorun"
require "minitest/matchers"

class BadMatcher; end

class KindOfMatcher
  def initialize klass
    @klass = klass
  end

  def description; "be kind of #{@klass}" end

  def matches? subject; subject.kind_of? @klass end
end

class BadSpec < MiniTest::Spec; end
class GoodSpec < MiniTest::Spec
  subject { [1, 2, 3] }
end

describe MiniTest::Matchers do
  let(:bad_spec)  { Class.new(BadSpec) }
  let(:good_spec) { Class.new(GoodSpec) }

  describe "check_matcher" do
    it "requires spec to have subject" do
      proc { bad_spec.must { BadMatcher.new } }.must_raise RuntimeError
    end

    it "requires matcher to have #description and #matches?" do
      proc { good_spec.must { BadMatcher.new } }.must_raise RuntimeError
      good_spec.must { KindOfMatcher.new(Object) }.must_be_kind_of KindOfMatcher
    end
  end

  describe "must" do
    subject do
      Class.new(good_spec) do
        must { KindOfMatcher.new String }
      end
    end

    let(:spec) { subject.new "A spec" }

    it "defines must expectation" do
      subject.test_methods.grep(/must_be_kind_of/).size.must_equal 1
    end

    it "passes when matches" do
      subject.send(:subject) { "hello" }
      proc { spec.send subject.test_methods.first }
    end

    it "raises error when does not match" do
      subject.send(:subject) { 1 }
      proc { spec.send subject.test_methods.first }.must_raise MiniTest::Assertion
    end
  end

  describe "wont" do
    subject do
      Class.new(good_spec) do
        wont { KindOfMatcher.new String }
      end
    end
    let(:spec) { subject.new "A spec" }

    it "defines wont expectation" do
      subject.test_methods.grep(/wont_be_kind_of/).size.must_equal 1
    end

    it "passes when does not match" do
      subject.send(:subject) { 1 }
      proc { spec.send subject.test_methods.first }
    end

    it "raises error when matches" do
      subject.send(:subject) { "hello" }
      proc { spec.send subject.test_methods.first }.must_raise MiniTest::Assertion
    end
  end
end
