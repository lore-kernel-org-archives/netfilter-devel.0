Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC1114C5AE
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264679; cv=none; b=L0yqN0toTztPxNvJeIHpi0F/r0cY8/LXT+1YyoUtp9uDjdDJTxYbT+B5Fawoacq7bl+k8rgPcCgwOBwistb/Ft5FDfMTC340mWPDokdi8LejrP6QpFF5FFLaj2Y3wWISrjmoAMIjN6vplWmlpILwulcgDciMYDX/wyF2rtvmLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264679; c=relaxed/simple;
	bh=Kdx6k8+j+h67rRThL/IJ3lqZoqk5UauZjlJEdh+bPgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VM1n+WVTiYeqGcXySUW0BIFbiaxy6NYLoLgqffDwxvhx46OPouGkowd8d5ELShrEE+OQA6LFwFzWCLaDaTHgB66AjBpZRCBwD11gTYfgyZDtv0hLEb9ki1JEXMrO1NA8KRcdU6Gibhr5bUmsAJoNce3+4jjixHHHJcuybV/NNMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Fv0Sr37E; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Fv0Sr37E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PYAaEkHhwCGS9TC/9YgKVdARmmx5ZGAPK1QCBaRHhXs=; b=Fv0Sr37ElCttqCMjKkmuDi8USz
	vgHnDrpLkh/mJA2yXJAle9dQnGz080cCRQAtpexWYrS9Z4S4RER/sz570K7uK7zgu6squhDDJjJdT
	M/ce0wQJIH26zjFcG8XQCG2EAIk6/9mXQn5ukbSXTwcMZSzCj9RFTz5zs+bJ3HLUjWsIt4ut52+JQ
	ZWK/j0cfQToHCQUmP76nHrhiktK1lJn1cn1/3snzR2lTimNY/79J0dLqH4p+Z0QCoQ40JaV3+taCb
	ypJvdBodDJAoMBmd7YTwTpzA7pm0i63bInxanpvN7eGt+aJoQxzwx9T6jISLl4khI83fNxYpXogyJ
	XDbGEXAg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1sgq0L-001PEZ-0Q;
	Wed, 21 Aug 2024 19:24:21 +0100
Date: Wed, 21 Aug 2024 19:24:19 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables: Fix compilation error with musl-libc
Message-ID: <20240821182419.GC7832@celephais.dreamlands>
References: <20240709130545.882519-1-joshualant@gmail.com>
 <ZsN_trJvTSw05f5W@calendula>
 <ZsR91p8Vf8_QxCvP@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BrK2p4MeJOuykcoz"
Content-Disposition: inline
In-Reply-To: <ZsR91p8Vf8_QxCvP@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--BrK2p4MeJOuykcoz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-08-20, at 13:28:22 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 19, 2024 at 07:24:06PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 09, 2024 at 01:05:45PM +0000, Joshua Lant wrote:
> > > Error compiling with musl-libc:
> > > The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958 introduces t=
he
> > > netinet/ether.h header into xtables.h, which causes an error due to t=
he
> > > redefinition of the ethhdr struct, defined in linux/if_ether.h and
> > > netinet/ether.h.
> > >=20
> > > This is is a known issue with musl-libc, with kernel headers providing
> > > guards against this happening when glibc is used:
> > > https://wiki.musl-libc.org/faq (Q: Why am I getting =E2=80=9Cerror: r=
edefinition
> > > of struct ethhdr/tcphdr/etc=E2=80=9D?)
> > >=20
> > > The only value used from netinet/ether.h is ETH_ALEN, which is alread=
y set
> > > manually in libxtables/xtables.c. Move this definition to the header =
and
> > > eliminate the inclusion of netinet/if_ether.h.
> >=20
> > Any chance that musl headers are being used so this can be autodetected?
> > Then, no option to pass -D__UAPI_DEF_ETHHDR=3D0 is required.
>=20
> To clarify, what I mean is if it is possible to autodetect that musl
> headers are used, then add this definition.
>=20
> I'd prefer no new --option as you propose is required to handle this.

There are a couple of approaches that I see.

1. Test whether netinet/if_ether.h sets `__UAPI_DEF_ETHHDR` to zero (in
which case we are building with musl):

  saved_CPPFLAGS=3D${CPPFLAGS}
  CPPFLAGS=3D${regular_CPPFLAGS}
  AC_PREPROC_IFELSE([AC_LANG_SOURCE([[
  #include <netinet/if_ether.h>
  #if defined(__UAPI_DEF_ETHHDR) && __UAPI_DEF_ETHHDR =3D=3D 0
  #else
  #error No __UAPI_DEF_ETHHDR
  #endif
  ]])], [AC_DEFINE([__UAPI_DEF_ETHHDR], [0], [Prevent multiple definitions =
of `struct ethhdr`])])
  CPPFLAGS=3D${saved_CPPFLAGS}

2. Just check `${host_os}`:

  AS_IF([test "${host_os}" =3D "linux-musl"],
        [AC_DEFINE([__UAPI_DEF_ETHHDR], [0], [Prevent multiple definitions =
of `struct ethhdr`])])

J.

--BrK2p4MeJOuykcoz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmbGMKoACgkQKYasCr3x
BA1q1hAAj7JoJNq++OysFV9zzJXoNCgbYfoOxiu8qoKkNdO2+bO3tLQPKjOeBPRb
xIIN8w6Ya8ThmP89bG1EDvuLj8uQugB5ahjzKFT7223mlXbW+qYk51YHFR/USsw8
d0NHvVVqWX8ZSfMAB0xtuPynN6bnHW3vMP+TK3/haLjWoaEVbRbRcvCccsFykJHj
H3TQ0gwv9O4xGfsN83WM42HN3R7gP/Pfmfs2+mw4nP0bkr8VTPed88R8E9LT9Prj
qdYe/hU4QK74CmB6xOGfEyVv4eXWf/j+KflNGx+ITXViCdGDRgHB6A1HfZKCBv4Q
iktf6iFHrVVGJ9+h4D7CDd0+kWrDsxPM1kV/KnzZb7uqdCMCxqkOHljgAeYywpdV
tAuYLA/oVw0Y3KqRgPfshTL6gAnIY1kATcdauq4q+CEQp7tQUIKkR+eImO/F+qlQ
GPdtYf/w70rrywFAg+GDV8JvqlaquDMj5pddwfmkpEttNcnqnk9n01+tv/nne2Za
g0nK/9nNTsENEjpZTyMlXylNpN4H82XBD/i21ACCVyAtgy1mxlDt9Y/+tRZMls+j
N2teszBp3F8B3/3G/7bZmKVfuxLLtfuGquIhpKd7tTKH004EQjMCQ4CQ27XCRfwN
VuK4Mpu5eBPlK6tElwZnxjDh1QJ1/iqSiu6pOqwx4wPW2bOv1zM=
=d97a
-----END PGP SIGNATURE-----

--BrK2p4MeJOuykcoz--
