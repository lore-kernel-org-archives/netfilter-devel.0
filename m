From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 18:07:25 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111805490.15668@obet.zrqbmnf.qr>
References: <20100211161235.GA4099@x200> <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr> <4B743196.6020005@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57927 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0BKRH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:07:27 -0500
In-Reply-To: <4B743196.6020005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-11 17:34, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Thursday 2010-02-11 17:12, Alexey Dobriyan wrote:
>> 
>>> Calling POST_ROUTING hook with NULL input device is not going to work.
>>>
>>> --- a/net/ipv4/netfilter/iptable_mangle.c
>>> +++ b/net/ipv4/netfilter/iptable_mangle.c
>>> @@ -85,7 +85,7 @@ iptable_mangle_hook(unsigned int hook,
>>> 		     const struct net_device *out,
>>> 		     int (*okfn)(struct sk_buff *))
>>> {
>>> -	if (hook == NF_INET_LOCAL_OUT)
>>> +	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
>>> 		return ipt_local_hook(hook, skb, in, out, okfn);
>>>
>>> 	/* PREROUTING/INPUT/FORWARD: */
>> 
>> postrouting did not call ipt_local_hook before, so why now?
>
>What Alexey meant is that
>
>	/* PREROUTING/INPUT/FORWARD: */
>	return ipt_do_table(skb, hook, in, out,
>			    dev_net(in)->ipv4.iptable_mangle);
>
>dev_net(in) for a NULL device won't work. Passing them to the local
>hook won't work either however since we perform rerouting there.
>I'm confused now why this didn't crash here so far ...

Before, ipt_post_routing_hook just called

	return ipt_do_table(skb, hook, in, out,
		dev_net(out)->ipv4.iptable_mangle);

Not caring about whether in and out are NULL or not,
because ipt_do_table checks for NULL.
Now, iptable_mangle_hook still just calls ipt_do_table, so
nothing really changed, thus nothing broke.

Thus the confusion this patch introduces.
