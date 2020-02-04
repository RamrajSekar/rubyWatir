require "watir"
require "watir-webdriver"

# Update your linkedin username and password below
$user_name = "test@test.com"
$password = "test123"
# Updated full name of the user to send message
$searchUser = "Michael \"Fritz\" Fritzius"
# Locators
$search_result = "//span[@class=\'name-and-icon\']/span/span[contains(text(),\'#{$searchUser}\')]"
$search_input = "//input[@placeholder=\'Search\']"
$search_btn = "//button[@class=\'search-typeahead-v2__button search-global-typeahead__button\']"
$userName = "//li[text()=\'#{$searchUser}\']"
$msg_to_send = "Sorry for spamming your message box"

$browser = Watir::Browser.new

def openBrowser
	$browser.goto("https://www.linkedin.com")
	$browser.wait_until{$browser.element(xpath: "//a[text()='Sign in']").visible?}
	if $browser.title == 'LinkedIn: Log In or Sign Up'
		print 'Test Pass'
	else
		print 'Test Fail'
	end
end

def login
	$browser.element(xpath: "//input[@name='session_key']").send_keys $user_name
	$browser.element(xpath: "//input[@name='session_password']").send_keys $password
	$browser.button(:text => "Sign in").click
	$browser.wait_until{$browser.element(xpath: "//div[text()='Ramraj Sekar']").visible?}
	if $browser.element(xpath: "//div[text()='Ramraj Sekar']").exists?
		if $browser.element(xpath: "//div[text()='Ramraj Sekar']").text == 'Ramraj Sekar'
			print 'Test Pass: Logged In Successfully'
		else
			print 'Test Fail: Login Failed'
		end
	end
end

def commonTeardown
	$browser.close()
end

def sendMessage
	openBrowser
	login
	#puts $search_result
	#puts $search_input
	#puts $search_btn
	#puts $userName
	# Search and Locate User
	$browser.element(xpath: $search_input).send_keys $searchUser
	$browser.send_keys :enter
	# Send message
	$browser.element(xpath: "//button[text()='Message']").wait_until_present
	$browser.wait_until{$browser.element(xpath: "//button[text()='Message']").visible?}
	$browser.element(xpath: "//button[text()='Message']").click
	if $browser.element(xpath: "//h4[text()='New message']").exists?
		$browser.element(xpath: "//div[@aria-label=\"Write a message…\"]/p").send_keys $msg_to_send
		$browser.button(:text => "Send").click
		$browser.wait_until{$browser.element(xpath: "//ul[contains(@class,'msg-s-message-list-content')]//p[text()=\'#{$msg_to_send}\']").present?}
		if $browser.element(xpath: "//ul[contains(@class,'msg-s-message-list-content')]//p[text()=\'#{$msg_to_send}\']").exists?
			print "Test Pass: Message Sent Successfully"
		else
			print "Test Fail: Message Sent Failed"
		end
		commonTeardown
	end
end

sendMessage
#browser.close()