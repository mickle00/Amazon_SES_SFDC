public with sharing abstract class GoogleTranslate {    
    
    public string key {get;set;}
    public String baseURL = 'https://www.googleapis.com/language/translate/v2';
    
    public static GoogleLanguageDetection detectLanguage(string sourceText){
    	return new GoogleLanguageDetection().detectSourceLanguage(sourceText);
    }

}