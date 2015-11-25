From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 00:57:31 +0000
Message-ID: <20151125005730.GC27315@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:51258 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932695AbbKYA5f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 19:57:35 -0500
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
> +		else
> +			__nft_trace_packet(pkt, chain, rulenum, type);

Not sure how the final solution is going to look, but this inline function was
meant to *only* get rid of the repeated nf_trace checks. Anything else should
be done out of line IMO since its inlined into the most performance critical
function of nftables.
