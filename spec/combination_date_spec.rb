# -*- encoding: utf-8 -*-
require 'spec_helper'

describe FormKeeper::CombinationConstraint::Date do

  it "validate value correctly" do

    constraint = FormKeeper::CombinationConstraint::Date.new
    constraint.validate(['2012', '2', '12'], true).should be_true
    constraint.validate(['2012', '2', '12', '12'], true).should_not be_true
    constraint.validate(['aaa', '12', '12'], true).should_not be_true
    constraint.validate(['2012', '28', '12'], true).should_not be_true
    constraint.validate(['2012', '2', '50'], true).should_not be_true

  end

end
