Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922B30B521
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 11:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788261346; cv=none; b=mT6AZuMqM8nU5i/NRgUD+iSTyjG8r++SyRBNcWPJ7tkOOxians5ROeivK3vNtLCCFGbsgyj2uBWHZ3TSSnd9t5/g4mqp2R6uPpM4BZ2m9vBvH3KPRKIqIIhZZWiPAU7tbD6mftzE9Ylh9ggQQH8Je1Ten0F3SQ4Uf/8onepb7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788261346; c=relaxed/simple;
	bh=FN1aWfXQTl8/MzNQhfIPQJb7PFwhg+7hW4VA5JlbFnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gf17C3+QRIk3M3g9ehXSXf3uRGuDLuoc1DEYelMrZdpz5BVy4RB+BLdUN6MJj3LQffguvZqVFnrKfEu+rUljUVSE6fv/u3CQ5M6EOt1Yzni9W+FPtTm0mnD9VzQHES6neX9mO8GDzuzhto8Hx7nSRpLpzmVanwGP/ywGDGXMoNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DPtCHJi3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m/ircIyG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lhRxhjXQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1f4cx1ah; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DPtCHJi3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m/ircIyG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lhRxhjXQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1f4cx1ah"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB9E22263B;
	Tue,  1 Sep 2026 11:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788261338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cnSNSfc0pM2gxtkMLp3njDUg87MSAE2sObIUw0cuOg=;
	b=DPtCHJi3kes0BFndWab4TjE71iMZ02tah83dKolYWWnrAzBmTeMKZXjhLnHBQeZxy8/fjl
	VhvJdqTy/59vt10vUpS78NFGo7ljn5vtTslgm4HiVdKj48Ozesk2F1w0F8cCOfCaH0LQ7o
	mfqes2ySAyjAXdJgDsIorj0W5i7HUeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788261338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cnSNSfc0pM2gxtkMLp3njDUg87MSAE2sObIUw0cuOg=;
	b=m/ircIyGaEXvpUgBcQckrF1HMWRWKKdTVxV7AOqk/B00mGbBk2H2lovxtuVsm/kymD5aVU
	ROzhwtU6rKv/x9DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lhRxhjXQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1f4cx1ah
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788261333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cnSNSfc0pM2gxtkMLp3njDUg87MSAE2sObIUw0cuOg=;
	b=lhRxhjXQL+JSx5YNQukM2krPOfB4Lb8jp1ZFxqwJMUPSCDxuTD4LvkUc2mK3SoaiyLThUy
	NpM9gy7ESpGa2cWWj2Of1MttOA+dS4Sf8xVkc6D481gShoQZDAn1NxPQoqmQ4DBskYB91r
	k7rCyYmr1eINjdN8BD593Q45XT95dAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788261333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cnSNSfc0pM2gxtkMLp3njDUg87MSAE2sObIUw0cuOg=;
	b=1f4cx1ahLlwUi3A3+9wF8BZAsRXTz4JbGHtcOr69H8c+622lVg/pJbtcHy09q3eXS6W3II
	W9NgZ/pPYXYG08Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F38E13515;
	Tue,  1 Sep 2026 11:15:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 35sEINWzlmokLgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 01 Sep 2026 11:15:33 +0000
Message-ID: <40767533-e1b7-4beb-a1c9-c721123134ca@suse.de>
Date: Tue, 1 Sep 2026 13:15:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix netdev hook sanity checks
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20260827204815.275949-1-phil@nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260827204815.275949-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DB9E22263B
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 8/27/26 10:48 PM, Phil Sutter wrote:
> Wildcard interface names were confused with non-wildcard ones or those
> matching the wildcard's prefix. Fix for odd behaviour when updating
> flowtable or netdev chain hook devices.
> 
> Unify behaviour between flowtable and netdev chain parsers by having
> both call the same parsing/validating code, also with old NFTA_HOOK_DEV
> attribute (which is still used for single hook updates by user space).
> 
> The validating code must distinguish between hooks being added or
> deleted (duplicates are ignored in the former case). Transport this info
> in a 'bool add' parameter, but rename the existing one with same name
> first since that actually reflects whether the code is parsing hooks for
> a new object or an existing one.
> 
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This is a follow-up to Fernando's "netfilter: nf_tables: fix device name
> and prefix match in hook lookup", sorting odd behaviour in similar,
> other cases, too. With his v4 and this patch in place, the new nftables
> shell tests pass for me.
> ---
>   net/netfilter/nf_tables_api.c | 102 +++++++++++++++++++++++-----------
>   1 file changed, 71 insertions(+), 31 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 500ef483e485..8fac88f07d74 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2450,10 +2450,44 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>   	return NULL;
>   }
>   
> +static struct nft_hook *
> +nf_tables_parse_netdev_hook(struct net *net,
> +			    const struct nlattr *tmp,
> +			    struct list_head *hook_list,
> +			    struct list_head *old_hook_list,
> +			    bool prefix, bool add)
> +{
> +	struct nft_hook *hook;
> +
> +	hook = nft_netdev_hook_alloc(net, tmp, prefix);
> +	if (IS_ERR(hook))
> +		return hook;
> +
> +	/* Reject new hooks which overlap */
> +	if (nft_hook_list_find(hook_list, hook, false)) {
> +		nft_netdev_hook_free(hook);
> +		return ERR_PTR(-EEXIST);
> +	}
> +	/* Skip this exact duplicate when adding */
> +	if (nft_hook_list_find(old_hook_list, hook, true)) {
> +		if (add) {
> +			nft_netdev_hook_free(hook);
> +			return NULL;
> +		}
> +	/* Reject partial overlaps in either case */
> +	} else if (nft_hook_list_find(old_hook_list, hook, false)) {
> +		nft_netdev_hook_free(hook);
> +		return ERR_PTR(add ? -EEXIST : -ENOENT);
> +	}
> +	return hook;
> +}
> +
>   static int nf_tables_parse_netdev_hooks(struct net *net,
>   					const struct nlattr *attr,
>   					struct list_head *hook_list,
> -					struct netlink_ext_ack *extack)
> +					struct list_head *old_hook_list,
> +					struct netlink_ext_ack *extack,
> +					bool add)
>   {
>   	struct nft_hook *hook, *next;
>   	const struct nlattr *tmp;
> @@ -2473,18 +2507,17 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
>   			goto err_hook;
>   		}
>   
> -		hook = nft_netdev_hook_alloc(net, tmp, prefix);
> +		hook = nf_tables_parse_netdev_hook(net, tmp, hook_list,
> +						   old_hook_list, prefix, add);
> +		if (!hook)
> +			continue;
> +
>   		if (IS_ERR(hook)) {
>   			NL_SET_BAD_ATTR(extack, tmp);
>   			err = PTR_ERR(hook);
>   			goto err_hook;
>   		}
> -		if (nft_hook_list_find(hook_list, hook, false)) {
> -			NL_SET_BAD_ATTR(extack, tmp);
> -			nft_netdev_hook_free(hook);
> -			err = -EEXIST;
> -			goto err_hook;
> -		}
> +
>   		list_add_tail(&hook->list, hook_list);
>   		n++;
>   
> @@ -2513,13 +2546,17 @@ struct nft_chain_hook {
>   
>   static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
>   				  struct list_head *hook_list,
> -				  struct netlink_ext_ack *extack, u32 flags)
> +				  struct list_head *old_hook_list,
> +				  struct netlink_ext_ack *extack, u32 flags,
> +				  bool add)
>   {
>   	struct nft_hook *hook;
>   	int err;
>   
>   	if (tb[NFTA_HOOK_DEV]) {
> -		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV], false);
> +		hook = nf_tables_parse_netdev_hook(net, tb[NFTA_HOOK_DEV],
> +						   hook_list, old_hook_list,
> +						   false, false);
>   		if (IS_ERR(hook)) {
>   			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
>   			return PTR_ERR(hook);
> @@ -2528,7 +2565,8 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
>   		list_add_tail(&hook->list, hook_list);
>   	} else if (tb[NFTA_HOOK_DEVS]) {
>   		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
> -						   hook_list, extack);
> +						   hook_list, old_hook_list,
> +						   extack, add);
>   		if (err < 0)
>   			return err;
>   
> @@ -2544,8 +2582,10 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
>   static int nft_chain_parse_hook(struct net *net,
>   				struct nft_base_chain *basechain,
>   				const struct nlattr * const nla[],
> -				struct nft_chain_hook *hook, u8 family,
> -				u32 flags, struct netlink_ext_ack *extack)
> +				struct nft_chain_hook *hook,
> +				struct list_head *old_hook_list, u8 family,
> +				u32 flags, struct netlink_ext_ack *extack,
> +				bool add)
>   {
>   	struct nftables_pernet *nft_net = nft_pernet(net);
>   	struct nlattr *ha[NFTA_HOOK_MAX + 1];
> @@ -2623,7 +2663,8 @@ static int nft_chain_parse_hook(struct net *net,
>   
>   	INIT_LIST_HEAD(&hook->list);
>   	if (nft_base_chain_netdev(family, hook->num)) {
> -		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
> +		err = nft_chain_parse_netdev(net, ha, &hook->list,
> +					     old_hook_list, extack, flags, add);
>   		if (err < 0) {
>   			module_put(type->owner);
>   			return err;
> @@ -2756,6 +2797,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
>   	if (nla[NFTA_CHAIN_HOOK]) {
>   		struct nft_stats __percpu *stats = NULL;
>   		struct nft_chain_hook hook = {};
> +		LIST_HEAD(empty);
>   
>   		if (table->flags & __NFT_TABLE_F_UPDATE)
>   			return -EINVAL;
> @@ -2763,8 +2805,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
>   		if (flags & NFT_CHAIN_BINDING)
>   			return -EOPNOTSUPP;
>   
> -		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, flags,
> -					   extack);
> +		err = nft_chain_parse_hook(net, NULL, nla, &hook, &empty,
> +					   family, flags, extack, true);
>   		if (err < 0)
>   			return err;
>   
> @@ -2916,7 +2958,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>   
>   		basechain = nft_base_chain(chain);
>   		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
> -					   ctx->family, flags, extack);
> +					   &basechain->hook_list,
> +					   ctx->family, flags, extack, true);
>   		if (err < 0)
>   			return err;
>   
> @@ -2936,7 +2979,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>   					ops->hook	= basechain->ops.hook;
>   				}
>   
> -				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
> +				if (nft_hook_list_find(&basechain->hook_list, h, true)) {
>   					list_del(&h->list);
>   					nft_netdev_hook_free(h);
>   					continue;
> @@ -3246,7 +3289,8 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>   		return -EOPNOTSUPP;
>   
>   	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
> -				   ctx->family, chain->flags, extack);
> +				   &basechain->hook_list, ctx->family,
> +				   chain->flags, extack, false);
>   	if (err < 0)
>   		return err;
>   
> @@ -8866,7 +8910,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
>   				    const struct nlattr * const nla[],
>   				    struct nft_flowtable_hook *flowtable_hook,
>   				    struct nft_flowtable *flowtable,
> -				    struct netlink_ext_ack *extack, bool add)
> +				    struct netlink_ext_ack *extack,
> +				    bool new, bool add)
>   {
>   	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
>   	struct nf_hook_ops *ops;
> @@ -8882,7 +8927,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
>   	if (err < 0)
>   		return err;
>   
> -	if (add) {
> +	if (new) {
>   		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
>   		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
>   			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
> @@ -8918,7 +8963,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
>   		err = nf_tables_parse_netdev_hooks(ctx->net,
>   						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
>   						   &flowtable_hook->list,
> -						   extack);
> +						   &flowtable->hook_list,
> +						   extack, add);
>   		if (err < 0)
>   			return err;
>   	}
> @@ -9112,17 +9158,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
>   	int err;
>   
>   	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
> -				       extack, false);
> +				       extack, false, true);
>   	if (err < 0)
>   		return err;
>   
>   	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
> -		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
> -			list_del(&hook->list);
> -			nft_netdev_hook_free(hook);
> -			continue;
> -		}
> -

Hi Phil,

Hm.. we should be able to also get rid of this check in 
nf_tables_updchain() no? Or am I missing something? AFAICS, this is 
already validated in the parse function with your patch.

                                 if 
(nft_hook_list_find(&basechain->hook_list, h, true)) {
                                         list_del(&h->list);
                                         nft_netdev_hook_free(h);
                                         continue;
                                 }


Other than that, the patch looks good to me.

Thanks!
Fernando
