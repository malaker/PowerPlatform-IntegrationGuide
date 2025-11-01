Listing 3.13 Power Automate - comparing dates

```
if(equals(
  formatDateTime(item()?['Created'], 'MM-yyyy'),
  formatDateTime(utcNow(), 'MM-yyyy')
),'dates equal','dates arent equal')

```

Listing 3.14 Power Automate - example output with array

```
{
  'value':[
           {'Title':'Book A'},
           {'Title':'Book B'}
          ]
}

```

Listing 3.15 Power Automate - accessing first element's property

```
first(outputs('Get_items')?['body/value'])?['Title']
```

Listing 3.16 Power Automate - accessing first element's property second approach

```
first(body(outputs('Get_items'))?['value'])?['Title']
```

Listing 3.17 Power Automate - accessing first element's property third approach

```
outputs('Get_items')?['body/value']?[0]?['Title']
```

Listing 3.18 Power Automate - coalesce function example

```
coalesce(outputs('Get_items')?['body/value']?[0]?['Title'],'---')
```

Listing 3.19 Power Automate – using addProperty function to extend object variable

```
addProperty(variables('Dictionary'),'setting3',2)
```

Listing 3.20 Referencing object property

```
variables('Dictionary')['setting1']
```