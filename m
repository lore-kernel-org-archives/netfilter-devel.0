Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D1336B90E;
	Wed, 12 Aug 2026 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498486; cv=none; b=hQR4CtgFJl6bs9QEFPNuRxltXC9eJz9ukPAbACKbT3uz9PSo2ufmRIX16786Te+mas/xyUcPvMqyjMTmIoPH/T9Z6hpKpT1dzPsmDm/m7fjKW6rLp9kYwqF+AztHO8FD3izXlt3jIItdH5YkQLykOINFNwBAwT2ce3stRJwE5jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498486; c=relaxed/simple;
	bh=54CujjSmrOV8keYzk88vTtTghtt/kUQFgGLxv4ukka8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxdcq0b7pDv/U72471WG8a726KBmASPD3ohEOcNsg7wjAz1tfGnx8oVkke7RIR4AKBrnLlsLF63sUKzObjzI2xZ6yX+eQTQe+hC/XHKW1VFK4cnbdmSqpOvMN9pXZa7SkKDf76WUxtqoeg6zKNBoEgVk9aNdh4PFMfqzWh9cnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igReUEJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igReUEJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFE01F00A3E;
	Wed, 12 Aug 2026 01:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786498484;
	bh=pkvvoJCBdXAC8Xf9efHvifPBtrUoH2pBZo/J82okfpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igReUEJ9lwSiNRnIWmB663XRYJailtTyxtUINPRGcF5uix64YEtFX/3VZLbQFrU+P
	 dWztbXhi1Y1hBPKnr5T+FgIY/U6DITz349TlWyJlmUHhmOkx5/Ewiduz/i9pFx7nTs
	 lCeudQSN33BNlv8OEYMWR80+vdZYIRoJAuzLITwib49alnKQDdtbgLVFOb/KGXmU1i
	 CrYGdo4iPjRxWHOsErelNqpsanG0mJPbp1Jd1yIVPI8ztgN1K5cYIRhnKGK1l8JIYQ
	 9xIefPbOgg723Zojz8BhWQpY5BTFrHu/3hJxL2UEbmxAluJOowPxJCSsi89q67wSdq
	 i0nRR5+9rP8Gw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net-next 03/12] net: netfilter: add ether_type to net_device_path_ctx and use it
Date: Tue, 11 Aug 2026 18:34:43 -0700
Message-ID: <20260812013443.1673999-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810194015.932627-4-pablo@netfilter.org>
References: <20260810194015.932627-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: netfilter: add ether_type to net_device_path_ctx and use it

This adds an ether_type field to struct net_device_path_ctx and makes the
ipip and ip6tnl ndo_fill_forward_path callbacks reject a context whose
ether_type does not match their own address family.  The netfilter
flowtable path builder fills the new field from pkt->ethertype.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 17d28adb029bb..2327a2703b835 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -941,6 +941,7 @@ struct net_device_path_stack {
>  struct net_device_path_ctx {
>  	const struct net_device *dev;
>  	u8			daddr[ETH_ALEN];
> +	__be16			ether_type;
>  
>  	int			num_vlans;
>  	struct {

[Severity: Medium]
This new field becomes a mandatory input for the tunnel
ndo_fill_forward_path callbacks, but only the netfilter context builder is
updated here.  The two other in-tree constructors of the context still use
designated initializers that set only .dev, so ether_type stays zero:

drivers/net/ethernet/mediatek/mtk_ppe_offload.c:mtk_flow_get_wdma_info() {
	struct net_device_path_ctx ctx = {
		.dev = dev,
	};
	...
}

drivers/net/ethernet/airoha/airoha_ppe.c:airoha_ppe_get_wdma_info() {
	struct net_device_path_ctx ctx = {
		.dev = dev,
	};
	...
}

Zero matches neither ETH_P_IP nor ETH_P_IPV6, and dev_fill_forward_path()
turns any negative return from the callback into a full abort:

net/core/dev.c:dev_fill_forward_path() {
	...
		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
		if (ret < 0)
			goto err_out;
	...
}

So does an ipip or ip6tnl device anywhere in the walk now always fail path
resolution for those two drivers, even for the same-family case that used
to work, leaving the PPE/WED entry unprogrammed?  Both drivers know the
flow's L3 protocol at that point, so could they populate ether_type as
well?

Would it also help to document in the struct that 0 means "unknown" and is
treated as unsupported by the tunnel callbacks?

> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index fb7d96f99b06b..62a374079bfcb 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -360,6 +360,9 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
>  	const struct iphdr *tiph = &tunnel->parms.iph;
>  	struct rtable *rt;
>  
> +	if (ctx->ether_type != cpu_to_be16(ETH_P_IP))
> +		return -EOPNOTSUPP;
> +
>  	if (tunnel->collect_md)
>  		return -EOPNOTSUPP;
>  

[Severity: Low]
The commit message describes a datapath defect ("incorrect dst_entry family
can be reached from datapath"), but there is no Fixes: tag.  Without this
gate, an IPv6 flow routed out of an ipip device makes
ipip_fill_forward_path() succeed and return an IPv4 rtable in
path->tun.dst, after which nft_dev_path_info() reads the v6 members of the
address union and nft_dev_forward_path() installs that dst:

net/netfilter/nf_flow_table_path.c:nft_dev_forward_path() {
	...
		dst_release(route->tuple[dir].dst);
		route->tuple[dir].dst = info.tun_dst;
	...
}

The two handlers were added by ab427db17885 ("netfilter: flowtable: Add
IPIP rx sw acceleration") and d98103575dcd, and the tunnel dst hand-off was
last touched by 806273fcaffb82 ("netfilter: flowtable: release tunnel route
on error when building forward path").  Could a Fixes: tag against one of
these be added so a backport can be keyed off it?

It would also be worth noting in the message that this is not
standalone-backportable: it depends on the preceding commit 635bf8763d7e
("net: pass net_device_path_ctx to dev_fill_forward_path()"), since before
that the context was built inside net/core/dev.c and the netfilter caller
had no way to pass an ethertype.

[Severity: Medium]
This isn't a bug introduced by this patch, but the new gate only validates
the packet's L3 protocol and still leaves the tunnel device's configured
payload protocol unchecked.  An ipip link can be configured with
iph.protocol == IPPROTO_MPLS (mplsip), and such a device shares
ipip_netdev_ops and therefore this callback, yet the callback never consults
tunnel->parms.iph.protocol and unconditionally sets
path->tun.inner_proto = IPPROTO_IPIP.

The device's own paths do enforce it:

net/ipv4/ipip.c:ipip_tunnel_xmit() {
	...
	if (tiph->protocol != ipproto && tiph->protocol != 0)
		goto tx_error;
	...
}

net/ipv4/ipip.c:ipip_rcv() {
	...
		if (tunnel->parms.iph.protocol != ipproto &&
		    tunnel->parms.iph.protocol != 0)
			goto drop;
	...
}

The offload path then writes the hardcoded value itself:

net/netfilter/nf_flow_table_ip.c:nf_flow_tunnel_ipip_push() {
	...
	iph->protocol	= tuple->tun.l3_proto;
	...
}

So for an mplsip ipip device, does the slow path drop the first packet
while every subsequent packet of the offloaded flow is encapsulated (and
matching ingress packets decapsulated) with a protocol number that
contradicts the device configuration?  Should the gate also compare against
tunnel->parms.iph.protocol?

> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 042d743edb6c0..d063add01f523 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1852,6 +1852,9 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
>  	struct flowi6 fl6;
>  	int err;
>  
> +	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
> +		return -EOPNOTSUPP;
> +
>  	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
>  			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
>  			      IP6_TNL_F_USE_ORIG_FWMARK))

[Severity: Medium]
Same pre-existing observation on the IPv6 side, not something this patch
introduces: t->parms.proto is ignored while path->tun.inner_proto is always
set to IPPROTO_IPV6, whereas the software paths reject a mismatch:

net/ipv6/ip6_tunnel.c:ipxip6_tnl_xmit() {
	...
	tproto = READ_ONCE(t->parms.proto);
	if (tproto != protocol && tproto != 0)
		return -1;
	...
}

ip6_tnl_rcv() applies the same check on receive.  For an ip6tnl in ip4ip6
mode, does the offload path end up forwarding traffic that the tunnel
device itself would drop?

> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 0cbde535b8bae..5f166da3b09be 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -44,13 +44,15 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
>  
>  static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
>  				     const struct nf_conn *ct,
> -				     enum ip_conntrack_dir dir, u8 *ha,
> +				     enum ip_conntrack_dir dir,
> +				     u8 *ha, __be16 ether_type,
>  				     struct net_device_path_stack *stack)
>  {
>  	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
>  	struct net_device *dev = dst_cache->dev;
>  	struct net_device_path_ctx ctx = {
>  		.dev = dev,
> +		.ether_type = ether_type,
>  	};
>  	struct neighbour *n;
>  	u8 nud_state;

[ ... ]

> @@ -228,7 +230,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  	unsigned char ha[ETH_ALEN];
>  	int i;
>  
> -	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
> +	if (nft_dev_fill_forward_path(dst, ct, dir, ha, pkt->ethertype, &stack) < 0 ||
>  	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
>  		return -ENOENT;
>
