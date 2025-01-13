Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507D574040
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736771552; cv=none; b=jb6c1CpHazFstqFWV5oki5VXCvT7EAvnlxeRELBS51NrrujdIaGHvbU5SnjBBD1wQW13jnTEhEU37rnRIY/o11FFMaF0scuvDLp4uasyiD+yu5eMfa7iyw9ZNka9UZj2XqzDWuFVbXu0e2UmueSnZqGF2SLq+g8ZRMiujUofBcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736771552; c=relaxed/simple;
	bh=sBtX6c+o2Gxn4DDV5kRpKvTL5aZtcYS01z8pTDwbl6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljizXX89NFciHiJFUOGNLCR7ur71Ff7453VU0hGWU9leBeLyJsafCsQ1utR5MqcmQ1VB3XRdVe0rmvPdGDRawjj6FZF7/hgUCTX2B7ykk8YtgSm0BjfEd5cHAznUyeD8Q/XNP/TGNyzxmVBsztst8iOXyQ4uyXyrVP3eT/fBY04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=NXmAvd3i; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="NXmAvd3i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7yv4SK9IZL4+cYmWPBf3/JpPnn6TuBXtAORLGByZTcY=; b=NXmAvd3iRY4UXCjaoNxpSnq6Ad
	SEyADvt4J4y/UmgUZj9rVFDyvBSlRaxUwJQZvrfm/fYQRrB2ZJJYK3wUjDsrRLIjDmbYqJUsr8Mxg
	01p1Nw7smpeCLSHVCWAggbgVi8wq5NDbHyYsZVwiHpGQ8JU7fRzwNn1jIJMuQifgTj3S+XEHxKL8t
	J+HZ8TMtclFlLq/5IxtXO1zlHl0QMd/iik5ZxkOe27kEs3mtrlWDkIW1+Zn+glT6KnwAe86gWkrZR
	kexvPOqQZp7jlIhlldB1hgeSX26GRet5QMlsjV5qIgO+/S0Qp48yFq4EQAYAMZTVoH11bQ7zpu0iN
	0kabPi9Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <azazel@debian.org>)
	id 1tXJcJ-0004so-4Z; Mon, 13 Jan 2025 12:32:27 +0000
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <azazel@debian.org>)
	id 1tXJcI-001Hod-1C;
	Mon, 13 Jan 2025 12:32:26 +0000
Date: Mon, 13 Jan 2025 12:32:25 +0000
From: Jeremy Sowden <azazel@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: James Dingwall <james@dingwall.me.uk>, netfilter-devel@vger.kernel.org
Subject: Re: ulogd: out of bounds array access in ulogd_filter_HWHDR
Message-ID: <20250113123225.GC2068886@celephais.dreamlands>
References: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
 <20250113111201.GB2068886@celephais.dreamlands>
 <Z4UHMxttvdFs55Vo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="unnP15Rjxb2upPyv"
Content-Disposition: inline
In-Reply-To: <Z4UHMxttvdFs55Vo@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: azazel@debian.org
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
X-Debian-User: azazel


--unnP15Rjxb2upPyv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-01-13, at 13:30:01 +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 13, 2025 at 11:12:01AM +0000, Jeremy Sowden wrote:
> > On 2025-01-13, at 10:33:10 +0000, James Dingwall wrote:
> [...]
> > > --- filter/ulogd_filter_HWHDR.c.orig	2025-01-13 09:25:18.937977335 +0=
000
> > > +++ filter/ulogd_filter_HWHDR.c	2025-01-13 09:25:51.337824820 +0000
> > > @@ -109,7 +109,7 @@
> > >  	},
> > >  };
> > > =20
> > > -static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
> > > +static char hwmac_str[(MAX_KEY + 1) - START_KEY][HWADDR_LENGTH];
> > > =20
> > >  static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
> > >  			 int okey, int len)
> >=20
> > This was fixed a couple of years ago:
> >=20
> >   https://git.netfilter.org/ulogd2/commit/?id=3D49f6def6fcbaf01f395fbe0=
0543a9ab2c4bb106e
> >=20
> > and the fix should have made it into the Debian & Ubuntu packages.  I
> > will investigate.
>=20
> I am going to launch a new release to help this propagate to distros.

Thanks, Pablo.  I was going to request one. :)

J.

--unnP15Rjxb2upPyv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnhQfNCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmf9tFDPNKqI2O58ORbd9ljJ3og9RBYeUHz+WxGdlw/P
yhYhBGwdtFNj70A3vVbVFymGrAq98QQNAADntBAAsLZv5SC7+SiI7OZnFhDWTymu
xSr5j5WrVzuLKHel/zocwoGQJK9xwQ8/tEqxd4Gyuz9eMAgOMDUFQ4KuZzi/b61c
No1fxjeSPSs5aYmB45N60uxpVor5Dp5cAt44BYiU9ZRrztIPmYWrv5xEmVqi5wBq
NI+v9vZWdBqWuhT8QatsQPUzT7CCC2swLz4nIrO284Kvf/ABh4I2wlGcmFGm+Njm
2nngfwbcltGn+SWfk28agXBRQCUBm2CxewfUEC2Y1WzDM60ooNJs//UYAgbCTaVW
piLDDmMdEzpYyB42GSk0eY7H44FUxhg2fhNtGzAZwdgnTCEkXpbaQsOYECr44K1z
N6711Lge7ShAw8kPndKDRxPk6VvgjGpRl4mFe9rBMXPnwhwGvtyT6DaxFHXXj77p
ROt9OCpeozQWXGiSSa7VUjPxf3MaSHLwzBd/hMjcNVlArO4yKd3Ts5aoukey9Pcy
p7LOOWFnTSfgoBb2tqxxWgZ/kFXgKFqbagX1aJM2XgswYq/cWj1topKs/eJg6UsU
jBBlx5dEaxWmyN2Q0mq6HFp7V9hfHg/AX3cImGcBx97/CsCR7oVuH1u+cVq8CgIa
C7iBNnnGxNyy/y0WfFPnu2ayyqZbavV1F+zbVRgMVXAGvKflX2b6r0V4PzsbApol
vBu4vHxoJtswk1PVFBE=
=wan2
-----END PGP SIGNATURE-----

--unnP15Rjxb2upPyv--
