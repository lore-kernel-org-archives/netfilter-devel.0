Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B9723C8B5
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366208; cv=none; b=KO9zxuuxzkRDHv5a+UhKXna12RB7t6MXGs9d1b5DaNo+gMEwsem0PxU+2R4KCkOYa77pZEn+oTpaVZGObDJ/j1Hyd+ERKx2UlNkstLPgaQdoWGaTicoEwyNoYUryL3rqsLTDfDfsNgt8OoBqlwxM+gl6fMX6+k3nTcM1D2j0PCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366208; c=relaxed/simple;
	bh=OZjOB4m1IrgcG+D6TGzSVbWFTQ0zs/aNF97j6Wu+ueU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EG1ql46k1SUDSKvIfIA5lqVG3FtSXPxbiFPWkIkmINgC7KNUfVBW8bs4pOZsD2hRK4dPCNgGIXUmJLY0nrWq8691Hogzvc9Ui3w1094Dg+KjYXHpruB+GyuXHO1ZSuXB871IwfGgrXcyik3x4T//VOlMcI6OlVx/DNIslwcUqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=f+U0QfRJ; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="f+U0QfRJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OZjOB4m1IrgcG+D6TGzSVbWFTQ0zs/aNF97j6Wu+ueU=; b=f+U0QfRJqg1QE9OeoLqYbhyq0B
	FyoKinntAu1VMy9f6tvWDz4akKzHSkF2cdXwI5uyWBoOFi4kEGFUcbGRP+MuwQhhngW2gczmzwY4y
	OQeGZPBWAi+lfMwY1xmrOsTU56HzHHDjjawCG7//TXSszgbmlMl3zNt5u89B4bFn5hweDxKVgP7TA
	6wz6YXRU0K9c2wiESeJ/FhrihCdkYPsHITPXXF/LvAp1A82ZECpBsCwUwKW/3xyTFUU5uY0PhAXXP
	MyUYQs+rTcebB3nOqnDHF8DxP+Spk2jDhITUh2kLTfQylM6WiEv3v5Ch+XeFiY6yz5T6/dzT2cYEF
	AXqeaJNg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tqatR-00Em1P-0k;
	Fri, 07 Mar 2025 16:49:49 +0000
Date: Fri, 7 Mar 2025 16:49:48 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Signature for newly released iptables-1.8.11 package
Message-ID: <20250307164948.GB255870@celephais.dreamlands>
References: <1741365601.5380.19.camel@trentalancia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4rfCZDhP201AJmyF"
Content-Disposition: inline
In-Reply-To: <1741365601.5380.19.camel@trentalancia.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--4rfCZDhP201AJmyF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-03-07, at 17:40:01 +0100, Guido Trentalancia wrote:
> The newly released iptables version 1.8.11 source package has been
> signed using a new gpg key 8C5F7146A1757A65E2422A94D70D1A666ACF2B21.
>=20
> Unfortunately it seems that such key has not been published yet on
> public keyservers.
>=20
> Can someone please publish the new gpg key used to sign newer iptables
> releases ?

It's here: https://netfilter.org/about.html#gpg.

J.

--4rfCZDhP201AJmyF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnyyOaCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcGXxVMkgBTbKiPBsHzMqVbsDBBDCEZqwLNYFRmHrPq
thYhBGwdtFNj70A3vVbVFymGrAq98QQNAADYxQ//ctFNxXGtwS3NAFCcO0UUT+aB
2mH7La3ploqtNdQv7Lh869aBUHmtTbq1OA+ssO8faDeDKjay4q812IoKYpkbOh/3
dwz10q2T07Dmqttc2vy6svFoHKi+W6WTfcJ4dtCKvlNUFu309ohZ14noD54jhvQa
Q8U4QuCHH5ym0r8Tig8Fe6h5+jZECELOI4xHFLmvPsOgkqs/E0z521B76MyiWQLc
Zyi53q5T/cBbOXQZOQqPmTheupOF6J3TXSQTz95Kyna+8EFnqh+Wmk0WgASAA/CC
zjta60xooDnJ3VhQtQdjdskGf+lqiUjcusjSp53J6aUKL9GWlr2Ktj3St7r7c417
jzaofRcGAJdty8n28MUWE113qfYw//UyrhzKXcNL878YiFM9+/uUN603nool2nD6
aAtmRbrRqnruycOU+5ZxJCO1C6enfH2rUrv8BM67yEYvLAeGizU+2J8RWSv+ALRn
EZzIvDFdSviAOy+g5QbabTLlRJRMQBNE8X1MwFNEhuUZp2zjKKeOSegd8Mi7qzBI
Owx6btUsfbZ02MT/2wDizFjpEoWN9CRwGXmEzIoBV6VDpixtyaT1z6s+lbceTDeK
+JDTnBT6/4Dq5Vk6UYZIf5NYyU1fJXEVHaeltgtNiUWudO/SCAFBq43+nhdz1B62
c9lAyICcUKrPmyr6AQs=
=V05x
-----END PGP SIGNATURE-----

--4rfCZDhP201AJmyF--
