Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D9CA
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 05:08:58 -0800 (PST)
Received: from [78.30.43.141] (port=43262 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rD2VH-001xrq-JW; Tue, 12 Dec 2023 14:08:53 +0100
Date: Tue, 12 Dec 2023 14:08:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXhbYs4vQMWX/q+d@calendula>
References: <20231208130103.26931-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231208130103.26931-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Fri, Dec 08, 2023 at 02:01:03PM +0100, Phil Sutter wrote:
> A process may take ownership of an existing table not owned yet or free
> a table it owns already.
> 
> A practical use-case is Firewalld's CleanupOnExit=no option: If it
> starts creating its own tables with owner flag, dropping that flag upon
> program exit is the easiest solution to make the ruleset survive.

I can think of a package update as use-case for this feature?
Meanwhile, package is being updated the ruleset remains in place.

Is there any more scenario are you having in mind for this?

> Mostly for consistency, this patch enables taking ownership of an
> existing table, too. This would allow firewalld to retake the ruleset it
> has previously left.

Isn't it better to start from scratch? Basically, flush previous the
table that you know it was there and reload the ruleset.

Maybe also goal in this case is to keep counters (and other stateful
objects) around?

Thanks.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a75dcce2c6c4..ef89298cd11a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1198,24 +1198,21 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
>  static int nf_tables_updtable(struct nft_ctx *ctx)
>  {
>  	struct nft_trans *trans;
> -	u32 flags;
> +	u32 flags = 0;
>  	int ret;
>  
> -	if (!ctx->nla[NFTA_TABLE_FLAGS])
> -		return 0;
> +	if (ctx->nla[NFTA_TABLE_FLAGS])
> +		flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
>  
> -	flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
>  	if (flags & ~NFT_TABLE_F_MASK)
>  		return -EOPNOTSUPP;
>  
>  	if (flags == ctx->table->flags)
>  		return 0;
>  
> -	if ((nft_table_has_owner(ctx->table) &&
> -	     !(flags & NFT_TABLE_F_OWNER)) ||
> -	    (!nft_table_has_owner(ctx->table) &&
> -	     flags & NFT_TABLE_F_OWNER))
> -		return -EOPNOTSUPP;
> +	if (nft_table_has_owner(ctx->table) &&
> +	    ctx->table->nlpid != ctx->portid)
> +		return -EPERM;
>  
>  	/* No dormant off/on/off/on games in single transaction */
>  	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> @@ -1226,6 +1223,14 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  	if (trans == NULL)
>  		return -ENOMEM;
>  
> +	if (flags & NFT_TABLE_F_OWNER) {
> +		ctx->table->flags |= NFT_TABLE_F_OWNER;
> +		ctx->table->nlpid = ctx->portid;
> +	} else if (nft_table_has_owner(ctx->table)) {
> +		ctx->table->flags &= ~NFT_TABLE_F_OWNER;
> +		ctx->table->nlpid = 0;
> +	}
> +
>  	if ((flags & NFT_TABLE_F_DORMANT) &&
>  	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
>  		ctx->table->flags |= NFT_TABLE_F_DORMANT;
> -- 
> 2.41.0
> 
