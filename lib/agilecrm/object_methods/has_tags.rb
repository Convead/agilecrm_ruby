module AgileCRM
  module ObjectMethods
    module HasTags

      def tags
        attributes[:tags] ||= []
      end

      def tags_with_time
        attributes[:tagsWithTime] ||= []
      end

      def add_tag(tag)
        add_tags tag
        tag
      end

      def add_tags(*_tags)
        _tags = _tags.map &:to_s
        self.tags = (tags + _tags).uniq
        _tags
      end

      def remove_tag(tag)
        remove_tags tag
        tag
      end

      def remove_tags(*_tags)
        _tags = _tags.map &:to_s
        self.tags = tags - _tags
        update_tags_with_time
        _tags
      end

      def clear_tags
        self.tags = []
        update_tags_with_time
        tags
      end

      def has_tag?(tag)
        tags.include? tag
      end

      private

        def tags=(_tags)
          attributes[:tags] = _tags
        end

        def update_tags_with_time
          tags_with_time.reject!{ |t| t[:entity_type] == 'tag' && !tags.include?(t[:tag]) }
        end

    end
  end
end