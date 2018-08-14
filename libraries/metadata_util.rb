include Chef::Mixin::ShellOut

module MacOS
  class MetadataUtil
    attr_reader :status_flags

    def initialize(volume)
      mdutil_possible_states = { 'Indexing enabled.' => ['on', ''],
                                 'Indexing disabled.' => ['off', ''],
                                 'Indexing and searching disabled.' => ['off', '-d'] }

      @status_flags = mdutil_possible_states[volume_current_state(volume)]
                      .insert(1, volume)
    end

    def mdutil_output(volume)
      shell_out('/usr/bin/mdutil', '-s', volume).stdout
    end

    def volume_current_state(volume)
      mdutil_output(volume).split(':')[1].strip
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
