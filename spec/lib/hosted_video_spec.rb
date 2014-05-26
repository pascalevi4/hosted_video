# encoding: utf-8
require 'spec_helper'

describe HostedVideo do
  let(:invalid_urls) { ['http://www.youtube.com/watch?v=4wTLj5Xk',
                        'http://www.youtub.com/watch?v=4wTLjEqj5Xk',
                        'http://vimeo.com/42',
                        'http://vmeo.com/63645580'] }

  it 'raises InvalidUrlError if url is invalid' do
    expect {
      subject.from_url('http://vmeo.com/63645580')
    }.to raise_error(HostedVideo::InvalidUrlError)
  end

  describe 'additional providers' do
    it 'uses additional provider' do
      class MyProvider < HostedVideo::Providers::Base
        def self.can_parse?(url)
          url =~ /myprovider\.com\/\d{3}.*/
        end
      end

      HostedVideo.configure do |c|
        c.additional_providers += [MyProvider]
      end

      subject.from_url('http://myprovider.com/111').kind.should == 'myprovider'
    end
  end

  context 'youtube url' do
    let(:parser) { subject.from_url('http://www.youtube.com/watch?v=4wTLjEqj5Xk&a=GxdCwVVULXctT2lYDEPllDR0LRTutYfW') }

    it 'successfully determines' do
      parser.kind.should == 'youtube'
    end

    it 'gets right video id' do
      parser.vid.should == '4wTLjEqj5Xk'
    end

    it 'gets right preview url' do
      parser.preview.should == "http://img.youtube.com/vi/4wTLjEqj5Xk/hqdefault.jpg"
    end

    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://www.youtube.com/embed/4wTLjEqj5Xk?wmode=transparent'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://www.youtube.com/embed/4wTLjEqj5Xk?wmode=transparent'></iframe>"
      end
    end

    it 'sucessfully parses youtu.be' do
      video = subject.from_url("http://youtu.be/SroTP8794aY")
      video.kind.should    == 'youtube'
      video.vid.should     == 'SroTP8794aY'
      video.preview.should == "http://img.youtube.com/vi/SroTP8794aY/hqdefault.jpg"
    end
  end

  context 'youtube by iframe src url' do
    let(:parser) { subject.from_url('//www.youtube.com/embed/MT4oShGnFuw?wmode=transparent') }

    it 'successfully determines' do
      parser.kind.should == 'youtubebyiframe'
    end

    it 'gets right video id' do
      parser.vid.should == 'MT4oShGnFuw'
    end

    it 'gets right preview url' do
      parser.preview.should == "http://img.youtube.com/vi/MT4oShGnFuw/hqdefault.jpg"
    end

    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://www.youtube.com/embed/MT4oShGnFuw?wmode=transparent'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://www.youtube.com/embed/MT4oShGnFuw?wmode=transparent'></iframe>"
      end
    end
  end

  context 'vimeo url' do
    let(:parser) { subject.from_url('https://vimeo.com/63645580') }

    it 'successfully determines' do
      parser.kind.should == 'vimeo'
    end

    it 'gets right video id' do
      parser.vid.should == '63645580'
    end

    it 'get right preview url' do
      stub_request(:get, "http://vimeo.com/api/v2/video/63645580.json")
        .to_return(:body => "[{\"id\":63645580,\"title\":\"lalala\",\"description\":\"\",\"url\":\"http:\\/\\/vimeo.com\\/63645580\",\"upload_date\":\"2011-12-11 08:32:29\",\"thumbnail_small\":\"http:\\/\\/i.vimeocdn.com\\/video\\/227287871_100x75.jpg\",\"thumbnail_medium\":\"http:\\/\\/i.vimeocdn.com\\/video\\/227287871_200x150.jpg\",\"thumbnail_large\":\"http:\\/\\/i.vimeocdn.com\\/video\\/63645580_640.jpg\",\"user_id\":7790763,\"user_name\":\"Thomas Schank\",\"user_url\":\"http:\\/\\/vimeo.com\\/drtom\",\"user_portrait_small\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_30x30.png&s=30\",\"user_portrait_medium\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_75x75.png&s=75\",\"user_portrait_large\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_100x100.png&s=100\",\"user_portrait_huge\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_300x300.png&s=300\",\"stats_number_of_likes\":5,\"stats_number_of_plays\":221,\"stats_number_of_comments\":0,\"duration\":791,\"width\":640,\"height\":360,\"tags\":\"ruby, programming language, eigenclass, object hierarchy\",\"embed_privacy\":\"anywhere\"}]", :status => 200, :headers => { 'Content-Length' => 3 })
      parser.preview.should == "http://i.vimeocdn.com/video/63645580_640.jpg"
    end

    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://player.vimeo.com/video/63645580?api=0'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://player.vimeo.com/video/63645580?api=0'></iframe>"
      end
    end
  end

  context 'vimeo iframe src url' do
    let(:parser) { subject.from_url('//player.vimeo.com/video/33481092') }

    it 'successfully determines' do
      parser.kind.should == 'vimeobyiframe'
    end

    it 'gets right video id' do
      parser.vid.should == '33481092'
    end

    it 'get right preview url' do
      stub_request(:get, "http://vimeo.com/api/v2/video/33481092.json")
        .to_return(:body => "[{\"id\":33481092,\"title\":\"lalala\",\"description\":\"\",\"url\":\"http:\\/\\/vimeo.com\\/33481092\",\"upload_date\":\"2011-12-11 08:32:29\",\"thumbnail_small\":\"http:\\/\\/i.vimeocdn.com\\/video\\/227287871_100x75.jpg\",\"thumbnail_medium\":\"http:\\/\\/i.vimeocdn.com\\/video\\/227287871_200x150.jpg\",\"thumbnail_large\":\"http:\\/\\/i.vimeocdn.com\\/video\\/33481092_640.jpg\",\"user_id\":7790763,\"user_name\":\"Thomas Schank\",\"user_url\":\"http:\\/\\/vimeo.com\\/drtom\",\"user_portrait_small\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_30x30.png&s=30\",\"user_portrait_medium\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_75x75.png&s=75\",\"user_portrait_large\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_100x100.png&s=100\",\"user_portrait_huge\":\"http:\\/\\/www.gravatar.com\\/avatar\\/4edb77ba747ee69a9540046a24611981?d=http%3A%2F%2Fi.vimeocdn.com%2Fportrait%2Fdefault-red_300x300.png&s=300\",\"stats_number_of_likes\":5,\"stats_number_of_plays\":221,\"stats_number_of_comments\":0,\"duration\":791,\"width\":640,\"height\":360,\"tags\":\"ruby, programming language, eigenclass, object hierarchy\",\"embed_privacy\":\"anywhere\"}]", :status => 200, :headers => { 'Content-Length' => 3 })
      parser.preview.should == "http://i.vimeocdn.com/video/33481092_640.jpg"
    end

    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://player.vimeo.com/video/33481092?api=0'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://player.vimeo.com/video/33481092?api=0'></iframe>"
      end
    end
  end

  context 'rutube url' do
    let(:parser) { subject.from_url('http://rutube.ru/video/52b48444f3efcfd2c2346972dfa16d6c/') }

    it 'successfully determines' do
      parser.kind.should == 'rutube'
    end

    it 'gets right video id' do
      parser.vid.should == '52b48444f3efcfd2c2346972dfa16d6c'
    end

    it 'get right preview url' do
      stub_request(:get, "http://rutube.ru/api/video/52b48444f3efcfd2c2346972dfa16d6c/?format=json")
        .to_return(:body => "{\"description\": \"\\u043f\\u043e\\u0434\\u0431\\u043e\\u0440\\u043a\\u0430\", \"title\": \"\\u043f\\u0440\\u043e\\u0432\\u0438\\u043d\\u0438\\u0432\\u0448\\u0438\\u0435\\u0441\\u044f \\u0441\\u043e\\u0431\\u0430\\u043a\\u0438\", \"is_hidden\": false, \"created_ts\": \"2014-04-08T10:12:50\", \"html\": \"<iframe width=\\\"720\\\" height=\\\"405\\\" src=\\\"//rutube.ru/video/embed/6910411\\\" frameborder=\\\"0\\\" webkitAllowFullScreen mozallowfullscreen allowfullscreen></iframe>\", \"id\": \"52b48444f3efcfd2c2346972dfa16d6c\", \"thumbnail_url\": \"http://pic.rutube.ru/video/1d/c8/1dc8a4d7ff8accdf22d32a4e89e9fd37.jpg\", \"for_registered\": false, \"for_linked\": false, \"video_url\": \"http://rutube.ru/video/52b48444f3efcfd2c2346972dfa16d6c/\", \"duration\": 287, \"has_high_quality\": true, \"hits\": 3302, \"is_adult\": false, \"is_deleted\": false, \"last_update_ts\": \"2014-04-08T15:51:41\", \"embed_url\": \"http://rutube.ru/video/embed/6910411\", \"source_url\": \"http://rutube.ru/tracks/6910411.html\", \"is_external\": false, \"author\": {\"id\": 216135, \"name\": \"NADEZHDA\", \"avatar_url\": \"http://pic.rutube.ru/user/f8/5f/f85ff0c9f3e57858502ff5fff0058af7.jpeg\", \"site_url\": \"http://rutube.ru/video/person/216135/\"}, \"category\": {\"id\": 10, \"category_url\": \"http://rutube.ru/video/category/10/\", \"name\": \"\\u0416\\u0438\\u0432\\u043e\\u0442\\u043d\\u044b\\u0435\"}, \"picture_url\": \"\", \"rutube_poster\": null, \"is_official\": false, \"restrictions\": null, \"action_reason\": 0, \"show\": null, \"persons\": \"http://rutube.ru/api/metainfo/video/52b48444f3efcfd2c2346972dfa16d6c/videoperson\", \"genres\": \"http://rutube.ru/api/metainfo/video/52b48444f3efcfd2c2346972dfa16d6c/videogenre\", \"music\": null, \"track_id\": 6910411}", :status => 200, :headers => { 'Content-Length' => 3 })
      parser.preview.should == "http://pic.rutube.ru/video/1d/c8/1dc8a4d7ff8accdf22d32a4e89e9fd37.jpg"
    end


    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://rutube.ru/video/embed/52b48444f3efcfd2c2346972dfa16d6c'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://rutube.ru/video/embed/52b48444f3efcfd2c2346972dfa16d6c'></iframe>"
      end
    end
  end

  context 'rutube iframe src url' do
    let(:parser) { subject.from_url('http://rutube.ru/video/embed/94867125d81559df05cbcd3713a67c78') }

    it 'successfully determines' do
      parser.kind.should == 'rutubebyiframe'
    end

    it 'gets right video id' do
      parser.vid.should == '94867125d81559df05cbcd3713a67c78'
    end

    it 'get right preview url' do
      stub_request(:get, "http://rutube.ru/api/video/94867125d81559df05cbcd3713a67c78/?format=json")
        .to_return(:body => "{\"description\": \"\\u043f\\u043e\\u0434\\u0431\\u043e\\u0440\\u043a\\u0430\", \"title\": \"\\u043f\\u0440\\u043e\\u0432\\u0438\\u043d\\u0438\\u0432\\u0448\\u0438\\u0435\\u0441\\u044f \\u0441\\u043e\\u0431\\u0430\\u043a\\u0438\", \"is_hidden\": false, \"created_ts\": \"2014-04-08T10:12:50\", \"html\": \"<iframe width=\\\"720\\\" height=\\\"405\\\" src=\\\"//rutube.ru/video/embed/6910411\\\" frameborder=\\\"0\\\" webkitAllowFullScreen mozallowfullscreen allowfullscreen></iframe>\", \"id\": \"52b48444f3efcfd2c2346972dfa16d6c\", \"thumbnail_url\": \"http://pic.rutube.ru/video/1d/c8/94867125d81559df05cbcd3713a67c78.jpg\", \"for_registered\": false, \"for_linked\": false, \"video_url\": \"http://rutube.ru/video/52b48444f3efcfd2c2346972dfa16d6c/\", \"duration\": 287, \"has_high_quality\": true, \"hits\": 3302, \"is_adult\": false, \"is_deleted\": false, \"last_update_ts\": \"2014-04-08T15:51:41\", \"embed_url\": \"http://rutube.ru/video/embed/6910411\", \"source_url\": \"http://rutube.ru/tracks/6910411.html\", \"is_external\": false, \"author\": {\"id\": 216135, \"name\": \"NADEZHDA\", \"avatar_url\": \"http://pic.rutube.ru/user/f8/5f/f85ff0c9f3e57858502ff5fff0058af7.jpeg\", \"site_url\": \"http://rutube.ru/video/person/216135/\"}, \"category\": {\"id\": 10, \"category_url\": \"http://rutube.ru/video/category/10/\", \"name\": \"\\u0416\\u0438\\u0432\\u043e\\u0442\\u043d\\u044b\\u0435\"}, \"picture_url\": \"\", \"rutube_poster\": null, \"is_official\": false, \"restrictions\": null, \"action_reason\": 0, \"show\": null, \"persons\": \"http://rutube.ru/api/metainfo/video/52b48444f3efcfd2c2346972dfa16d6c/videoperson\", \"genres\": \"http://rutube.ru/api/metainfo/video/52b48444f3efcfd2c2346972dfa16d6c/videogenre\", \"music\": null, \"track_id\": 6910411}", :status => 200, :headers => { 'Content-Length' => 3 })
      parser.preview.should == "http://pic.rutube.ru/video/1d/c8/94867125d81559df05cbcd3713a67c78.jpg"
    end


    describe 'iframe_code' do
      it 'gets right iframe html' do
        parser.iframe_code.should == "<iframe width='420' height='315' frameborder='0' src='http://rutube.ru/video/embed/94867125d81559df05cbcd3713a67c78'></iframe>"
      end

      it 'receives attributes and applies them to iframe tag' do
        parser.iframe_code({ wmode: true }).should == "<iframe width='420' height='315' frameborder='0' wmode='true' src='http://rutube.ru/video/embed/94867125d81559df05cbcd3713a67c78'></iframe>"
      end
    end
  end

end