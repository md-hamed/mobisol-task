## Mobisol Custom Attributes
This is my solution to Mobisol's Recruitment Exercise. It's an implementation for dynamic custom attributes that can be added to any model.

#### Ruby version
2.5.1

#### Rails version
5.2.1

#### Installation 
Just the normal installation path, nothing mysteriuos.
```
bundle
rake db:prepare
rails s
```
and tada :tada:

#### Usage
First, include the concern named `Customizable` in the model that you need to include custom attributes to. The logic to store custom attributes in any model is encapsulated in this concern.

For example, in the Customer model, we have:

```
class Customer < ApplicationRecord
  include Customizable
end
```

Then, define the custom attributes that need to be added to the model in the `CustomAttributesProvider` model. 

```
  > CustomAttributesProvider.create(model: 'Customer', key: 'age')
  > CustomAttributesProvider.create(model: 'Customer', key: 'email')
```

Then, you can access your custom attributes the usual way.

```
  >  c = Customer.create(name: 'hamed', age: 25, email: 'hamed.ccp@gmail.com')
  >  c.age
  => "25"
  >  c.email
  => "hamed.ccp@gmail.com"
  >  c.update(age: 26)
  >  c.reload.age
  => "26"
```

#### How does it work?
* The custom attribues keys that need to be added to a model are defined in the `CustomAttributeProvider` model.
* The custom attributes themselves are defined in the `CustomAttribute` model with a reference to the instanec of the model that is using this custom attribute.
* Everytime a model with custom attribute is created/updated, the associated custom attributes are created/updated accordingly.

#### Can we do better?
Of course! We can save some DB hits by optimizing the configuration to define custom attributes to be read from a config file. We can also keep track of whether the attribute has been changed or not to save us from unncessary updates.
