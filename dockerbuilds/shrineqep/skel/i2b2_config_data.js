{
  urlProxy: "/shrine-proxy/request",	
	urlFramework: "js-i2b2/",
	loginTimeout: 15, // in seconds
	//JIRA|SHRINE-519:Charles McGow
	username_label:"Username:", //Username Label
	password_label:"Password:", //Password Label
    	clientHelpUrl:'help/pdf/shrine-client-guide.pdf',
    	networkHelpUrl:'help/pdf/shrine-network-guide.pdf',
	//JIRA|SHRINE-519:Charles McGow
	// -------------------------------------------------------------------------------------------
	// THESE ARE ALL THE DOMAINS A USER CAN LOGIN TO
	lstDomains: [
                {
                    domain: "I2B2_DOMAIN_ID",
                    name: "UAMS SHRINE Test",
                    debug: true,
                    allowAnalysis: true,
		    isSHRINE: true,
                    urlCellPM: "http://I2B2_REST_IP:I2B2_REST_PORT/i2b2/services/PMService/"
                }
	]
	// -------------------------------------------------------------------------------------------
}
