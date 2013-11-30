From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] netfilter: nft: add queue module
Date: Sat, 30 Nov 2013 13:26:57 +0100
Message-ID: <20131130122657.GG2067@breakpoint.cc>
References: <1385808722.4321.19.camel@ice-age2.regit.org>
 <1385808978-19833-1-git-send-email-eric@regit.org>
 <1385808978-19833-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44561 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab3K3M1K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:27:10 -0500
Content-Disposition: inline
In-Reply-To: <1385808978-19833-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@regit.org> wrote:
> This patch adds a new nft module named "nft_queue" which is a
> nftables target sending packet to nfnetlink_queue subsystem. It has
> the same level of functionnality as is iptables ancestor and share
> some code with it.

> +static u32 jhash_initval __read_mostly;

Consider adding something like

> +static int nft_queue_init(const struct nft_ctx *ctx,
> +			   const struct nft_expr *expr,
> +			   const struct nlattr * const tb[])
> +{
> +	struct nft_queue *priv = nft_expr_priv(expr);

	while (jhash_initval == 0)
		jhash_initval = prandom_u32();

Other than this, it looks good to me.

Thanks for spending time on this!
