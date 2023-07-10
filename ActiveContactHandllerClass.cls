public with sharing class ActiveContactHandllerClass {
  
        public static void ActiveContacts(List<Contact> conList) {
            Set<Id> accIds = new Set<Id>(); 
            List<Account> accList = new List<Account>();
            
            for (Contact con : conList) {
                if (String.isNotBlank(con.AccountId)) {  
                    accIds.add(con.AccountId);
                }
            }
            
            for(Account acc:[SELECT Id, Active_Contacts_Team2__c, 
                                    (SELECT Id FROM Contacts WHERE Active_Team2__c=true) 
                             FROM Account 
                             WHERE Id IN:accIds]){
          
                if(!acc.Contacts.isEmpty()){ 
                    acc.Active_Contacts_Team2__c = acc.Contacts.size();
                    accList.add(acc);
                }else{
               
                    acc.Active_Contacts_Team2__c = 0;
                    accList.add(acc);
                }
                 }
            update accList;
        }
    }