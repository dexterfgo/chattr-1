class ExampleOrator < Orator::Base

  # This defines the name of the orator.  THIS IS REQUIRED.  Orator will not
  # be able to correctly route your events to this orator if it is not put
  # here.
  #orator_name 'example'

  # This defines a before event.  It can take a block or a symbol.  If it's a
  # symbol, it'll call the method.
  #before do
  #  something
  #end

  # This defines the event `some_event`.  Note that the two have to have the
  # same value.  If they're different, you need to add a second argument
  # describing the method name (i.e. `on 'some_event', :some_method`).
  #on 'some_event'
  #def some_event(json)
  #  do_something
  #end

  # Inline syntax.
  #on 'other_event' do; end

  #after do
  #  other_thing
  #end

end

#Orator.add_orator(ExampleOrator)
