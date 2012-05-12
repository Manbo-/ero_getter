require 'spec_helper'

describe EroGetter::Downloader::Base do
  let(:regex) { %r{http://example.net/\d+.html} }
  before do
    _regex = regex
    @klazz = Class.new(EroGetter::Downloader::Base) do
      name 'NijiEro BBS'
      url _regex
    end
    @klazz.stub(:to_s).and_return('TestClass')
  end

  describe "assign url_mapping" do
    it { EroGetter.url_mapping.should have_key regex }
    it { EroGetter.url_mapping[regex].should == @klazz }
  end

  describe :instance_methods do
    subject { @dl }
    context :good do
      before { @dl = @klazz.new('http://example.net/10101010.html') }
      its(:name) { should == 'NijiEro BBS' }
      its(:url_regex) { should == regex }
      its(:base_dir) { should == 'test_class' }
      its(:http_client) { should be_a HTTPClient }
    end
    context :url_mismatch do
      it {
        lambda {
          @klazz.new('http://example.com/10101010.html')
        }.should raise_error
      }
    end
  end
end
