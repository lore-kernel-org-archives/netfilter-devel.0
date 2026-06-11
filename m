Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA413101C8;
	Thu, 11 Jun 2026 08:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781166249; cv=none; b=cInC4bQ5Q5lUfuTQZTv54G8/zHv5AfeOEW468kVFuRKenKTjp1eTOgBfPvtJAazq9Tlbk8hySsPn3qpgYGjyEXzib0WgU+gd7fWDqYxhvkGeax//qdpo9JxftKegaVSm1WEbEeFYyM96nczz7mWwm1RBCFv00yBzBvgnsG5OtYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781166249; c=relaxed/simple;
	bh=IO9rJs7T38yo+TK6izt9duvp55N+9i3j+3Atz0x5s1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBW2tETAC7D7l+w2uXk0vR4N3YiRmGUgJeYKBOWWcMxN0tgy4mmDhMop2ZWrUtZp/IRA5+tqHfPvAPo8qWiAPZXz9st9Jyh8WLfuOE3Q+WxqcVkFqbmTsfuC06LfZsRc0Yio9Hpi2uEf9YIeJdsmadhb3lLpEybptJeT7RQEN3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZWso0TR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZWso0TR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D671F00893;
	Thu, 11 Jun 2026 08:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781166247;
	bh=Yjg0i8SR0KD3kOfgggb+4qce8niDREk8xow7m/nK0vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DZWso0TRqEKL3AK96G0lqFXNCZZvH9jOeq9NnuIuqvEeDHHEF4abMHvdStGGQaJo6
	 yRCSiiEJlf8INlzvceNajfri2LxQZmMmVFvaFmV9OrFQD37PLzGTyKC4NKfmre1fD6
	 APNde28aEMORP8o6ZqXZGk7ADhohwTiIg40pr83pN/i678cY/2ahaKnN/+MOAj6rmg
	 Kn7ett0M/FW7ycEPUGQE1xBIp3VPZ4bbe90at3fEmmok7TZcRbKy8az4/VWx8odwcN
	 uyWwahD6Cuj2hqkYUFQnGGF8gtRJ/PC9Rmq4ZqPAfHPiRcfgj3PtZsqKn9b1WRV1M+
	 TGzZqwMTKhDmw==
Date: Thu, 11 Jun 2026 10:24:05 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: use pskb_may_pull() in
 nf_flow_ip6_tunnel_proto()
Message-ID: <aipwpXlisPVxO2ig@lore-desk>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
 <aidMPKrm9gOcPLW-@chamomile>
 <aifquGhK_Cijxq7m@lore-desk>
 <aif9kL38LKNcX1Xu@chamomile>
 <aigHh5cBKc12frX2@lore-desk>
 <aih5uTn97bK29LDR@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LMbnxSaivFP16/g/"
Content-Disposition: inline
In-Reply-To: <aih5uTn97bK29LDR@chamomile>


--LMbnxSaivFP16/g/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> On Tue, Jun 09, 2026 at 02:31:03PM +0200, Lorenzo Bianconi wrote:
> > > On Tue, Jun 09, 2026 at 12:28:08PM +0200, Lorenzo Bianconi wrote:
> > > > On Jun 09, Pablo Neira Ayuso wrote:
> > > > > Hi Lorenzo,
> > > > >=20
> > > > > On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> > > > > > Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> > > > > > pskb_may_pull() for header validation, aligning it with the app=
roach
> > > > > > used in nf_flow_ip4_tunnel_proto().
> > > > > > Move ctx->offset update inside the IPPROTO_IPV6 conditional blo=
ck since
> > > > > > it should only be adjusted when a tunnel is actually detected.
> > > > > > While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 =
constant
> > > > > > when setting ctx->tun.proto.
> > > > > >=20
> > > > > > Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw a=
cceleration")
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > ---
> > > > > >  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
> > > > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > > >=20
> > > > > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/n=
f_flow_table_ip.c
> > > > > > index 9c05a50d6013..2946399ab715 100644
> > > > > > --- a/net/netfilter/nf_flow_table_ip.c
> > > > > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > > > > @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(stru=
ct nf_flowtable_ctx *ctx,
> > > > > >  				     struct sk_buff *skb)
> > > > > >  {
> > > > > >  #if IS_ENABLED(CONFIG_IPV6)
> > > > > > -	struct ipv6hdr *ip6h, _ip6h;
> > > > > > +	struct ipv6hdr *ip6h;
> > > > > >  	__be16 frag_off;
> > > > > >  	u8 nexthdr;
> > > > > >  	int hdrlen;
> > > > > > =20
> > > > > > -	ip6h =3D skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), =
&_ip6h);
> > > > > > -	if (!ip6h)
> > > > > > +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
> > > > > >  		return false;
> > > > > > =20
> > > > > > +	ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + ctx->of=
fset);
> > > > > >  	if (ip6h->hop_limit <=3D 1)
> > > > > >  		return false;
> > > > >=20
> > > > > Not shown in the patch, but is there still a corner case here that
> > > > > needs to be covered?
> > > > >=20
> > > > > ipv6_skip_exthdr() uses skb_header_pointer() internal, then anoth=
er
> > > > > pskb_may_pull() is needed to make sure no other IPv6 extension he=
ader
> > > > > sits between the outer and the inner IPPROTO_IPV6 header, allowin=
g to
> > > > > be in a non-linear area of the skb?       =20
> > > > >=20
> > > > > > @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct=
 nf_flowtable_ctx *ctx,
> > > > > > =20
> > > > >=20
> > > > > I mean:
> > > > >=20
> > > > >         if (!pskb_may_pull(skb, hdrlen))
> > > > >                 return false;
> > > > >=20
> > > > > where hdrlen is what ipv6_skip_exthdr() returns.
> > > > >=20
> > > > > Then, I think it should be safe to call skb_pull() on
> > > > > ctx->tun.hdr_size.
> > > > >=20
> > > > > Let me know, thanks.
> > > >=20
> > > > I think you are right, here we need to run:
> > > >=20
> > > > 	if (!pskb_may_pull(skb, hdrlen))
> > > > 		return false;
> > > >=20
> > > > in order to be sure we can pull ctx->tun.hdr_size in nf_flow_ip_tun=
nel_pop().
> > > > Doing so, we can roll-back to the original skb_header_pointer() to =
access the
> > > > outer ip6 header here. What do you think?
> > >=20
> > > Yes, initial skb_header_pointer() then pskb_may_pull(skb, hdrlen) to
> > > ensure the entire should be fine.
> > >=20
> > > I think this need one more fix: This needs to resort to classic path
> > > if there are intermediate extension headers sitting in between the
> > > outer and inner headers in IP6IP6, ie. ipv6_ext_hdr() =3D=3D true. Th=
ose
> > > extensions need to be handled by the IPv6 stack.
> >=20
> > In my setup we have just a single Destination Option extension header (=
60)
> > between the outer and the inner IPV6 headers. In order to check if we h=
ave
> > other extensions headers other than Destination Option (and if so, send=
 the
> > packet the networking stack) I guess we need to implement something sim=
ilar
> > to ipv6_skip_exthdr(), agree?
>=20
> Maybe simpler check? If nexthdr is immediately IP6IP6 (ie. no
> intermediate headers are in place), then handle this from the
> flowtable datapath, otherwise fallback to classic. Thus, no new
> special parser function is needed.

Hi Pablo,

ack, I agree. I guess we can limit the flowtable acceleration to the case o=
f a
IP6IP6 tunnel created with encaplimit set to none:

$ip link add name tun0 type ip6tnl local <local> remote <remote> encaplimit=
 none

>=20
> > > nf_flow_ip6_tunnel_proto() needs to be fixed to deal with this.=20
> >=20
> > Do you want to do it with a dedicated patch or do you prefer to do it i=
n this
> > one?
>=20
> I think a single patch to fix the issues in nf_flow_ip6_tunnel_proto()
> should be fine.

I cooked this patch, it works fine. What do you think?

Regards,
Lorenzo

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table=
_ip.c
index 9c05a50d6013..5cb50414a491 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -347,29 +347,20 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
 				     struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct ipv6hdr *ip6h, _ip6h;
-	__be16 frag_off;
-	u8 nexthdr;
-	int hdrlen;
+	struct ipv6hdr *ip6h;
=20
-	ip6h =3D skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
-	if (!ip6h)
+	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
 		return false;
=20
+	ip6h =3D (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	if (ip6h->hop_limit <=3D 1)
 		return false;
=20
-	nexthdr =3D ip6h->nexthdr;
-	hdrlen =3D ipv6_skip_exthdr(skb, sizeof(*ip6h) + ctx->offset, &nexthdr,
-				  &frag_off);
-	if (hdrlen < 0)
-		return false;
-
-	if (nexthdr =3D=3D IPPROTO_IPV6) {
-		ctx->tun.hdr_size =3D hdrlen;
-		ctx->tun.proto =3D IPPROTO_IPV6;
+	if (ip6h->nexthdr =3D=3D IPPROTO_IPV6) {
+		ctx->tun.proto =3D ip6h->nexthdr;
+		ctx->tun.hdr_size =3D sizeof(*ip6h);
+		ctx->offset +=3D ctx->tun.hdr_size;
 	}
-	ctx->offset +=3D ctx->tun.hdr_size;
=20
 	return true;
 #else
@@ -648,25 +639,19 @@ static int nf_flow_tunnel_v4_push(struct net *net, st=
ruct sk_buff *skb,
 	return 0;
 }
=20
-struct ipv6_tel_txoption {
-	struct ipv6_txoptions ops;
-	__u8 dst_opt[8];
-};
-
 static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 				      struct flow_offload_tuple *tuple,
-				      struct in6_addr **ip6_daddr,
-				      int encap_limit)
+				      struct in6_addr **ip6_daddr)
 {
 	struct ipv6hdr *ip6h =3D (struct ipv6hdr *)skb_network_header(skb);
-	u8 hop_limit =3D ip6h->hop_limit, proto =3D IPPROTO_IPV6;
 	struct rtable *rt =3D dst_rtable(tuple->dst_cache);
 	__u8 dsfield =3D ipv6_get_dsfield(ip6h);
 	struct flowi6 fl6 =3D {
 		.daddr =3D tuple->tun.src_v6,
 		.saddr =3D tuple->tun.dst_v6,
-		.flowi6_proto =3D proto,
+		.flowi6_proto =3D IPPROTO_IPV6,
 	};
+	u8 hop_limit =3D ip6h->hop_limit;
 	int err, mtu;
 	u32 headroom;
=20
@@ -674,41 +659,18 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net=
, struct sk_buff *skb,
 	if (err)
 		return err;
=20
-	skb_set_inner_ipproto(skb, proto);
+	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
 	headroom =3D sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
 		   rt->dst.header_len;
-	if (encap_limit)
-		headroom +=3D 8;
 	err =3D skb_cow_head(skb, headroom);
 	if (err)
 		return err;
=20
 	skb_scrub_packet(skb, true);
 	mtu =3D dst_mtu(&rt->dst) - sizeof(*ip6h);
-	if (encap_limit)
-		mtu -=3D 8;
 	mtu =3D max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
=20
-	if (encap_limit > 0) {
-		struct ipv6_tel_txoption opt =3D {
-			.dst_opt[2] =3D IPV6_TLV_TNL_ENCAP_LIMIT,
-			.dst_opt[3] =3D 1,
-			.dst_opt[4] =3D encap_limit,
-			.dst_opt[5] =3D IPV6_TLV_PADN,
-			.dst_opt[6] =3D 1,
-		};
-		struct ipv6_opt_hdr *hopt;
-
-		opt.ops.dst1opt =3D (struct ipv6_opt_hdr *)opt.dst_opt;
-		opt.ops.opt_nflen =3D 8;
-
-		hopt =3D skb_push(skb, ipv6_optlen(opt.ops.dst1opt));
-		memcpy(hopt, opt.ops.dst1opt, ipv6_optlen(opt.ops.dst1opt));
-		hopt->nexthdr =3D IPPROTO_IPV6;
-		proto =3D NEXTHDR_DEST;
-	}
-
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
=20
@@ -716,7 +678,7 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, =
struct sk_buff *skb,
 	ip6_flow_hdr(ip6h, dsfield,
 		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
 	ip6h->hop_limit =3D hop_limit;
-	ip6h->nexthdr =3D proto;
+	ip6h->nexthdr =3D IPPROTO_IPV6;
 	ip6h->daddr =3D tuple->tun.src_v6;
 	ip6h->saddr =3D tuple->tun.dst_v6;
 	ipv6_hdr(skb)->payload_len =3D htons(skb->len - sizeof(*ip6h));
@@ -729,12 +691,10 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net=
, struct sk_buff *skb,
=20
 static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
-				  struct in6_addr **ip6_daddr,
-				  int encap_limit)
+				  struct in6_addr **ip6_daddr)
 {
 	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr,
-						  encap_limit);
+		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr);
=20
 	return 0;
 }
@@ -1089,7 +1049,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx=
 *ctx, struct sk_buff *skb,
 static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 					struct nf_flowtable *flow_table,
 					struct flow_offload_tuple_rhash *tuplehash,
-					struct sk_buff *skb, int encap_limit)
+					struct sk_buff *skb)
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -1100,11 +1060,8 @@ static int nf_flow_offload_ipv6_forward(struct nf_fl=
owtable_ctx *ctx,
 	flow =3D container_of(tuplehash, struct flow_offload, tuplehash[dir]);
=20
 	mtu =3D flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num) {
+	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -=3D sizeof(*ip6h);
-		if (encap_limit > 0)
-			mtu -=3D 8; /* encap limit option */
-	}
=20
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
@@ -1158,7 +1115,6 @@ unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
 {
-	int encap_limit =3D IPV6_DEFAULT_TNL_ENCAP_LIMIT;
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table =3D priv;
 	struct flow_offload_tuple *other_tuple;
@@ -1177,8 +1133,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff =
*skb,
 	if (tuplehash =3D=3D NULL)
 		return NF_ACCEPT;
=20
-	ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
-					   encap_limit);
+	ret =3D nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret =3D=3D 0)
@@ -1198,7 +1153,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff =
*skb,
 	ip6_daddr =3D &other_tuple->src_v6;
=20
 	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   &ip6_daddr, encap_limit) < 0)
+				   &ip6_daddr) < 0)
 		return NF_DROP;
=20
 	switch (tuplehash->tuple.xmit_type) {

>=20
> My understanding is that IP6IP6 tunnels are special, because it is
> handled in the received path as local traffic, then decapsulation
> happens and packet follows local output path. This is different to
> what we already have where packets follow forwarding path, not local
> input. The flowtable should only pull the outer IP6 header.
>=20
> > > And I suspect nf_flow_ip4_tunnel_proto() with IP options have the same
> > > problem, the flowtable need to resort to the classic stack path.
> >=20
> > In the IPv4 case, if the packet has options nf_flow_ip4_tunnel_proto() =
will
> > return false and so the packet will be sent to the networking stack.
>=20
> OK, then IPv4 is fine, thanks for explaining.

--LMbnxSaivFP16/g/
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaipwpQAKCRA6cBh0uS2t
rIkbAP4hcapcj6PpaqksT5TiwKMT9yXGQnldZYY8WDBDiqvTQwEArWT4NOoXcvxR
HONktiBhKWlH+TNyLmhA+G0r3cQFPgQ=
=7uKb
-----END PGP SIGNATURE-----

--LMbnxSaivFP16/g/--
