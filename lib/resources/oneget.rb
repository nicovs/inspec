# encoding: utf-8

# This resource talks with OneGet (https://github.com/OneGet/oneget)
# Its part of Windows Management Framework 5.0 and part of Windows 10
#
# Usage:
# describe oneget('zoomit') do
#   it { should be_installed }
# end
class OneGetPackage < Vulcano.resource(1)
  name 'oneget'

  def initialize(package_name)
    @package_name = package_name
  end

  def info
    return @info if defined?(@info)

    @info = {}
    @info[:type] = 'oneget'

    cmd = vulcano.run_command("Get-Package -Name '#{@package_name}' | ConvertTo-Json")
    # cannot rely on exit code for now, successful command returns exit code 1
    # return nil if cmd.exit_status != 0
    # try to parse json

    begin
      pkgs = JSON.parse(cmd.stdout)
    rescue JSON::ParserError => _e
      return @info
    end

    @info[:name] = pkgs['Name']
    @info[:version] = pkgs['Version']
    @info[:installed] = true
    @info
  end

  def installed?
    info[:installed] == true
  end

  def version
    info[:version]
  end

  def to_s
    "oneget package #{@package_name}"
  end
end