Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32483FEF
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769188877; cv=none; b=pQBtUdjVSgpLYw6IG9rPs0a6LZ87NCotCJq1JBOcfVkhEtjGJtEDwZq3YjY2uaJu67Xk5hsLEOrsAty9gU6ZTJmRJ2Wi3IpQmGm3g4vFaWc7TAN/g41cXlyArmXasaMzenFBtOiOz42w3yQF8mMs7xCQr5epQBxq+kO9rWdeP3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769188877; c=relaxed/simple;
	bh=SZUkXtnAOuoTXVbPNFLw9+rvU5bVxokX/W2qrSRNR70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6asqKC0nXuT47tC2Wj/Khs0FGRa7WE6hhy8KN/pbi6/EMvj6JEDzb7MJum0DNrrLw2rV7e+F2lJ8hb9F0oecKI5Mdh4y44kWRSWlJAKZcd+etzGO4XNbAxr+6cyIYmeaqP5zCYUGqhUZUYRFu4z62e6OceyI2ZQf1ksxxPdnfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=OhW7FeiI; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OhW7FeiI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Bae2HgIYgRMwVikovqt/KpVMjFlFQBc05W2+w1aZheY=; b=OhW7FeiIumATOiL5+VZQgbVxCg
	3uxIy2K4xhhWtE2CMopH9L2Ho2p89EEkQBqAcijozXf1MQukBPw3EA5QtMspnxkgkMuMTJaoNmCxV
	tqzH+rO2vp/DhYTHFiziLGjbrbOjOuZm45QqMmh3/dORTt5kOyqCYr0wMsW4mangCA9iUaK89Nlew
	ZcRd0Tnzguc2VVycCZXggm/orAzxQuAlWE/vaHzICPts+mYWKlHVNymUKgcL9zwWiHF5UrjzYx2Kd
	G4Vy0yXmeDAwKw0r9+GVKIZ1Itce3WmzOl3roudkwmlgh0jj59PW2YGDDI9quEwC52QqzmOmdk+CY
	2kArz+kA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vjK8u-00000008Zja-45KZ;
	Fri, 23 Jan 2026 16:36:16 +0000
Date: Fri, 23 Jan 2026 16:36:15 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: netfilter-devel@vger.kernel.org
Cc: Philipp Bartsch <phil@grmr.de>, Arnout Engelen <arnout@bzzt.net>
Subject: Re: [nftables PATCH] build: support SOURCE_DATE_EPOCH for
 reproducible build
Message-ID: <20260123163615.GB1387959@celephais.dreamlands>
References: <20260123123137.2327427-1-phil@amsel.grmr.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wYmRFHjnajKZBkYS"
Content-Disposition: inline
In-Reply-To: <20260123123137.2327427-1-phil@amsel.grmr.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--wYmRFHjnajKZBkYS
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-01-23, at 13:30:40 +0100, Philipp Bartsch wrote:
> Including build timestamps in artifacts makes it harder to
> reproducibly build them.
>=20
> Allow to overwrite build timestamp MAKE_STAMP by setting the
> SOURCE_DATE_EPOCH environment variable.
>=20
> More details on SOURCE_DATE_EPOCH and reproducible builds:
> https://reproducible-builds.org/docs/source-date-epoch/
>=20
> Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
> Reported-by: Arnout Engelen <arnout@bzzt.net>
> Closes: https://github.com/NixOS/nixpkgs/issues/478048
> Signed-off-by: Philipp Bartsch <phil@grmr.de>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index dd172e88..3c672c99 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -165,7 +165,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
>  ])
>  # Current date should be fetched exactly once per build,
>  # so have 'make' call date and pass the value to every 'gcc' call
> -AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> +AC_SUBST([MAKE_STAMP], ["\$(shell printenv SOURCE_DATE_EPOCH || date +%s=
)"])
>=20
>  AC_ARG_ENABLE([distcheck],
>  	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),

Apart from the reproducibility problem, the original code doesn't actual
do what the comment says.  `date` is called every time a file is
compiled.  Here are the first and last half-dozen time-stamps snipped
=66rom a recent build:

	-DMAKE_STAMP=3D1769185524
	-DMAKE_STAMP=3D1769185524
	-DMAKE_STAMP=3D1769185524
	-DMAKE_STAMP=3D1769185524
	-DMAKE_STAMP=3D1769185525
	-DMAKE_STAMP=3D1769185525
	...
	-DMAKE_STAMP=3D1769185536
	-DMAKE_STAMP=3D1769185536
	-DMAKE_STAMP=3D1769185539
	-DMAKE_STAMP=3D1769185539
	-DMAKE_STAMP=3D1769185540
	-DMAKE_STAMP=3D1769185540

Generating one time-stamp in the Makefile is a pain in backside.  I have
come up with a way to do it, but it's fiddly.  Florian, Phil, would it
suffice to generate the time-stamp in configure?

J.

--wYmRFHjnajKZBkYS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpc6NuCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmej+fA9LuVbN1HM06Amq9/IKGvRv2drNxQ+yC3aI/1S
TBYhBGwdtFNj70A3vVbVFymGrAq98QQNAAB2uhAAwbNL5ES5opWSX9a45X6/mFef
dL2gOO10PC7aq8eW6ntHkXywJni7WfhWYZDXtPTMHlAfYsMKhF+6qNsXaIc8GbuC
ikU0eDNFtEexQdPMddOTyJXpY/wvrisI9recQLcr68KZwY2DzHqbEa0LcnZe7HJe
M0y7c462+61OnwLYEzpjwA4hE+bGHxGXdeWnaLCM2b5sIdgJCsAjD8UW4O3jbeCk
gQyhzRbDpSse/+aFzB8Jo9iFC+Ch/U2b5CmoAgszOjRXm3S9fhPvmleVJpnNIhoe
tYlaFEozDN20XTs8KWKuVt3//ha8M+TyYF7h0vmv+PMXLlJuUljXBGro0XTHdP9g
pQh4lo1bWTKB2AoqmS0xccOPfQ9DphqEJ2/l0oVsKfUVEUKzdL5KrHQpeEM7A0ys
AuzTmx/OEO2/1Qf2LIsknlNS7O0MVePrItgmXW6vQMF3lD1AW82WHTtnm1Z9y2tw
HyTEi0XavJtEyHTbSvYo4zIC/R3B/vx+0zctn8hPgJ/ARIwrtAYHLWXuToMK99vb
DqHePM2k4esUDpiM34X/QdDnW16It8/9oG+3syzVPjoB2CWvoPU5mh3bdwkqccrS
MfuasEfuIZ4t7Dp/x3h+5jdVw772ZAuACqm4T8EkH18UiFAxhZSpvdT2hDAdegWt
fKaZDCdXjQE7wsKlJ4o=
=8p2r
-----END PGP SIGNATURE-----

--wYmRFHjnajKZBkYS--
