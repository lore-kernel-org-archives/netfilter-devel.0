From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: xt_statistic.c - the statistic match
Date: Thu, 15 Jan 2009 10:25:31 -0600
Message-ID: <496F637B.6020305@astrocorp.com>
References: <4967CDCB.3080306@astrocorp.com>  <alpine.LSU.2.00.0901100433100.28890@fbirervta.pbzchgretzou.qr>  <496B7F66.40900@astrocorp.com> <38bcb3ec0901150237nc2d8316l62c27beef7e59170@mail.gmail.com> <alpine.LSU.2.00.0901151143480.400@fbirervta.pbzchgretzou.qr> <496F5A5C.1070504@astrocorp.com> <alpine.LSU.2.00.0901151652120.17559@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21491 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757735AbZAOQYS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:24:18 -0500
In-Reply-To: <alpine.LSU.2.00.0901151652120.17559@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-01-15 16:46, Bryan Duff wrote:
>   
>>> And iptables -Z should take care of the counters if rules are added
>>> one-by-one. Also noteworthy is that when iptables is run, the
>>> ruleset (including counters) is downloaded from the kernel, and
>>> later uploaded again - possible setting counters backwards.
>>> (I do no think there are any workarounds to that in the kernel,
>>> at least I have not seen any.)
>>> But at least all of the counters are set to where they were.
>>>       
>> Would iptables -Z fix the internal counter for the statistic nth match rule?  I
>> don't see that it would.  Because that's the counter I really care about
>> fixing.
>>     
>
> It depends on the module and the implementation. As for -A/-I/-Z, all
> private data will usually be retained. Only when the actual rule that
> references a module is deleted, the private data of the module _may_
> be removed too -- this obviously does not apply for modules that have
> an information storage that can be referenced multiple times, such as
> xt_recent, xt_condition or xt_quota2.
>
> So if you want to have the nth state be zeroed too, it's best to use
> iptables-restore to insert them all at once into the kernel.
>
>   
>> A couple things - this problem occurs multiple times after adding
>> the rules (as in it can correct itself by oops'ing again), the
>> other amusing thing - if I use printk's I can make it happen
>> faster, also if I'm doing more throughput it happens faster.
>>     
>
> Oopses, where?
>   
I'm sorry - it doesn't kernel panic.  But the count will get out of sync 
continually (well after the rule has been put in place).  This problem 
has nothing to do with adding the rule.   Because it works just fine ... 
for a while.  Sending packets for an hour can cause this problem to 
happen a good half-dozen times at least.  So I say oopses in the sense 
that the module does not work as intended.

Once again the problem deals with the internal counter: 
"info->u.nth.count++".  If the problem was adding the rule it would only 
happen once.

-Bryan
