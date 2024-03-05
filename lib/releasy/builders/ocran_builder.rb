require "releasy/builders/windows_builder"

module Releasy
module Builders
  # Functionality for a {WindowsBuilder} that use Ocran to build on Windows.
  #
  # @attr icon [String] Optional filename of icon to show on executable/installer (.ico).
  #
  # @abstract
  class OcranBuilder < WindowsBuilder
    OCRAN_COMMAND = "ocran"
    ICON_EXTENSION = ".ico"

    # @return [String] Extra options to send to Ocran, but they are unlikely to be needed explicitly. '_--no-enc_' is automatically used if {#exclude_encoding} is called and '_--console_' or '_--window_' is used based on {#executable_type}
    attr_accessor :ocran_parameters

    def valid_for_platform?; Releasy.win_platform?; end

    attr_reader :icon
    def icon=(icon)
      raise ArgumentError, "icon must be a #{ICON_EXTENSION} file" unless File.extname(icon) == ICON_EXTENSION
      @icon = icon
    end

    protected
    def setup
      @icon = nil
      @ocran_parameters = ""
      super
    end

    protected
    def ocran_command
      command = 'bundle exec '
      command += %[#{OCRAN_COMMAND} "#{project.executable}" ]
      command += "--#{effective_executable_type} "
      command += "--no-enc " if encoding_excluded?
      command += "#{ocran_parameters} " if ocran_parameters
      command += %[--icon "#{icon}" ] if icon
      command += (project.files - [project.executable]).map {|f| %["#{f}"]}.join(" ")
      command
    end
  end
end
end