Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77283563DD
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783883978; cv=none; b=FX9F2g8K0drFUuihLHHMTa87kzX9X8U+UMHrtdUZt7zjCFM8ijVkfljoG/LpBVMHskR2oCevkZrhRsZhLeazViHY085EYlau1UqmLlQWcAIVTFzXqgenFsEHJE52PJ4W0/RFpPBafzlFcRxliMMj4AgzHVyPfdrxw6b3KUHLo0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783883978; c=relaxed/simple;
	bh=jK+ghLCd5JwFyT0hyMfGsqfYanVuR27WgmyiMDdGj/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuJITwEJ0147iMrJ68yYkjDqqa1zKf5f6GNjm0b5x1e65qa9oRagLz/cz8lUH3HhITiP4Ru4v3URVn1UQcYOmIn06LW1jhjrtoYCqw+tnd4+DyLF4+Q84AgpTL2xKIEtss+N8pcwRiKD29nwkYV9ivYpJgvqvO2tpQHW9s5Eg8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F5sHJBml; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F5sHJBml"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 945F06019B;
	Sun, 12 Jul 2026 21:19:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783883973;
	bh=01HXA6gBLMPavtz9G3pQnINrFl6QpgVyhn5zfx6+++Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F5sHJBmlzeN8hb9ncLcbHCnw5tSmZukflDjQcZqvHQlTc2CYkEPNa/DOUnqPaN58U
	 2P+ZkxeEIF9OIEUJGS23si3LxJFVdFfs1K0PahFwjDp7YDrsURnnzIvO6I8wedbLOo
	 yANLL4xIpj5O984e+KlVIFNxd4atdd8gK6G1kMl+OaF3pkeP5v9kCIStkB12a35neN
	 gzv2OhKYdUYcuQ5On9YqlJTkT1Irh8Sp2DoW0CA6uNPAxIHDZGSLpAYckPHcSfcbYx
	 MmXHfM5D/IUMDjMCS/iiSja4ZgeJZYklcjOQuIGskqAJTDH9c6rcYo4QdgjvSBK3Ll
	 T/V213TRXUkFg==
Date: Sun, 12 Jul 2026 21:19:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org, razor@blackwall.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 3/3] netfilter: flowtable: initial bridge
 support
Message-ID: <alPowzheMt-_N-Z6@chamomile>
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-4-pablo@netfilter.org>
 <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>

On Sun, Jul 12, 2026 at 11:27:50AM +0200, Eric Woudstra wrote:
[...]
> On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
> > diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> > index 5455149e5d9a..a3aa9a9ce673 100644
> > --- a/net/netfilter/nf_flow_table_path.c
> > +++ b/net/netfilter/nf_flow_table_path.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/netfilter/nf_conntrack_common.h>
> >  #include <linux/netfilter/nf_tables.h>
> > +#include <linux/if_vlan.h>
> >  #include <net/ip.h>
> >  #include <net/inet_dscp.h>
> >  #include <net/netfilter/nf_tables.h>
> > @@ -360,3 +361,67 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
> >  	return -ENOENT;
> >  }
> >  EXPORT_SYMBOL_GPL(nft_flow_route);
> > +
> > +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
> > +				    struct nft_flowtable *ft,
> > +				    enum ip_conntrack_dir dir,
> > +				    const struct net_device *dev,
> > +				    unsigned char *src_ha,
> > +				    unsigned char *dst_ha)
> > +{
> > +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> 
> Add:
> 
> struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
> 
> See below.
> 
> > +	struct net_device_path_stack stack;
> > +	struct nft_forward_info info = {};
> > +	struct net_device_path_ctx ctx;
> > +	int i, j = 0;
> > +
> > +	nft_dev_fill_forward_path_init(&ctx, dev, dst_ha);
> > +
> 
> Here you could add the following to handle the encaps on this_tuple.

Why?

> for (i = this_tuple->encap_num - 1; i >= 0 ; i--) {
> 	if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
> 		return -1;
> 
> 	if (this_tuple->in_vlan_ingress & BIT(i))
> 		continue;

I don't do bridge vlan filtering at this stage. I have to teach
nf_conntrack_bridge to track PPPoE/VLAN tagged packets, this is not
included in this series.

> 	info.encap[info.num_encaps].id = this_tuple->encap[i].id;
> 	info.encap[info.num_encaps].proto = this_tuple->encap[i].proto;
> 	info.num_encaps++;
> 
> 	if (this_tuple->encap[i].proto == htons(ETH_P_PPP_SES))
> 		continue;
> 
> 	if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
> 		return -1;
> 	ctx.vlan[ctx.num_vlans].id = this_tuple->encap[i].id;
> 	ctx.vlan[ctx.num_vlans].proto = this_tuple->encap[i].proto;
> 	ctx.num_vlans++;
> }
> 
> > +	if (dev_fill_forward_path(&ctx, &stack) < 0 ||
> > +	    nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
> > +		return -1;
> > +
> > +	if (!nft_flowtable_find_dev(info.indev, ft))
> > +		return -1;
> > +
> 
> After replacing dev_fill_forward_path() with dev_fill_bridge_path(),
> from here...
> 
> > +	this_tuple->iifidx = info.indev->ifindex;
> > +	for (i = info.num_encaps - 1; i >= 0; i--) {
> > +		this_tuple->encap[j].id = info.encap[i].id;
> > +		this_tuple->encap[j].proto = info.encap[i].proto;
> > +		j++;
> > +	}
> > +	this_tuple->encap_num = info.num_encaps;
> 
> Until here, this_tuple needs to be the other_tuple.
> dev_fill_forward_path() does not traverse the bridge.

As I said, this series does not included bridge vlan filtering support.

> See other comment in other patch. Also, need to copy
> the in_vlan_ingress bit.
> 
> So it becomes:
> 
> other_tuple->iifidx = info.indev->ifindex;
> for (i = info.num_encaps - 1; i >= 0; i--) {
> 	other_tuple->encap[j].id = info.encap[i].id;
> 	other_tuple->encap[j].proto = info.encap[i].proto;
> 	if (info.ingress_vlans & BIT(i))
> 		other_tuple->in_vlan_ingress |= BIT(j);
> 	j++;
> }
> other_tuple->encap_num = info.num_encaps;
> 
> > +
> > +	ether_addr_copy(this_tuple->out.h_source, src_ha);
> > +	ether_addr_copy(this_tuple->out.h_dest, dst_ha);
> > +	this_tuple->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> > +
> > +	return 0;
> > +}
> > +
> > +int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
> > +		    enum ip_conntrack_dir dir, struct nft_flowtable *ft)
> > +{
> > +	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
> > +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> > +	const struct net_device *outdev = nft_out(pkt);
> > +	const struct net_device *indev = nft_in(pkt);
> > +	struct ethhdr *eth = eth_hdr(pkt->skb);
> > +	int err;
> > +
> 
> Here I use the skb to fill other_tuple->encaps. I understand you want to
> do this differently.

Using skb to populate tuples will not work, the skb comes with no tags
when VLAN/PPPoE devices are used in the bridge ports.

> Then I call nft_dev_fill_bridge_path() with !dir first, then dir.
> 
> > +	err = nft_dev_fill_bridge_path(flow, ft, dir, indev,
> > +				       eth->h_source, eth->h_dest);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	err = nft_dev_fill_bridge_path(flow, ft, !dir, outdev,
> > +				       eth->h_dest, eth->h_source);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	this_tuple->out.ifidx = other_tuple->iifidx;
> > +	other_tuple->out.ifidx = this_tuple->iifidx;
> 
> This could move to nft_dev_fill_bridge_path() (only 1 line) as both
> tuples are also known there.

No, because other_tuple is unset when the first nft_dev_fill_bridge_path()
call is done.
