From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ctnetlink: optional packet drop to make event delivery
 reliable
Date: Tue, 24 Mar 2009 14:21:57 +0100
Message-ID: <49C8DE75.1050109@trash.net>
References: <20090324110706.13981.24167.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbZCXNWE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:22:04 -0400
In-Reply-To: <20090324110706.13981.24167.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index 5a449b4..98078b2 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -62,8 +62,11 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)

What tree is this against? I get reject in my nf-next tree.

>  	if (ct && ct != &nf_conntrack_untracked) {
>  		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
>  			ret = __nf_conntrack_confirm(skb);
> -		if (likely(ret == NF_ACCEPT))
> -			nf_ct_deliver_cached_events(ct);
> +		if (likely(ret == NF_ACCEPT) &&
> +		    nf_ct_deliver_cached_events(ct) < 0) {

The combined condition is unlikely I'd say. My main question though:
how does this make event delivery reliable? It will drop the packet,
fine, but all state changes have already been performed, new connections
have been confirmed, etc.

> +			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
> +			return NF_DROP;
> +		}
>  	}
>  	return ret;
