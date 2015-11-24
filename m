From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 10:16:15 +0000
Message-ID: <20151124101614.GD2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44493 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbbKXKQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:16:18 -0500
Content-Disposition: inline
In-Reply-To: <1448359331-12692-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> No need to clutter nflog/dmesg ring buffer with the old tracing output
> when the 'native' nfnetlink interface is used.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index dabf5ed..69bdd9a 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -55,6 +55,7 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
>  		     rulenum);
>  }
>  
> +static bool prefer_native_trace __read_mostly;
>  struct static_key nft_trace_enabled __read_mostly;
>  EXPORT_SYMBOL_GPL(nft_trace_enabled);
>  
> @@ -69,7 +70,13 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
>  		if (!pkt->skb->nf_trace)
>  			return;
>  		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
> -		__nft_trace_packet(pkt, chain, rulenum, type);
> +		if (prefer_native_trace)
> +			return;
> +
> +		if (nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
> +			prefer_native_trace = true;

This seems to be better placed in a netlink bind callback.

> +		else
> +			__nft_trace_packet(pkt, chain, rulenum, type);
>  	}
>  }
