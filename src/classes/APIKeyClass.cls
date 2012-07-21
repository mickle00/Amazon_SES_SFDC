public with sharing class APIKeyClass {
	
	public Map<String, API_Key__c> allAPIKeys;
	
	public APIKeyClass(){
		this.allAPIKeys = API_Key__c.getAll();
	}
	
	public API_Key__c getInstance(String name){
		return this.allAPIKeys.get(name);
	}

}