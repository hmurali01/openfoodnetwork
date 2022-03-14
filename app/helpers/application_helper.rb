# frozen_string_literal: true

module ApplicationHelper
  include RawParams
  include Pagy::Frontend

  def error_message_on(object, method, options = {})
    object = convert_to_model(object)
    obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

    return "" unless obj && obj.errors[method].present?

    errors = obj.errors[method].map { |err| h(err) }.join('<br />').html_safe

    if options[:standalone]
      content_tag(
        :div,
        content_tag(:span, errors, class: 'formError standalone'),
        class: 'checkout-input'
      )
    else
      content_tag(:span, errors, class: 'formError')
    end
  end

  def feature?(feature, user = nil)
    OpenFoodNetwork::FeatureToggle.enabled?(feature, user)
  end

  def ng_form_for(name, *args, &block)
    options = args.extract_options!

    form_for(name, *(args << options.merge(builder: AngularFormBuilder)), &block)
  end

  # Pass URL helper calls on to spree where applicable so that we don't need to use
  # spree.foo_path in any view rendered from non-spree-namespaced controllers.
  def method_missing(method, *args, &block)
    if method.to_s.end_with?('_path', '_url') && spree.respond_to?(method)
      spree.public_send(method, *args)
    else
      super
    end
  end

  def body_classes
    classes = []
    classes << "off-canvas" unless @hide_menu
    classes << @shopfront_layout
  end

  def pdf_stylesheet_pack_tag(source)
    if running_in_development?
      options = { media: "all", host: "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}" }
      stylesheet_pack_tag(source, **options)
    else
      wicked_pdf_stylesheet_pack_tag(source)
    end
  end

  def line_items_for_invoice(order)
    if @order.distributor.preferred_invoice_order_by_supplier
      order.line_items.sort do |a, b|
        if a.supplier == b.supplier
          a.product.name <=> b.product.name
        else
          a.supplier.name <=> b.supplier.name
        end
      end
    else
      order.line_items.sort do |a, b|
        a.product.name <=> b.product.name
      end
    end
  end
end
