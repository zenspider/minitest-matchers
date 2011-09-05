= minitest-matchers

* http://github.com/zenspider/minitest-matchers

== DESCRIPTION:

minitest-matchers adds support for RSpec/Shoulda-style matchers to
MiniTest::Spec.

A matcher is a class that must implement #description and #matches?
methods. Expactations are then builded using these two methods.

== FEATURES/PROBLEMS:

* Enables you to define reusable matcher classes

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

    describe Post do
      subject { Post.new }

      must { have_valid(:title).when("Hello") }
      wont { have_valid(:title).when("", nil, "Bad") }
    end

== REQUIREMENTS:

* minitest > 2.5.0

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
