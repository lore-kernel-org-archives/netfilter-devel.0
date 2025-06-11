Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F49325F996
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2025 22:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682033; cv=none; b=Tl6chcLAioz6rtS6ThJI/Ih567Fu6ER5Ebm21KqQmlZI4C/zP8+mOOxmOudjvznCiIe2DPX4NzUn95aB/Rio89X/hHrpoNQz0x3dbcNpkIeF4Gg6ciGmmTfpPX3QdY6BKe/8etXWK5dChWoE8HyZExmiQpiOYcS8FkJho6xF9QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682033; c=relaxed/simple;
	bh=1VRo3Gd4VPCcBkDGOPRm+Dpz5v/HLC/OmuDhgZq8M9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql7Pe1/ln+QAMNtx9cddAkbxrEvL7tHwKHo5xBSZzspd5kWw4E2UNnxaUGhfK8h6eg22zYl4MtQjSlyIJrb9fmZepRb7Fz3uw/T2I2NFkr4NEiwIoISOpQOSBHKNcP/mt4W6v7eJC2dHSNZ+DNeKVRQi4Ax0GgxQZlee5Ru72o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lMhbxSZK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=odQByQYO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lMhbxSZK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="odQByQYO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2294E60254; Thu, 12 Jun 2025 00:46:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749682018;
	bh=Z/49EZOwoLzl/lxYvPm00nQg6skTRoOfXDsWeToD3e8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lMhbxSZKZVOxNd8Hu/rCaHIh023edExS44VDK3rp85J27A9/ZfARo2qTLvufBr/U/
	 rFC00OpOfJ1sD+6ISP7P5hrbe/EjsALxm4eg0plkpYR1DWNY7NV9Ei9QS5rtVj1Fr8
	 5LsQ4K6vdY7tsTdzzMtEsjiZ8iGZBV6lgdaQV0aLdEgmcU/uSiKku9Is6hQ/oPfpzO
	 zTdTMQCKC1o9WUnqvASyjUcD0OuQi3OWkkFjd/fHxaORQwe2SKpfD8kv9wns4ies7h
	 C8vTJlGqC1hZwp0ZqrZI+2pDt/cq3Z3RlqZQ7iUvGtxBZx5PunX9mS6sufNc9sE5mA
	 IsrKeVEuYbW8Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3FE0A605DE;
	Thu, 12 Jun 2025 00:46:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749682017;
	bh=Z/49EZOwoLzl/lxYvPm00nQg6skTRoOfXDsWeToD3e8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=odQByQYOOHb0hTJW0uZyI83NFz0/M4tY9dpy7EHvl7T7CPWJAmzHsH4A61u7SfJHa
	 eKAmpEFoZKTAqbSHhgBaz0XUknWZGXRwDPMglDHjB2eqp3rDLZvjmBofc17xgBhKsf
	 Cm01ksV2SHuYQupKGPqz0HsyleGJNjrL/mc3jM/xZ/yctuDkkyKmodPbPOlC2L/6Mo
	 xmuno+fXFAA5mabZZlxs+7ovnGyugrBy//AB2xN22flBiEOYAJjmfglbv8afdlCJwL
	 LLu1JncXPZy1vezY2M6WcYy5p0sdyAHX7y6Qpz/pDrLSN1GmWzxcqNYMJLdC3Yv//+
	 ZvudYECq9bykA==
Date: Thu, 12 Jun 2025 00:46:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: move BASECHAIN flag toggle to netlink linearize
 code for device update
Message-ID: <aEoHXtMloXwrY1mx@calendula>
References: <20250605164457.32614-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250605164457.32614-1-fw@strlen.de>

Hi Florian,

On Thu, Jun 05, 2025 at 06:44:54PM +0200, Florian Westphal wrote:
> The included bogon will crash nft because print side assumes that
> a BASECHAIN flag presence also means that priority expression is
> available.
> 
> We can either make the print side conditional or move the BASECHAIN
> setting to the last possible moment.

I don't remember to have said otherwise before, but I would go for
adding conditional print on priority in this case.

Thanks.

> Fixes: a66b5ad9540d ("src: allow for updating devices on existing netdev chain")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                      |  3 ---
>  src/mnl.c                                           | 13 +++++++++----
>  .../testcases/bogons/nft-f/null_ingress_type_crash  |  6 ++++++
>  3 files changed, 15 insertions(+), 7 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 014ee721cc04..b9a140172b2b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -6030,9 +6030,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>  	}
>  
>  	if (chain->dev_expr) {
> -		if (!(chain->flags & CHAIN_F_BASECHAIN))
> -			chain->flags |= CHAIN_F_BASECHAIN;
> -
>  		if (chain->handle.family == NFPROTO_NETDEV ||
>  		    (chain->handle.family == NFPROTO_INET &&
>  		     chain->hook.num == NF_INET_INGRESS)) {
> diff --git a/src/mnl.c b/src/mnl.c
> index 6565341fa6e3..9a885ee02739 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -821,6 +821,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  		      unsigned int flags)
>  {
>  	struct nftnl_udata_buf *udbuf;
> +	uint32_t chain_flags = 0;
>  	struct nftnl_chain *nlc;
>  	struct nlmsghdr *nlh;
>  	int priority, policy;
> @@ -846,6 +847,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  					     nftnl_udata_buf_len(udbuf));
>  			nftnl_udata_buf_free(udbuf);
>  		}
> +
> +		chain_flags = cmd->chain->flags;
> +		if (cmd->chain->dev_expr)
> +			chain_flags |= CHAIN_F_BASECHAIN;
>  	}
>  
>  	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, cmd->handle.table.name);
> @@ -866,7 +871,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
>  	cmd_add_loc(cmd, nlh, &cmd->handle.chain.location);
>  
> -	if (!cmd->chain || !(cmd->chain->flags & CHAIN_F_BINDING)) {
> +	if (!(chain_flags & CHAIN_F_BINDING)) {
>  		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
>  	} else {
>  		if (cmd->handle.chain.name)
> @@ -874,8 +879,8 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  					  cmd->handle.chain.name);
>  
>  		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(cmd->handle.chain_id));
> -		if (cmd->chain->flags)
> -			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
> +		if (chain_flags)
> +			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, chain_flags);
>  	}
>  
>  	if (cmd->chain && cmd->chain->policy) {
> @@ -889,7 +894,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
>  
>  	nftnl_chain_nlmsg_build_payload(nlh, nlc);
>  
> -	if (cmd->chain && cmd->chain->flags & CHAIN_F_BASECHAIN) {
> +	if (chain_flags & CHAIN_F_BASECHAIN) {
>  		struct nlattr *nest;
>  
>  		if (cmd->chain->type.str) {
> diff --git a/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
> new file mode 100644
> index 000000000000..2ed88af24c56
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
> @@ -0,0 +1,6 @@
> +table netdev filter1 {
> +	chain c {
> +		devices = { lo }
> +	}
> +}
> +list ruleset
> -- 
> 2.49.0
> 
> 
