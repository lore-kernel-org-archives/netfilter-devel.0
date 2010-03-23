From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 12:57:47 +0100
Message-ID: <4BA8ACBB.8040007@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003171437440.6297@obet.zrqbmnf.qr> <4BA0DF4D.5000504@trash.net> <alpine.LSU.2.01.1003230241580.12017@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0CWL5s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:57:48 -0400
In-Reply-To: <alpine.LSU.2.01.1003230241580.12017@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 14:55, Patrick McHardy wrote:
>>>>> +	if (dst->hh != NULL) {
>>>>> +		neigh_hh_output(dst->hh, skb);
>>>>> +	} else if (dst->neighbour != NULL) {
>>>>> +		dst->neighbour->output(skb);
>>>>> +	} else {
>>>>> +		if (net_ratelimit())
>>>>> +			pr_debug(KBUILD_MODNAME
>>>>> +				"no hdr & no neighbour cache!\n");
>>>>> +		kfree_skb(skb);
>>>>> +	}
>>>>> +}
>>>> Remind me again why we need this duplicated output function?
>> You can use dst_output() and set IPSKB_REROUTED to skip the hook
>> invocation. This will potentially perform fragmentation however.
> 
> We don't have IPSKB_REROUTED for IPv6 currently.
> 
> While I was pondering adding that, I noticed another upside-down
> world:
> 
>  - iptables POSTROUTING is invoked before outgoing fragmentation
>    (verified using ping -s 65000 localhost, and watching with both
>    ipt_LOG and tcpdump.)
> 
>  - ip6tables POSTROUTING is invoked after outgoing fragmentation

That's correct. We used to invoke IPv4 POST_ROUTING after fragmentation
as well just to defragment the packets in conntrack immediately
afterwards, but that got changed during the netfilter-ipsec integration.

Ideally IPv6 would behave like IPv4.

> Also, if I am reading right, POSTROUTING is invoked twice for v6
> multicast.

I can see one invocation for loopback and one for non-loopback.
That's fine.

