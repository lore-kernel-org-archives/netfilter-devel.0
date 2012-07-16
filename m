From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 13:43:55 +0100
Message-ID: <50040C8B.6010302@googlemail.com>
References: <50002CEF.508@googlemail.com>			 <1342194935.11019.12.camel@tiger.regit.org>			 <50016D84.5080207@googlemail.com>		 <1342300959.6098.8.camel@tiger.regit.org>	 <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org>	 <500345F1.3050407@googlemail.com> <1342420387.8476.20.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60223 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2GPMoH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:44:07 -0400
Received: by eekc13 with SMTP id c13so160690eek.19
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jul 2012 05:44:05 -0700 (PDT)
In-Reply-To: <1342420387.8476.20.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>  In other words, to be able to 
>> customise, say, certain IP addresses/subnets, certain ethernet 
>> interfaces etc, and then used anywhere in stack statements - NFCT, NFLOG 
>> and so on.
>>     
>
> If this universal filter is an excellent idea, it will suffer from some
> performance issue. The NFCT filter I'm currently implementing does the
> filtering inside the kernel which is really efficient. For NFLOG, kernel
> filtering can be done via iptables.
>   
Yeah, sorry, I've got carried away a bit there. :-) 

Of course, with NFLOG things are much more easier.

>> If I am able to place a "custom" filter with different "filter" values 
>> in each separate stack, redirecting input to different places, then I 
>> would be able to track down what I want quite easily.
>>     
>
> You should be able to do a per-network filtering with my current work. I
> should have a patch ready today.
>   
Looking forward to it.

>> In the coming days I'll look at the PGSQL 
>> implementation code to see whether SSL connection to the database server 
>> is a possibility with this plug in - it will be another good security 
>> feature if that is possible to be implemented.
>>     
>
> Fine!
>   
I managed to get some preliminary code working yesterday and later today 
when I get home I'll get the chance to test it with the real plug in to 
see whether SSL works. If it does, I'll propose some changes to include 
SSL capability to the PGSQL plugin.

