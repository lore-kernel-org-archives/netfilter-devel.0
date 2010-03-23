From: Patrick McHardy <kaber@trash.net>
Subject: Re: debugging kernel during packet drops
Date: Tue, 23 Mar 2010 16:39:45 +0100
Message-ID: <4BA8E0C1.2070007@trash.net>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net> <4BA8DAC5.6050002@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60439 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0CWPjr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:39:47 -0400
In-Reply-To: <4BA8DAC5.6050002@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jorrit Kronjee wrote:
> On 3/22/2010 6:16 PM, Patrick McHardy wrote:
>   
>>> When I disable the hashlimit module the packet drops disappear again.
>>> Now I know that hashlimit is made for more than one thing, namely
>>> limiting packets based on source/destination host and source/destination
>>> port, so it's not as efficient as it could be for my purposes. I could
>>> rewrite it, but before I do that, I would like to know if the module
>>> itself is really what's causing it, or if there's some underlying cause
>>> that I'm not seeing. So my question in short: how can I discover why
>>> it's dropping packets? 
>>>   
>>>     
>>>       
>> A couple of suggestions:
>>
>> - try the limit module in case you don't actually need per-source/dest etc.
>>   limiting but just a global limit
>>
>> - try using TBF or ingress policing. Both limit and hashlimit suffer of
>> problems
>>   regarding the resolution of the applied TBF. I don't remember the
>> exact range
>>   of values it is able to handle, but IIRC you should be able to find it
>> in the
>>   netfilter bugzilla.
>>
>> - if you use TBF or ingress policing and don't need ip_tables specific
>> modules,
>>   disabling bridge netfilter invocation of ip_tables through /proc
>> should increase
>>   performance.
>>
>>   
>>     
> Patrick,
>
> Although these are good suggestions, I really need to be able to limit
> per destination. The receiving network is a /15 which means I have to
> use something like a hashtable to keep track of destination IP
> addresses. Neither rateest or limit can do that. OTOH, that's also the
> only thing I need. This would make a low-cost ISP-grade DDoS filter,
> which is why I'm interested in it.
>
> The bug you're referring to is this one, I think: 
> http://bugzilla.netfilter.org/show_bug.cgi?id=523 but I'm not entirely
> sure if that is related to my problems.
>   

Yes, that's the one. Not specifically related to your problem, but to
the general hashlimit limitations.

> Is there any way I can figure out why ifconfig is reporting dropped
> packets?

Based on your description I'd say that the CPU simply can't keep up with
traffic. Perhaps the hash is undersized. The default size depends on the
amount of memory, you could try setting it manually to something appropriate
for the amount of addresses you expect to see.

If that doesn't help, I'd start by profiling the kernel.
