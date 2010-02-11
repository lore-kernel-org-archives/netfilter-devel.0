From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 18:24:48 +0100
Message-ID: <4B743D60.1070407@trash.net>
References: <20100211161235.GA4099@x200> <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr> <4B743196.6020005@trash.net> <20100211171553.GB4099@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46582 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0BKRYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:24:50 -0500
In-Reply-To: <20100211171553.GB4099@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Thu, Feb 11, 2010 at 05:34:30PM +0100, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> On Thursday 2010-02-11 17:12, Alexey Dobriyan wrote:
>>>
>>>> Calling POST_ROUTING hook with NULL input device is not going to work.
>>>>
>>>> --- a/net/ipv4/netfilter/iptable_mangle.c
>>>> +++ b/net/ipv4/netfilter/iptable_mangle.c
>>>> @@ -85,7 +85,7 @@ iptable_mangle_hook(unsigned int hook,
>>>> 		     const struct net_device *out,
>>>> 		     int (*okfn)(struct sk_buff *))
>>>> {
>>>> -	if (hook == NF_INET_LOCAL_OUT)
>>>> +	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
>>>> 		return ipt_local_hook(hook, skb, in, out, okfn);
>>>>
>>>> 	/* PREROUTING/INPUT/FORWARD: */
>>> postrouting did not call ipt_local_hook before, so why now?
>> What Alexey meant is that
>>
>> 	/* PREROUTING/INPUT/FORWARD: */
>> 	return ipt_do_table(skb, hook, in, out,
>> 			    dev_net(in)->ipv4.iptable_mangle);
>>
>> dev_net(in) for a NULL device won't work. Passing them to the local
>> hook won't work either however since we perform rerouting there.
>> I'm confused now why this didn't crash here so far ...
> 
> It did crashed, that's why I noticed it.
> But now I can't reproduce it too. Hopefully this patch is correct.

It looks correct to me. Will try to reproduce the crash
just to make sure.
