Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87134F46D;
	Sat, 25 Jul 2026 09:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784972637; cv=none; b=PLTFNGGZxsZy6buQjs8nKzLz1kcy9AOqBGeK+6DK9GUUwhnZAG4BAc3Xn21v+LFDxYeUGecKQer21iuJocCjPYTo094Db8Iix77lCvT2GAWEyTUyW9d3MmlHNJ1cxffK/jAZ/Q2JQEHWTmCYHFQ05CuartGocO5Fyn2TewML3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784972637; c=relaxed/simple;
	bh=xadDKsLz3vbwIr6aH41Z7CaOY9noBVAbEIQlOHMSHxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZB3GTfGONqVq9OlsTJ25t8pvfTXpWIvvzgQU6hCue6tkxKdfw6+w1E2CuNSGcIhiJutAG/5ja7vI8w+QmlVbXuVi9ff2E2oMJbiy1RvmN1Ck8xFIL1ubBk1ry2oSn41BcYZnuWpp0DujfyDn7wa58xa69eTK2y+qzWEXQKxjq7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKSXMFOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKSXMFOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680AD1F000E9;
	Sat, 25 Jul 2026 09:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784972634;
	bh=ikxmqceKM6CjZZLgzbbGhufgOUwVYZSkPtOFLRTP18I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XKSXMFOlSOY8ipmQjwbmakbcMiVJ2AkXPTHbmESOEdgpZ6wa2tvbJ+GogVDk0xbQr
	 VkEKt3LdjKF1BPe/VeIDMbySuhj9ByoRG148y+x+m2xBXRw/a2rkaUWdOXbwW4XT+X
	 BujG3fgefDkLQTxT6XaV/kR19YqCwDtITqOqhg5500e/nfcpmYbQrLZpVj8kdJCbGa
	 Tol+ita7trBL5bCANIPw9/kTQz5eJJhrQFH6LaeQ3WAuOxWtfaD8RvvFKEhvJn/vvc
	 HrTp2KcXKc1rKIyhR/0WjKJTvYZWxdzruhjBXziIw7rcaz6elc1sMazW4J85z2JqpX
	 8XEuIHqGnOh2w==
Date: Sat, 25 Jul 2026 11:43:52 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
Message-ID: <amSFWElG-j_B8HBD@lore-desk>
References: <20260724-ip6ip6-route-lookup-fill_forward_path-v3-1-7b7991538614@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nrFEi88iiMHlAaLj"
Content-Disposition: inline
In-Reply-To: <20260724-ip6ip6-route-lookup-fill_forward_path-v3-1-7b7991538614@kernel.org>

--nrFEi88iiMHlAaLj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Reuse the flowi6 template t->fl.u.ip6 built by ip6_tnl_link_config() in
> ip6_tnl_fill_forward_path(), aligning the fast-path route lookup with
> the slow path in ipxip6_tnl_xmit(). This automatically inherits the
> correct conditional FLOWLABEL masking based on the
> IP6_TNL_F_USE_ORIG_FLOWLABEL flag.
>=20
> Return -EOPNOTSUPP when IP6_TNL_F_USE_ORIG_TCLASS,
> IP6_TNL_F_USE_ORIG_FLOWLABEL or IP6_TNL_F_USE_ORIG_FWMARK is set,
> or for collect_md tunnels, since fill_forward_path has no access to
> the original skb and cannot recover the per-packet traffic class,
> flowlabel, mark or tunnel destination needed for the route lookup.
>=20
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes in v3:
> - Return EOPNOTSUPP when IP6_TNL_F_USE_ORIG_TCLASS is set or for collect_=
md tunnels
> - Link to v2: https://lore.kernel.org/r/20260722-ip6ip6-route-lookup-fill=
_forward_path-v2-1-ff0b7b013699@kernel.org
>=20
> Changes in v2:
> - Reuse flowi6 template for the route lookup
> - Return EOPNOTSUPP if the tunnel is configured with
>   IP6_TNL_F_USE_ORIG_FWMARK or IP6_TNL_F_USE_ORIG_FLOWLABEL
> - Use flowi6 fields to setup net_device_path
> - Link to v1: https://lore.kernel.org/r/20260708-ip6ip6-route-lookup-fill=
_forward_path-v1-1-863b9647102e@kernel.org
> ---
>  net/ipv6/ip6_tunnel.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)

commenting on sashiko's report:
https://sashiko.dev/#/patchset/20260724-ip6ip6-route-lookup-fill_forward_pa=
th-v3-1-7b7991538614%40kernel.org

- This is a pre-existing issue, but since you are explicitly handling
  collect_md tunnels here, should the IPv4 equivalent in net/ipv4/ipip.c
  also reject collect_md tunnels?
  - this issue has not been introduced by this patch and it is fixed in
    the following patch:
    https://lore.kernel.org/netdev/20260725-ipip-fill-forward-path-fix-v1-1=
-bc69fd3127d5@kernel.org/T/#u

- This isn't a bug introduced by this patch, but does this lockless memcpy =
of
  t->fl.u.ip6 and t->parms risk data corruption from concurrent updates?
  - As pointed out by sashiko, this issue has not been introduced by this p=
atch
    and it is present in the slow-path as well (ipxip6_tnl_xmit()). I guess=
 we
    should fix it with a dedicated patch.

Regards,
Lorenzo

>=20
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index bf8e40af60b0..97c3f61d627b 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1845,24 +1845,30 @@ static int ip6_tnl_fill_forward_path(struct net_d=
evice_path_ctx *ctx,
>  				     struct net_device_path *path)
>  {
>  	struct ip6_tnl *t =3D netdev_priv(ctx->dev);
> -	struct flowi6 fl6 =3D {
> -		.daddr =3D t->parms.raddr,
> -	};
>  	struct dst_entry *dst;
> +	struct flowi6 fl6;
>  	int err;
> =20
> -	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT)) {
> -		/* encaplimit option is currently not supported is
> -		 * sw-acceleration path.
> -		 */
> +	if (t->parms.flags & (IP6_TNL_F_USE_ORIG_TCLASS |
> +			      IP6_TNL_F_USE_ORIG_FLOWLABEL |
> +			      IP6_TNL_F_USE_ORIG_FWMARK))
>  		return -EOPNOTSUPP;
> -	}
> +
> +	if (t->parms.collect_md)
> +		return -EOPNOTSUPP;
> +
> +	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> +		return -EOPNOTSUPP;
> +
> +	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
> +	fl6.flowi6_mark =3D t->parms.fwmark;
> +	fl6.flowi6_proto =3D 0;
> =20
>  	dst =3D ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
>  	if (!dst->error) {
>  		path->type =3D DEV_PATH_TUN;
> -		path->tun.src_v6 =3D t->parms.laddr;
> -		path->tun.dst_v6 =3D t->parms.raddr;
> +		path->tun.src_v6 =3D fl6.saddr;
> +		path->tun.dst_v6 =3D fl6.daddr;
>  		path->tun.l3_proto =3D IPPROTO_IPV6;
>  		path->dev =3D ctx->dev;
>  		ctx->dev =3D dst->dev;
>=20
> ---
> base-commit: 89d8006259b81dd25c962f6cc8d7ab268d6ea426
> change-id: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9
>=20
> Best regards,
> --=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>=20

--nrFEi88iiMHlAaLj
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCamSFWAAKCRA6cBh0uS2t
rCoFAQCkprH2HmRiIk/GIaCfKY0lpX04YV/Ko6Dedd/TVNANsAEAjnKuqcCas5Xc
2nlJH7d5SUXz9YzwA0PvduFoFs6EvQ4=
=Ucx8
-----END PGP SIGNATURE-----

--nrFEi88iiMHlAaLj--
