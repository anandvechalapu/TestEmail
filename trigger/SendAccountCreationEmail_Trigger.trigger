Trigger:

trigger SendAccountCreationEmail on Account (after insert) {
  // Get list of system admins
  List<User> admins = [SELECT Id, Email FROM User WHERE UserType = 'System Administrator'];
  
  // Create a list of emails to be sent
  List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
  
  // Loop through the list of new accounts
  for (Account a : Trigger.new) {
    // Create a new email for every system admin
    for (User admin : admins) {
      // Create email object
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      
      // Set email subject
      String subject = 'New account got created';
      email.setSubject(subject);
      
      // Set email recipient
      email.setToAddresses(new String[] { admin.Email });
      
      // Set email body
      String body = 'A new account with name ' + a.Name + ' has been created on ' + a.CreatedDate + '. Contact information for the account owner is ' + a.AccountOwner.Email + '.';
      email.setPlainTextBody(body);
      
      // Add email to list
      emails.add(email);
    }
  }
  
  // Send emails
  Messaging.sendEmail(emails);
}