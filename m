Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7D2F5B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 02:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753150307; cv=none; b=Sk8TYfCGcMZmPuO1Q+KT7F6xSKg2ohY4ngjOHxQZ/pMyZ2LF6jzJXxOPJo0ukzYEilfGYYNrF6iJUpM0YfXfvMcxTX9FxqlPEvgoC2rMJyH6+1GiVfBaQ7hSvBbP71HlVV0GJIixBaTKzI4NF8uGZjGUBfa33bOlMUR7uO+W+ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753150307; c=relaxed/simple;
	bh=oI18GF1TAUrPOgUk7c4GukenoGl2WQL5PACGV4OEznE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc6DACY58vP94zuhPbixoPAzhRZLmq7B44oYH30If49uCDpItSAwHwI2eKok4y8P5YGmWBmdmizulPInYunwLA7jTz6X7kqCYXXDSMltC5EsyajJ2TIH+sG1zY/2jTncBlcAZhgyANLq9FNVtlot40GFTsOEoLEfRy9uAoscQB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WQLFYdTA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oR3kmY+a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WQLFYdTA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oR3kmY+a"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 38E6D60281; Tue, 22 Jul 2025 04:11:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753150302;
	bh=bOCz1iCV4aO+jL2msnJia8iL3WWQthoNZ4jAUWFpASA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQLFYdTAcvhGvhewueihHr/Rnap1WQh65nJjnRxBcebEnJd4D+XHUz+aNGJRD4olZ
	 vU1xvGoOY9G3pPClzvFMd/u4soXo35C/pWsy86i4RMMBu9i7TcpbZL4zZofWC2sRdY
	 WQo2h9ZIkBOBBVoa4gKAweV7AxzIKiT8W73F2m53iBKTvLEUe1j9uCxA33qcESBWHp
	 2iUzG44fPTyPQRvCJ2UxExImWkIPsTQn5l/IJhVPBZotmBpndf5l4SONOZQSUPp7hp
	 CTcq6HseiOnLbSeKD8E+WkuQwecrzFoj9g0vUlWQZeJsMTUMG+lQf1nSbBldv5Y7OM
	 WYUI6vT777b0g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6263260281;
	Tue, 22 Jul 2025 04:11:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753150300;
	bh=bOCz1iCV4aO+jL2msnJia8iL3WWQthoNZ4jAUWFpASA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oR3kmY+aXdMIza35B4Oz1oKVWoae2L3wamk/U0O8nUa6BX1N91L0urqzp0u8QSC08
	 8lYo8JTSsXI5WtoUSsCCGabUn8JlbJTW3zwlxs65zjzObrnAIH4KwfGj0rH0ts/Nc6
	 VlZtjaR6YKYjjICgTTIiys4UhSopaaXce1hN2DQ7bLZMNYhPaLqvF9AC+UF7AirOzc
	 hgcIafq351HxtHelTJSuArDRgfBVZhmgZ8ZcuMzfaWBdmQZR7UCN2QcyYAnbgSqjhB
	 FCxxVNiJ4OjQkT55PsKBpUxbmglEWjPLbS5Pqmhky/HdW08AG3eIee9Y1Y/E8Ua++G
	 FQuswXupEvHYg==
Date: Tue, 22 Jul 2025 04:11:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aH7zWPAVRV8_1ehk@calendula>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250520030842.3072235-1-brady.1345@gmail.com>

On Mon, May 19, 2025 at 11:08:41PM -0400, Shaun Brady wrote:
[...]
> @@ -4039,14 +4049,62 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
>  }
>  EXPORT_SYMBOL_GPL(nft_chain_validate);
>  
> -static int nft_table_validate(struct net *net, const struct nft_table *table)
> +/** nft_families_inc_jump - Determine if tables should add to the total jump
> + * count for a netns.
> + *
> + * @table: table of interest
> + * @sibling_table: a 'sibling' table to compare against
> + *
> + * Compare attributes of the tables to determine if the sibling tables
> + * total_jump_count should be added to the working context (done by caller).
> + * Mostly concerned with family compatibilities, but also identifying equality
> + * (a tables own addition will be recalculated soon).
> + *
> + * Ex: v4 tables do not apply to v6 packets
> + */
> +static bool nft_families_inc_jump(struct nft_table *table, struct nft_table *sibling_table)
> +{

I think we mentioned about NFPROTO_BRIDGE here too.

> +	/* Invert parameters to on require one test for two cases (the reverse) */
> +	if (sibling_table->family > table->family) /* include/uapi/linux/netfilter.h */
> +		return nft_families_inc_jump(sibling_table, table);
> +
> +	/* We found ourselves; don't add current jump count (will be counted dynamically) */
> +	if (sibling_table == table)
> +		return false;
> +
> +	switch (table->family) {
> +	case NFPROTO_IPV4:
> +		if (sibling_table->family == NFPROTO_IPV6)
> +			return false;
> +		break;
> +	}
> +
> +	return true;
> +}
> +
> +static int nft_table_validate(struct net *net, struct nft_table *table)

This function is called from abort path too. I suspect total_jump_count
for this table will not be OK in such case. And this selftest does cover
many cases.

>  {
>  	struct nft_chain *chain;
> +	struct nftables_pernet *nft_net;
>  	struct nft_ctx ctx = {
>  		.net	= net,
>  		.family	= table->family,
> +		.total_jump_count = 0,
>  	};
>  	int err;
> +	u32 total_jumps_before_validate;
> +	struct nft_table *sibling_table;
> +
> +	nft_net = nft_pernet(net);
> +
> +	if (!net_eq(net, &init_net)) {
> +		list_for_each_entry(sibling_table, &nft_net->tables, list) {
> +			if(nft_families_inc_jump(table, sibling_table))
                          ^
                  coding style

> +				ctx.total_jump_count += sibling_table->total_jump_count;
> +		}
> +	}
> +
> +	total_jumps_before_validate = ctx.total_jump_count;
>  
>  	list_for_each_entry(chain, &table->chains, list) {
>  		if (!nft_is_base_chain(chain))
> @@ -4060,6 +4118,8 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
>  		cond_resched();
>  	}
>  
> +	table->total_jump_count = ctx.total_jump_count - total_jumps_before_validate;
> +
>  	return 0;
>  }
>  
> @@ -4084,6 +4144,7 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
>  	case NFT_JUMP:
>  	case NFT_GOTO:
>  		pctx->level++;
> +		pctx->total_jump_count++;
>  		err = nft_chain_validate(ctx, data->verdict.chain);
>  		if (err < 0)
>  			return err;
> @@ -11916,6 +11977,59 @@ static struct notifier_block nft_nl_notifier = {
>  	.notifier_call  = nft_rcv_nl_event,
>  };
>  
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table nf_limit_control_sysctl_table[] = {
> +	{
> +		.procname	= "nf_max_table_jumps_netns",
> +		.data		= &init_net.nf.nf_max_table_jumps_netns,
> +		.maxlen		= sizeof(init_net.nf.nf_max_table_jumps_netns),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +};
> +
> +static int netfilter_limit_control_sysctl_init(struct net *net)
> +{
> +	struct ctl_table *tbl;
> +
> +	net->nf.nf_max_table_jumps_netns = NFT_DEFAULT_MAX_TABLE_JUMPS;
> +	tbl = nf_limit_control_sysctl_table;
> +	if (!net_eq(net, &init_net)) {
> +		tbl = kmemdup(tbl, sizeof(nf_limit_control_sysctl_table), GFP_KERNEL);

Not checking error:

                if (!tbl)
                        ...

> +		tbl->data = &net->nf.nf_max_table_jumps_netns;
> +		if (net->user_ns != &init_user_ns)
> +			tbl->mode &= ~0222;
> +	}
> +
> +	net->nf.nf_limit_control_dir_header = register_net_sysctl_sz(
> +		net, "net/netfilter", tbl, ARRAY_SIZE(nf_limit_control_sysctl_table));
> +
> +	if (!net->nf.nf_limit_control_dir_header)
> +		goto err_alloc;
> +
> +	return 0;
> +
> +err_alloc:
> +	if (tbl != nf_limit_control_sysctl_table)
> +		kfree(tbl);
> +	return -ENOMEM;
> +}
