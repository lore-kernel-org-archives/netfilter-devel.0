From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Sat, 20 Mar 2010 03:03:42 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003200252060.762@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57962 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0CTCDo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 22:03:44 -0400
In-Reply-To: <4BA0DAB3.3000700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 14:35, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +static void tee_tg_send(struct sk_buff *skb)
>> +{
>> +	const struct dst_entry *dst  = skb_dst(skb);
>> +	const struct net_device *dev = dst->dev;
>> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
>> +
>> +	/* Be paranoid, rather than too clever. */
...
>
>Remind me again why we need this duplicated output function?

:

>> +	/*
>> +	 * Normally, we would just use ip_local_out. Because iph->check is
>> +	 * already correct, we could take a shortcut and call dst_output
>> +	 * [forwards to ip_output] directly. ip_output however will invoke
>> +	 * Netfilter hooks
[ok we can skip these with IPSKB_REROUTED]

>>         and cause reentrancy. So we skip that too and go
>> +	 * directly to ip_finish_output.

And since we don't want fragmentation, we would need to call
ip_finish_output2. That function is not exported, so it is copied. I
am not even sure what the IPv4 layer does when it has to fragment a
fragment (because fragments don't seem to carry IP_DF).

Setting IP_DF on the cloned skb could possibly lead to a Packet Too
Big being sent back to the original sender - which should probably be
avoided too.


So removing the copied code does not look that easy.
