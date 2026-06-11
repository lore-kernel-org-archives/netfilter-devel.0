Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393963C9894;
	Thu, 11 Jun 2026 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781175846; cv=none; b=NfchNd6AM/HbIdbutXqVJVyDZxh1xqegYkEwGOMt2O69INUPGcoYQ71NVzrwx+cU6+wEv8BG37QBtcQCGqvaPaaGGwVK73DLSJSByaywAsqYQlCku1GVowrnMGMV4d0g470rsZcm2kQO+BRDyow3xca90uJbHxXImGoDX/KhteQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781175846; c=relaxed/simple;
	bh=t0Kjgeupyq/fwLmWsm5fPORYV4YusFFUcFeTupW1DyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcMZsrehXz5wGLc8Jt7LJzQDt98rUWXv3TFtUgLnceoEmDUgbS+F8YKyGaBcF4joKdapDJWJnKyEIpRGnLAoVbUKiu9oO0ki+yKG1kKt3sqyx+oyGDU15cenG59upPxcKZYy3pKT9hm0tHd3rsqk0pcMIzAzYJJLfCJ5pjJtyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d6XrqJuw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d6XrqJuw"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 51A3D60276;
	Thu, 11 Jun 2026 13:04:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781175841;
	bh=q4z30TcaEWGq60ARAg0jTLz7SZSYSuYwdxEcywugLT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6XrqJuwqDr0Zc+VZyCfZ2jlgDj9g6oaywqP2x5Nf43fIHDPXnzL27rkpXaq8Iyo2
	 pX5mxf8GJw2YI0puSxgo6tiwx/ltvfQTByeDR0c345dWdY8BWOW4PvQ/tYhnCv9PYy
	 YjOxuHNYKWHsgCTLNwRIW5Af09PxKacJR6uW/pxgJkhAb4ME7oGiZO7ly8y8X2SiXh
	 +S2FQi7EL4EuaogN+hwrDC8ssl6/6jrnEyGz5xdk7CXypw8C33ZhjLJ4pczK116y57
	 hhmlwhxQyGqEW6LwtkrJRJwQ9x3DMP7L97NoQjgK3+r9+ycr1DW98SBKaFw+mOozOC
	 7hgDoqGkogeSQ==
Date: Thu, 11 Jun 2026 13:03:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: use pskb_may_pull() in
 nf_flow_ip6_tunnel_proto()
Message-ID: <aiqWHszyI-RXqHVI@chamomile>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
 <aidMPKrm9gOcPLW-@chamomile>
 <aifquGhK_Cijxq7m@lore-desk>
 <aif9kL38LKNcX1Xu@chamomile>
 <aigHh5cBKc12frX2@lore-desk>
 <aih5uTn97bK29LDR@chamomile>
 <aipwpXlisPVxO2ig@lore-desk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aipwpXlisPVxO2ig@lore-desk>

On Thu, Jun 11, 2026 at 10:24:05AM +0200, Lorenzo Bianconi wrote:
> > Hi Lorenzo,
> > 
> > On Tue, Jun 09, 2026 at 02:31:03PM +0200, Lorenzo Bianconi wrote:
> > > > On Tue, Jun 09, 2026 at 12:28:08PM +0200, Lorenzo Bianconi wrote:
> > > > > On Jun 09, Pablo Neira Ayuso wrote:
> > > > > > Hi Lorenzo,
> > > > > > 
> > > > > > On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> > > > > > > Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> > > > > > > pskb_may_pull() for header validation, aligning it with the approach
> > > > > > > used in nf_flow_ip4_tunnel_proto().
> > > > > > > Move ctx->offset update inside the IPPROTO_IPV6 conditional block since
> > > > > > > it should only be adjusted when a tunnel is actually detected.
> > > > > > > While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 constant
> > > > > > > when setting ctx->tun.proto.
> > > > > > > 
> > > > > > > Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
> > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > ---
> > > > > > >  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
> > > > > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > > > > > index 9c05a50d6013..2946399ab715 100644
> > > > > > > --- a/net/netfilter/nf_flow_table_ip.c
> > > > > > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > > > > > @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
> > > > > > >  				     struct sk_buff *skb)
> > > > > > >  {
> > > > > > >  #if IS_ENABLED(CONFIG_IPV6)
> > > > > > > -	struct ipv6hdr *ip6h, _ip6h;
> > > > > > > +	struct ipv6hdr *ip6h;
> > > > > > >  	__be16 frag_off;
> > > > > > >  	u8 nexthdr;
> > > > > > >  	int hdrlen;
> > > > > > >  
> > > > > > > -	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
> > > > > > > -	if (!ip6h)
> > > > > > > +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
> > > > > > >  		return false;
> > > > > > >  
> > > > > > > +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
> > > > > > >  	if (ip6h->hop_limit <= 1)
> > > > > > >  		return false;
> > > > > > 
> > > > > > Not shown in the patch, but is there still a corner case here that
> > > > > > needs to be covered?
> > > > > > 
> > > > > > ipv6_skip_exthdr() uses skb_header_pointer() internal, then another
> > > > > > pskb_may_pull() is needed to make sure no other IPv6 extension header
> > > > > > sits between the outer and the inner IPPROTO_IPV6 header, allowing to
> > > > > > be in a non-linear area of the skb?        
> > > > > > 
> > > > > > > @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
> > > > > > >  
> > > > > > 
> > > > > > I mean:
> > > > > > 
> > > > > >         if (!pskb_may_pull(skb, hdrlen))
> > > > > >                 return false;
> > > > > > 
> > > > > > where hdrlen is what ipv6_skip_exthdr() returns.
> > > > > > 
> > > > > > Then, I think it should be safe to call skb_pull() on
> > > > > > ctx->tun.hdr_size.
> > > > > > 
> > > > > > Let me know, thanks.
> > > > > 
> > > > > I think you are right, here we need to run:
> > > > > 
> > > > > 	if (!pskb_may_pull(skb, hdrlen))
> > > > > 		return false;
> > > > > 
> > > > > in order to be sure we can pull ctx->tun.hdr_size in nf_flow_ip_tunnel_pop().
> > > > > Doing so, we can roll-back to the original skb_header_pointer() to access the
> > > > > outer ip6 header here. What do you think?
> > > > 
> > > > Yes, initial skb_header_pointer() then pskb_may_pull(skb, hdrlen) to
> > > > ensure the entire should be fine.
> > > > 
> > > > I think this need one more fix: This needs to resort to classic path
> > > > if there are intermediate extension headers sitting in between the
> > > > outer and inner headers in IP6IP6, ie. ipv6_ext_hdr() == true. Those
> > > > extensions need to be handled by the IPv6 stack.
> > > 
> > > In my setup we have just a single Destination Option extension header (60)
> > > between the outer and the inner IPV6 headers. In order to check if we have
> > > other extensions headers other than Destination Option (and if so, send the
> > > packet the networking stack) I guess we need to implement something similar
> > > to ipv6_skip_exthdr(), agree?
> > 
> > Maybe simpler check? If nexthdr is immediately IP6IP6 (ie. no
> > intermediate headers are in place), then handle this from the
> > flowtable datapath, otherwise fallback to classic. Thus, no new
> > special parser function is needed.
> 
> Hi Pablo,
> 
> ack, I agree. I guess we can limit the flowtable acceleration to the case of a
> IP6IP6 tunnel created with encaplimit set to none:
> 
> $ip link add name tun0 type ip6tnl local <local> remote <remote> encaplimit none

I can see IPV6_DEFAULT_TNL_ENCAP_LIMIT is used from packet path, so
the flowtable ignores this existing configuration.

I guess encaplimit is reachable from net_device so .fill_forward_path
can check this _at flow offload_ set up time.

I think it is sensible to start simple, ie. no encaplimit support,
then maybe at full support later for NEXTHDR_DEST later on, but
I think encaplimit support is currently half-way done?

I think your patch is fine, probably only .fill_forward_path needs the
update to skip the offload if encaplimit is used for ip6ip6?

more comments below

> > > > nf_flow_ip6_tunnel_proto() needs to be fixed to deal with this. 
> > > 
> > > Do you want to do it with a dedicated patch or do you prefer to do it in this
> > > one?
> > 
> > I think a single patch to fix the issues in nf_flow_ip6_tunnel_proto()
> > should be fine.
> 
> I cooked this patch, it works fine. What do you think?
> 
> Regards,
> Lorenzo
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 9c05a50d6013..5cb50414a491 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -347,29 +347,20 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
>  				     struct sk_buff *skb)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	struct ipv6hdr *ip6h, _ip6h;
> -	__be16 frag_off;
> -	u8 nexthdr;
> -	int hdrlen;
> +	struct ipv6hdr *ip6h;
>  
> -	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
> -	if (!ip6h)
> +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
>  		return false;
>  
> +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
>  	if (ip6h->hop_limit <= 1)
>  		return false;
>  
> -	nexthdr = ip6h->nexthdr;
> -	hdrlen = ipv6_skip_exthdr(skb, sizeof(*ip6h) + ctx->offset, &nexthdr,
> -				  &frag_off);
> -	if (hdrlen < 0)
> -		return false;
> -
> -	if (nexthdr == IPPROTO_IPV6) {
> -		ctx->tun.hdr_size = hdrlen;
> -		ctx->tun.proto = IPPROTO_IPV6;
> +	if (ip6h->nexthdr == IPPROTO_IPV6) {

LGTM, if we see an IP6IP6 packets with intermediate headers, then
flowtable lookup fails and packet follows classic path.

And this also removes the ipv6_skip_exthdr() preprocessing which is a
bit expensive to run for all IPv6 packets, most people do not use
IP6IP6.

> +		ctx->tun.proto = ip6h->nexthdr;
> +		ctx->tun.hdr_size = sizeof(*ip6h);
> +		ctx->offset += ctx->tun.hdr_size;
>  	}
> -	ctx->offset += ctx->tun.hdr_size;
>  
>  	return true;
>  #else
> @@ -648,25 +639,19 @@ static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
>  	return 0;
>  }
>  
> -struct ipv6_tel_txoption {
> -	struct ipv6_txoptions ops;
> -	__u8 dst_opt[8];
> -};
> -
>  static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  				      struct flow_offload_tuple *tuple,
> -				      struct in6_addr **ip6_daddr,
> -				      int encap_limit)
> +				      struct in6_addr **ip6_daddr)
>  {
>  	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
> -	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
>  	struct rtable *rt = dst_rtable(tuple->dst_cache);
>  	__u8 dsfield = ipv6_get_dsfield(ip6h);
>  	struct flowi6 fl6 = {
>  		.daddr = tuple->tun.src_v6,
>  		.saddr = tuple->tun.dst_v6,
> -		.flowi6_proto = proto,
> +		.flowi6_proto = IPPROTO_IPV6,
>  	};
> +	u8 hop_limit = ip6h->hop_limit;
>  	int err, mtu;
>  	u32 headroom;
>  
> @@ -674,41 +659,18 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> -	skb_set_inner_ipproto(skb, proto);
> +	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
>  	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
>  		   rt->dst.header_len;
> -	if (encap_limit)
> -		headroom += 8;
>  	err = skb_cow_head(skb, headroom);
>  	if (err)
>  		return err;
>  
>  	skb_scrub_packet(skb, true);
>  	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
> -	if (encap_limit)
> -		mtu -= 8;
>  	mtu = max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
>  
> -	if (encap_limit > 0) {
> -		struct ipv6_tel_txoption opt = {
> -			.dst_opt[2] = IPV6_TLV_TNL_ENCAP_LIMIT,
> -			.dst_opt[3] = 1,
> -			.dst_opt[4] = encap_limit,
> -			.dst_opt[5] = IPV6_TLV_PADN,
> -			.dst_opt[6] = 1,
> -		};
> -		struct ipv6_opt_hdr *hopt;
> -
> -		opt.ops.dst1opt = (struct ipv6_opt_hdr *)opt.dst_opt;
> -		opt.ops.opt_nflen = 8;
> -
> -		hopt = skb_push(skb, ipv6_optlen(opt.ops.dst1opt));
> -		memcpy(hopt, opt.ops.dst1opt, ipv6_optlen(opt.ops.dst1opt));
> -		hopt->nexthdr = IPPROTO_IPV6;
> -		proto = NEXTHDR_DEST;
> -	}
> -
>  	skb_push(skb, sizeof(*ip6h));
>  	skb_reset_network_header(skb);
>  
> @@ -716,7 +678,7 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  	ip6_flow_hdr(ip6h, dsfield,
>  		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
>  	ip6h->hop_limit = hop_limit;
> -	ip6h->nexthdr = proto;
> +	ip6h->nexthdr = IPPROTO_IPV6;
>  	ip6h->daddr = tuple->tun.src_v6;
>  	ip6h->saddr = tuple->tun.dst_v6;
>  	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
> @@ -729,12 +691,10 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  
>  static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
>  				  struct flow_offload_tuple *tuple,
> -				  struct in6_addr **ip6_daddr,
> -				  int encap_limit)
> +				  struct in6_addr **ip6_daddr)
>  {
>  	if (tuple->tun_num)
> -		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr,
> -						  encap_limit);
> +		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
>  
>  	return 0;
>  }
> @@ -1089,7 +1049,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
>  static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
>  					struct nf_flowtable *flow_table,
>  					struct flow_offload_tuple_rhash *tuplehash,
> -					struct sk_buff *skb, int encap_limit)
> +					struct sk_buff *skb)
>  {
>  	enum flow_offload_tuple_dir dir;
>  	struct flow_offload *flow;
> @@ -1100,11 +1060,8 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  
>  	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
> -	if (flow->tuplehash[!dir].tuple.tun_num) {
> +	if (flow->tuplehash[!dir].tuple.tun_num)
>  		mtu -= sizeof(*ip6h);
> -		if (encap_limit > 0)
> -			mtu -= 8; /* encap limit option */
> -	}
>  
>  	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
>  		return 0;
> @@ -1158,7 +1115,6 @@ unsigned int
>  nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  			  const struct nf_hook_state *state)
>  {
> -	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
>  	struct flow_offload_tuple_rhash *tuplehash;
>  	struct nf_flowtable *flow_table = priv;
>  	struct flow_offload_tuple *other_tuple;
> @@ -1177,8 +1133,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	if (tuplehash == NULL)
>  		return NF_ACCEPT;
>  
> -	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
> -					   encap_limit);
> +	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
>  	if (ret < 0)
>  		return NF_DROP;
>  	else if (ret == 0)
> @@ -1198,7 +1153,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	ip6_daddr = &other_tuple->src_v6;
>  
>  	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
> -				   &ip6_daddr, encap_limit) < 0)
> +				   &ip6_daddr) < 0)
>  		return NF_DROP;
>  
>  	switch (tuplehash->tuple.xmit_type) {
