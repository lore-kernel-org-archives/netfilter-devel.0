Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA714A60C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732055926; cv=none; b=CetyPwojjdeHOvUQ4DDQKIZE7Z3j9GVDpjxF+HKbdWXrDjDz1WDoa7tVL9ZXJieroMHqMbaJPLp+6tOMMJ9Sl2qNVUFgJ3OILP4vIeSbs/7JHwn0Zz6+V3PkkA/NTyeEvFX8C90DGXzxWEaGxV2Y9ZxTrBmble0a2bw49nSpY24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732055926; c=relaxed/simple;
	bh=aYWtOhF1d0RR+0S9l2377tJ27r6mTHMHmzgoYdl47HM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8Oh2IEXcaLTc5ZAdZrp0GP76CWtag1VNLVbsA+3mX4sQ31Fx0GqrYGui/goHRIAJY038NM3iD7rB06CBMCKnbaP3YYed2EtJ4YbtJxeMePkueHGheQLFDKcuLOiGswFQqnuPuRusO+6rnoy+hSHfq8d7yQI/PNxFTvvkahgLeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=QP6vltnT; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QP6vltnT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+5yDuvFHZTr/KKBSAKotLargkkCP21PRLgo4x9auzl0=; b=QP6vltnT8DNNOgBM3bRe2/Sdrn
	DaorfwvZBL2zs6rMmwMuPslA6hVN7gruwxnwmCgIMphjOs/z2IAzATmN+CsbmVTJ8pLOwdKXGe8oP
	bnAQ90UmsmIBNPIXjMpZiecUiwkMB6rA0mpMM5VqtSR2ZPeGoa4oZKwOaHt0DD8VH2DyYWDt0CsWY
	ungYUhURh0hk+MfTekOzeEeyOPxF1+88dtAKY3Ntzor0e2sBNgDMLIrzZFauIUDrSVgGBSGybAUY4
	VjvNb7ENAHdbyFCZ92hwwNKUIqxfbu4QM5paIgF7xWvERc1GCrkpl0/UJqRxB5qggSOv800ZgEyK9
	p+ddT/WA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tDWrq-009wWQ-2u;
	Tue, 19 Nov 2024 22:38:42 +0000
Date: Tue, 19 Nov 2024 22:38:41 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 2/2] nft: Drop interface mask leftovers from
 post_parse callbacks
Message-ID: <20241119223841.GC3017153@celephais.dreamlands>
References: <20241119220325.30700-1-phil@nwl.cc>
 <20241119220325.30700-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cFBfXFURHoLcgmoB"
Content-Disposition: inline
In-Reply-To: <20241119220325.30700-2-phil@nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--cFBfXFURHoLcgmoB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-11-19, at 23:03:25 +0100, Phil Sutter wrote:
> Fixed commit only adjusted the IPv4-specific callback for unclear
> reasons.
>=20
> Fixes: fe70364b36119 ("xshared: Do not populate interface masks per defau=
lt")
> Cc: Jeremy Sowden <jeremy@azazel.net>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Jeremy Sowden <jeremy@azazel.net>

> ---
> Changes since v1:
> - New patch
> ---
>  iptables/nft-arp.c | 3 ---
>  iptables/xshared.c | 5 -----
>  iptables/xshared.h | 1 -
>  3 files changed, 9 deletions(-)
>=20
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index c11d64c368638..fa2dd558b1f89 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -459,10 +459,7 @@ static void nft_arp_post_parse(int command,
>  	cs->arp.arp.invflags =3D args->invflags;
> =20
>  	memcpy(cs->arp.arp.iniface, args->iniface, IFNAMSIZ);
> -	memcpy(cs->arp.arp.iniface_mask, args->iniface_mask, IFNAMSIZ);
> -
>  	memcpy(cs->arp.arp.outiface, args->outiface, IFNAMSIZ);
> -	memcpy(cs->arp.arp.outiface_mask, args->outiface_mask, IFNAMSIZ);
> =20
>  	cs->arp.counters.pcnt =3D args->pcnt_cnt;
>  	cs->arp.counters.bcnt =3D args->bcnt_cnt;
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index 2a5eef09c75de..2f663f9762016 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -2104,12 +2104,7 @@ void ipv6_post_parse(int command, struct iptables_=
command_state *cs,
>  	cs->fw6.ipv6.invflags =3D args->invflags;
> =20
>  	memcpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
> -	memcpy(cs->fw6.ipv6.iniface_mask,
> -	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
> -
>  	memcpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
> -	memcpy(cs->fw6.ipv6.outiface_mask,
> -	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
> =20
>  	if (args->goto_set)
>  		cs->fw6.ipv6.flags |=3D IP6T_F_GOTO;
> diff --git a/iptables/xshared.h b/iptables/xshared.h
> index a111e79793b54..af756738e7c44 100644
> --- a/iptables/xshared.h
> +++ b/iptables/xshared.h
> @@ -262,7 +262,6 @@ struct xtables_args {
>  	uint8_t		flags;
>  	uint16_t	invflags;
>  	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
> -	unsigned char	iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
>  	char		bri_iniface[IFNAMSIZ], bri_outiface[IFNAMSIZ];
>  	bool		goto_set;
>  	const char	*shostnetworkmask, *dhostnetworkmask;
> --=20
> 2.47.0
>=20

--cFBfXFURHoLcgmoB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc9E3AACgkQKYasCr3x
BA3R/g//cketH+r3sABDQ/e+b11NHfM2uIHH02o3TQpIQVXQucvvN7Nda7k0TaUA
hiXTNiqH9x/k8dQuSQLP/ORlvHZSibOqJiXouHGcGXxuhE2+gmuKA4jLHC2eJMR1
t0fT0rHZP/uv4h87UigNv+ALU0k4pvgf4ySLzzxmWf8jIHH0AytVipfSorgnO5Ni
2/Pcdd3z1u3xjGmmaUQk3qz+VkEjAWU9S+Qsbg0mWUnc7lx88XvfGfIExy3N1/xY
yefxn/6wfOJdN/LyFTaQcp3418W2z5jx4FAQl9ifDPsl9Gj8B4gZ5HtZmqVl1/bn
So7di+1kFrhjDj49B2ga6yX/KWPiyUCyHTUa5fhPylnzfiYPvQZqjNEqCsmH03Fx
sPwiTgR00h05VfDTFiA/ZfCG6kivKcJHcLkWJI9TpVV5cLPeMeXwsFgftMcF+e+8
YM7Q2cpCqvyPqExSv05oUeVwgdLha2uLCbnfmoUaeJ37puRiz+Aw0Keix1x+3H8b
aLeffcDciT7nBqM1/5mGuHY7uOg07JnSLZn7vQnzybMEJ//cyxpdHOgDdvDXNPpT
/8D12ybZ9dhUDk/f0KPXxTg/m4IPkfwPzEUpsEy2mu66LSYMNIRgGEtdDWBpdnuo
CiQlBxl1ldLXeAkBTuaxkd+tEPYwe3KJpVJcCcfYVBwElxIGA1g=
=tdeh
-----END PGP SIGNATURE-----

--cFBfXFURHoLcgmoB--
