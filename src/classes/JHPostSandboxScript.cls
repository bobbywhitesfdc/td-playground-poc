global class JHPostSandboxScript implements SandboxPostCopy {
  global void runApexClass(SandboxContext context) {
      System.debug('JH Post Sandbox Activation Script: ' + context.organizationId() + ' ' + context.sandboxId() + '' + context.sandboxName());
      
      fixUpEmailAddresses();
      
}
   /**
    * Normal Sandbox creation approach automatically disables email addresses so that members will
    * not receive annoying emails.  We must fix them back for selected users so they can work.
    **/ 
   public void fixUpEmailAddresses() {
     List<User> users = [SELECT id,email,username 
                           FROM User 
                          WHERE Profile.name='System Administrator' 
                            and email LIKE '%=%@example.com'
                            and isActive = true];

     List<User> toUpdate = new List<User>();
     System.debug('Count of emails needing repair:' + users.size());
     
     for (User current : users) {
         // initial = 'namepart=domainpart@example.com'
         String[] pass1 = current.email.split('@');
         String[] pass2 = pass1[0].split('=');
         if (pass2[1] !='example.com') {
            System.debug('Before: '+current.email);
            current.email = pass2[0] + '@' + pass2[1];
            toUpdate.add(current);
            System.debug('After: '+current.email);
          }
     }
        
    if (!toUpdate.isEmpty()) {
       System.debug('updating ' + toUpdate.size() + ' records');
       update toUpdate;
       }


    }

}