Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F4231A046
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780667633; cv=none; b=mihAKWhAeyMxf/3MnP7x2KzoVfFaY433YylnrewfwSP8enOx7I6dck3t81hOznIPUfu1R+CGSZvByjNyrUepYrix87D2c3HxidR+ALS73Iozwfn7ij7gXLdbA2vQu8hRPmIXCf+OPS5TPicKOa3aWxG+Fswq4b57TWyXp0QnX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780667633; c=relaxed/simple;
	bh=+NVeeT5v0V1zgJMbHJN7Ha3aPT32Yy1/J1VdP/x1Sgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZyIFjX/gJGvdWZAbhoVf6LU1AWBQkyoWi/pnSUTYRLtcaurdZe03z0Y2Oh7dRGik9xx9LDcQht91luuJO7rfNZSfev9hIN8NaFUN8P7DwLlygm3spsqV60uztNROHHmqiwEVSvwvy+ctcTt+5x/q1UPO+e4tpFxqEWRxqw2088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6i7/eBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6i7/eBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF4F1F00893;
	Fri,  5 Jun 2026 13:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780667632;
	bh=iPzbLpzpMVb9VznJOZVEVr4d3VEgMc+wjh1QDrtMujY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U6i7/eBIljSVYn67Dt+wFyEiJg7CYYyzPfz9CgtYTIdn5z9thJ3P92av2h5ifrTHF
	 oIjnpNAxB/ezAAde5yu6B7GSzaXyqmjN/zxeTU00xN1MFLEUgaL4y+dndfeRCJ7rIF
	 kz6ERtk1cJS+fepBQ0JneyU1Yc9xJSn2oa3cUP0WcjdIbVBO2aeA12RU8D1+Yn2E27
	 l+imC6lHgRSGIXIp3bAUWWhGT0sbyXQQFfQdOCGU77p6duGKEuvlz+uZVfh6+TCMwL
	 /QGtIxDM5ZrjVVnlMc87U+nLAkqU76g9XAv7lRM/HBicFPvh4ziHCG48UhniKanKI3
	 GUGUif1Bx2kQA==
Date: Fri, 5 Jun 2026 15:53:50 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: flowtable: fix IP6IP6 tunnel offset
 double-count with vlan/pppoe encap
Message-ID: <aiLU7j2jzBob9u-1@lore-desk>
References: <20260604211700.253946-1-devnexen@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w5xnwBu8s2QhpGVo"
Content-Disposition: inline
In-Reply-To: <20260604211700.253946-1-devnexen@gmail.com>


--w5xnwBu8s2QhpGVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> nf_flow_ip6_tunnel_proto() stores the return value of ipv6_skip_exthdr()
> directly into ctx->tun.hdr_size and then does ctx->offset +=3D
> ctx->tun.hdr_size.
>=20
> ipv6_skip_exthdr() returns an offset measured from skb->data, i.e. its
> result already includes the "sizeof(*ip6h) + ctx->offset" start argument.
> So hdr_size ends up containing ctx->offset, and the subsequent
> "ctx->offset +=3D ctx->tun.hdr_size" counts the encap offset twice.
>=20
> This is harmless for a bare IP6IP6 packet, where ctx->offset is 0 on
> entry, which is why it has gone unnoticed. But nf_flow_skb_encap_protocol=
()
> advances ctx->offset by VLAN_HLEN / PPPOE_SES_HLEN before the tunnel
> parser runs, so for an IP6IP6 flow carried over vlan or pppoe both
> ctx->offset and ctx->tun.hdr_size are off by the encap length:
>=20
>   - nf_flow_tuple_ipv6() then reads the inner header at the wrong offset,
>     the computed tuple no longer matches the flowtable entry, and the
>     packet silently falls back to the slow path (IP6IP6 rx acceleration
>     stops working);
>   - on the forward path nf_flow_ip_tunnel_pop() would skb_pull() past the
>     inner header.
>=20
> The IPv4 sibling nf_flow_ip4_tunnel_proto() does this correctly: it stores
> a relative header length (iph->ihl << 2) and adds that to ctx->offset.
> Make the IPv6 path symmetric by storing the relative size.
>=20
> Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration=
")
> Signed-off-by: David Carlier <devnexen@gmail.com>

Hi David,

thx for fixing it. I developed the IP6IP6 vlan support using the veth as
underlying device. veth enables vlan rx/tx offload by default so I was
not able to spot the issue.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

Regards,
Lorenzo

> ---
>  net/netfilter/nf_flow_table_ip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 9c05a50d6013..4c6a68765c6b 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -366,7 +366,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowta=
ble_ctx *ctx,
>  		return false;
> =20
>  	if (nexthdr =3D=3D IPPROTO_IPV6) {
> -		ctx->tun.hdr_size =3D hdrlen;
> +		ctx->tun.hdr_size =3D hdrlen - ctx->offset;
>  		ctx->tun.proto =3D IPPROTO_IPV6;
>  	}
>  	ctx->offset +=3D ctx->tun.hdr_size;
> --=20
> 2.53.0
>=20

--w5xnwBu8s2QhpGVo
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaiLU7gAKCRA6cBh0uS2t
rLGuAP9j8yhbbbpflBrahUKbgwTOOQXFJieNvJDSsjNBepFCVwEA8xYnYInJG/2T
kKPKSCh/+Q0iVQA20RLpUZm5uIaGvQo=
=fyAj
-----END PGP SIGNATURE-----

--w5xnwBu8s2QhpGVo--
