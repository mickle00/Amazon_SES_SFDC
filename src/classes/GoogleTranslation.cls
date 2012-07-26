public class GoogleTranslation extends GoogleTranslate {
    /**
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
    **/
    public GoogleTranslation(){
        this.key = new APIKeyClass().getInstance('Google').key__c;
    }

    public class Data {
        public List<Translations> translations {get;set;}
        /**
        public Data(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'translations') {
                            translations = new List<Translations>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                translations.add(new Translations(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
        **/
    }
    
    public class Translations {
        public String translatedText {get;set;}
        public String detectedSourceLanguage {get;set;}

        /**
        public Translations(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'translatedText') {
                            translatedText = parser.getText();
                        } else if (text == 'detectedSourceLanguage') {
                            detectedSourceLanguage = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Translations consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
        **/
    }
    
    public Data data {get;set;}

    /**
    public GoogleTranslation(JSONParser parser) {
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
    **/
    
    /**
    
    public static GoogleTranslation parse(String json) {
        return new GoogleTranslation(System.JSON.createParser(json));
    }
    **/

    public GoogleTranslation translateLanguage (String originalLanguage){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        string body = 'q=' + EncodingUtil.urlEncode(originalLanguage, 'UTF-8');
        
        //can only translate 5k characters. leaving a buffer just cause
        if (body.length() > 4800){
            body = body.substring(0, 4800);
        }
        
        req.setEndpoint(baseURL + '?key=' +   
                        EncodingUtil.urlEncode(key, 'UTF-8') +
                        '&target=en&prettyprint=true');
                        
        //Can POST up to 5k characters. GET limit is 2k characters
        req.setMethod('POST');
        //must explicitly state overriding GET
        req.setHeader('X-HTTP-Method-Override', 'GET');
        req.setBody(body);
        req.setHeader('Content-Length',string.valueOf(body.length()));

        try{
            res = http.send(req);
            string responseBody = res.getBody();
            GoogleTranslation myTranslation = (GoogleTranslation)JSON.deserialize(responseBody, GoogleTranslation.class);
            return myTranslation;
        }
        catch(System.CalloutException e){
            System.debug('Job Error: '+ e);
            System.debug(res.toString());
            
        }
        return null;       
    }
}