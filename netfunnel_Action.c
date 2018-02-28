Action()
{ 
	int success = 0; 
	int sequence = 1;

	lr_start_transaction("LR_NETFUNNEL");
	
	// NetFunnel_Action
	web_reg_save_param_regexp("ParamName=key",
		"RegExp=.*key=(.+?)&",
		SEARCH_FILTERS,
		"Scope=Body" ,
		LAST);  

	web_reg_save_param_regexp("ParamName=ttl",
		"RegExp=.*ttl=(.+?)&",
		SEARCH_FILTERS,
		"Scope=Body" ,
		LAST);  
	
	web_reg_save_param_regexp("ParamName=retval",
		"RegExp=(...):.*",
		SEARCH_FILTERS,
		"Scope=Body" ,
		LAST);  
 
	web_url("NetFunnel_Action", 
		"URL=http://nf2.netfunnel.co.kr/ts.wseq?sid=service_5&aid=load&opcode=5101", 
		"Resource=0", 
		"RecContentType=text/html", 
		"Referer=", 
		"Snapshot=t1.inf", 
		"Mode=HTML", 
		LAST);   
		 
	// NetFunnel_chkEnter
	do{ 
		if(strcmp("201",lr_eval_string("{retval}")) == 0){  
			web_reg_save_param_regexp("ParamName=key",
				"RegExp=.*key=(.+?)&",
				SEARCH_FILTERS,
				"Scope=Body" ,
				LAST);  

			web_reg_save_param_regexp("ParamName=ttl",
				"RegExp=.*ttl=(.+?)&",
				SEARCH_FILTERS,
				"Scope=Body" ,
				LAST);  

			web_reg_save_param_regexp("ParamName=retval",
				"RegExp=(...):.*",
				SEARCH_FILTERS,
				"Scope=Body" ,
				LAST);  

			web_url("chkEnter",
				"URL=http://nf2.netfunnel.co.kr/ts.wseq?opcode=5002&key={key}&retval={retval}&ttl={ttl}&continued=true", 
				"Resource=0", 
				"RecContentType=text/html", 
				"Referer=", 
				"Snapshot=t1.inf", 
				"Mode=HTML", 
				LAST); 

			// wating code : 201
			if(strcmp("201",lr_eval_string("{retval}")) == 0){ 
				sequence++;
				lr_error_message("============== %d : WATING %s sec...",sequence,lr_eval_string("{ttl}"));
				sleep(atoi(lr_eval_string("{ttl}"))*1000); 
			}
		}else{  
			// pass code : 201 , error code : 5xx
			lr_log_message("RETVAL : %s",lr_eval_string("{retval}"));
			success=1;
		} 
	}while(success == 0);  
		// Call success page...
	
		// NetFunnel_Complete
		web_url("NetFunnel_Complete",
			"URL=http://nf2.netfunnel.co.kr/ts.wseq?opcode=5004&key={key}", 
			"Resource=0", 
			"RecContentType=text/html", 
			"Referer=", 
			"Snapshot=t1.inf", 
			"Mode=HTML", 
			LAST);   
	
	lr_end_transaction("LR_NETFUNNEL",LR_AUTO);   
	return 0;
}
