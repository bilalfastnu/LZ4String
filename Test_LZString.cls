/**
 * Created by bilalnazir on 11/29/16.
 */

@isTest 
public class Test_LZString {
    static testMethod void testLZW() {
		string comp = LZString.compress('TOBEORNOTTOBEORTOBEORNOT1234');
		string decomp = LZString.decompress(comp); 
        
        system.debug('Compreessed' + comp);
		system.debug('De-Compreessed' + decomp);
        System.assertEquals('TOBEORNOTTOBEORTOBEORNOT1234', decomp);
    }
}