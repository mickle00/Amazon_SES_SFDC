public with sharing class EmailMessageClass {
	
	//TODO: Move to Map
	/**
	EmailMessage.Status VALUES:
	'0' = New
	'1' = Read
	'2' = Replied
	'3' = Sent
	'4' = Forwarded
	**/
	
	public static Id logEmailMessage(Id parentId, Messaging.InboundEmail email) {
		EmailMessage newEmail = new EmailMessage(ParentId = parentId
	                                          ,Incoming = true
	                                          ,Subject = email.subject
	                                          ,FromAddress = email.fromAddress
	                                          ,FromName = email.fromName
	                                          ,ToAddress = Utilities.listToDelimitedString(email.toAddresses, ';')
	                                          ,TextBody = email.plaintextBody
	                                          ,HtmlBody = email.htmlBody
	                                          ,MessageDate = system.now()
	                                          ,CCAddress = Utilities.listToDelimitedString(email.ccAddresses, ';')
	                                          //TODO: Fix
	                                          ,Status = '0'
	                                          ,Headers = JSON.serializePretty(email.headers)
	                                          );
	  
		insert newEmail;
		return newEmail.Id; 
	}
	
	public static Id logEmailMessageFromAmazonEmail(Id parentId, SESEmail amazonEmail){
		EmailMessage newEmail = new EmailMessage(ParentId = parentId
	                                          ,Incoming = true
	                                          ,Subject = amazonEmail.subject
	                                          ,FromAddress = amazonEmail.fromAddress
	                                          //,FromName = CaseTeam.findByEmailServiceAddress(amazonEmail.fromAddress).Name
	                                          ,ToAddress = Utilities.listToDelimitedString(amazonEmail.toAddresses, ';')
	                                          ,TextBody = amazonEmail.plainTextBody
	                                          ,MessageDate = system.now()
	                                          ,CCAddress = Utilities.listToDelimitedString(amazonEmail.ccAddresses, ';')
	                                          //TODO: Fix
	                                          ,Status = '3'
	                                          );
	  
		insert newEmail;
		return newEmail.Id; 
		
	}
	//Must be a future method, as non-future methods can't do a callout after DML. 
	//Need to insert the Case to get CaseId and RefId
	//@future methods cannot accept sObjects as parameters
	@future(callout=true)
	public static void sendAutoResponse(string myCaseJSON,  string emailJSON, string envelopeJSON){
		Messaging.Inboundemail email = (Messaging.Inboundemail) JSON.deserialize(emailJSON, Messaging.Inboundemail.class);
		Messaging.InboundEnvelope envelope = (Messaging.InboundEnvelope) JSON.deserialize(envelopeJSON, Messaging.InboundEnvelope.class);
		Type sObjectType = Type.forName('Case'); 
		Case myCase = (Case) JSON.deserialize(myCaseJSON, sObjectType);
		
		AWSKeys myCredentials = AWSKeys.getInstance('Amazon');
		SES amazonEmailService = new SES(myCredentials.key, myCredentials.secret);
		
		List<String> toAddresses = new List<String>{email.fromAddress};
		toAddresses.addAll(email.toAddresses);
		toAddresses = removeEmailAliasFromReply(toAddresses, envelope.toAddress);
		List<String> ccAddresses = email.ccAddresses;
		
		//TODO: IMPLEMENT EMAIL TEMPLATES AND MERGE FIELDS
		//			Id EmailTemplateId 	 = CaseTeam.findByEmailServiceAddress(amazonEmail.fromAddress).EmailTemplateId;
		//		EmailTemplate myTemplate = [SELECT * FROM EmailTemplate WHERE Id = :emailTemplateId];
				
		string subject = 'RE: ' + email.subject + ' ' + CaseClass.createReferenceId(myCase.Id);
		string plainTextBody = 'CaseId = {!Id} \r\n\r\n' + email.plainTextBody;
		string htmlBody = 'Thank you for Contacting Support<br/><br/>' + email.htmlBody;
		
		List<String> mergeFields = findAllMergeFields(plainTextBody);
		plainTextBody = replaceMergeFields(mergeFields, plainTextBody, myCase);
		system.debug('#############');
		system.debug(plainTextBody);
		
		SESEmail amazonEmail = new SESEmail (toAddresses, ccAddresses, envelope.toAddress, subject, plainTextBody, htmlBody);
		//TODO: Trap for Errors
		amazonEmailService.sendEmail(amazonEmail);
		logEmailMessageFromAmazonEmail(myCase.Id, amazonEmail);
	}
	
	//Prevent sending an autoreply to yourself
	private static List<String> removeEmailAliasFromReply(List<String> sendToAddresses, string aliasToRemove){
		List<String> cleanedAddresses = new List<String>();
		for (String toAddress : sendToAddresses){
			if (toAddress != aliasToRemove) cleanedAddresses.add(toAddress);
		}
		return cleanedAddresses;
	}
	
	public static string replaceMergeFields(List<String> mergeFields, string fullText, sObject mySObject){
		for (String mergeField : mergeFields){
			system.debug ('{!' + mergeField + '}');
			if (fullText.contains('{!' + mergeField + '}')) {
				String replacementValue = string.valueOf(mySobject.get(mergeField));
				fullText = fullText.replace('{!' + mergeField + '}', replacementValue);
			}
		}
		return fullText;
	}
	public static List<String> findAllMergeFields(string fullText){
		List<String> mergeFields = new List<String>();
		Integer startingPoint = 0;
				
		while (fullText.indexOf('{!', startingPoint) != -1){
			Integer beginningPoint = fullText.indexOf('{!', startingPoint) + 2;
			Integer endingPoint = fullText.indexOf('}', startingPoint);
			String subString = fullText.substring(beginningPoint, endingPoint);
			mergeFields.add(subString);
			startingPoint = endingPoint + 1;
		}
		return mergeFields;
	}
	
}