From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 11:24:45 +0100
Message-ID: <20151124102445.GE2683@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39285 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbbKXKYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:24:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F3081B6BA5
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:24:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E44A1DA863
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:24:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D9EFDA860
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:24:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448359331-12692-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:02:08AM +0100, Florian Westphal wrote:
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
> +		else
> +			__nft_trace_packet(pkt, chain, rulenum, type);

For this very specific case I prefer a sysctl that we can remove
moving forward, then remove this code and default to the new tracing
infrastructure once we have indications that adoption of this new
tracing infrastructure has been massively adopted instead of the
existing one.
