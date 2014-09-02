From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH 5/6 v5] netfilter: nf_tables: extend
 NFT_MSG_DELTABLE to support flushing the ruleset
Date: Tue, 2 Sep 2014 16:12:41 +0100
Message-ID: <20140902151241.GA29716@acer.localdomain>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIBPMx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:12:53 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:26PM +0200, Arturo Borrero Gonzalez wrote:
> This patch extend the NFT_MSG_DELTABLE call to support flushing the entire
> ruleset.
> 
> The options now are:
>  * No family speficied, no table specified: flush all the ruleset.
>  * Family specified, no table specified: flush all tables in the AF.
>  * Family specified, table specified: flush the given table.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: address comments by Pablo:
>     * don't return EINVAL if called with AF_UNSPEC and a concrete table.
>     * A more generic function, nft_flush()
> 
> v3: no changes, resending the series.
> v4: no changes, resending the series because v3 series was invalid.
> v5: address comment by Pablo: delete set if the list of bindings is empty.

> +static int nft_flush_table(struct nft_ctx *ctx)
> +{
> +	int err;
> +	struct nft_chain *chain, *nc;
> +	struct nft_set *set, *ns;
> +
> +	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
> +		ctx->chain = chain;
> +
> +		err = nft_delrule_by_chain(ctx);
> +		if (err < 0)
> +			goto out;
> +
> +		err = nft_delchain(ctx);
> +		if (err < 0)
> +			goto out;
> +	}
> +
> +	list_for_each_entry_safe(set, ns, &ctx->table->sets, list) {
> +		if (set->flags & NFT_SET_ANONYMOUS &&
> +		    !list_empty(&set->bindings))
> +			continue;

So we're removing anonymous sets iff the bindings are empty. I feel I'm
missing something:

- how could we possibly still have bindings after the table has been flushed?
- if that were possible, why wouldn't it also apply to non-anonymous sets?

If I'm not mistaken we should be able to unconditionally delete all sets
once the ruleset has been flushed.

> +		err = nft_delset(ctx, set);
> +		if (err < 0)
> +			goto out;
> +	}
