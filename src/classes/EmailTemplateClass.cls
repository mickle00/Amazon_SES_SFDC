public with sharing class EmailTemplateClass {
	
	public static String getReplyText(string bodyText, string newLine, string originalText){
		return bodyText + newLine + newLine + Utilities.repeatString('#', 25) + ' YOUR REQUEST ' + Utilities.repeatString('#', 25) + newLine + newLine + originalText;
	}
	
	public static EmailTemplate findByLanguageOrDefault(string fromAddress, Id languageId){
		Localized_Auto_Response__c myAutoResponse;
		List<Localized_Auto_Response__c> languageAutoResponses = [SELECT Id, Email_Template_Id__c FROM Localized_Auto_Response__c WHERE Language__c = :languageId AND CaseTeam__r.Email_Service_Address__c = :fromAddress];
		if (languageAutoResponses.size() == 1) {
			myAutoResponse = languageAutoResponses[0];
		} else {
			// TODO: Get in one Query
			myAutoResponse = [SELECT Id, Email_Template_Id__c FROM Localized_Auto_Response__c WHERE CaseTeam__r.Email_Service_Address__c = :fromAddress AND Default__c = true LIMIT 1];
		}
		return [SELECT Id, Body, HtmlValue FROM EmailTemplate WHERE Id = :myAutoResponse.Email_Template_Id__c LIMIT 1];
	}

}