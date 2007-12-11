From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] Add support for NAT sequence adjustments
Date: Tue, 11 Dec 2007 16:56:38 +0100
Message-ID: <475EB336.2030503@netfilter.org>
References: <475C302C.1070402@netfilter.org> <475C3D6E.9000800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35346 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750965AbXLKP4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:56:10 -0500
In-Reply-To: <475C3D6E.9000800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> The combination of NAT and helpers may produce TCP sequence adjustments.
>> In failover setups, this information needs to be replicated in order to
>> achieve a successful recovery of mangled, related connections. This
>> patch is particularly useful for conntrackd, see:
>>
>>   
> +    /* NAT sequence adjustment */
> +    IPCT_NATSEQADJ_BIT = 13,
> +    IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
> 
> You don't seem to be using this bit for anything.

Hm, I think I did.

> @@ -191,6 +192,8 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
>  		/* Tell TCP window tracking about seq change */
>  		nf_conntrack_tcp_update(skb, ip_hdrlen(skb),
>  					ct, CTINFO2DIR(ctinfo));
> +
> +		nf_conntrack_event_cache(IPCT_NATSEQADJ, skb);

Here we cache the NAT sequence adjustment event.

> ===================================================================
> --- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-11-25 19:08:18.000000000 +0100
> +++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-12-08 21:42:31.000000000 +0100
> @@ -424,6 +474,10 @@ static int ctnetlink_conntrack_event(str
>  		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
>  		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
>  			goto nla_put_failure;
> +
> +		if (events & IPCT_NATSEQADJ &&
> +		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
> +			goto nla_put_failure;

And here we dump it.
