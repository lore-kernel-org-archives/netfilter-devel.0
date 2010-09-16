From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/4] iptables: limit chain name length to be consistent
 with targets
Date: Thu, 16 Sep 2010 11:45:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009161129580.28367@obet.zrqbmnf.qr>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de> <1284576828-32412-3-git-send-email-jengelh@medozas.de> <4C9164D8.2060307@vyatta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Stig Thormodsrud <stig@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40314 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0IPJpk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:45:40 -0400
In-Reply-To: <4C9164D8.2060307@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-09-16 02:29, Stig Thormodsrud wrote:
>> -	if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
>> +	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
>>  		xtables_error(PARAMETER_PROBLEM,
>> -			   "chain name `%s' too long (must be under %i chars)",
>> -			   chain, IPT_FUNCTION_MAXNAMELEN);
>> +			   "chain name `%s' too long (must be under %u chars)",
>> +			   chain, XT_EXTENSION_MAXNAMELEN);
>>  
>>  	/* only allocate handle if we weren't called with a handle */
>>  	if (!*handle)
>
>Thanks for the fix.  I guess my original question was if the change in
>max name length from 29 to 28 characters was intentional or required by
>some other data structure change?

struct xt_entry_match simply just has space for 28+1 bytes for the
name+'\0'. Chain names could be 31+1, but it is unknown in advance
whether a name whose length is to be checked is going to be a target
or a chain, so it is safer to just use 29 for now.
