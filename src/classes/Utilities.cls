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
}