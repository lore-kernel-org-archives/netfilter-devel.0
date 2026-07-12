Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6A73563DD
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783884131; cv=none; b=G0NUJTNmMYAjxeMCohH/P1+gR80xeg71Ol3HLT7UQTDCwv5/hgdNu+RVWEyeKnqhriclwnN1NhEwX7llfUe0EzCuDs8yQ/0UgSW75seo/to2UBxSyRYGK+kLT1AFy4sAc+FqoAgg0SNLvl1TwDNpVPSgDSEKk30xndmGD+8eMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783884131; c=relaxed/simple;
	bh=oAqbfqBMyI7YO4j5acZy/FJMWV34s2nXEU1+bparNxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tI7d1sP4WonIG8jz9dJPtt1qikka2iSuiMz+vdbt5pVlTBSNaVh3jmJbg2uYBYhw6uDjIBLfPlhJFemYNyH4rWCGmKzL9gjGR8jW9jDVfoz1XpZVQUgGTOmyKFzSs8QVfHvxbpz0+V3VI21X4fJrjJSxdWjQOueQODBRhldC8oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KCDSiW5G; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KCDSiW5G"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id F069D60579;
	Sun, 12 Jul 2026 21:22:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783884127;
	bh=8kM9TuZFECOEzxoBsHsxivg/54RPmSWV6+cr2HH7A+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KCDSiW5GBT8VsCAtLpC/BuBL84jWAWHNMZQ3iG4i+wkfjJtpT3ogPVJIs8iUL0OfY
	 GoPv5nEp9tbj/EKALvob0ZMtst543tJgML/Dbs5B1EGSPxR8h5NyE0JMGgIID5QkFS
	 329rCDFqOHiu9uq54zpNhQUXMyIA/ITCmmFkLQK/bINRkTqqxTiIc3gjBmKDScCur9
	 GdHdzJXHKiVVAhjMMYGO5jXgPkVAPIpHRMEjIJLP0viImeT3meZPA6lXrBPkaOheCc
	 JTVmwX47nAEkElk2uLk3eyql5X3hwCpS3Dg1BE6UejaUuyXhCrpGxV8xzP+Q9DTkaD
	 0dF1Kubesx+ow==
Date: Sun, 12 Jul 2026 21:22:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org, razor@blackwall.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 1/3] net: pass net_device_path_ctx struct to
 dev_fill_forward_path()
Message-ID: <alPpXDQq0rOqbDUG@chamomile>
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-2-pablo@netfilter.org>
 <5f4d5f1e-edab-4b9c-9c86-b9554492e0dd@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f4d5f1e-edab-4b9c-9c86-b9554492e0dd@gmail.com>

On Sun, Jul 12, 2026 at 11:28:11AM +0200, Eric Woudstra wrote:
> On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
> > Generalize dev_fill_forward_path() so it can be used by the bridge
> > family to retrieve the bridge vlan filtering information from the
> > bridge port when discovering the bridge flowtable path.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: - move nft_dev_fill_forward_path_init() call after out: goto tag
> >       to fix a crash otherwise in the existing flowtable ip family.
> > 
> >  include/linux/netdevice.h          |  2 +-
> >  net/core/dev.c                     | 18 +++++++-----------
> >  net/netfilter/nf_flow_table_path.c | 14 ++++++++++++--
> >  3 files changed, 20 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 9981d637f8b5..db04b6d2e8d2 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3420,7 +3420,7 @@ void dev_remove_offload(struct packet_offload *po);
> >  
> >  int dev_get_iflink(const struct net_device *dev);
> >  int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
> > -int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> > +int dev_fill_forward_path(struct net_device_path_ctx *ctx,
> >  			  struct net_device_path_stack *stack);
> >  struct net_device *dev_get_by_name(struct net *net, const char *name);
> >  struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 714d05283500..24c384ef9e78 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -750,41 +750,37 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
> >  	return &stack->path[k];
> >  }
> >  
> > -int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> > +int dev_fill_forward_path(struct net_device_path_ctx *ctx,
> >  			  struct net_device_path_stack *stack)
> >  {
> >  	const struct net_device *last_dev;
> > -	struct net_device_path_ctx ctx = {
> > -		.dev	= dev,
> > -	};
> >  	struct net_device_path *path;
> >  	int ret = 0;
> >  
> > -	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
> >  	stack->num_paths = 0;
> > -	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
> > -		last_dev = ctx.dev;
> > +	while (ctx->dev && ctx->dev->netdev_ops->ndo_fill_forward_path) {
> > +		last_dev = ctx->dev;
> >  		path = dev_fwd_path(stack);
> >  		if (!path)
> >  			return -1;
> >  
> >  		memset(path, 0, sizeof(struct net_device_path));
> > -		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
> > +		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
> >  		if (ret < 0)
> >  			return -1;
> >  
> > -		if (WARN_ON_ONCE(last_dev == ctx.dev))
> > +		if (WARN_ON_ONCE(last_dev == ctx->dev))
> >  			return -1;
> >  	}
> >  
> > -	if (!ctx.dev)
> > +	if (!ctx->dev)
> >  		return ret;
> >  
> >  	path = dev_fwd_path(stack);
> >  	if (!path)
> >  		return -1;
> >  	path->type = DEV_PATH_ETHERNET;
> > -	path->dev = ctx.dev;
> > +	path->dev = ctx->dev;
> >  
> >  	return ret;
> >  }
> 
> Calling dev_fill_forward_path() from nft_dev_fill_bridge_path()
> it does not traverse the bridge. It exits at the source "indev"
> already. After calling nft_dev_path_info(), the info structure
> is filled in with the opposite device and the encaps of the
> opposite device.

Traversing the bridge is only needed for bridge vlan filtering and
that is not included in this initial support.

> Would need to add something like this:
> 
> int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
> 			 struct net_device_path_stack *stack)
> {
> 	const struct net_device *last_dev, *br_dev;
> 	struct net_device_path *path;
> 
> 	if (!ctx->dev || !netif_is_bridge_port(ctx->dev))
> 		return -1;
> 
> 	br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
> 	if (!br_dev || !br_dev->netdev_ops->ndo_fill_forward_path)
> 		return -1;
> 
> 	last_dev = ctx->dev;
> 	path = dev_fwd_path(stack);
> 	if (!path)
> 		return -1;
> 
> 	memset(path, 0, sizeof(struct net_device_path));
> 	if (br_dev->netdev_ops->ndo_fill_forward_path(ctx, path) < 0)
> 		return -1;
> 
> 	if (!ctx->dev || WARN_ON_ONCE(last_dev == ctx->dev))
> 		return -1;
> 
> 	return dev_fill_forward_path(ctx, stack);
> }
> EXPORT_SYMBOL_GPL(dev_fill_bridge_path);
> 
> First need to find the bridge device to call ndo_fill_forward_path()
> from it.
> 
> This also needs the patch "bridge: Add filling forward path from port to
> port"
> That patch still needs a change according to Nikolay.

Once bridge vlan filtering is added, but that need nf_conntrack_bridge
support for VLAN/PPPoE as I said.
