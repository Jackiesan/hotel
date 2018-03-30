## What classes does each implementation include? Are the lists the same?
  Both implementations have the 3 same classes.
  1. CartEntry
  2. ShoppingCart
  3. Order


## Write down a sentence to describe each class.

  1. CartEntry - creates objects of cart entries that have attributes unit price and quantity.
  2. ShoppingCart - initialized with array of entries. In implementation B the carts total subtotal is calculated.
  3. Order - Creates new instance of ShoppingCart and calculates total price of cart including the tax.

## How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
  * The relationship between Order and ShoppingCart is has-A. Order has an instance of shopping cart. Shopping cart also has objects of cart entry which holds information of each entry such as unit price and quantity.

## What data does each class store? How (if at all) does this differ between the two implementations?
  Implementation A -
  CartEntry - Stores unit price and quantity.
  ShoppingCart - Stores array of cart entry objects.
  Order - Stores new instance of a shopping cart and total price of order.

  Implementation B -
  CartEntry - Stores unity price and quantity of an item. Also stores the price of the item * quantity.
  ShoppingCart - Stores array of entry objects and the subtotal of all entries.
  Order - Stores instance of new shopping cart and total price of order.

## What methods does each class have? How (if at all) does this differ between the two implementations?
  Implementation A -
  CartEntry & ShoppingCart --> None
  Order --> total_price - calculates total cost of order including tax.

  Implementation B -
  CartEntry - price - calculates subtotal of all entries.
  Order - total_price - calculates total price of cart including tax.


## Consider the Order#total_price method. In each implementation:

## Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?

  Implementation A - logic to compute price is retained in Order.
  Implementation B - logic to compute price is delegated to class ShoppingCart which calculates the subtotal of items in shopping cart.

## Does total_price directly manipulate the instance variables of other classes? If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?

  Total price in implementation A directly manipulates the instance variables of other classes because it is expecting to know what unit_price is and quantity is of the entry. If we were to use this implementation we would need to change it as well if items were cheaper if bought in bulk.

  It would be easier to modify Implementation B since the total calculation does not depend on knowing methods of other classes. The method in shopping cart price will be the only method that needs to be changed.


## Which implementation better adheres to the single responsibility principle? Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?

Implementation B adheres a lot more to the single responsibility principle. Each class has a single responsibility to calculate how much it is contributing to the total cost of the order. It is also more loosely coupled as it knows less about other classes when compared to implementation A.
