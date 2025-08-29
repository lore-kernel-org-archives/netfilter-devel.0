Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F226A3A1DB
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756484838; cv=none; b=OtxD3khAMNOwYzWlwqA8JsKdiAUp2jNfaIJNFWp4eP5V/ALnvLPHRAojGhBQSz73e3R848WheCoZ9PODL8UOgIcrSRKwPbg+fsba6WFyst6uu0wTU/q34kFh9Tzgp6SKzN0fPdDDc44R+CfwtsWGB33vtcnjOuJerah4uPL/YXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756484838; c=relaxed/simple;
	bh=gIfGebOiuxmlVSRX9vAzaPgsFyFJdMHkNfCrtTp91AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gil0zhDSWpWbyaKD19o23clVFMjTm7Dq/ZkIdCl2NnbQel+7l7a6PPMlD+3UWiaJMdl8PToSaMkWYT/sTC94odPE6+GVk1da9pJPkd/Ovy59bcLoI9G1kuM7Ai2vSMz0pa0E/WjpJBqvQ3C8iiTMQQ8VhKN1R5K4WvBTCDWj3II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=NGBxX+RG; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NGBxX+RG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CjkmvX4Zdi9AhzuHG/4zKDRiTk9b7g8rYotKyFFHZW4=; b=NGBxX+RGrGy0/rWw8TEsFXYT3/
	+xBzJ05Og7i5q61TV5wI/WT/mit4Gs3y3mEPPQkmvrIYOynLr2n9/9m8MjZMYivqsDBxXMyS5oZyS
	KvbRo+Wg8TLG9ba6RyDthetR7C4fBwqGFIVGW9fNVSSHLcPM/CqJvlpXk8KigkUUEwb3c5F9xA4aR
	7h+Npcr0IabCE5noOYYki0M2eW7o09gRHpGDoKOOJ3U2V4Jur1T/LuHhUcVgZJfJTyJ/zt8MNjJQT
	4HWdckyI0R5Xzqs7n6Z3lVwkB0wXNWuDFtyn4NBNkcFE/UyetrxvCL+f+DjQ1Rk1T748TXaA2k7nc
	rKD9YQfA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1us1Ga-0000000AmFM-166z;
	Fri, 29 Aug 2025 16:43:52 +0100
Date: Fri, 29 Aug 2025 16:43:50 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] build: disable --with-unitdir by default
Message-ID: <20250829154350.GE3204340@azazel.net>
References: <20250827140214.645245-1-pablo@netfilter.org>
 <aK8aN4h2XsLnTdT6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8R2wIVrB9l97S81a"
Content-Disposition: inline
In-Reply-To: <aK8aN4h2XsLnTdT6@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--8R2wIVrB9l97S81a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-08-27, at 16:46:15 +0200, Pablo Neira Ayuso wrote:
> Cc'ing Phil, Jan.
>=20
> Excuse me my terse proposal description.
>=20
> Extension: This is an alternative patch to disable --with-unitdir by
> default, to address distcheck issue.
>=20
> I wonder also if this is a more conservative approach, this should
> integrate more seamlessly into existing pipelines while allowing
> distributors to opt-in to use this.
>=20
> But maybe I'm worrying too much and it is just fine to change defaults
> for downstream packagers.

The upshot of this is that the service file is not installed by default, but
the related man-page and the example main.nft still are.  Gueesing this is =
an
oversight?  If so, I will send a patch.

J.

> On Wed, Aug 27, 2025 at 04:02:14PM +0200, Pablo Neira Ayuso wrote:
> > Same behaviour as in the original patch:
> >=20
> >   --with-unitdir	auto-detects the systemd unit path.
> >   --with-unitdir=3DPATH	uses the PATH
> >=20
> > no --with-unitdir does not install the systemd unit path.
> >=20
> > INSTALL description looks fine for what this does.
> >=20
> > While at this, extend tests/build/ to cover for this new option.
> >=20
> > Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  configure.ac             | 29 +++++++++++++++++++++--------
> >  tests/build/run-tests.sh |  2 +-
> >  2 files changed, 22 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/configure.ac b/configure.ac
> > index 42708c9f2470..3a751cb054b9 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -115,15 +115,22 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumbe=
r_r, getservbyport_r], [], [],
> >  ]])
> > =20
> >  AC_ARG_WITH([unitdir],
> > -	[AS_HELP_STRING([--with-unitdir=3DPATH], [Path to systemd service uni=
t directory])],
> > -	[unitdir=3D"$withval"],
> > +	[AS_HELP_STRING([--with-unitdir[=3DPATH]],
> > +	[Path to systemd service unit directory, or omit PATH to auto-detect]=
)],
> >  	[
> > -		unitdir=3D$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>=
/dev/null)
> > -		AS_IF([test -z "$unitdir"], [unitdir=3D'${prefix}/lib/systemd/system=
'])
> > -	])
> > +		if test "x$withval" =3D "xyes"; then
> > +			unitdir=3D$($PKG_CONFIG --variable=3Dsystemdsystemunitdir systemd 2=
>/dev/null)
> > +			AS_IF([test -z "$unitdir"], [unitdir=3D'${prefix}/lib/systemd/syste=
m'])
> > +		elif test "x$withval" =3D "xno"; then
> > +			unitdir=3D""
> > +		else
> > +			unitdir=3D"$withval"
> > +		fi
> > +	],
> > +	[unitdir=3D""]
> > +)
> >  AC_SUBST([unitdir])
> > =20
> > -
> >  AC_CONFIG_FILES([					\
> >  		Makefile				\
> >  		libnftables.pc				\
> > @@ -137,5 +144,11 @@ nft configuration:
> >    use mini-gmp:			${with_mini_gmp}
> >    enable man page:              ${enable_man_doc}
> >    libxtables support:		${with_xtables}
> > -  json output support:          ${with_json}
> > -  systemd unit:			${unitdir}"
> > +  json output support:          ${with_json}"
> > +
> > +if test "x$unitdir" !=3D "x"; then
> > +AC_SUBST([unitdir])
> > +echo "  systemd unit:                 ${unitdir}"
> > +else
> > +echo "  systemd unit:                 no"
> > +fi
> > diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
> > index 916df2e2fa8e..1d32d5d8afcb 100755
> > --- a/tests/build/run-tests.sh
> > +++ b/tests/build/run-tests.sh
> > @@ -3,7 +3,7 @@
> >  log_file=3D"$(pwd)/tests.log"
> >  dir=3D../..
> >  argument=3D( --without-cli --with-cli=3Dlinenoise --with-cli=3Deditlin=
e --enable-debug --with-mini-gmp
> > -	   --enable-man-doc --with-xtables --with-json)
> > +	   --enable-man-doc --with-xtables --with-json --with-unitdir --with-=
unidir=3D/lib/systemd/system)
> >  ok=3D0
> >  failed=3D0
> > =20
> > --=20
> > 2.30.2
> >=20
> >=20
>=20

--8R2wIVrB9l97S81a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJoscq2CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcv2R3kGYf4+LWiFbVGD7Kr3Egvq8Pne8/lcr8FjmqE
wBYhBGwdtFNj70A3vVbVFymGrAq98QQNAABBZw//W4sLXQyytCKPbRKWuG52TjaI
scXYVSmeT8sBfhnMh294RTerc4QfhXkfQ+2vIWgjN778c3kC4xMDH4Ak+iDPU9dZ
YiaE+LLhlWmjGcS1AOyz8IUqyWTzrQK21pSXOB39GORcvImxxMiEkfi2/g30QvWe
Hi8LvNppKiuMayfdmM+ILtYVU2CecE8eo28cwxNMlgVEXrSqCAvIVXAmul6ja9KQ
gMEesyCTrFvKptyIzY/QHrmK8x6RjUZdT1sCHsiKdnB+yptglcSbQeE1n/8gIswB
g9NwK61h5NiqMsHn/nOxHkxjRHfEEU8xfD3JvJEN/gq6Z0XSrqljKtaN3uTbgCK0
2OeC4/EG/sI2f8r/2NVLw8Xh6QztrpR02+WvWP5WV2/EcMGLTdScMrmgI1iQ8QES
X4rYZ4x0wlzZnmfixK0jluJkFBW+UNZcK/0Wbcat6NF3VSz9LvdyNNFhPaxBRZ3w
ETSducIkqOuE+l3+3zT3VVJR7sVKT5CoaYDJTpPTZ4sqRcnME0fIOg6dZIdGYrF/
3DUGAyDEYdVoJPHwjxwJHi7HQNSwfkmtd4/xXMx6N8p5n564rxEzfRQMtKwI1eUx
bVFErFnNc9Yikc1MW6jUbXje4Ddl26eaTEFYvhAv4wmTQCo5O7PP16zzV8bBaOTW
w1j3pozkvtbwvlNqnEI=
=GCEB
-----END PGP SIGNATURE-----

--8R2wIVrB9l97S81a--
