require 'spec_helper'

describe VScripts::API do
  it 'should allow accessing the home page' do
    get '/'
    expect(last_response).to be_ok
  end
  it 'should set header' do
    get '/'
    expect(last_response.header).to have_key('X-API-Version')
  end
  it 'should contain' do
    get '/'
    expect(last_response.body).to include('VScripts')
  end
end
