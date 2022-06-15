Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197F9C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 07:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiFOHEH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiFOHEG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 03:04:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 973381582E
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 00:04:05 -0700 (PDT)
Date:   Wed, 15 Jun 2022 09:04:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Exit if nftnl_alloc_expr fails
Message-ID: <YqmEYNjjLO5WKgfr@salvia>
References: <20220614164457.4592-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220614164457.4592-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 14, 2022 at 06:44:57PM +0200, Phil Sutter wrote:
> In some code-paths, 'reg' pointer remaining unallocated is used later so
> at least minimal error checking is necessary. Given that a call to
> nftnl_alloc_expr() should never fail with sane argument, complain and
> exit if it happens.
> 
> Fixes: 7e38890c6b4fb ("nft: prepare for dynamic register allocation")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft-shared.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 27e95c1ae4f38..d603e7c9d663b 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -40,15 +40,25 @@ extern struct nft_family_ops nft_family_ops_ipv6;
>  extern struct nft_family_ops nft_family_ops_arp;
>  extern struct nft_family_ops nft_family_ops_bridge;
>  
> +static struct nftnl_expr *nftnl_expr_alloc_or_die(const char *name)

better call this:

xt_nftnl_expr_alloc()

or such, to not enter nftnl_ namespace, I'd suggest.

> +{
> +	struct nftnl_expr *expr = nftnl_expr_alloc(name);
> +
> +	if (expr)
> +		return expr;
> +

extra line space.

> +
> +	xtables_error(RESOURCE_PROBLEM,
> +		      "Failed to allocate nftnl expression '%s'", name);
> +}
> +
>  void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
>  	      uint8_t *dreg)
>  {
>  	struct nftnl_expr *expr;
>  	uint8_t reg;
>  
> -	expr = nftnl_expr_alloc("meta");
> -	if (expr == NULL)
> -		return;
> +	expr = nftnl_expr_alloc_or_die("meta");
>  
>  	reg = NFT_REG_1;
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
> @@ -64,9 +74,7 @@ void add_payload(struct nft_handle *h, struct nftnl_rule *r,
>  	struct nftnl_expr *expr;
>  	uint8_t reg;
>  
> -	expr = nftnl_expr_alloc("payload");
> -	if (expr == NULL)
> -		return;
> +	expr = nftnl_expr_alloc_or_die("payload");
>  
>  	reg = NFT_REG_1;
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
> @@ -85,9 +93,7 @@ void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
>  	struct nftnl_expr *expr;
>  	uint8_t reg;
>  
> -	expr = nftnl_expr_alloc("bitwise");
> -	if (expr == NULL)
> -		return;
> +	expr = nftnl_expr_alloc_or_die("bitwise");
>  
>  	reg = NFT_REG_1;
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
> @@ -107,9 +113,7 @@ void add_bitwise(struct nft_handle *h, struct nftnl_rule *r,
>  	uint32_t xor[4] = { 0 };
>  	uint8_t reg = *dreg;
>  
> -	expr = nftnl_expr_alloc("bitwise");
> -	if (expr == NULL)
> -		return;
> +	expr = nftnl_expr_alloc_or_die("bitwise");
>  
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
> @@ -126,9 +130,7 @@ void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len,
>  {
>  	struct nftnl_expr *expr;
>  
> -	expr = nftnl_expr_alloc("cmp");
> -	if (expr == NULL)
> -		return;
> +	expr = nftnl_expr_alloc_or_die("cmp");
>  
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_SREG, sreg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_OP, op);
> -- 
> 2.34.1
> 
