Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520B2469848
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 10:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345722; cv=none; b=t6s9MJQUMlWym7At9gUCxEqqSR2olZ8aJ8VBSRUUYazzbsGXztE6CntFhWLjboiqmL/IO1aTF6949/ZDmcOq8ZIR059yemp0oL7IexDxLAVdcwb83TnaDcbt+6z11zAvNer+5mE6N/YEsCRQeOcSCtDe2nIOLGhydZCOauZCEdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345722; c=relaxed/simple;
	bh=Ll7zDsoVWdM/3iPBBOfp1B425GtkFjp1mKvE0Vi5pdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8vs/+LzqaprILMh9DqYGI9ULjcFXIlzGO0Y0tfg/LoIbZ3hHVzLjhZlODDgOnNLHa4fvfXNptiedhf/xyRmBgRgpvhQHnWmwERHfmB/SXLsVOGUU8Z9SZjHKIEqpbqXOmMBye8Uo3Lya/BTxc1LCYeqzvWaG6CjpYFGEVRD/Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MxSnB7/y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MxSnB7/y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BSb/0IKyGGtL3E/chuk4wMEU+xuuxFw1zVhuCeCRPPQ=; b=MxSnB7/y+7SzbHyhZA87av1ka+
	bnXMHnFtGSwOjFUnQgW+u8YmKEf+ycqgnKyl10G9wc6/LXdYhyer5z7rbqy+WolP5RdtgRPbg19Na
	2BdZLfGbKAJlGwhp0S/IW1tBZXgsmvBdoRBXEibf/AZfaX70AlGasE4N8GcvlQVof2YbUNPslrrPS
	EvsebjwlCJ4aVB2PrRR2fK8/xc2HCGpJkW4XYoofJUcvWU7xSiAy2I/U8ziIN3i8dV1RMeo4o/CzU
	oDluG13BSk4nHEp/nwrUeWMZUtakkqrEQgBiGNuM3OaFjiLk9CZ0A8kSDAFaLv8vJJf7ryHzUzp7Q
	HY9EOaXg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x1iPc-000000004S9-3eei;
	Wed, 02 Sep 2026 12:41:48 +0200
Date: Wed, 2 Sep 2026 12:41:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix netdev hook sanity checks
Message-ID: <apf9bOiDOkMiyEej@orbyte.nwl.cc>
References: <20260827204815.275949-1-phil@nwl.cc>
 <40767533-e1b7-4beb-a1c9-c721123134ca@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40767533-e1b7-4beb-a1c9-c721123134ca@suse.de>

Hi Fernando,

On Tue, Sep 01, 2026 at 01:15:05PM +0200, Fernando Fernandez Mancera wrote:
> On 8/27/26 10:48 PM, Phil Sutter wrote:
> > Wildcard interface names were confused with non-wildcard ones or those
> > matching the wildcard's prefix. Fix for odd behaviour when updating
> > flowtable or netdev chain hook devices.
> > 
> > Unify behaviour between flowtable and netdev chain parsers by having
> > both call the same parsing/validating code, also with old NFTA_HOOK_DEV
> > attribute (which is still used for single hook updates by user space).
> > 
> > The validating code must distinguish between hooks being added or
> > deleted (duplicates are ignored in the former case). Transport this info
> > in a 'bool add' parameter, but rename the existing one with same name
> > first since that actually reflects whether the code is parsing hooks for
> > a new object or an existing one.
> > 
> > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > This is a follow-up to Fernando's "netfilter: nf_tables: fix device name
> > and prefix match in hook lookup", sorting odd behaviour in similar,
> > other cases, too. With his v4 and this patch in place, the new nftables
> > shell tests pass for me.
> > ---
> >   net/netfilter/nf_tables_api.c | 102 +++++++++++++++++++++++-----------
> >   1 file changed, 71 insertions(+), 31 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 500ef483e485..8fac88f07d74 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -2450,10 +2450,44 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
> >   	return NULL;
> >   }
> >   
> > +static struct nft_hook *
> > +nf_tables_parse_netdev_hook(struct net *net,
> > +			    const struct nlattr *tmp,
> > +			    struct list_head *hook_list,
> > +			    struct list_head *old_hook_list,
> > +			    bool prefix, bool add)
> > +{
> > +	struct nft_hook *hook;
> > +
> > +	hook = nft_netdev_hook_alloc(net, tmp, prefix);
> > +	if (IS_ERR(hook))
> > +		return hook;
> > +
> > +	/* Reject new hooks which overlap */
> > +	if (nft_hook_list_find(hook_list, hook, false)) {
> > +		nft_netdev_hook_free(hook);
> > +		return ERR_PTR(-EEXIST);
> > +	}
> > +	/* Skip this exact duplicate when adding */
> > +	if (nft_hook_list_find(old_hook_list, hook, true)) {
> > +		if (add) {
> > +			nft_netdev_hook_free(hook);
> > +			return NULL;
> > +		}
> > +	/* Reject partial overlaps in either case */
> > +	} else if (nft_hook_list_find(old_hook_list, hook, false)) {
> > +		nft_netdev_hook_free(hook);
> > +		return ERR_PTR(add ? -EEXIST : -ENOENT);
> > +	}
> > +	return hook;
> > +}
> > +
> >   static int nf_tables_parse_netdev_hooks(struct net *net,
> >   					const struct nlattr *attr,
> >   					struct list_head *hook_list,
> > -					struct netlink_ext_ack *extack)
> > +					struct list_head *old_hook_list,
> > +					struct netlink_ext_ack *extack,
> > +					bool add)
> >   {
> >   	struct nft_hook *hook, *next;
> >   	const struct nlattr *tmp;
> > @@ -2473,18 +2507,17 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
> >   			goto err_hook;
> >   		}
> >   
> > -		hook = nft_netdev_hook_alloc(net, tmp, prefix);
> > +		hook = nf_tables_parse_netdev_hook(net, tmp, hook_list,
> > +						   old_hook_list, prefix, add);
> > +		if (!hook)
> > +			continue;
> > +
> >   		if (IS_ERR(hook)) {
> >   			NL_SET_BAD_ATTR(extack, tmp);
> >   			err = PTR_ERR(hook);
> >   			goto err_hook;
> >   		}
> > -		if (nft_hook_list_find(hook_list, hook, false)) {
> > -			NL_SET_BAD_ATTR(extack, tmp);
> > -			nft_netdev_hook_free(hook);
> > -			err = -EEXIST;
> > -			goto err_hook;
> > -		}
> > +
> >   		list_add_tail(&hook->list, hook_list);
> >   		n++;
> >   
> > @@ -2513,13 +2546,17 @@ struct nft_chain_hook {
> >   
> >   static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
> >   				  struct list_head *hook_list,
> > -				  struct netlink_ext_ack *extack, u32 flags)
> > +				  struct list_head *old_hook_list,
> > +				  struct netlink_ext_ack *extack, u32 flags,
> > +				  bool add)
> >   {
> >   	struct nft_hook *hook;
> >   	int err;
> >   
> >   	if (tb[NFTA_HOOK_DEV]) {
> > -		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV], false);
> > +		hook = nf_tables_parse_netdev_hook(net, tb[NFTA_HOOK_DEV],
> > +						   hook_list, old_hook_list,
> > +						   false, false);
> >   		if (IS_ERR(hook)) {
> >   			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
> >   			return PTR_ERR(hook);
> > @@ -2528,7 +2565,8 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
> >   		list_add_tail(&hook->list, hook_list);
> >   	} else if (tb[NFTA_HOOK_DEVS]) {
> >   		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
> > -						   hook_list, extack);
> > +						   hook_list, old_hook_list,
> > +						   extack, add);
> >   		if (err < 0)
> >   			return err;
> >   
> > @@ -2544,8 +2582,10 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
> >   static int nft_chain_parse_hook(struct net *net,
> >   				struct nft_base_chain *basechain,
> >   				const struct nlattr * const nla[],
> > -				struct nft_chain_hook *hook, u8 family,
> > -				u32 flags, struct netlink_ext_ack *extack)
> > +				struct nft_chain_hook *hook,
> > +				struct list_head *old_hook_list, u8 family,
> > +				u32 flags, struct netlink_ext_ack *extack,
> > +				bool add)
> >   {
> >   	struct nftables_pernet *nft_net = nft_pernet(net);
> >   	struct nlattr *ha[NFTA_HOOK_MAX + 1];
> > @@ -2623,7 +2663,8 @@ static int nft_chain_parse_hook(struct net *net,
> >   
> >   	INIT_LIST_HEAD(&hook->list);
> >   	if (nft_base_chain_netdev(family, hook->num)) {
> > -		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
> > +		err = nft_chain_parse_netdev(net, ha, &hook->list,
> > +					     old_hook_list, extack, flags, add);
> >   		if (err < 0) {
> >   			module_put(type->owner);
> >   			return err;
> > @@ -2756,6 +2797,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
> >   	if (nla[NFTA_CHAIN_HOOK]) {
> >   		struct nft_stats __percpu *stats = NULL;
> >   		struct nft_chain_hook hook = {};
> > +		LIST_HEAD(empty);
> >   
> >   		if (table->flags & __NFT_TABLE_F_UPDATE)
> >   			return -EINVAL;
> > @@ -2763,8 +2805,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
> >   		if (flags & NFT_CHAIN_BINDING)
> >   			return -EOPNOTSUPP;
> >   
> > -		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, flags,
> > -					   extack);
> > +		err = nft_chain_parse_hook(net, NULL, nla, &hook, &empty,
> > +					   family, flags, extack, true);
> >   		if (err < 0)
> >   			return err;
> >   
> > @@ -2916,7 +2958,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
> >   
> >   		basechain = nft_base_chain(chain);
> >   		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
> > -					   ctx->family, flags, extack);
> > +					   &basechain->hook_list,
> > +					   ctx->family, flags, extack, true);
> >   		if (err < 0)
> >   			return err;
> >   
> > @@ -2936,7 +2979,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
> >   					ops->hook	= basechain->ops.hook;
> >   				}
> >   
> > -				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
> > +				if (nft_hook_list_find(&basechain->hook_list, h, true)) {
> >   					list_del(&h->list);
> >   					nft_netdev_hook_free(h);
> >   					continue;
> > @@ -3246,7 +3289,8 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
> >   		return -EOPNOTSUPP;
> >   
> >   	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
> > -				   ctx->family, chain->flags, extack);
> > +				   &basechain->hook_list, ctx->family,
> > +				   chain->flags, extack, false);
> >   	if (err < 0)
> >   		return err;
> >   
> > @@ -8866,7 +8910,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
> >   				    const struct nlattr * const nla[],
> >   				    struct nft_flowtable_hook *flowtable_hook,
> >   				    struct nft_flowtable *flowtable,
> > -				    struct netlink_ext_ack *extack, bool add)
> > +				    struct netlink_ext_ack *extack,
> > +				    bool new, bool add)
> >   {
> >   	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
> >   	struct nf_hook_ops *ops;
> > @@ -8882,7 +8927,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
> >   	if (err < 0)
> >   		return err;
> >   
> > -	if (add) {
> > +	if (new) {
> >   		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
> >   		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
> >   			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
> > @@ -8918,7 +8963,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
> >   		err = nf_tables_parse_netdev_hooks(ctx->net,
> >   						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
> >   						   &flowtable_hook->list,
> > -						   extack);
> > +						   &flowtable->hook_list,
> > +						   extack, add);
> >   		if (err < 0)
> >   			return err;
> >   	}
> > @@ -9112,17 +9158,11 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
> >   	int err;
> >   
> >   	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
> > -				       extack, false);
> > +				       extack, false, true);
> >   	if (err < 0)
> >   		return err;
> >   
> >   	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
> > -		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
> > -			list_del(&hook->list);
> > -			nft_netdev_hook_free(hook);
> > -			continue;
> > -		}
> > -
> 
> Hi Phil,
> 
> Hm.. we should be able to also get rid of this check in 
> nf_tables_updchain() no? Or am I missing something? AFAICS, this is 
> already validated in the parse function with your patch.
> 
>                                  if 
> (nft_hook_list_find(&basechain->hook_list, h, true)) {
>                                          list_del(&h->list);
>                                          nft_netdev_hook_free(h);
>                                          continue;
>                                  }

Good point! It is complicated, though:

With netdev chains, we get either NFTA_HOOK_DEV or _DEVS attribute. I
didn't want to mess with the code in nft_chain_parse_netdev too much, so
I decided to always set 'add' parameter to false when calling
nf_tables_parse_netdev_hook for _DEV attribute.

Looking at it again, it seems possible to pass the real 'add' value and
call list_add_tail conditionally in there. AIUI, IS_ERR(NULL) should
evaluate to false, so that part does not need to be touched.

I'll try that and see what LLM and test suites say about it. :)

> Other than that, the patch looks good to me.

Thanks, Phil
