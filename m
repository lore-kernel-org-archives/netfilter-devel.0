Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE6B3BBFAC;
	Tue,  9 Jun 2026 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005726; cv=none; b=J/T2xwvVz7DSQTZkx4mHXQrVISInoFTCnFIsS7YlAGcfKqGQPrbMOtaDqZ3uJJmtZeEv1+ZtyEQkZ4d4AnwGOC7zQ5GZfTjfL4x4ehSZ9dMivvRtINnLQdnsOnIOaq8+D90XG9yrXqnJU8Wiftv53zcaoSuYMEHUsN8sG8BqXD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005726; c=relaxed/simple;
	bh=ldWhcXnwh+A+XWhyxIjx0R8yNZMMzv9lZ1aS0VvRq4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bb+TzaZ2f0ipVG+Uran1H8RYkMTtR7b+Z4dZaHAwVrm3nSl14ZJ/eEzC/ednRu7JxhBTNkQGqo1ImhI6Zhk0FdBC5Pzd6AaDnjbE+n0N5FdP/upEUh81K6jMBOOcMsvEYiKF+cUhFmliRe1U23cyBU9fSwJoXkEOn4fu/JDFPa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PD4tQSfC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PD4tQSfC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5129460177;
	Tue,  9 Jun 2026 13:48:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781005715;
	bh=QRqBRPh48kXFvPRrxaw0XzUQjHrYbLrSEoU1hs+N5ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PD4tQSfCPqZRtYVfXg86OYvV02f0pmDA7e8RTlCABmmIzH7cybzmqVORO0liEoDDM
	 b8i2fX5dpPlVe9l9BHlD6D4VeFZEb22FF0K434zpyVD0ilc+wGGlCsjmJvFv1MhB7p
	 MQcNbIzhYxNtsKs1pWcXTIS7Zhy5Co2AR6iHNZAQZWHXEbiUd4wjzF90kUXXi65wGf
	 9fh1ohBhqzXC0kVTv7fUcXbUYCgEvaAfKMKQFeAwandq2juX74Fhf0pL3ZCYiEclyv
	 HUpP7pxpiCyVAe5Wgl7wjVZcLwv2YFQ7RrLS0g9docV8sAcSMyg9C1SxOz86w0DGNo
	 oXPQuFSaxj5wA==
Date: Tue, 9 Jun 2026 13:48:32 +0200
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
Message-ID: <aif9kL38LKNcX1Xu@chamomile>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
 <aidMPKrm9gOcPLW-@chamomile>
 <aifquGhK_Cijxq7m@lore-desk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aifquGhK_Cijxq7m@lore-desk>

On Tue, Jun 09, 2026 at 12:28:08PM +0200, Lorenzo Bianconi wrote:
> On Jun 09, Pablo Neira Ayuso wrote:
> > Hi Lorenzo,
> > 
> > On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> > > Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> > > pskb_may_pull() for header validation, aligning it with the approach
> > > used in nf_flow_ip4_tunnel_proto().
> > > Move ctx->offset update inside the IPPROTO_IPV6 conditional block since
> > > it should only be adjusted when a tunnel is actually detected.
> > > While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 constant
> > > when setting ctx->tun.proto.
> > > 
> > > Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > index 9c05a50d6013..2946399ab715 100644
> > > --- a/net/netfilter/nf_flow_table_ip.c
> > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
> > >  				     struct sk_buff *skb)
> > >  {
> > >  #if IS_ENABLED(CONFIG_IPV6)
> > > -	struct ipv6hdr *ip6h, _ip6h;
> > > +	struct ipv6hdr *ip6h;
> > >  	__be16 frag_off;
> > >  	u8 nexthdr;
> > >  	int hdrlen;
> > >  
> > > -	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
> > > -	if (!ip6h)
> > > +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
> > >  		return false;
> > >  
> > > +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
> > >  	if (ip6h->hop_limit <= 1)
> > >  		return false;
> > 
> > Not shown in the patch, but is there still a corner case here that
> > needs to be covered?
> > 
> > ipv6_skip_exthdr() uses skb_header_pointer() internal, then another
> > pskb_may_pull() is needed to make sure no other IPv6 extension header
> > sits between the outer and the inner IPPROTO_IPV6 header, allowing to
> > be in a non-linear area of the skb?        
> > 
> > > @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
> > >  
> > 
> > I mean:
> > 
> >         if (!pskb_may_pull(skb, hdrlen))
> >                 return false;
> > 
> > where hdrlen is what ipv6_skip_exthdr() returns.
> > 
> > Then, I think it should be safe to call skb_pull() on
> > ctx->tun.hdr_size.
> > 
> > Let me know, thanks.
> 
> I think you are right, here we need to run:
> 
> 	if (!pskb_may_pull(skb, hdrlen))
> 		return false;
> 
> in order to be sure we can pull ctx->tun.hdr_size in nf_flow_ip_tunnel_pop().
> Doing so, we can roll-back to the original skb_header_pointer() to access the
> outer ip6 header here. What do you think?

Yes, initial skb_header_pointer() then pskb_may_pull(skb, hdrlen) to
ensure the entire should be fine.

I think this need one more fix: This needs to resort to classic path
if there are intermediate extension headers sitting in between the
outer and inner headers in IP6IP6, ie. ipv6_ext_hdr() == true. Those
extensions need to be handled by the IPv6 stack.

nf_flow_ip6_tunnel_proto() needs to be fixed to deal with this. 
And I suspect nf_flow_ip4_tunnel_proto() with IP options have the same
problem, the flowtable need to resort to the classic stack path.

Thanks.
