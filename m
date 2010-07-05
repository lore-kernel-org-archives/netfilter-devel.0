From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt2 table core
Date: Mon, 05 Jul 2010 10:55:51 +0200
Message-ID: <4C319E17.2020908@trash.net>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de> <201007020532.12596.simonl@parknet.dk> <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Simon Lodal <simonl@parknet.dk>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab0GEIzv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:55:51 -0400
In-Reply-To: <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2010-07-02 05:32, Simon Lodal wrote:
>   
>>> This patchset adds the xtables2 main proper, and incrementally
>>> changes ip6_tables to use it. There are more patches for iptables
>>> and arptables and, but to not make it larger than needed, just this
>>> much for now.
>>>
>>> Previously featured on http://lwn.net/Articles/345176/ .
>>>       
>> Nice to see some new development! Guess we all have a long wishlist that is 
>> hard to implement in the current design, and this may make it easier.
>>
>> But what about performance? I think all these lists must cause a huge amount 
>> of jumps in hot path (eg. filtering packets). The packed blob format is hard to 
>> work with, but once created it is efficient. Do you have any expectations or 
>> even numbers on the performance?
>>     
>
> Your suspicion was right, linked lists seem to have their impact.
>
> The command I used was
>
> 	ping6 localhost -fc 500 -i .001
>
> this sends 500 packets in near-flood fashion (-i0 would lead to
> packet drops).
>
> Xtables1 blob-style 2.6.31-rc4:
> 500 packets transmitted, 500 received, 0% packet loss, time 3532ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3428ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3339ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3219ms
>
> Xtables1 blob-style 2.6.34:
> 500 packets transmitted, 500 received, 0% packet loss, time 3405ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3525ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3426ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3388ms
> 500 packets transmitted, 500 received, 0% packet loss, time 3328ms
>
> Xtables2 (linked lists) 2.6.35-rc1:
> 500 packets transmitted, 500 received, 0% packet loss, time 14775ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14383ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14381ms
> 500 packets transmitted, 500 received, 0% packet loss, time 15432ms
> 500 packets transmitted, 500 received, 0% packet loss, time 14498ms
>   

While this is probably a pretty bad test, you can't seriously expect
me to merge something that degrades performance by 400% for all users?

