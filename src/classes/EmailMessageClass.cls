public with sharing class EmailMessageClass {
	
	public enum enumEmailStatus{newMessage, read, replied, sent}
	
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
	                                          //,Status = 1
	                                          );
	  
		insert newEmail;
		return newEmail.Id; 
	}
	
	public static Id sendAutoResponse(Case myCase,  Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
		return null;
	}
}