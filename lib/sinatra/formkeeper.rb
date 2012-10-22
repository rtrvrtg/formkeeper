#--
# Copyright (C) 2012 Lyo Kato, <lyo.kato _at_ gmail.com>.
#
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the 
# "Software"), to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to 
# the following conditions: 
#
# The above copyright notice and this permission notice shall be 
# included in all copies or substantial portions of the Software. 
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

require 'formkeeper'

module Sinatra
  module FormKeeper
    def form_failure_messages(arg)
      case arg
      when String
        messages = ::FormKeeper::Messages.from_file(arg)
      when Hash
        messages = ::FormKeeper::Messages.new(arg)
      else
        raise ArgumentError.new
      end
      set :form_messages, messages
    end
    module Helpers
      def reset_form
        @form_report = ::FormKeeper::Report.new
      end
      def form(&block)
        if block
          rule = ::FormKeeper::Rule.new
          rule.instance_eval(block)
          messages = settings.form_messages
          @form_report = 
            settings.form_validator.validate(params, @form_rule, messages)
        end
        @form_report
      end
      def fill_in_form(output, others={})
        filled = settings.form_respondent.fill_up(output, params.merge(others))
        output.replace(filled)
        output
      end
    end
    def self.registered(app)
      app.helpers Helpers
      app.set :form_validator, ::FormKeeper::Validator.new
      app.set :form_respondent, ::FormKeeper::Respondent.new
      app.set :form_messages, nil
      app.before do
        reset_form
      end
    end
  end
  register FormKeeper
end

