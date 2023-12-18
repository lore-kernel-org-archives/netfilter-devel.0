Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ED7760B7
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2023 23:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.43.141] (port=56846 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rFN4C-00GGO3-B4; Tue, 19 Dec 2023 00:30:34 +0100
Date: Tue, 19 Dec 2023 00:30:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Introduce
 NFT_TABLE_F_PERSIST
Message-ID: <ZYDWF8VRwAtlTMqo@calendula>
References: <20231215122627.19686-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231215122627.19686-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Fri, Dec 15, 2023 at 01:26:27PM +0100, Phil Sutter wrote:
> This companion flag to NFT_TABLE_F_OWNER requests the kernel to keep the
> table around after the process has exited. It marks such table as
> orphaned and allows another process to retake ownership later.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  6 +++-
>  net/netfilter/nf_tables_api.c            | 37 ++++++++++++++++++------
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index ca30232b7bc8..3fee994721cd 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -179,13 +179,17 @@ enum nft_hook_attributes {
>   * enum nft_table_flags - nf_tables table flags
>   *
>   * @NFT_TABLE_F_DORMANT: this table is not active
> + * @NFT_TABLE_F_OWNER:   this table is owned by a process
> + * @NFT_TABLE_F_PERSIST: this table shall outlive its owner
>   */
>  enum nft_table_flags {
>  	NFT_TABLE_F_DORMANT	= 0x1,
>  	NFT_TABLE_F_OWNER	= 0x2,
> +	NFT_TABLE_F_PERSIST	= 0x4,
>  };
>  #define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
> -				 NFT_TABLE_F_OWNER)
> +				 NFT_TABLE_F_OWNER | \
> +				 NFT_TABLE_F_PERSIST)
>  
>  /**
>   * enum nft_table_attributes - nf_tables table netlink attributes
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a75dcce2c6c4..cca2741f47be 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1198,24 +1198,29 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
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
> +	if (nft_table_has_owner(ctx->table)) {
> +		if (ctx->table->nlpid != ctx->portid)
> +			return -EPERM;
> +		if (!(flags & NFT_TABLE_F_OWNER))
> +			return -EOPNOTSUPP;
> +	}
> +
> +	if (flags & NFT_TABLE_F_OWNER &&
> +	    !nft_table_has_owner(ctx->table) &&
> +	    !(ctx->table->flags & NFT_TABLE_F_PERSIST))
> +		return -EPERM;
>  
>  	/* No dormant off/on/off/on games in single transaction */
>  	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> @@ -1226,6 +1231,16 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  	if (trans == NULL)
>  		return -ENOMEM;
>  
> +	if (flags & NFT_TABLE_F_OWNER) {
> +		ctx->table->flags &= ~NFT_TABLE_F_PERSIST;
> +		ctx->table->flags |= flags & NFT_TABLE_F_PERSIST;
> +		ctx->table->flags |= NFT_TABLE_F_OWNER;

I wouldn't allow to update the 'persist' flag on and off, just set it on
at creation and then this flag always remains there on for simplicity.

> +		ctx->table->nlpid = ctx->portid;
> +	} else if (nft_table_has_owner(ctx->table)) {
> +		ctx->table->flags &= ~NFT_TABLE_F_OWNER;
> +		ctx->table->nlpid = 0;
> +	}

I think you have to annotate this flag update and the new owner in the
transaction object. And disallow a second owner coming in the same batch
claiming to retake this.

Probably clear NFT_TABLE_F_OWNER flag when process goes away, then
annotate new owner in nlpid here, so it is effectively considered to
have an owner while processing the transaction.

If transaction gets aborted, just clear it up since NFT_TABLE_F_OWNER is
unset.

I think this needs a closer look.

>  	if ((flags & NFT_TABLE_F_DORMANT) &&
>  	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
>  		ctx->table->flags |= NFT_TABLE_F_DORMANT;
> @@ -11373,6 +11388,10 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
>  	list_for_each_entry(table, &nft_net->tables, list) {
>  		if (nft_table_has_owner(table) &&
>  		    n->portid == table->nlpid) {
> +			if (table->flags & NFT_TABLE_F_PERSIST) {
> +				table->flags &= ~NFT_TABLE_F_OWNER;
> +				continue;
> +			}
>  			__nft_release_hook(net, table);
>  			list_del_rcu(&table->list);
>  			to_delete[deleted++] = table;
> -- 
> 2.43.0
> 
