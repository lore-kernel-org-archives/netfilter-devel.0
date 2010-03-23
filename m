From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 23 Mar 2010 02:55:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003230241580.12017@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net> <alpine.LSU.2.01.1003171437440.6297@obet.zrqbmnf.qr> <4BA0DF4D.5000504@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47545 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab0CWBzt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:55:49 -0400
In-Reply-To: <4BA0DF4D.5000504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 14:55, Patrick McHardy wrote:
>>>> +	if (dst->hh != NULL) {
>>>> +		neigh_hh_output(dst->hh, skb);
>>>> +	} else if (dst->neighbour != NULL) {
>>>> +		dst->neighbour->output(skb);
>>>> +	} else {
>>>> +		if (net_ratelimit())
>>>> +			pr_debug(KBUILD_MODNAME
>>>> +				"no hdr & no neighbour cache!\n");
>>>> +		kfree_skb(skb);
>>>> +	}
>>>> +}
>>> Remind me again why we need this duplicated output function?
>
>You can use dst_output() and set IPSKB_REROUTED to skip the hook
>invocation. This will potentially perform fragmentation however.

We don't have IPSKB_REROUTED for IPv6 currently.

While I was pondering adding that, I noticed another upside-down
world:

 - iptables POSTROUTING is invoked before outgoing fragmentation
   (verified using ping -s 65000 localhost, and watching with both
   ipt_LOG and tcpdump.)

 - ip6tables POSTROUTING is invoked after outgoing fragmentation

Also, if I am reading right, POSTROUTING is invoked twice for v6
multicast.
