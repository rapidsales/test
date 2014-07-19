global with sharing class Contacts_Ext{
    public Contacts_Ext(ApexPages.StandardController c) {}
        
    @RemoteAction
    global static List<Contact> getContactRecs(){
        return [select id, name, firstName, lastName, email, title, phone, 
                MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry,
                Account.Name,Contact_Pic__c from Contact order by FirstName limit 20];
    }
}