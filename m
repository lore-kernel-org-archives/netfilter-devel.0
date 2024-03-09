Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99F17740
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709973145; cv=none; b=LW0myId6Tb8HASF9MXEPA0A8PX8ILLtLUvigM8EXD9AM/zkOv7TLadB7ZtinznyVsxyMH0+cZC0RpDXkW0dsWD4ZZu6xEL+1hu6vQnwUuBNO6F5QtOd2Aty5Kv0DkIrYsB2UTkmnm91/KTr2CnWcGZ4ryUV6uQQbufIW+Xyc/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709973145; c=relaxed/simple;
	bh=U/b4Uuy5EmXk6skqg2wVKh3q7L5HnsVDbuv9lusAths=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwB/FYcPuBYkCg08lcDWRDiFtspfI91k8EyPj0ZoX5V1LYo0oCvw9KSznUUD0ozGt6Bu58CSFjGPh0NaQ473Dl0gZVEwopesKIxCt4jpuaVyTl3eFOkpnmbhQ9p7xzrzlBcS40g4IDJFHQhoHJ+QwvtSKTx+i7XmpUjhdvZcq2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Z5zS+Fcw; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Z5zS+Fcw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a5nD3+hLowtTdm4prantHzWeewPOck3uGtPYqwZDmI8=; b=Z5zS+FcwUJdqH2iWFLcx78ux3A
	AKTCDyspm9bTogWntsxyvtjHjcnRNyZAJLe/Aiil4+hEqpOrTuxSvs1oVIX9cFjewk26Wyh9r4Q+8
	4htKeCyJMdnZSWJhyatpDQ2RWmBd9P3Dopeqsqx8hams1/QhJI15PaIFAp1McDxtujzBqY9zECh2W
	6VS0L5TgXCEvLbHOmnEFbj2pvBopqkOJL9X+XLcCjMvrZEzUec4fpaADXwXYcMhSgHaw4HVriop9H
	rUmgfjn60oAEOAOWivW1aiEL8RU98/+S/JCVc3LAp5ZIdU5WuuR+j63GTbLXdEllxjmfveP+y1m1x
	RwKK0YrQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1ris7r-009dvM-0c;
	Sat, 09 Mar 2024 08:32:15 +0000
Date: Sat, 9 Mar 2024 08:32:14 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH arptables] Fix a couple of spelling errors
Message-ID: <20240309083214.GA4876@celephais.dreamlands>
References: <20240308221720.639060-1-jeremy@azazel.net>
 <ZeuZiCDOI8NoyfOF@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/axIK4cRAyRF2/mK"
Content-Disposition: inline
In-Reply-To: <ZeuZiCDOI8NoyfOF@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--/axIK4cRAyRF2/mK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-03-09, at 00:04:40 +0100, Phil Sutter wrote:
> On Fri, Mar 08, 2024 at 10:17:20PM +0000, Jeremy Sowden wrote:
> > One mistake in a man-page, one in a warning.
> >=20
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>=20
> Patch applied, thanks!
>=20
> Just please be aware that it's entirely unclear if/when a new
> arptables-legacy release will be made.

Thanks, Phil.  Yes, I had a suspicion that might be the case.  Just
giving the Debian package a spring clean.

J.

--/axIK4cRAyRF2/mK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmXsHoYACgkQKYasCr3x
BA1IEg//RESvGDyY0mVdEAk4YHUQzONE+7l127BimUaOUAR+Sgm0VxWmdky+DORB
tZtXtm2VOEUdlN9xERK9JCanAEfjkR8n4S/oqBJrmsBb508Il5sAUcddvmDzfOQl
dnXNDm2yubUs2w+gX6M76lVkSMemhRfDf/cneLrp3V38VCpjyzk3VKvIMa0ZxMx+
BQK6q16YwM5qiso7fsFGkPYvDImHcM5d3Xeq0qphPKC7szSyxdvWebTo1/WOMmtN
2aETNun7lme10n9tTKFo/rYQYJmePlun+rIs69srgg9JTZ80Nwhx6rM45EhYpjuG
ksHNNQnrlGJVx2JD8npJedyzufkUTKws7gj0//4QbTw9T7RJmjO7LW1AgB+rx6VZ
2B8s1yGkwg+LaTJ/ywi6Cd1yj3vajPjzq5fnpVUEtooatl0bAnSeaC8tX9PX1C1g
jYuyBLyaqoER0AYdDVyqclzbOXBVj/zqnrjpSmoIXH/9otFijkK/3vhYMOMOU2CC
Czy2ET4aRQFX8wTrJv1vtoS+LNT4VqqxK/4onWAp/Q4eToIeXWLhBNYZi+QLIVAo
y+8e13H5u8Soj5b1UbiN+29Vr/i3I3NiGHDSvSN/VwpIKiUmG7HwKH/bWFTsPIvU
tvrh6hNg1jblAwrRnRG3Ca6Xpl2SkiSqpRXMusN84DwKhh6DcCw=
=R+iM
-----END PGP SIGNATURE-----

--/axIK4cRAyRF2/mK--
