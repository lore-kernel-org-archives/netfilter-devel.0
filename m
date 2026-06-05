Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B434B8DCB
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780673182; cv=none; b=tV/t0jk27DgGAqSzdHUP912MRf16Zem3iKmKIIIxWOskl9FROnsfKRCNSZN/21IwzoDwDA7Ok/U3YjFtsfgh83rTVA48gh5OuHo3IsXYJi8BqQBwwLiUeFvUpklu9Lg8IqMTF0upUkebhoI4gMRUDNiOpR9j2jukaAMKUFcebfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780673182; c=relaxed/simple;
	bh=3fI7waF0fxsIdqMzvcIHcdxZ4xO94+pAPd6QEDaMwDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/quGDt/V7svvUuVJmmvArDWZ6HXsEEGGlNvXe4H/ovJawd9+BL4z/q5gsUMc8CR0/YstjK43X407GfLRoNDGyx5RfgYyXITRD32AKxzAdEzTB5gCohnMW9SezZpC3b57aVIhKytz/8OIQOxTZEXSXXxeyI6bf99MGvakgKxTgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSY5dlz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSY5dlz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D0F1F00893;
	Fri,  5 Jun 2026 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780673181;
	bh=UY+EGrBtwnIaEU8mRKjO2msseRLHIP00XWV1KkbytPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jSY5dlz19+Z+nTE8N+F+mMsR74BtWDNbHMQhOLaqNaDcq/9cDXOvd4V3O5D1e8FiY
	 NyEifijMxZmNSSLpactZUr706PrZJfdFdM4oAWItmQmudolcUYsPf8xeX9K/AH3NWD
	 zdbEd/voY4IJ5m2cV37FXrrE9qgD95UxVRfR8cfFJkJaOGa26gWdySkE9/AO8h/M7G
	 BWFmJdvv7iu297s6sw1M40tc1YfMWAfLf46Z2K8VyiT5D+8YgjeEsO8jq7AO1e/4zO
	 LXROPvCF58JZ23FbjUcryDpcdgvDWMuZpX/nMfaqobZ/1tTpnOoHZq/cYOfDJnhnUR
	 ht0BvzB95raxQ==
Date: Fri, 5 Jun 2026 17:26:19 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: David Carlier <devnexen@gmail.com>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: flowtable: fix IP6IP6 tunnel offset
 double-count with vlan/pppoe encap
Message-ID: <aiLqm4MYoR0CZqfW@lore-desk>
References: <20260604211700.253946-1-devnexen@gmail.com>
 <aiLU7j2jzBob9u-1@lore-desk>
 <aiLohUmGT7Dto0TU@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2nkKv1UNiCu+ux+V"
Content-Disposition: inline
In-Reply-To: <aiLohUmGT7Dto0TU@chamomile>


--2nkKv1UNiCu+ux+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Jun 05, 2026 at 03:53:50PM +0200, Lorenzo Bianconi wrote:
> > > nf_flow_ip6_tunnel_proto() stores the return value of ipv6_skip_exthd=
r()
> > > directly into ctx->tun.hdr_size and then does ctx->offset +=3D
> > > ctx->tun.hdr_size.
> > >=20
> > > ipv6_skip_exthdr() returns an offset measured from skb->data, i.e. its
> > > result already includes the "sizeof(*ip6h) + ctx->offset" start argum=
ent.
> > > So hdr_size ends up containing ctx->offset, and the subsequent
> > > "ctx->offset +=3D ctx->tun.hdr_size" counts the encap offset twice.
> > >=20
> > > This is harmless for a bare IP6IP6 packet, where ctx->offset is 0 on
> > > entry, which is why it has gone unnoticed. But nf_flow_skb_encap_prot=
ocol()
> > > advances ctx->offset by VLAN_HLEN / PPPOE_SES_HLEN before the tunnel
> > > parser runs, so for an IP6IP6 flow carried over vlan or pppoe both
> > > ctx->offset and ctx->tun.hdr_size are off by the encap length:
> > >=20
> > >   - nf_flow_tuple_ipv6() then reads the inner header at the wrong off=
set,
> > >     the computed tuple no longer matches the flowtable entry, and the
> > >     packet silently falls back to the slow path (IP6IP6 rx accelerati=
on
> > >     stops working);
> > >   - on the forward path nf_flow_ip_tunnel_pop() would skb_pull() past=
 the
> > >     inner header.
> > >=20
> > > The IPv4 sibling nf_flow_ip4_tunnel_proto() does this correctly: it s=
tores
> > > a relative header length (iph->ihl << 2) and adds that to ctx->offset.
> > > Make the IPv6 path symmetric by storing the relative size.
> > >=20
> > > Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw accelera=
tion")
> > > Signed-off-by: David Carlier <devnexen@gmail.com>
> >=20
> > Hi David,
> >=20
> > thx for fixing it. I developed the IP6IP6 vlan support using the veth as
> > underlying device. veth enables vlan rx/tx offload by default so I was
> > not able to spot the issue.
>=20
> One question when looking at this code:
>=20
> In nf_flow_ip6_tunnel_proto():
>=20
>         if (nexthdr =3D=3D IPPROTO_IPV6) {
>                 ctx->tun.hdr_size =3D hdrlen - ctx->offset;
>                 ctx->tun.proto =3D IPPROTO_IPV6;
>         }
>         ctx->offset +=3D ctx->tun.hdr_size;
>=20
> ctx->offset is bumped out of the branch.
>=20
> and nf_flow_ip4_tunnel_proto():
>=20
>         if (iph->protocol =3D=3D IPPROTO_IPIP) {
>                 ctx->tun.proto =3D IPPROTO_IPIP;
>                 ctx->tun.hdr_size =3D size;
>                 ctx->offset +=3D size;
>         }
>=20
> I think these checks are superfluous at this stage:
>=20
> if (nexthdr =3D=3D IPPROTO_IPV6) {
>=20
> if (iph->protocol =3D=3D IPPROTO_IPIP) {
>=20
> because only ipip and ip6ip6 is supported.

In this series [0] I modified a bit this code to support the mixed cases
(SIT and IPv4 over IPv6).

Regards,
Lorenzo

[0] https://lore.kernel.org/netfilter-devel/20260531-b4-flowtable-sw-accel-=
ip6ip-v3-0-56a2826f3279@kernel.org/

--2nkKv1UNiCu+ux+V
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaiLqmwAKCRA6cBh0uS2t
rE9rAP42molsrHGNg51PlEzGg2wUBJP07zStF6qAM4z/VoZIJQD+OFi/nFO2gMWt
RrnxB5tFgMmVFtMBpqhir10ewP8eWAg=
=82qT
-----END PGP SIGNATURE-----

--2nkKv1UNiCu+ux+V--
