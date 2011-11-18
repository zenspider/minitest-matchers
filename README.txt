= minitest-matchers

* http://github.com/zenspider/minitest-matchers

== DESCRIPTION:

minitest-matchers adds support for RSpec/Shoulda-style matchers to
minitest/unit and minitest/spec.

More information about matchers can be found here:
* https://www.relishapp.com/rspec/rspec-expectations
* http://railscasts.com/episodes/157-rspec-matchers-macros

For use with Rails check out (ValidAttribute + Capybara):
* https://github.com/wojtekmach/minitest-rails-example

== FEATURES/PROBLEMS:

* Enables you to use existing matcher classes from projects like
  valid_attribute and in the future shoulda-matchers and maybe even remarkable.
* Can be used both in MiniTest::Unit::TestCase & MiniTest::Spec

== SYNOPSIS:

* see example matcher: https://github.com/bcardarella/valid_attribute/blob/master/lib/valid_attribute/matcher.rb

    gem "minitest"
    require "minitest/matchers"
    require "minitest/autorun"
    require "valid_attribute"
    require "active_model"

    class Post
      include ActiveModel::Validations
      attr_accessor :title
      validates :title, :presence => true, :length => 4..20
    end

    # Using minitest/unit

    class PostTest < MiniTest::Unit::TestCase
      include ValidAttribute::Method

      def test_validations
        post = Post.new

        assert_must have_valid(:title).when("Good"), post
        assert_wont have_valid(:title).when(""), post
      end
    end

    # Using minitest/spec

    describe Post do
      include ValidAttribute::Method

      it "should have validations" do
        post = Post.new

        post.must have_valid(:title).when("Good")
        post.wont have_valid(:title).when("")
      end
    end

    # Using minitest/spec with subject

    describe Post do
      subject { Post.new }

      it { must have_valid(:title).when("Hello") }
      it { wont have_valid(:title).when("", nil, "Bad") }
    end

== REQUIREMENTS:

* minitest >= 2.7.0

== INSTALL:

* sudo gem install minitest-matchers

== LICENSE:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb, Wojciech Mach

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
