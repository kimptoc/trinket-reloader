require 'yaml'
require 'net/http'
require 'json'
require 'fileutils'

config_file = ARGV[0]
puts "Checking projects in supplied config file:#{config_file}!"


config = YAML.load(File.read(config_file))



def http_call(endpoint, method = :GET, body = nil, multipart = nil, debug = :NODEBUG)

    puts "Calling: #{method} - #{endpoint}"

    if body
        puts "SENDING BODY:"
        puts body
    end

    url = URI.parse(endpoint)

    if method == :GET
        req = Net::HTTP::Get.new(url.to_s)
    elsif method == :POST
        req = Net::HTTP::Post.new(url.to_s)
    else
        req = Net::HTTP::Options.new(url.to_s)
    end

    if body
        req['Content-Type'] = 'application/json;charset=UTF-8'
        req.body = body.to_json
    elsif multipart
        data, headers = Multipart::Post.prepare_query(multipart)
        req['Content-Type'] = headers["Content-Type"]
        req.body = data
    end

    http = Net::HTTP.new(url.host, url.port)

    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.set_debug_output $stderr if debug == :DEBUG

    res = http.request(req)

    # puts res.code + "/" + res.message + "/" + res.body

    res

end

 

def svc_call(endpoint, method = :GET, body = nil, multipart = nil, debug = :NODEBUG)

    res = http_call(endpoint, method, body, multipart, debug)

    body_obj = nil
    body_obj = JSON.parse(res.body) if res.body && res.body.length > 0

    puts
    body_obj
end

# https://trinket.io/python/6823e0288d.json

config.each_pair do |name, id|
    puts "Name:#{name}, project id:#{id}"

    puts "Get trinket project json for each in config"
    res = svc_call "https://trinket.io/python/#{id}.json"
    puts "project config:#{res.inspect}"
    puts "save project locally"
    project_dir = "projects/#{name}/#{id}"
    FileUtils.mkdir_p project_dir
    res["code"].each do |code_file|
        File.write "#{project_dir}/#{code_file['name']}", code_file['content']
        puts "#{code_file['name']} length: #{code_file['content'].length}"
    end
    main_py = "#{project_dir}/main.py"
    if File::exist? main_py
        puts
        puts "Running #{name} project #{id}:"
        puts `python3 "#{main_py}"`
        puts
    end
end


