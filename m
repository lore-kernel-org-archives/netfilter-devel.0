Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E313101A6;
	Wed, 12 Aug 2026 20:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786566883; cv=none; b=vBj3fJ/YiPWdYvUGW0r85YlDjnFJLiKeK90B+BvbabK1OtsbEZNPRXziNYkUEA6hRNlG8DnnjYZE61oCZtbyiGIcIKR5PdT+EIxJWU0AaV6hu0uB7ZlPRnuo9Z5vfsIWxZUyhF50VGPq1uxRw2EKyQKRXycjZXS8UedqPrxd/LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786566883; c=relaxed/simple;
	bh=ybYSZ3lsCEKbMckLOeHW/7XBHlTknWGJMP9BHEUVklI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ielksFzUC8jVO4Z8M3kpNqwOXkeLDuWxJvZv/CnJG53RE2F3EdcjhxuR1pZj9QfKwfJeT6z8rS0P0OPukRziIpocC0Q7q0jiOBceeVeMEWqePKTJF3dmTxrInFHnv74XA32KddqI03UuqOOTsf22XPYIc3F3NypI3tQv1YI5AOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PANkdZP4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PANkdZP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786566869;
	bh=Ez0F/16kNv/GmLYc9iKPtKgua+9IcU41y9NzxtXy/xU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PANkdZP4KeWudLz4ZrOBRwkTG9R4JX2UyUM017FAgKFpZ/9sDG7MIeNp8C+dHcZA4
	 3C5FHlbuyzymn0ntBADzW4v/rnSB4/DZrti2eXxY3YwCz/G5JhAazulSbKKjW4bz/J
	 d6BbztawHmaFalxNuuEEhBaa3+yyzTFtlNea4bFbMTfg7WTc20bkJQhG9aFtq7+ozb
	 QbC233YSCp7Q2X6R6vZZ7bvfyNvzOBMS8ouKJ3ln2DYlvCxTnCLq3wg9++BXT3WMhw
	 53dq1sh9NW5dQSVQ4cK86fZstSqCwqwxOdJEB2wd8rtr8+rx5ACBOj71Zza93QInYE
	 N80diLqZ72tqg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E885160058;
	Wed, 12 Aug 2026 22:34:28 +0200 (CEST)
Date: Wed, 12 Aug 2026 22:34:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 03/12] net: netfilter: add ether_type to
 net_device_path_ctx and use it
Message-ID: <anzY0oTiZdWkt0eF@chamomile>
References: <20260810194015.932627-4-pablo@netfilter.org>
 <20260812013443.1673999-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812013443.1673999-1-kuba@kernel.org>

Hi Jakub,

On Tue, Aug 11, 2026 at 06:34:43PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net: netfilter: add ether_type to net_device_path_ctx and use it
> 
> This adds an ether_type field to struct net_device_path_ctx and makes the
> ipip and ip6tnl ndo_fill_forward_path callbacks reject a context whose
> ether_type does not match their own address family.  The netfilter
> flowtable path builder fills the new field from pkt->ethertype.
> 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 17d28adb029bb..2327a2703b835 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -941,6 +941,7 @@ struct net_device_path_stack {
> >  struct net_device_path_ctx {
> >  	const struct net_device *dev;
> >  	u8			daddr[ETH_ALEN];
> > +	__be16			ether_type;
> >  
> >  	int			num_vlans;
> >  	struct {
> 
> [Severity: Medium]
> This new field becomes a mandatory input for the tunnel
> ndo_fill_forward_path callbacks, but only the netfilter context builder is
> updated here.  The two other in-tree constructors of the context still use
> designated initializers that set only .dev, so ether_type stays zero:
> 
> drivers/net/ethernet/mediatek/mtk_ppe_offload.c:mtk_flow_get_wdma_info() {
> 	struct net_device_path_ctx ctx = {
> 		.dev = dev,
> 	};
> 	...
> }
> 
> drivers/net/ethernet/airoha/airoha_ppe.c:airoha_ppe_get_wdma_info() {
> 	struct net_device_path_ctx ctx = {
> 		.dev = dev,
> 	};
> 	...
> }
> 
> Zero matches neither ETH_P_IP nor ETH_P_IPV6, and dev_fill_forward_path()
> turns any negative return from the callback into a full abort:
> 
> net/core/dev.c:dev_fill_forward_path() {
> 	...
> 		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
> 		if (ret < 0)
> 			goto err_out;
> 	...
> }
> 
> So does an ipip or ip6tnl device anywhere in the walk now always fail path
> resolution for those two drivers, even for the same-family case that used
> to work, leaving the PPE/WED entry unprogrammed?  Both drivers know the
> flow's L3 protocol at that point, so could they populate ether_type as
> well?
> 
> Would it also help to document in the struct that 0 means "unknown" and is
> treated as unsupported by the tunnel callbacks?

This is fine, Lorenzo Bianconi will follow up with ip6ip and ipip6
support for this soon.

> > diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> > index fb7d96f99b06b..62a374079bfcb 100644
> > --- a/net/ipv4/ipip.c
> > +++ b/net/ipv4/ipip.c
> > @@ -360,6 +360,9 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
> >  	const struct iphdr *tiph = &tunnel->parms.iph;
> >  	struct rtable *rt;
> >  
> > +	if (ctx->ether_type != cpu_to_be16(ETH_P_IP))
> > +		return -EOPNOTSUPP;
> > +
> >  	if (tunnel->collect_md)
> >  		return -EOPNOTSUPP;
> >  
> 
> [Severity: Low]
> The commit message describes a datapath defect ("incorrect dst_entry family
> can be reached from datapath"), but there is no Fixes: tag.  Without this
> gate, an IPv6 flow routed out of an ipip device makes
> ipip_fill_forward_path() succeed and return an IPv4 rtable in
> path->tun.dst, after which nft_dev_path_info() reads the v6 members of the
> address union and nft_dev_forward_path() installs that dst:
> 
> net/netfilter/nf_flow_table_path.c:nft_dev_forward_path() {
> 	...
> 		dst_release(route->tuple[dir].dst);
> 		route->tuple[dir].dst = info.tun_dst;
> 	...
> }
> 
> The two handlers were added by ab427db17885 ("netfilter: flowtable: Add
> IPIP rx sw acceleration") and d98103575dcd, and the tunnel dst hand-off was
> last touched by 806273fcaffb82 ("netfilter: flowtable: release tunnel route
> on error when building forward path").  Could a Fixes: tag against one of
> these be added so a backport can be keyed off it?

I can request this patch to go to -stable, not a big deal.

> It would also be worth noting in the message that this is not
> standalone-backportable: it depends on the preceding commit 635bf8763d7e
> ("net: pass net_device_path_ctx to dev_fill_forward_path()"), since before
> that the context was built inside net/core/dev.c and the netfilter caller
> had no way to pass an ethertype.
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but the new gate only validates
> the packet's L3 protocol and still leaves the tunnel device's configured
> payload protocol unchecked.  An ipip link can be configured with
> iph.protocol == IPPROTO_MPLS (mplsip), and such a device shares
> ipip_netdev_ops and therefore this callback, yet the callback never consults
> tunnel->parms.iph.protocol and unconditionally sets
> path->tun.inner_proto = IPPROTO_IPIP.
> 
> The device's own paths do enforce it:
> 
> net/ipv4/ipip.c:ipip_tunnel_xmit() {
> 	...
> 	if (tiph->protocol != ipproto && tiph->protocol != 0)
> 		goto tx_error;
> 	...
> }
> 
> net/ipv4/ipip.c:ipip_rcv() {
> 	...
> 		if (tunnel->parms.iph.protocol != ipproto &&
> 		    tunnel->parms.iph.protocol != 0)
> 			goto drop;
> 	...
> }
> 
> The offload path then writes the hardcoded value itself:
> 
> net/netfilter/nf_flow_table_ip.c:nf_flow_tunnel_ipip_push() {
> 	...
> 	iph->protocol	= tuple->tun.l3_proto;
> 	...
> }
> 
> So for an mplsip ipip device, does the slow path drop the first packet
> while every subsequent packet of the offloaded flow is encapsulated (and
> matching ingress packets decapsulated) with a protocol number that
> contradicts the device configuration?  Should the gate also compare against
> tunnel->parms.iph.protocol?
> 
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index 042d743edb6c0..d063add01f523 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -1852,6 +1852,9 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
> >  	struct flowi6 fl6;
> >  	int err;
> >  
> > +	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
> > +		return -EOPNOTSUPP;
> > +
> >  	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
> >  			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
> >  			      IP6_TNL_F_USE_ORIG_FWMARK))
> 
> [Severity: Medium]
> Same pre-existing observation on the IPv6 side, not something this patch
> introduces: t->parms.proto is ignored while path->tun.inner_proto is always
> set to IPPROTO_IPV6, whereas the software paths reject a mismatch:
> 
> net/ipv6/ip6_tunnel.c:ipxip6_tnl_xmit() {
> 	...
> 	tproto = READ_ONCE(t->parms.proto);
> 	if (tproto != protocol && tproto != 0)
> 		return -1;
> 	...
> }
> 
> ip6_tnl_rcv() applies the same check on receive.  For an ip6tnl in ip4ip6
> mode, does the offload path end up forwarding traffic that the tunnel
> device itself would drop?

As said I plan to request this patch to get into -stable to address
this too.

> > diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> > index 0cbde535b8bae..5f166da3b09be 100644
> > --- a/net/netfilter/nf_flow_table_path.c
> > +++ b/net/netfilter/nf_flow_table_path.c
> > @@ -44,13 +44,15 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
> >  
> >  static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
> >  				     const struct nf_conn *ct,
> > -				     enum ip_conntrack_dir dir, u8 *ha,
> > +				     enum ip_conntrack_dir dir,
> > +				     u8 *ha, __be16 ether_type,
> >  				     struct net_device_path_stack *stack)
> >  {
> >  	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
> >  	struct net_device *dev = dst_cache->dev;
> >  	struct net_device_path_ctx ctx = {
> >  		.dev = dev,
> > +		.ether_type = ether_type,
> >  	};
> >  	struct neighbour *n;
> >  	u8 nud_state;
> 
> [ ... ]
> 
> > @@ -228,7 +230,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
> >  	unsigned char ha[ETH_ALEN];
> >  	int i;
> >  
> > -	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
> > +	if (nft_dev_fill_forward_path(dst, ct, dir, ha, pkt->ethertype, &stack) < 0 ||
> >  	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
> >  		return -ENOENT;
> >
