From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Sun, 15 Jul 2012 23:36:33 +0100
Message-ID: <500345F1.3050407@googlemail.com>
References: <50002CEF.508@googlemail.com>		 <1342194935.11019.12.camel@tiger.regit.org>		 <50016D84.5080207@googlemail.com>	 <1342300959.6098.8.camel@tiger.regit.org> <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60368 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GOWgn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 18:36:43 -0400
Received: by weyx8 with SMTP id x8so3597135wey.19
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 15:36:42 -0700 (PDT)
In-Reply-To: <1342385528.8476.2.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Currently, NFCT reports absolutely everything, which is not what I 
>> really want as I have to sift through thousands of logs, not to mention 
>> that by reporting everything the system load is much higher.
>>
>> So, is there a way for me to do that, somehow?
>>     
>
> Not now but I'm working on it: Pablo has made a filter system in
> libnetfilter_conntrack. I will used it to filter.
>   
This would be some awesome feature. I think this new filter which 
implements "custom" restrictions should not be for a particular input 
filter, but rather be universal. In other words, to be able to 
customise, say, certain IP addresses/subnets, certain ethernet 
interfaces etc, and then used anywhere in stack statements - NFCT, NFLOG 
and so on.

If this is implemented, it will certainly make ulogd2 very powerful and 
flexible at the same time - a bit like what syslog-ng is to the old 
syslog ;-)

The specific reason I raised this issue is because on the main firewall 
we have here, if I deploy ulogd2 and use NFCT at its present form, I 
will get the logs from all 7 interfaces, and it would make it an 
absolutely huge task to sift through all these logs and "match" the 
various entries (OK, doing it through the database will help up a bit, 
but not a lot).

If I am able to place a "custom" filter with different "filter" values 
in each separate stack, redirecting input to different places, then I 
would be able to track down what I want quite easily.

>> I had in mind exactly what you've suggested above - use a separate, 
>> manually-registered table containing the table columns and their mapping 
>> to ulogd2 parameters - much less risk and everything is configurable, 
>> though the downside is that the two tables need to be synchronised if 
>> the structure of the main ulogd table changes (columns renamed or added).
>>     
>
> It seems the safest way.
>   
It looks that way, doesn't it? In the coming days I'll look at the PGSQL 
implementation code to see whether SSL connection to the database server 
is a possibility with this plug in - it will be another good security 
feature if that is possible to be implemented.

