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
	                                          ,MessageDate = system.now()
	                                          ,CCAddress = Utilities.listToDelimitedString(email.ccAddresses, ';')
	                                          //TODO: Fix
	                                          ,Status = '0'
	                                          );
	  
		insert newEmail;
		return newEmail.Id; 
	}
	
	public static Id logEmailMessageFromAmazonEmail(Id parentId, SESEmail amazonEmail){
		EmailMessage newEmail = new EmailMessage(ParentId = parentId
	                                          ,Incoming = true
	                                          ,Subject = amazonEmail.subject
	                                          ,FromAddress = amazonEmail.fromAddress
	                                          //,FromName = amazonEmail.fromName
	                                          ,ToAddress = Utilities.listToDelimitedString(amazonEmail.toAddresses, ';')
	                                          ,TextBody = amazonEmail.Body
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
		List<String> ccAddresses = email.ccAddresses;
		string subject = 'RE: ' + email.subject + ' ' + CaseClass.createReferenceId(myCase.Id);
		string body = 'Thank you for Contacting Support<br/><br/><br/>' + email.plainTextBody;
		
		SESEmail amazonEmail = new SESEmail (toAddresses, ccAddresses, envelope.toAddress, subject, body);
		amazonEmailService.sendEmail(amazonEmail);
		logEmailMessageFromAmazonEmail(myCase.Id, amazonEmail);
	}
}