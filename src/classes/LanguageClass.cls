public with sharing class LanguageClass {

	public static Language__c findByISOCode(String ISOCode){
		return [SELECT Id FROM Language__c WHERE ISO_Code__c = :ISOCode];
	}

}