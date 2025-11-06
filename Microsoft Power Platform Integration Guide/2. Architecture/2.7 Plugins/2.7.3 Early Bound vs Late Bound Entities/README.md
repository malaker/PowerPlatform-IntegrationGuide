Listing 2.28 Late Bound Entity Example

```c#
Entity contact = new Entity("contact");
        
contact["firstname"] = "John";
contact["emailaddress1"] = "john@example.com";

service.Create(contact);
```

Listing 2.29 Early Bound Entity Example

```c#
Contact contact = new Contact
{
 	FirstName = "John",
 	EMailAddress1 = "john@example.com"
};

service.Create(contact);
```

Listing 2.30 PAC CLI - generating early bound classes

```
pac modelbuilder build –settingsTemplateFile ./builder-settings.json
```