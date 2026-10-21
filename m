Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792568811;
	b=Nu8bmpgCYdU6zXrfwGt+1bpWy+hcy9GH067F7gti1yMBUrtSj9tTo/yjhCgHzs1e/7IN
	 06VyRcqztINpDRVYSzGBXvpcOhMFTJDmNy8rwZq2DGTGFGVQ+N+whnvmPvkLNUqC7bUJh
	 hTLTACfBEvdIU4dyHniH1CgvaEdO0YTUkKnLVzz9NpYoH85uePSmehU934NrBpE7IlG00
	 d0lKMm01ssEc9BZoOzs446iwJ0E2j0XIqzgZSSR0RjX7rI6nOWOZy18Ib+l/naDKWo9l4
	 c9AtOnsMIPhU6davpvLjw6xHCDA6sI0bOY8PisItY7sE0KHWmx81rR3bpQxlhcmxVmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568811;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9zUq4YV4CqgCorW58QUwKR+mbWvZVyMsaKvt2an9aE8=;
	b=x2KBzCs8oeayc7HPiL2V+StdsGfZS6ilHGHkjhkPB9UkMYXV6s1P8VKhbO3ko1wtyTdg
	 xqWGK0jk/LirMrnEy56pKyhqGGDdw0cP5+6o/oRVF66ZhZxdB056yrBnC74GMO+09zRtN
	 Yf5sJVjvu8odrT1rh2v/ElKoRBNrtPCya1d+Vjx+bh19kNfMgnkeqJl8l5zKE23avSEhp
	 Mh8Y1LpX0LFyO8T1fWyq82nQD1paTisVKZNcy4octLZlUfmr+aBVrc9QxBpBwEwjIHPts
	 ap3zXpHjQEhQfenrJFMbyyH9YPOkF8tE48P87ham3t7cYzlnbdHYaGJdLaM7fLS/UOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lxy9nmMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF52606A339
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lxy9nmMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3A21F000CA;
	Wed, 21 Oct 2026 07:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792568810;
	bh=9zUq4YV4CqgCorW58QUwKR+mbWvZVyMsaKvt2an9aE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lxy9nmMf3EtCDJ2ZRj9PW0y0uAFvHBUidGFdFTmAEFSuV+LBi7KEBNjinnA6Fk2Q9
	 /r0FNpSeuGETvlK5ezgaimOgnTIerFCrb+tYYT3xP2JQLZpp0y8oY2mexbKbxGCDFy
	 8XAVCelO07TKztUsduw3PPrv4kqq6dZMmKlz+1OeRpLmkUdGUoHc1in+CBLzhALvAV
	 pN0WRqNTpAPci6HquTT5YMQgAw8izq5/btjlvl6cXdyOpoCa5DO/T7KjRnhWwYDsTD
	 OFUTUEAtrbRv6+HptfJjJXOi3mZSa5eBeoTpdbgTmPiSkZSs/ZJVE51Ccbr4lSJeIQ
	 XcLvFfp702gEg==
Date: Wed, 21 Oct 2026 09:46:48 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: use skb_pull_rcsum() to pull
 IPIP tunnel header
Message-ID: <atht6OHisTqDHk0u@lore-desk>
References: <20261020222909.1937894-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gM6ahf8zET21bm04"
Content-Disposition: inline
In-Reply-To: <20261020222909.1937894-1-pablo@netfilter.org>

--gM6ahf8zET21bm04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Use skb_pull_rcsum() to pop the IPIP and IP6IP6 tunnel header so this
> works with CHECKSUM_COMPLETE.
>=20
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  net/netfilter/nf_flow_table_ip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index bb894c4f2b4a..f9b6119c9db5 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -370,7 +370,7 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable=
_ctx *ctx,
>  	    ctx->tun.inner_proto !=3D IPPROTO_IPV6)
>  		return;
> =20
> -	skb_pull(skb, ctx->tun.hdr_size);
> +	skb_pull_rcsum(skb, ctx->tun.hdr_size);
>  	skb_reset_network_header(skb);
>  }
> =20
> --=20
> 2.47.3
>=20

--gM6ahf8zET21bm04
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCatht6AAKCRA6cBh0uS2t
rI7xAQDHv7Ik1gdkIsHYvDjfX9BISdGsjPaxFpNcJDJQ64YL1AD/RAZrIWJP3aCi
wl24kaLCEiEM/pPW4KFbE+xq5b0wlg8=
=M6rx
-----END PGP SIGNATURE-----

--gM6ahf8zET21bm04--
