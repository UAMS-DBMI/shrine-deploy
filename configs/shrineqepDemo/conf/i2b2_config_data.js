{
  urlProxy: "/shrine-proxy/request",	
	urlFramework: "js-i2b2/",
	loginTimeout: 15, // in seconds
	//JIRA|SHRINE-519:Charles McGow
	username_label:"Username:", //Username Label
	password_label:"Password:", //Password Label
	//JIRA|SHRINE-519:Charles McGow
	// -------------------------------------------------------------------------------------------
	// THESE ARE ALL THE DOMAINS A USER CAN LOGIN TO
	lstDomains: [
		{
		    domain: "i2b2demo",
		    name: "SHRINE Demo Data",
		    debug: true,
		    allowAnalysis: true,
		    urlCellPM: "http://i2b2:9090/i2b2/services/PMService/"
		}
	]
	// -------------------------------------------------------------------------------------------
}
