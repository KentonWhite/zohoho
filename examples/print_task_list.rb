# -------------
# Example: Prints out all tasks
# -------------
# Gets all tasks and prints them to the screen. 

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "rubygems"
require "zohoho"
require "pp"

USERNAME, PASSWORD, ZOHO_KEY = "aisha.fenton", "epson123", "wcRImoTaNxWDAgM-LlfsbhRqsC8Zcu03kQaMGWeIdlI$"

@crm = Zohoho::Crm.new(USERNAME, PASSWORD, ZOHO_KEY)

pp @crm.tasks

