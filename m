Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC976C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 16:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5840208C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 16:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfGRQb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 12:31:56 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbfGRQb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 12:31:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1ho9Jy-0003z6-8j; Thu, 18 Jul 2019 18:31:54 +0200
Date:   Thu, 18 Jul 2019 18:31:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_dynset: support for element deletion
Message-ID: <20190718163154.6mabfb6ddwldyizb@breakpoint.cc>
References: <20190718064359.5440-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718064359.5440-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> This patch implements the delete operation from the ruleset.
> 
> It implements a new delete() function in nft_set_rhash. It is simpler
> to use than the already existing remove(), because it only takes the set
> and the key as arguments, whereas remove() expects a full
> nft_set_elem structure.
> 
> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  include/net/netfilter/nf_tables.h        | 17 ++++++---
>  include/uapi/linux/netfilter/nf_tables.h |  1 +
>  net/netfilter/nft_dynset.c               | 44 +++++++++++++++++-------
>  net/netfilter/nft_set_hash.c             | 19 ++++++++++
>  4 files changed, 63 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 9e8493aad49d..ddea26ba14b1 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -286,24 +286,25 @@ struct nft_expr;
>  /**
>   *	struct nft_set_ops - nf_tables set operations
>   *
> + *	@update: update an element if exists, add it if doesn't exist
> + *	@delete: delete an element
>   *	@lookup: look up an element within the set

I would suggest:

>   *	@lookup: look up an element within the set
> + *	@update: update an element if exists, add it if doesn't exist
> + *	@delete: delete an element

> + *
> + *	Operations update and delete have simpler interfaces, and currently
> + *	only used in the packet path. All the rest are for the control plane.

Not correct, update/delete/lookup are packet path.

>   */
>  struct nft_set_ops {
You could add a comment here,
	/* data plane / fast path */
> -	bool				(*lookup)(const struct net *net,
> -						  const struct nft_set *set,
> -						  const u32 *key,
> -						  const struct nft_set_ext **ext);

This looks confusing, why is this being moved around?
You can keep it where it is, its most likely the most frequently called op.

>  	bool				(*update)(struct nft_set *set,
>  						  const u32 *key,
>  						  void *(*new)(struct nft_set *,
> @@ -312,7 +313,13 @@ struct nft_set_ops {
>  						  const struct nft_expr *expr,
>  						  struct nft_regs *regs,
>  						  const struct nft_set_ext **ext);
> +	bool				(*delete)(const struct nft_set *set,
> +						  const u32 *key);

Adding delete here looks good.

> +	bool				(*lookup)(const struct net *net,
> +						  const struct nft_set *set,
> +						  const u32 *key,
> +						  const struct nft_set_ext **ext);

I would keep it at the start, no need to move it.

You could add a comment here,
	/* control plane / slow path */

Also, please run your patches through scripts/checkpatch.pl.

> +static bool nft_rhash_delete(const struct nft_set *set,
> +			     const u32 *key)
> +{
> +	struct nft_rhash *priv = nft_set_priv(set);
> +	struct nft_rhash_elem *he;
> +	struct nft_rhash_cmp_arg arg = {
> +		.genmask = NFT_GENMASK_ANY,
> +		.set = set,
> +		.key = key,
> +	};
> +
> +	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
> +	if (he == NULL)
> +		return false;
> +
> +	return (rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params) == 0);

No need for those ().
	return rhashtable_remove_fast( ...) == 0;

Other than that this looks ready for merging.
