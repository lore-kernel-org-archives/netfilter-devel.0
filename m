From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: nft_meta: split nft_meta_init() into two
 functions for get/set
Date: Wed, 2 Apr 2014 13:43:19 +0200
Message-ID: <20140402114319.GC26035@macbook.localnet>
References: <1396089783-3984-1-git-send-email-kaber@trash.net>
 <1396089783-3984-3-git-send-email-kaber@trash.net>
 <53396197.20809@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44290 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbaDBLnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:43:24 -0400
Content-Disposition: inline
In-Reply-To: <53396197.20809@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 31, 2014 at 03:37:43PM +0300, Tomasz Bursztyka wrote:
> Hi Patrick,
> 
> >diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> >index 425cf39..6d0b8cc2 100644
> >--- a/net/netfilter/nft_meta.c
> >+++ b/net/netfilter/nft_meta.c
> >@@ -170,21 +170,15 @@ static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
> >  	[NFTA_META_SREG]	= { .type = NLA_U32 },
> >  };
> >-static int nft_meta_init_validate_set(uint32_t key)
> >+static int nft_meta_get_init(const struct nft_ctx *ctx,
> >+			     const struct nft_expr *expr,
> >+			     const struct nlattr * const tb[])
> >  {
> >-	switch (key) {
> >-	case NFT_META_MARK:
> >-	case NFT_META_PRIORITY:
> >-	case NFT_META_NFTRACE:
> >-		return 0;
> >-	default:
> >-		return -EOPNOTSUPP;
> >-	}
> >-}
> >+	struct nft_meta *priv = nft_expr_priv(expr);
> >+	int err;
> >-static int nft_meta_init_validate_get(uint32_t key)
> >-{
> >-	switch (key) {
> 
> With the disappearance of nft_meta_init_validate_get(), I will need to add
> an #ifdef/#endif clause for bridge key support. Or I would copy and adapt
> this new nft_meta_get_init() in nft_meta_bridge.c.
> 
> Don't you think nft_meta_validate_get() could be kept?

Why don't you add a bridge specific init function and invoke
nft_meta_get_init() for unknown keys?

It could be kept by passing a unsigned int *size for returning the size
of the key, but I would prefer to solve this differently.
