module Customizable
  extend ActiveSupport::Concern

  included do
    has_many :custom_attributes, as: :customizable, dependent: :destroy,
             autosave: true

    before_save :save_custom_attributes
  end

  def method_missing(method_name, *arguments, &block)
    if should_load_custom_attributes?
      load_custom_attributes
      send(method_name, *arguments, &block)
    else
      super
    end
  end

  def respond_to?(method_name, include_private = false)
    if super
      true
    else
      load_custom_attributes if should_load_custom_attributes?
      custom_attribute_keys.find { |attribute| attribute == method_name.to_s.delete('=') }.present?
    end
  end

  private

  def should_load_custom_attributes?
    custom_attribute_keys.present? && custom_attributes_store.empty?
  end

  def load_custom_attributes
    custom_attributes.each do |attribute|
      custom_attributes_store[attribute.key] = attribute.value
    end

    define_attribute_accessors
  end

  def custom_attributes_store
    @custom_attributes_store ||= {}
  end

  def define_attribute_accessors
    custom_attribute_keys.each do |attribute|
      define_singleton_method(attribute) do
        custom_attributes_store[attribute]
      end

      define_singleton_method("#{attribute}=") do |value|
        custom_attributes_store[attribute] = value
      end
    end
  end

  def custom_attribute_keys
    @custom_attribute_keys ||= CustomAttributesProvider.where(model: self.class.name)
                                                       .map(&:key)
  end

  def save_custom_attributes
    custom_attribute_keys.each do |attribute|
      attr = custom_attributes.find_or_initialize_by(customizable: self, key: attribute)

      if persisted?
        attr.update(value: custom_attributes_store[attribute])
      else
        attr.value = custom_attributes_store[attribute]
      end
    end
  end
end
