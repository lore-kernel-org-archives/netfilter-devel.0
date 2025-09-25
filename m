Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5F35940
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 20:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758832420; cv=none; b=f4kGgMIO4K6NsqDR7+dppeGyW9LqvDbC5gDrlwkpRy63stzcyQiLMLcX3q2J7aveobU510LMeGdbmGAjAUA6YxC0EV6aOLN2OKR1NVqpCFZqwsujaxLU9ZB9mzvawsWilWsXXKJvPkbKMfPKlWqxfUe4pv8BVUEr8ubeHSqeriw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758832420; c=relaxed/simple;
	bh=UOAVtFlpx6vH1XlIrfzqAd00f5q8Fw5p8fJybaSFHTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCUlCyP9szoJe1ucQYQjIvoAlhB7w4O6O6UuXVTEJtvUEPPs+7ReEl0s5n+4An6GmhA2A4KdSRGxQdBb7+YCCfITTHx+Zi+RoaPLGL+lHMvDE1fVxbdulOpBsPrXxUIEz1V/8ESjIU2uhcoQDN+fsIpBoFvv9T3TmeT2gFb6Gx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=SmJg6QOS; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SmJg6QOS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gKyhv1K5M8tunUKnZQ3Cp0j0+ySVVlXFxxq983GsBhQ=; b=SmJg6QOSvRUrBMiqVQ3xWBUTDc
	WJc16V8efR4wvbbXEJAmSWT2K+MTtlG+WonPOadBPAAUuKdQGbYwx9SAlDJISqA17EPlVuyoFkiKi
	7cDaQGO9GfCj4aX9RGjem4tehTp4MdtU2j68Ux1A9SRyMFXtb5LrCpR2W7sUzu5w9uJzZLGPRoLJj
	K5XUAkAwfNGxW23T22a5ttLC/pChtnCA3yn7pVoFzwzf0fTKjo8B9/nhAYYwIkvqEByikhERQfLvk
	hhWGq5UNPgJIB1tNA088wj4fVSJwfYF72cpQjY7fdcDly77Yk1caURy4exhiq2UzA+0MR2VDBaAzg
	G4YlFO+g==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1v1s8M-00000001QW9-2nFt;
	Thu, 25 Sep 2025 21:00:06 +0100
Date: Thu, 25 Sep 2025 21:00:05 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: netfilter-devel@vger.kernel.org
Cc: Christoph Anton Mitterer <calestyo@scientia.org>
Subject: Re: bug: nft include with includedir path with globs loads files
 twice
Message-ID: <20250925200005.GB6365@celephais.dreamlands>
References: <500beefd7481a43c4068469300e07ca3769a064e.camel@scientia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OVNPRaLKuQOm9yao"
Content-Disposition: inline
In-Reply-To: <500beefd7481a43c4068469300e07ca3769a064e.camel@scientia.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--OVNPRaLKuQOm9yao
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-09-24, at 22:23:11 +0200, Christoph Anton Mitterer wrote:
> Hey.
>=20
> With:
>    # nft -v
>    nftables v1.1.5 (Commodore Bullmoose #6)
> from Debian sid which uses a default include dir of:
>    # nft -h | grep includepath
>      -I, --includepath <directory>   Add <directory> to the paths searche=
d for include files. Default is: /etc
>=20
>=20
> And e.g.:
> /etc/nftables.conf
>    #!/usr/sbin/nft -f
>   =20
>    flush ruleset
>   =20
>    table inet filter {
>    	chain input {
>    		type filter hook input priority filter
>    		ct state {established,related} accept
>    	}
>    }
>   =20
>    include "nftables/rules.d/*.nft"
>=20
> and:
> /etc/nftables/rules.d/x.nft:
>    table inet filter {
>            chain bla {
>                    type filter hook input priority filter
>                    ip daddr 1.1.1.1 drop
>            }
>    }
> and no other files in rules.d... nft seem to somehow include x.nft
> twice:
>=20
> # nft -f /etc/nftables.conf; nft list ruleset
> table inet filter {
> 	chain input {
> 		type filter hook input priority filter; policy accept;
> 		ct state { established, related } accept
> 	}
>=20
> 	chain bla {
> 		type filter hook input priority filter; policy accept;
> 		ip daddr 1.1.1.1 drop
> 		ip daddr 1.1.1.1 drop
> 	}
> }
>=20
> If I change the include to "nftables/rules.d/x.nft" or to
> "/etc/nftables/rules.d/*.nft"... it works (i.e. only one ip daddr
> 1.1.1.1 drop).

There is a Debian bug report related to this:

  https://bugs.debian.org/1112512

J.

--OVNPRaLKuQOm9yao
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJo1Z8kCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmda54q3Du3mdXzFHAJvoOrj7QJEm/7Qe/g9Zi3wBkEh
IhYhBGwdtFNj70A3vVbVFymGrAq98QQNAABArg//cPgBi1nQcyMS921mZ5evyWZA
5VhYTNX5TApbPouBNonBrqQDxehxkmQZlQLKxfve/6x6ydgu/Zktm/v3obSUqWYw
pAl1ZrYy9u1ULpj3pk1SLf2yFWOdTz8Zp6cF8LELzl/FaNGXr5p+7jlGDzGfLg5v
/WWdhsYgw1mhnyWm8rY3FJPKCb2SR2ftdnDEH/ViP5dtt+RGbXZ9LzhO7WifL7Jg
ptlObo0AzWNU0U2dCEEE5eI4siuNy+ErJPAZ3mcMgt9+IAnBIybRvToL2Yh6PLJh
4tgDkbG2/DEk7j8Ghl2j72uQaUe7tqQVdup/x0/mRQT2RgXZJyNOEpICAbbdITMV
9zzMRoq3GtzVsjqQ24N6kKTVZAScbsrSkaJP0hugM7zAEW3iX5ECSBldqIm0yuJO
+5w2HzvaXOR8/PfL9FOBW5yGsOYR2wBcLMjQzf0Brx46H+w0IQ+JZKFS1u92++IA
/FLcH6soPX1+bPX8eRzqrCDWPB+z3KOLEMZmmbZybasU+Ze/z1/0gSWdasSiugnp
KKQquq9V0EEVe3pb61iXlpJqmGEkdGTIlCdj2qhZL9MjGE2bJdzf0XwMdX3wtzEz
DlpksIorT06R3xH/xC333cfCXK1yqxm/EwNFD8ae3TjTh1qKBYLOj/WmUpnch0Ni
qR9x9hXwJY6gfJhsaq0=
=f+gn
-----END PGP SIGNATURE-----

--OVNPRaLKuQOm9yao--
