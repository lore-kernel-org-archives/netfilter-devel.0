Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20D45FFCB
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787761346; cv=none; b=aELxO44Ht9saD2HPPRINhB4OTKltMDtxJQgmQ940h0wKeCT98O0AGbuiP/6TMFEfQnDAcY2sZlh+/V/bmhv6Zi7D0RyaMsKFvTgyAq6ZXkmUJxzyVB3nQ6pzISDHqIPAUHdn9YBgnrtsPE+i+YvFdIQ3nXVW08Ocz/NH4wKJtZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787761346; c=relaxed/simple;
	bh=DK53Rf7qA8J7FLgjujYN13p4sSL6tDFgLhJYk2fWYdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+tfW6/hq/1bH+1QeNg6yDdKJlwEWSoWDaL99P9miafdOeKTdu3fPGNAMTDwGrwc5iHKFXjWhCtrEkgQAfIMd4Kdo49G+tIG9Q96WTSdW5+9QP62/bfsiuVY1fqJYwtErrb7VsSP7kAN89dx7Bm6D+kbEMry5kUQOEbU0Jw1Nk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MM8Y3H18; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MM8Y3H18"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y2dpLuaVvwRlXv7ui8/qGhZtu7BUqMj6TSVcLrnULmc=; b=MM8Y3H182vcYy8kwBvbCma8F1W
	YZUcQyQa3uzHoBzj0Zzv+Brwm7Mf27lTQEfV3s8PeiVJ2T+88Dkj4/y3WRWKuHN6OMoTNYfleFXJi
	xV4ng03h1BOuQrRPyXvkaLp/h00uwOBrh8RWclKqg2ijQv0o3ivKUlnt+TIbQao1cBdI7VcgH+rN2
	sCvqRgfTLDfZIxQ45qTvqcV7GiGYNgn3udZBXnt8wa9y0jo1OaxR7MC6F/LkgUNBOR6LcnSjn4+z1
	S1tPc2VuuejZ1Ho0Kw3G8Z8NzmdN0SgiBavTgA488ha0hSg3TEZL6Lh/qWSdtz6W7xonZ5GPkCAm8
	tXOTZixw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzGOI-000000001ig-0Ypq;
	Wed, 26 Aug 2026 18:22:18 +0200
Date: Wed, 26 Aug 2026 18:22:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v3] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <ao8SujdfOcqEJLUD@orbyte.nwl.cc>
References: <20260826133208.4550-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826133208.4550-1-fmancera@suse.de>

On Wed, Aug 26, 2026 at 03:32:08PM +0200, Fernando Fernandez Mancera wrote:
> Currently, a netdev chain or flowtable hooked to a device prefix can be
> unintentionally deleted by a control-plane request targeting an exact
> device name or even a shorter one due to the usage of min() to calculate
> the length to match.
> 
> Fix this by making sure an exact device match never matches a prefix and
> that both the target and the candidate have the same length during
> delete operation. The add and update paths retain the existing overlap
> matching to prevent a single device from matching multiple hooks.
> 
> Reported-by: Wei Fang <void0red@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c112ecc4fca3..9ef12feec1ac 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>  	return -ENOSPC;
>  }
>  
> -static bool hook_is_prefix(struct nft_hook *hook)
> +static bool hook_is_prefix(const struct nft_hook *hook)

This is an unrelated change now.

>  {
>  	return strlen(hook->ifname) >= hook->ifnamelen;
>  }
> @@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>  }
>  
>  static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
> -					   const struct nft_hook *this)
> +					   const struct nft_hook *this,
> +					   bool strict)
>  {
>  	struct nft_hook *hook;
>  
>  	list_for_each_entry(hook, hook_list, list) {
> +		if (strict && hook->ifnamelen != this->ifnamelen)
> +			continue;
>  		if (!strncmp(hook->ifname, this->ifname,
>  			     min(hook->ifnamelen, this->ifnamelen))) {
>  			if (hook->flags & NFT_HOOK_REMOVE)
> @@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
>  			err = PTR_ERR(hook);
>  			goto err_hook;
>  		}
> -		if (nft_hook_list_find(hook_list, hook)) {
> +		if (nft_hook_list_find(hook_list, hook, false)) {
>  			NL_SET_BAD_ATTR(extack, tmp);
>  			nft_netdev_hook_free(hook);
>  			err = -EEXIST;
> @@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  					ops->hook	= basechain->ops.hook;
>  				}
>  
> -				if (nft_hook_list_find(&basechain->hook_list, h)) {
> +				if (nft_hook_list_find(&basechain->hook_list, h, false)) {

I think this should be a strict match. It fixes a problem you didn't
intend to fix (I feel like an LLM-reviewer now), when updating a chain
with a partially matching wildcard:

| add table netdev t
| add chain netdev t c '{ type filter hook ingress priority 0; devices = { eth* }; }'
| add chain netdev t c '{ type filter hook ingress priority 0; devices = { et* }; }'

The last command should return EEXIST instead of being accepted and
treated as a NOP.

>  					list_del(&h->list);
>  					nft_netdev_hook_free(h);
>  					continue;
> @@ -2956,7 +2959,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  					    !nft_trans_chain_update(trans))
>  						continue;
>  
> -					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
> +					if (nft_hook_list_find(&nft_trans_chain_hooks(trans),
> +							       h, false)) {
>  						nft_chain_release_hook(&hook);
>  						return -EEXIST;
>  					}
> @@ -3257,7 +3261,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>  		return err;
>  
>  	list_for_each_entry(this, &chain_hook.list, list) {
> -		hook = nft_hook_list_find(&basechain->hook_list, this);
> +		hook = nft_hook_list_find(&basechain->hook_list, this, true);
>  		if (!hook) {
>  			err = -ENOENT;
>  			goto err_chain_del_hook;
> @@ -9073,7 +9077,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>  			if (!nft_is_active_next(net, ft))
>  				continue;
>  
> -			if (nft_hook_list_find(&ft->hook_list, hook)) {
> +			if (nft_hook_list_find(&ft->hook_list, hook, false)) {
>  				err = -EEXIST;
>  				goto err_unregister_net_hooks;
>  			}
> @@ -9150,7 +9154,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
>  		return err;
>  
>  	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
> -		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
> +		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {

Same here.

I'll write test cases for nftables shell test suite to cover these.

Thanks, Phil

>  			list_del(&hook->list);
>  			nft_netdev_hook_free(hook);
>  			continue;
> @@ -9163,7 +9167,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
>  			    !nft_trans_flowtable_update(trans))
>  				continue;
>  
> -			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
> +			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook, false)) {
>  				err = -EEXIST;
>  				goto err_flowtable_update_hook;
>  			}
> @@ -9383,7 +9387,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
>  		return err;
>  
>  	list_for_each_entry(this, &flowtable_hook.list, list) {
> -		hook = nft_hook_list_find(&flowtable->hook_list, this);
> +		hook = nft_hook_list_find(&flowtable->hook_list, this, true);
>  		if (!hook) {
>  			err = -ENOENT;
>  			goto err_flowtable_del_hook;
> -- 
> 2.55.0
> 
> 
