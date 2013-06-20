From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_conntrack_ipv6: Plug sk_buff leak in
 fragment handling
Date: Thu, 20 Jun 2013 11:20:31 +0200
Message-ID: <20130620092031.GC2124@breakpoint.cc>
References: <20130619104950.GA1343@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, security@kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35735 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab3FTJUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:20:36 -0400
Content-Disposition: inline
In-Reply-To: <20130619104950.GA1343@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> In commit 4cdd3408 ("netfilter: nf_conntrack_ipv6: improve fragmentation
> handling"), an sk_buff leak was introduced when dealing with reassembled
> packets by grabbing a reference to the original skb instead of the
> reassembled skb.  At this point, the leak only impacted conntracks with an
> associated helper.  

David, could you please apply this patch directly in case Pablo doesn't
apply it first?  This fixes a remote DoS, so it better hit -stable ASAP.

Thanks.

[ archive link: http://patchwork.ozlabs.org/patch/252692/ ]

> diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> index 97bcf2b..c9b6a6e 100644
> --- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> @@ -204,7 +204,7 @@ static unsigned int __ipv6_conntrack_in(struct net *net,
>  		if (ct != NULL && !nf_ct_is_untracked(ct)) {
>  			help = nfct_help(ct);
>  			if ((help && help->helper) || !nf_ct_is_confirmed(ct)) {
> -				nf_conntrack_get_reasm(skb);
> +				nf_conntrack_get_reasm(reasm);
>  				NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, reasm,
>  					       (struct net_device *)in,
>  					       (struct net_device *)out,

Thanks for fixing it, but personally I would have preferred a short early
warning period.
