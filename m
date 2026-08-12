Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FC034BA50;
	Wed, 12 Aug 2026 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786566983; cv=none; b=UAz79ArPsg2VhoYut95zGoGb6QI17FMSbKUnFsM8xfYD8lsd/mk8T8QehDvanYrTtfRmlXJzfob+PMT+D9f8DSV+oK9CT0ainIw0lxZM1kmEixfUpknR/gTHpz4+Pi5xbgkpuZPMmhj4T9t42JbEw88NYbT9JuKnsgeIW3lqwSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786566983; c=relaxed/simple;
	bh=WL6w9LOVRM/msDJ2jr6+UAOv7xEI8RDKE76/cIidYCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMClDmIOi1CsH2OGacuifYX9LSsv7+5G+JQd7AJ3kX+acuB9gFCcKa/6CCrkBS/c0o1WBTygb5Ku+TQY4Qns4VbwrZVgFG3IRz1MoRyjQr/ufA3lJJrO8i7yM8PsZvPbymJbbgpU2gVlzTZkhvsHUx2IibXU3KRQYERk6v4jfj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qM1xAbd2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qM1xAbd2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786566979;
	bh=8m/FI2CMD2FpXB8LzuThZq14v9VvMSjId8GyjncAa+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qM1xAbd2k3SWb2Fy6VUHFhNQQmCbMpKscflVWyizsfWnJnAR+epfcf+o1Ovh+UDyz
	 Fy2jiXwzbCSoxnmgzUyWLIROqAA4s+DebolCHKK87wyJhdMlC5w7V6seQW4JzxqNkO
	 unTaYQiclokIUYVrUTG9PBaIbyk6deXJTUaxCqAeST4mj7Nt1nQD1AFoZ3A8TQt5aA
	 EsobzyBZF8Eahl2hFInlMmoyG0pMoQyjNB0lSFt5srHhI+QD9bwDcm80vorVyAvj4q
	 ArEhsWw+Al0YPStWL7pbxEpurH5o8ORcx2C5hWg0ub9sjBiToTYCPEDhm0Nf7frKjM
	 K48wjEJRZrhsg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C65EC60077;
	Wed, 12 Aug 2026 22:36:18 +0200 (CEST)
Date: Wed, 12 Aug 2026 22:36:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 06/12] netfilter: flowtable: store ethertype in
 flowtable context
Message-ID: <anzZQBvrnNOhQfjK@chamomile>
References: <20260810194015.932627-7-pablo@netfilter.org>
 <20260812013444.1674732-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812013444.1674732-1-kuba@kernel.org>

On Tue, Aug 11, 2026 at 06:34:44PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: flowtable: store ethertype in flowtable context
> 
> This adds an ether_type field to struct nf_flowtable_ctx, sets it while
> parsing the layer 2 header in nf_flow_skb_encap_protocol(), and replaces
> the local inner_proto computations in nf_flow_tuple_encap() and
> nf_flow_skb_encap_protocol() with reads of ctx->ether_type.  The IPv4 and
> IPv6 lookup helpers now compare ctx->ether_type themselves instead of
> passing an expected protocol down.
> 
> No Link: tags in the commit header.
> 
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 7692ae7aa8539..3f417a43bd122 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -161,7 +162,6 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
> >  				struct sk_buff *skb,
> >  				struct flow_offload_tuple *tuple)
> >  {
> > -	__be16 inner_proto = skb->protocol;
> >  	struct vlan_ethhdr *veth;
> >  	struct pppoe_hdr *phdr;
> >  	struct ipv6hdr *ip6h;
> > @@ -179,19 +179,17 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
> >  		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
> >  		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
> >  		tuple->encap[i].proto = skb->protocol;
> > -		inner_proto = veth->h_vlan_encapsulated_proto;
> >  		offset += VLAN_HLEN;
> >  		break;
> >  	case htons(ETH_P_PPP_SES):
> >  		phdr = (struct pppoe_hdr *)skb_network_header(skb);
> >  		tuple->encap[i].id = ntohs(phdr->sid);
> >  		tuple->encap[i].proto = skb->protocol;
> > -		inner_proto = *((__be16 *)(phdr + 1));
> >  		offset += PPPOE_SES_HLEN;
> >  		break;
> >  	}
> >  
> > -	switch (inner_proto) {
> > +	switch (ctx->ether_type) {
> >  	case htons(ETH_P_IP):
> >  		iph = (struct iphdr *)(skb_network_header(skb) + offset);
> >  		if (ctx->tun.inner_proto == IPPROTO_IPIP) {
> 
> [Severity: Medium]
> 
> Does this hunk change behaviour for PPPoE frames rather than just moving
> the ethertype into the context?
> 
> Before this patch, the PPPoE arm fed the raw PPP protocol id into the
> switch:
> 
> net/netfilter/nf_flow_table_ip.c:nf_flow_tuple_encap() {
> 	case htons(ETH_P_PPP_SES):
> 		...
> 		inner_proto = *((__be16 *)(phdr + 1));
> 		offset += PPPOE_SES_HLEN;
> 		break;
> 	}
> 
> 	switch (inner_proto) {
> 	case htons(ETH_P_IP):
> 	...
> }
> 
> PPP_IP is 0x0021 and PPP_IPV6 is 0x0057, so inner_proto could never equal
> htons(ETH_P_IP) (0x0800) or htons(ETH_P_IPV6) (0x86dd), and PPPoE frames
> always landed in the default: arm.  That left
> tuple->tun.{src_v4,dst_v4,src_v6,dst_v6} and tuple->tun.inner_proto zero
> even when nf_flow_skb_encap_protocol() -> nf_flow_ip4_tunnel_proto() had
> already set ctx->tun.inner_proto = IPPROTO_IPIP.
> 
> After the patch, ctx->ether_type for PPPoE is the value normalised by
> __nf_flow_pppoe_proto() in include/net/netfilter/nf_flow_table.h:
> 
> 	switch (proto) {
> 	case htons(PPP_IP):
> 		return htons(ETH_P_IP);
> 	case htons(PPP_IPV6):
> 		return htons(ETH_P_IPV6);
> 	}
> 
> so these tunnel arms now execute for PPPoE traffic and populate
> tuple->tun.
> 
> struct flow_offload_tunnel tun sits before the __hash marker in struct
> flow_offload_tuple, so it is part of the rhashtable lookup key, and the
> control path always installs non-zero endpoints for tunnel flows:
> 
> net/netfilter/nf_flow_table_core.c:flow_offload_fill_tuple() {
> 	flow_tuple->tun = route->tuple[dir].in.tun;
> 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
> }
> 
> filled from DEV_PATH_TUN in nft_dev_path_info(), which can be walked
> together with DEV_PATH_PPPOE in the same path stack (ipip or ip6tnl over a
> PPPoE underlay).  That means PPPoE encapsulated IPIP/IP6IP6 rx flows
> previously missed their flowtable entry on every packet and now start
> matching.
> 
> Should the commit message mention this, and should a Fixes: tag be added
> pointing at ab427db17885 ("netfilter: flowtable: Add IPIP rx sw
> acceleration") and d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw
> acceleration"), which introduced the raw PPP id versus ETH_P_* comparison?
> As written, the message only says "Store the ether_type in the context
> after parsing the layer 2 header for the first time and then use it later
> on", which reads as a pure cleanup.

I will make sure this reaches -stable at some point as this fixes ipip
and ip6ip6 over pppoe.

> The behaviour persists to the end of the series (nf_flow_tuple_encap() at
> 839e6caf13c7 still switches on ctx->ether_type), so no later patch
> documents or reverts it.
> 
> > @@ -389,22 +387,27 @@ static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
> >  			return false;
> >  
> >  		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
> > -		if (veth->h_vlan_encapsulated_proto == proto) {
> > -			ctx->offset += VLAN_HLEN;
> > -			inner_proto = proto;
> > -			ret = true;
> > -		}
> > +		ctx->ether_type = veth->h_vlan_encapsulated_proto;
> > +		ctx->offset += VLAN_HLEN;
> > +		ret = true;
> >  		break;
> >  	case htons(ETH_P_PPP_SES):
> > -		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
> > -		    inner_proto == proto) {
> > -			ctx->offset += PPPOE_SES_HLEN;
> > -			ret = true;
> > -		}
> > +		if (!nf_flow_pppoe_proto(skb, &ether_type))
> > +			return false;
> > +
> > +		ctx->ether_type = ether_type;
> > +		ctx->offset += PPPOE_SES_HLEN;
> > +		ret = true;
> > +		break;
> 
> This is the store of the normalised ETH_P_* value that nf_flow_tuple_encap()
> later consumes for PPPoE frames.
> 
> [ ... ]
