@isTest
private class GoogleTranslation_Test {

	/**
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		' \"data\": {'+
		'  \"translations\": ['+
		'   {'+
		'    \"translatedText\": \"Hello, how are you?\",'+
		'    \"detectedSourceLanguage\": \"es\"'+
		'   }'+
		'  ]'+
		' }'+
		'}';
		GoogleTranslation r = parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Data objData = new Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.translations == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Translations objTranslations = new Translations(System.JSON.createParser(json));
		System.assert(objTranslations != null);
		System.assert(objTranslations.translatedText == null);
		System.assert(objTranslations.detectedSourceLanguage == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GoogleTranslation objRoot = new GoogleTranslation(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.data == null);
	}
	**/
}