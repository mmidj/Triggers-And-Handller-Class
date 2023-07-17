public with sharing class US25HandlerClass {
    public static void handleNewCaseWithParent(List<Case> newCases) {
        // Collect account IDs and case origins of new cases
        Set<ID> accountIds = new Set<ID>();
        Set<String> caseOrigins = new Set<String>();
        for (Case w1 : newCases) {
            accountIds.add(w1.AccountId);
            caseOrigins.add(w1.Origin);}        
        // Query existing open cases with the same origin and account
        Map<String, Case> existingCases = new Map<String, Case>();         
        for (Case existingCase : [SELECT Id, AccountId, Origin, CreatedDate
                                        FROM Case
                                        WHERE AccountId IN :accountIds AND Origin IN :caseOrigins
                                        ORDER BY AccountId, Origin, CreatedDate ASC]) {
            existingCases.put(existingCase.Origin + existingCase.AccountId, existingCase);
        }         
        // Assign parent cases to new cases
        for (Case w2 : newCases) {
            Case parentCase = existingCases.get(w2.Origin + w2.AccountId);
            if (parentCase != null) {
                w2.ParentId = parentCase.Id;
            }
        }
    } 
}