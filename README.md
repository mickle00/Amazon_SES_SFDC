Amazon SES SFDC
===============
Utility for Sending Email using Amazon SES from Salesforce.com
Primary purpose to allow for Reply-All Autoresponses
Added Google Translate API to determine source language

http://aws.amazon.com/ses/
  
  *$0.10 per 10,000 Emails 
  
  *A single email communication sent to multiple recipients is considered to be a unique messsage sent to each recipient

  *12,000 Cases a Day, Average of 3 Reply-All= $0.12 * 3 = $0.36/day


https://developers.google.com/translate/
 
 *$20 per 1,000,000 characters of text
 
 *Average 42 Character Subject Line = $0.00084 per email
 
 *12,000 emails a day = $10.08 per day

http://json2apex.herokuapp.com/

####TODO:
  *Dynamically pull Email Template

  *Properly Handle Merge Fields, including relationships and NULLVALUE() Function

  *Properly weed out other SFDC Email-to-Case aliases; as well as known spam addresses

  *Error handling of Amazon Web Service

####RISKS:
  *Separate Dependency on Amazon/Google

  *Cost $$
  
  *More likely to have Email Auto Response Loops with wider audience
