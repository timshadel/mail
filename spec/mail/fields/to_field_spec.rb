# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ToField do
  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
  
  describe "initialization" do

    it "should initialize" do
      doing { Mail::ToField.new("To", "Mikel") }.should_not raise_error
    end

    it "should mix in the CommonAddress module" do
      Mail::ToField.included_modules.should include(Mail::CommonAddress::InstanceMethods) 
    end

    it "should accept two strings with the field separate" do
      t = Mail::ToField.new('To', 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'To'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string with the field name" do
      t = Mail::ToField.new('To: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'To'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'To'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oTours in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.formatted.should == ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
      t.formatted.first.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      t.addresses.last.should == 'ada@test.lindsaar.net'
    end

    it "should return one address and a group" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.addresses[0].should == 'sam@me.com'
      t.addresses[1].should == 'mikel@me.com'
      t.addresses[2].should == 'bob@you.com'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.value.should == 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.encoded.should == "To: sam@me.com, \r\n\tmy_group: mikel@me.com, \r\n\tbob@you.com;\r\n"
    end
    
    it "should return the decoded line" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.decoded.should == "sam@me.com, my_group: mikel@me.com, bob@you.com;"
    end
    
  end
  
  
end
