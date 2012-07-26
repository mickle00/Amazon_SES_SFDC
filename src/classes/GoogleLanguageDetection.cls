public class GoogleLanguageDetection extends GoogleTranslate {
	
	public GoogleLanguageDetection(){
		this.key = new APIKeyClass().getInstance('Google').key__c;
	}
        
    public Data data {get;set;}
    
    public string detectedLanguage{
    	get { return this.data.detections[0][0].language; }
    	set;
    }
    
    public double confidence{
    	get { return this.data.detections[0][0].confidence; }
    	set;
    }
    
    public boolean isReliable{
    	get { return this.data.detections[0][0].isReliable; }
    	set;
    }
    
    public GoogleLanguageDetection detectLanguage (String source){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http(); 
        
        source = EncodingUtil.urlEncode(source, 'UTF-8');
        
        if (source.length() > 1000){
            source = source.substring(0, 999);
        }
        
        req.setEndpoint(baseURL + '/detect?key=' +
                        EncodingUtil.urlEncode(key, 'UTF-8') +
                        '&q=' +
                        source);                
        
        req.setMethod('GET');

        try{
            res = http.send(req);
            string responseBody = res.getBody();
            // HACKITY HACK HACK BECAUSE OF PROBLEM WITH SYSTEM.JSON.deserialize(pString, pType) WITH NESTED ARRAYS
            //GoogleLanguageDetection deserializedResponse = (GoogleLanguageDetection) JSON.deserialize(responseBody, GoogleLanguageDetection.class);
            GoogleLanguageDetection deserializedResponse = GoogleLanguageDetection.parse(responseBody);
            return deserializedResponse;
        }
        catch(System.CalloutException e){
            System.debug('Job Error: '+ e);
            System.debug(res.toString());
            
        }
        return null;
    }
    
    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    public class Data {
        public List<List<Detection>> detections {get;set;}

        public Data(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'detections') {
                            detections = new List<List<Detection>>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                List<Detection> innerList = new List<Detection>();
                                detections.add(innerList);
                                while (parser.nextToken() != JSONToken.END_ARRAY) {
                                    innerList.add(new Detection(parser));
                                }
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Detection {
        public String language {get;set;}
        public Boolean isReliable {get;set;}
        public Double confidence {get;set;}

        public Detection(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'language') {
                            language = parser.getText();
                        } else if (text == 'isReliable') {
                            isReliable = parser.getBooleanValue();
                        } else if (text == 'confidence') {
                            confidence = parser.getDoubleValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Detections consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public GoogleLanguageDetection(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'data') {
                        data = new Data(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public static GoogleLanguageDetection parse(String json) {
        return new GoogleLanguageDetection(System.JSON.createParser(json));
    }
}