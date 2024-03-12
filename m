Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957C17A152
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710251360; cv=none; b=ms8DtqX1kidXEjOODRveE1hiRK79A0LATKLajq+3aePE5ThBRpIIgMyFMpFYyNo6V4Ryf1iQLu6RTYetQAOcu9ghsmTGT/eSavhkVhdSJqHSdMz0jSndhnwOuITYCduJr9NwetKdIMHpUgoQssL+O8Dt1cauqcPf/5p4bMv3Mj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710251360; c=relaxed/simple;
	bh=lebE4y9ztXhMwROr99aBQv278/+05+A8OuPt1mRyUbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iU+lSRxBT75xBZv/vLdibFIu/68hXPQNmKsk3o4/e8QmYujM+0w5jSBVQTYI1+s5Bk3/XXl67eI+a06iPGhX3/ouafsUjgQNamEVbMqFsNt6XcymfXTDreU+hAPPpINWdQfCD13ukHwy2wpVX5/BQreQ+kK5Sdg2TyjZzaDMgCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 12 Mar 2024 14:49:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfBdWIne-ujSEePS@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240311141454.31537-2-tianquan23@gmail.com>

On Mon, Mar 11, 2024 at 10:14:54PM +0800, Quan Tian wrote:
> The NFTA_TABLE_USERDATA attribute was ignored on updates. The patch adds
> handling for it to support table comment updates.

dump path is lockless:

        if (table->udata) {
                if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
                        goto nla_put_failure;
        }

there are two things to update at the same time here, table->udata and
table->udlen.

This needs to be reworked fully if updates are required.

nft_userdata {
        const u8        *data;
        u16             len;
}

then, update struct nft_table to have:

        struct nft_userdata __rcu *user;

then, from dump path, rcu_dereference struct nft_userdata pointer.

BTW, does swap() ensure rcu semantics?

> Signed-off-by: Quan Tian <tianquan23@gmail.com>
> ---
>  v2: Change to store userdata in struct nlattr * to ensure atomical update
>  v3: Do not call nft_trans_destroy() on table updates in nf_tables_commit()
> 
>  include/net/netfilter/nf_tables.h |  3 ++
>  net/netfilter/nf_tables_api.c     | 56 ++++++++++++++++++++++---------
>  2 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 144dc469ebf8..43c747bd3f80 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1684,10 +1684,13 @@ struct nft_trans_chain {
>  
>  struct nft_trans_table {
>  	bool				update;
> +	struct nlattr			*udata;
>  };
>  
>  #define nft_trans_table_update(trans)	\
>  	(((struct nft_trans_table *)trans->data)->update)
> +#define nft_trans_table_udata(trans)	\
> +	(((struct nft_trans_table *)trans->data)->udata)
>  
>  struct nft_trans_elem {
>  	struct nft_set			*set;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 85088297dd0d..62a2a1798052 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -188,6 +188,17 @@ static struct nlattr *nft_userdata_dup(const struct nlattr *udata, gfp_t gfp)
>  	return kmemdup(udata, nla_total_size(nla_len(udata)), gfp);
>  }
>  
> +static bool nft_userdata_is_same(const struct nlattr *a, const struct nlattr *b)
> +{
> +	if (!a && !b)
> +		return true;
> +	if (!a || !b)
> +		return false;
> +	if (nla_len(a) != nla_len(b))
> +		return false;
> +	return !memcmp(nla_data(a), nla_data(b), nla_len(a));
> +}
> +
>  static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
>  				 bool bind)
>  {
> @@ -1210,16 +1221,16 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  {
>  	struct nft_trans *trans;
>  	u32 flags;
> +	const struct nlattr *udata = ctx->nla[NFTA_TABLE_USERDATA];
>  	int ret;
>  
> -	if (!ctx->nla[NFTA_TABLE_FLAGS])
> -		return 0;
> -
> -	flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
> -	if (flags & ~NFT_TABLE_F_MASK)
> -		return -EOPNOTSUPP;
> +	if (ctx->nla[NFTA_TABLE_FLAGS]) {
> +		flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
> +		if (flags & ~NFT_TABLE_F_MASK)
> +			return -EOPNOTSUPP;
> +	}
>  
> -	if (flags == ctx->table->flags)
> +	if (flags == ctx->table->flags && nft_userdata_is_same(udata, ctx->table->udata))
>  		return 0;
>  
>  	if ((nft_table_has_owner(ctx->table) &&
> @@ -1240,6 +1251,14 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  	if (trans == NULL)
>  		return -ENOMEM;
>  
> +	if (udata) {
> +		nft_trans_table_udata(trans) = nft_userdata_dup(udata, GFP_KERNEL_ACCOUNT);
> +		if (!nft_trans_table_udata(trans)) {
> +			ret = -ENOMEM;
> +			goto err_table_udata;
> +		}
> +	}
> +
>  	if ((flags & NFT_TABLE_F_DORMANT) &&
>  	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
>  		ctx->table->flags |= NFT_TABLE_F_DORMANT;
> @@ -1271,6 +1290,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  
>  err_register_hooks:
>  	ctx->table->flags |= NFT_TABLE_F_DORMANT;
> +	kfree(nft_trans_table_udata(trans));
> +err_table_udata:
>  	nft_trans_destroy(trans);
>  	return ret;
>  }
> @@ -9378,6 +9399,9 @@ static void nft_obj_commit_update(struct nft_trans *trans)
>  static void nft_commit_release(struct nft_trans *trans)
>  {
>  	switch (trans->msg_type) {
> +	case NFT_MSG_NEWTABLE:
> +		kfree(nft_trans_table_udata(trans));
> +		break;
>  	case NFT_MSG_DELTABLE:
>  	case NFT_MSG_DESTROYTABLE:
>  		nf_tables_table_destroy(&trans->ctx);
> @@ -10140,19 +10164,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  		switch (trans->msg_type) {
>  		case NFT_MSG_NEWTABLE:
>  			if (nft_trans_table_update(trans)) {
> -				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
> -					nft_trans_destroy(trans);
> -					break;
> +				if (trans->ctx.table->flags & __NFT_TABLE_F_UPDATE) {
> +					if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> +						nf_tables_table_disable(net, trans->ctx.table);
> +					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
>  				}
> -				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> -					nf_tables_table_disable(net, trans->ctx.table);
> -
> -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
> +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
>  			} else {
>  				nft_clear(net, trans->ctx.table);
> +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
> +				nft_trans_destroy(trans);
>  			}
> -			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
> -			nft_trans_destroy(trans);
>  			break;
>  		case NFT_MSG_DELTABLE:
>  		case NFT_MSG_DESTROYTABLE:
> @@ -10430,6 +10453,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  		switch (trans->msg_type) {
>  		case NFT_MSG_NEWTABLE:
>  			if (nft_trans_table_update(trans)) {
> +				kfree(nft_trans_table_udata(trans));
>  				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
>  					nft_trans_destroy(trans);
>  					break;
> -- 
> 2.39.3 (Apple Git-145)
> 
