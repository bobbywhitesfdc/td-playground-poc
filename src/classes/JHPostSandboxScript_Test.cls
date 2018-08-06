@istest
public class JHPostSandboxScript_Test {

@isTest
   public static void testSandboxPostCopyScript() {
      // Precursor is to scramble some of the email addresses  name=domain@example.com
      List<User> admins = [SELECT id, username,email 
                           from User 
                           Where Profile.Name='System Administrator'
                             and isActive = true];
       List<User> toScramble = new List<User>();
       for (User current : admins) {
           String[] parts = current.email.split('@');
           String scrambled = parts[0] + '=' + parts[1] + '@example.com';
           current.email = scrambled;
           
           toScramble.add(current);
       }
       if (!toScramble.isEmpty()) {
           update toScramble;
       }
       
       List<User> beforeAdmins = [SELECT id, username,email 
                           from User 
                           Where Profile.Name='System Administrator'
                             and isActive = true 
                             and email like '%=%@example.com'];
       
      System.assert(beforeAdmins.size() > 0,'Some Admin Email addresses should be scrambled before test!');

       
      Test.testSandboxPostCopyScript(new JHPostSandboxScript(), '00D41000000F2sD', '00D41000000F2sD', 'TESTSANDBOX');
      
      List<User> afterAdmins = [SELECT id, username,email 
                           from User 
                           Where Profile.Name='System Administrator'
                             and isActive = true 
                             and email like '%=%@example.com'
                             and (NOT email like '%=example.com@example.com')];
       for (User current : afterAdmins) {
           System.debug('after SBScript:' + current.email);
       }
      System.assertEquals(afterAdmins.size(),0,'All Active Admin Email addresses should be unscrambled!');
   }
}