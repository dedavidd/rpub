require 'spec_helper'

describe RPub::Commands::Preview do
  before do
    Dir.chdir File.join(FIXTURES_DIRECTORY, 'preview')
  end

  after do
    File.unlink 'preview.html' if File.exist?('preview.html')
    File.unlink 'foo.bar' if File.exist?('foo.bar')
  end

  context 'generated content' do
    before { RPub::Commands::Preview.new.invoke }
    let(:subject) { File.read('preview.html') }

    it { should include('<p>foo</p>') }
    it { should include('<p>bar</p>') }
    it { should match(/foo.*bar/m) }
    it { should match(/<html>/) }
  end

  it 'should create new preview file' do
    expect {
      RPub::Commands::Preview.new.invoke
    }.to create_file('preview.html')
  end

  it 'should do nothing when there are no files to preview' do
    Dir.chdir FIXTURES_DIRECTORY
    expect {
      RPub::Commands::Preview.new.invoke
    }.to_not create_file('preview.html')
  end

  it 'should allow overriding the filename' do
    expect {
      RPub::Commands::Preview.new(['-o', 'foo.bar']).invoke
    }.to create_file('foo.bar')
  end

end
