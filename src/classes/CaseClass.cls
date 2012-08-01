public with sharing class CaseClass {

	public static Case processEmail(Messaging.Inboundemail email, Messaging.InboundEnvelope envelope) {
		Case myCase = new Case();
		string myReferenceId = getReferenceId(email.subject); 
        
        if (myReferenceId == null){
        	myCase = insertCaseFromEmail(email);
        	//Remove attachments to reduce heap size??
        	EmailMessageClass.sendAutoResponse(JSON.serialize(myCase), JSON.serialize(email), JSON.serialize(envelope));
        } else{
        	myCase = updateCaseFromEmail(myReferenceId, email);
        }
        EmailMessageClass.logEmailMessage(myCase.Id, email);
		return myCase;
  }
  
	public static string getReferenceId(String subject) {
		if(subject == null) return null;
		if (subject.contains('ref:') && subject.contains(':ref')) {
			Integer firstRef = subject.indexof('ref:');
			Integer lastRef = subject.lastindexof(':ref') + 4;
			return subject.substring(firstRef,lastRef);	
		}	
		return null;
	}
	
	public static string createReferenceId(string caseId){
	    return ' [ ref:' + String.valueOf(Userinfo.getOrganizationId()).substring(0,4) + 
			       String.valueOf(Userinfo.getOrganizationId()).substring(11,15) + '.' + 
			       caseId.substring(0,4) + caseId.substring(10,15) + ':ref ]';

	}
	
	private static Case insertCaseFromEmail(Messaging.InboundEmail email){
		GoogleLanguageDetection myDetection = GoogleTranslate.detectLanguage(email.subject);
		Language__c myLanguage = LanguageClass.findByISOCode(myDetection.detectedLanguage);
		Case myCase = new Case(Subject = email.subject
							  ,Description = email.plainTextBody
							  ,SuppliedEmail = email.fromAddress
                              ,SuppliedName = email.fromName
                              ,Origin = 'Email'
                              ,Language__c = myLanguage.Id
                              ,Language_Confidence__c = myDetection.confidence);
		insert myCase;
		return myCase;
	}
	
	private static Case updateCaseFromEmail(string referenceId, Messaging.InboundEmail email){
		Case myCase = findByReferenceId(referenceId);
		myCase.Status = 'Reply: Customer Email';
		update myCase;
		return myCase;
	}
	
	private static Case findByReferenceId(string referenceId){
		String queryWhere = '%' + referenceId + '%';
		List<EmailMessage> emails = [SELECT ParentId, Subject FROM EmailMessage WHERE Subject like :queryWhere];
		
		if (emails.size() != 0){
			for (EmailMessage myEmail : emails){
	    		//.equals() method is case sensitive whereas == is not case sensitive
		    	if (referenceId.equals(getReferenceId(myEmail.Subject))){
		    		return new Case(Id = myEmail.ParentId);
		    	}    	    	
	    	}    
	  	}
		return null;
	}
}