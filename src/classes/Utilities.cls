public with sharing class Utilities {
	public static String listToDelimitedString(List<string> values, String delimeter) {
		if(values == null) return '';
		String delimitedString = '';
		for(String value : values) {
			if(delimitedString.length() == 0) {
				delimitedString = value;
			}
			else {
				delimitedString = delimitedString + delimeter + ' ' + value;
			}
		}
	  	return delimitedString;
	}
	//http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dynamic_describe_objects_understanding.htm#apex_describe_object_all_fields
	public static Set<String> getFields(sObject sobj) {
	    return sobj.getSobjectType().getDescribe().fields.getMap().keySet();
	}
	
	//http://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#CSHID=apex_methods_system_sobject.htm|StartTopic=Content%2Fapex_methods_system_sobject.htm|SkinName=webhelp
	public static void getReferenceTo(){
		Schema.DescribeFieldResult F = Case.AccountId.getDescribe();
		List<Schema.sObjectType> P = F.getReferenceTo();
		system.debug(P);	
	}
}