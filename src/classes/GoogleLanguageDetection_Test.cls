@isTest
public with sharing class GoogleLanguageDetection_Test {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{ \"data\": {  \"detections\": [   [    {     \"language\": \"es\",     \"isReliable\": false,     \"confidence\": 0.6554622    }   ]  ] }}';
        GoogleLanguageDetection r = GoogleLanguageDetection.parse(json);
        System.assert(r != null);
        System.assert(r.data != null);
        System.assert(r.data.detections != null);
        System.assert(r.data.detections[0] != null);
        System.assert(r.data.detections[0][0] != null);
        System.assert(r.data.detections[0][0].language == 'es');
        System.assert(r.data.detections[0][0].isReliable == false);
        System.assert(r.data.detections[0][0].confidence == 0.6554622);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        GoogleLanguageDetection.Data objData = new GoogleLanguageDetection.Data(System.JSON.createParser(json));
        System.assert(objData != null);
        System.assert(objData.detections == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        GoogleLanguageDetection.Detection objDetection = new GoogleLanguageDetection.Detection(System.JSON.createParser(json));
        System.assert(objDetection != null);
        System.assert(objDetection.language == null);
        System.assert(objDetection.isReliable == null);
        System.assert(objDetection.confidence == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        GoogleLanguageDetection objRoot = new GoogleLanguageDetection(System.JSON.createParser(json));
        System.assert(objRoot != null);
        System.assert(objRoot.data == null);
    }
}