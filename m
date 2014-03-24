From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_tables: set names cannot be larger than 15
 bytes
Date: Mon, 24 Mar 2014 23:41:05 +0100
Message-ID: <20140324224105.GA21741@breakpoint.cc>
References: <1395670237-3841-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55408 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbaCXWlH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:41:07 -0400
Content-Disposition: inline
In-Reply-To: <1395670237-3841-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 33045a5..43ae487 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1946,7 +1946,8 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
>  
>  static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
>  	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
> -	[NFTA_SET_NAME]			= { .type = NLA_STRING },
> +	[NFTA_SET_NAME]			= { .type = NLA_STRING,
> +					    .len = IFNAMSIZ - 1 },

Not related to your patch, but it looks to me as if all of these
should be NLA_NUL_STRING, no?
