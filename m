Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99D21BBBE8
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 23:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145663; cv=none; b=Klyp05ta+nGyFpgc4iRoFT/rz0FoKZz4IWcf/YLrQ/N7z9q+/rE0obdq2x+PG2GcPG8LeAqfQuioC3W3spEx+1Z/tt0dpq8+spmeHb6lw+m44RevLQNg6Shy+WPc7BV5OaKYNkbJOzxFv5hHnm4EmuhH41t5I5HI2sVKY21mhO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145663; c=relaxed/simple;
	bh=ETQowP0q06ZwYzfx57N7JpT76LYPkTB1ufVmMw5Lx7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWZxL9NMn9blT5D1I2vCHw/XPDkB0SSUGjuKjQ4wGltJ1nIoY3LmWv3/0Wc4SiGvHVZIh1UCZWGFc7GujeUHoUSI6dcBJZxXI8RIpuEidibmTQlhHVAwfEYa9tLw7g63MRK/eQQ0NqaZjSB3QVgLa0TjFe0GIzzB/j3e6OryQRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=56444 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tDuDB-006UmX-19; Thu, 21 Nov 2024 00:34:19 +0100
Date: Thu, 21 Nov 2024 00:34:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: export set count and
 backend name to userspace
Message-ID: <Zz5x-ImnAOh-9trs@calendula>
References: <20241120095236.10532-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241120095236.10532-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Nov 20, 2024 at 10:52:33AM +0100, Florian Westphal wrote:
> nf_tables picks a suitable set backend implementation (bitmap, hash,
> rbtree..) based on the userspace requirements.
> 
> Figuring out the chosen backend requires information about the set flags
> and the kernel version.  Export this to userspace so nft can include this
> information in debug stats.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nf_tables_api.c            | 19 +++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 49c944e78463..6e87d704d3a8 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -394,6 +394,8 @@ enum nft_set_field_attributes {
>   * @NFTA_SET_HANDLE: set handle (NLA_U64)
>   * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
>   * @NFTA_SET_EXPRESSION: list of expressions (NLA_NESTED: nft_list_attributes)
> + * @NFTA_SET_OPSNAME: set backend type (NLA_STRING)
> + * @NFTA_SET_NELEMS: number of set elements (NLA_U32)
>   */
>  enum nft_set_attributes {
>  	NFTA_SET_UNSPEC,
> @@ -415,6 +417,8 @@ enum nft_set_attributes {
>  	NFTA_SET_HANDLE,
>  	NFTA_SET_EXPR,
>  	NFTA_SET_EXPRESSIONS,
> +	NFTA_SET_OPSNAME,
> +	NFTA_SET_NELEMS,
>  	__NFTA_SET_MAX
>  };
>  #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 21b6f7410a1f..da308e295b95 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4565,6 +4565,8 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
>  	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
>  	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
>  	[NFTA_SET_EXPRESSIONS]		= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
> +	[NFTA_SET_OPSNAME]		= { .type = NLA_REJECT },
> +	[NFTA_SET_NELEMS]		= { .type = NLA_REJECT },
>  };
>  
>  static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
> @@ -4751,6 +4753,21 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
>  	return 0;
>  }
>  
> +/* no error checking: non-essential debug info */
> +static void nf_tables_fill_set_info(struct sk_buff *skb,
> +				    const struct nft_set *set)
> +{
> +	unsigned int nelems = atomic_read(&set->nelems);
> +	const char *str = kasprintf(GFP_ATOMIC, "%ps", set->ops);
> +
> +	nla_put_be32(skb, NFTA_SET_NELEMS, htonl(nelems));
> +
> +	if (str)
> +		nla_put_string(skb, NFTA_SET_OPSNAME, str);
> +
> +	kfree(str);

Can you think of a case where this cannot fit in the skbuff either in
netlink dump or event path? I would check for errors here.

If you like my syntax proposal in userspace:

        size 128        # count 56

maybe rename _NELEMS to _COUNT.

As for NFTA_SET_OPSNAME, I suggest NFTA_SET_TYPE.

Thanks.

> +}
> +
>  static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
>  			      const struct nft_set *set, u16 event, u16 flags)
>  {
> @@ -4830,6 +4847,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
>  
>  	nla_nest_end(skb, nest);
>  
> +	nf_tables_fill_set_info(skb, set);
> +
>  	if (set->num_exprs == 1) {
>  		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
>  		if (nf_tables_fill_expr_info(skb, set->exprs[0], false) < 0)
> -- 
> 2.45.2
> 
> 
