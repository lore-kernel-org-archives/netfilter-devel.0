Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749EC21770A
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766048440; cv=none; b=D5lDrPIIPpUhZs/qZmMqhnOdBnG9YViXPgAVc8jdJH4bjwPB4RKIRisNYxA4n7mx4GsTW3gFejMq76ffG6CB6xiL3Xwb/l/DOcBAPA4MmLWlpe1TUZvqGNrkcvR/dPRxTDDy7uJXmkzu07Zg8IwbsYjX6CYOXbzTUTgp46dzli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766048440; c=relaxed/simple;
	bh=APEfaPUyhxAdEZx0EZYam3irhnyGVgNj6Vs7LylRioY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXSma+4YzJZk8iFOCblRmpDaOzs8MZNYf8JhoEB8mk4FfSIFQYjdWvc/e2c6wQHcH5cYbkCyvCVJi8FofR+3n0uSx/YaaMrqWmyHS0pfGG0icaW+TuanPryuTSoLhweKsfVu2CkBrc4JjhjAuxVB0aWg9LS+GITIa/7WdEzHaxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=FhcPKf2v; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FhcPKf2v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QbEILHiSMa0m1/SiKGJJTvS7Y+nX3fTAxp2oLpMF0m4=; b=FhcPKf2v2hkXHW9RSl98dZRxrc
	jicsiHMUumgOXJieyHx+KqNOr8zdTm0cpjQMkBzc3WAkehcqKMWC12Oyh89i06qlXl7jXg6cglMI9
	5xafcoj+f3rZzeoV5T6/E9/ylV+/CLTpShQNWtJRJMasuULD+DDuo7axSymDwbCDhenQCQwV8CVtT
	Vcql8ZZCRyznXsEMGZv9FmZB+hWI6llJG2gFSsig5773PNJK6iCeTvCMFFHvIcStQ3xCM3bXA7NnA
	1L33pBYbfQjIrSBIQSp0FVFshtD9Woyn1mhUqxbjAGU+JjpJL8Q2sw9mJRAUEqGMvikg07Yrp2dVZ
	c1KYyUaQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vW9s4-00000004gFl-1OhM;
	Thu, 18 Dec 2025 09:00:28 +0000
Date: Thu, 18 Dec 2025 09:00:27 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: New conntrack-tools release?
Message-ID: <20251218090027.GB2993022@celephais.dreamlands>
References: <20251212145754.GA2993022@celephais.dreamlands>
 <aUHXEmNOo8WvQaa3@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5yWDZ+oflU7sdZuf"
Content-Disposition: inline
In-Reply-To: <aUHXEmNOo8WvQaa3@chamomile>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--5yWDZ+oflU7sdZuf
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-12-16, at 23:02:58 +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 12, 2025 at 02:57:54PM +0000, Jeremy Sowden wrote:
> > It's been a couple of years since conntrack-tools 1.4.8 and there have
> > been twenty-odd commits since.  Time for 1.4.9?
>=20
> OK, let's prepare for it.

Great.  One thing I noticed is that the current head depends on an
unreleased commit in libnetfilter-conntrack.

J.

--5yWDZ+oflU7sdZuf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpQ8KfCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeOjN1WLVeTmIPRX+93hUH2taeYkuzKbjb5fZht5WwS
jxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAuaw/9GEBXF2rGMhdM9ix9si5LeiCG
4B+IEHSX2zQ7+2ks3R0PIs+06V1j3AhX/20pUdDB6IC0rXueOSvIgJafBOPPZ3dU
FVD6/sIgy1rPB41Kw0yOGX6KGf4ZIEzyLDlGPYcbxJKbMc1YgwY1uTjSZcFH1fBA
0TXOV8JJaICnBVccl+rytYFERfL0ES8GNRlEWjDk0VXrEDkJMfdVVcIaL6DXNOND
Mzwwt3OFHORNUXjLtMc6iMhY3MzEYVxkrymKAYpKBO/AFB1SZIhz8SWNfH2R4QbE
11wJHEMYfxni0F8JArzBwV7rffwv9WkgvKFl3oLh7FhviV5OL+kJxuXNtNGxmkUq
GyZN4YVoY2S2Lu6dnSfkWjOz29Wxlb1GN+pebFHvL+JSurKHhJChIBqEVcTVwMMv
z009wM3RxIoXRmTrzuourCi/TqBXQH3TnAzrLhrih3UVDFx6+JW/ZElCnVH+FPNH
vXJqavs/HBFc2y8lfxE2DkbZuyj8MgjnZuBqYaiL/RidFSSpcaYmTZvYYWQq6D8o
OuO8FEhxdan9/DtLtlbhqDq4rGyFDBhg7uzgB8qPQkQa15qjD+I8rGJwJU+Efn3L
+2+OsC9j6VzApPHdBCAmabkxyj0ZA/9vTckZErbcMCk2uKfLA2Ctgw8+EpWh3yXN
Au5XiQGafwVUzcKMUYw=
=HJe1
-----END PGP SIGNATURE-----

--5yWDZ+oflU7sdZuf--
