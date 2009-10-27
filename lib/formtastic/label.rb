# coding: utf-8

module Formtastic # :nodoc:
  
  module Label
    
    # Generates the label for the input. It also accepts the same arguments as
    # Rails label method. It has three options that are not supported by Rails
    # label method:
    #
    # * :required - Appends an abbr tag if :required is true
    # * :label - An alternative form to give the label content. Whenever label
    #            is false, a blank string is returned.
    # * :as_span - When true returns a span tag with class label instead of a label element
    # * :input_name - Gives the input to match for. This is needed when you want to
    #                 to call f.label :authors but it should match :author_ids.
    #
    # == Examples
    #
    #  f.label :title # like in rails, except that it searches the label on I18n API too
    #
    #  f.label :title, "Your post title"
    #  f.label :title, :label => "Your post title" # Added for formtastic API
    #
    #  f.label :title, :required => true # Returns <label>Title<abbr title="required">*</abbr></label>
    #
    def label(method, options_or_text=nil, options=nil)
      if options_or_text.is_a?(Hash)
        return "" if options_or_text[:label] == false
        options = options_or_text
        text = options.delete(:label)
      else
        text = options_or_text
        options ||= {}
      end
      text = localized_string(method, text, :label) || humanized_attribute_name(method)
      text += required_or_optional_string(options.delete(:required))
      
      # special case for boolean (checkbox) labels, which have a nested input
      text = (options.delete(:label_prefix_for_nested_input) || "") + text
      
      input_name = options.delete(:input_name) || method
      if options.delete(:as_span)
        options[:class] ||= 'label'
        template.content_tag(:span, text, options)
      else
        super(input_name, text, options)
      end
    end
    
    protected
    
    # Prepare options to be sent to label
    #
    def options_for_label(options)
      options.slice(:label, :required).merge!(options.fetch(:label_html, {}))
    end
    
    # Generates the required or optional string. If the value set is a proc,
    # it evaluates the proc first.
    #
    def required_or_optional_string(required) #:nodoc:
      string_or_proc = case required
        when true
          required_string
        when false
          optional_string
        else
          required
      end
  
      if string_or_proc.is_a?(Proc)
        string_or_proc.call
      else
        string_or_proc.to_s
      end
    end
    
  end
  
end