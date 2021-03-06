/**
 * Simple Email Service methods
 * 
 * Author: Tom Gersic, Model Metrics
 **/ 

public class SES extends AWS {

	public String endpoint = 'https://email.us-east-1.amazonaws.com';
	public String method = 'POST';

	public SES(String key, String secret){
		this.key = key;
		this.secret= secret;	
	}
    
    /**
     * Create the HTTP Request and send it off to AWS
     **/	
	public void sendEmail(List<String> toAddresses, List<String> ccAddresses, String fromAddress, String subject, String plainTextBody, String htmlBody){	
		String awsFormattedNow=awsFormattedDate(Datetime.now());
		
		HttpRequest httpReq = new HttpRequest();
		httpReq.setMethod(method);
		httpReq.setEndpoint(endpoint);
		httpReq.setHeader('X-Amzn-Authorization',headerForAmazonAuthorization(key,signature(awsFormattedNow,this.secret)));
		httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
		httpReq.setHeader('Date',awsFormattedNow);
		
		SESEmail newEmail = new SESEmail(toAddresses,ccAddresses,fromAddress,subject,plainTextBody, htmlBody);
		
		httpReq.setBody(newEmail.encodedEmail);
		
		System.debug(httpReq.getBody());
		 
		Http http = new Http();
		
		HttpResponse response = http.send(httpReq);
		System.debug(response.getBody());
	}
	
	public void sendEmail(SESEmail amazonEmail){
		this.sendEmail(amazonEmail.toAddresses, amazonEmail.ccAddresses, amazonEmail.fromAddress, amazonEmail.subject, amazonEmail.plainTextBody, amazonEmail.htmlBody);
	}
}