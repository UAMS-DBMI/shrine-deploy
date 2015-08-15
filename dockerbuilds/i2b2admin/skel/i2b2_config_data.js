{
	urlProxy: "index.php",
	urlFramework: "js-i2b2/",
	//-------------------------------------------------------------------------------------------
	// THESE ARE ALL THE DOMAINS A USER CAN LOGIN TO
	lstDomains: [
		{ domain: "I2B2_DOMAIN_ID",
		  name: "SHRINE I2B2 ADMIN",
		  urlCellPM: "http://I2B2_REST_IP:I2B2_REST_PORT/i2b2/services/PMService/",
		  allowAnalysis: true,
		  adminOnly: true,
		  debug: true 
		},
		{ domain: "i2b2demo",
		  name: "SHRINE I2B2",
		  urlCellPM: "http://I2B2_REST_IP:I2B2_REST_PORT/i2b2/services/PMService/",
		  allowAnalysis: true,
		  adminOnly: false,
		  debug: true 
		}
	]
	//-------------------------------------------------------------------------------------------
}
