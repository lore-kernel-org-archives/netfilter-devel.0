Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DE1BA27
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738066672; cv=none; b=KjonD6p/ripRLe2iDqyTrH/vsdXaJIbEJrso6fnm1IEfaCJ4medSThGJNtJ8pYe7EG5eSDucio0cU1ed9dSliXiE7JirfdP5mMsSir0KVkSxNhY+tJ4/LjJFzejMohGGgertf3Glgu11c8/QmmDXzGIxlgFiq/iGuoZgRcuO6Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738066672; c=relaxed/simple;
	bh=hhoqY8z1IhdGljVFvePevANF9wsF1hjq1WvwMQwnIJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2xw2uK7cDyWxsCEGSplY4vzlx39nhif6OHxUuDSy6tBHh6PuecQy8kBK0rBLXnnRZciqxm75bICmR2GfebdzCZKFYIkTQYQAbaeLMhQZogbgT9FaKr5n+KwXeUTTB7vVnDLPe/nMJ7mRJx6fS2NJasgBmyxH+ovhWHPoQwRJA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=gmoeVi21; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="gmoeVi21"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hhoqY8z1IhdGljVFvePevANF9wsF1hjq1WvwMQwnIJw=; b=gmoeVi21MWFx0lZuel1S8ukwOT
	F5s9DvA8P4FfwcNnQFvc1+hIXixdoE3q/ckiNNed8XlQpRxHSaz5OnlgXBZs17GWu2AWzgVcW4Jfp
	PvGhrtjV7YKaG+3PdU0mCL1FMZ/xFBiNhpmwtqLYnUfkqw+JH0WkW7I8i6Myrip+5EZZ9Zcg7Oqkt
	HRVOvafleRhjI6vpTzq4Y5mUMIvoOtCSAXuz0zFqJ+8WL9ODc6XDdEANXBha0twkkK00TIqJyOIbp
	VQj0pHHE/KG26dHkbyEQfYpQPcijoNSr9D3x2H1noBx32JEWdXZmlZoHRPhzmr/IqXBJFw7V08fkD
	BzFbQLJQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tckHh-00G7Js-24;
	Tue, 28 Jan 2025 12:01:37 +0000
Date: Tue, 28 Jan 2025 12:01:36 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: fossdd <fossdd@pwned.life>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] configure: Avoid addition assignment operators
Message-ID: <20250128120136.GC485209@celephais.dreamlands>
References: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>
 <Z4WSxlAq0_Ja2o44@calendula>
 <D71GI2NB7TP9.20P2VR1XEPU11@pwned.life>
 <D7C69D5AU3UF.3RUIITULHRHAZ@pwned.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tSK9oQO1sHTNwwju"
Content-Disposition: inline
In-Reply-To: <D7C69D5AU3UF.3RUIITULHRHAZ@pwned.life>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--tSK9oQO1sHTNwwju
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2025-01-26, at 18:13:59 +0100, fossdd wrote:
> On Tue Jan 14, 2025 at 3:56 AM CET, fossdd wrote:
> >> Unfortunately, we don't take patches that abuse DCO via Signed-off-by:
> >> that looks clearly made up.
> >
> > I can resend a v2 with my full name as commit author and Signed-off-by,
> > if thats what you're asking.

Yes, please.

> Ping

J.

--tSK9oQO1sHTNwwju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnmMcPCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeaI2epgEcEqoeUnH0jksUkP4hX5x5ffTh0MO32HUnz
jBYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAZ9w/7BxW/YihtoKZLlilE0SXssMxy
sDZFPuBemGldyVk6bXhqc9p1S9Oy7UtgoyRcluiLXsHwsFYyKjJf/1JpLr8Ix92L
TtaRY1nsVKTK1+NtvAXWc+lrC4PEYS3K3Yb+1efCWHGbG/LfG/6X5nnAETBBtsdo
nfnoFe8zUuPI2jnkLqEv8/iYXEk5/m18/bCEY/wUwXJGzYODlY71kzYFXDHk4FP8
xwciwjU7gNApLPxMocHOYcE6czggfP6eqxaab9zOGYpspRAWOoxFDAvQChEO0pGU
T1m4wziStQN+x04UT6tCi4hFTry//Ex8wFuK0ZY6OyAF9WqP6w9WQCDHhY6ZXmIL
N+8h5Dz//Or+pQWXyTm4Hz4FTdZLDgWuPl+CvW0u7OVZ9ZsJYaOLJx9WosEriGC/
dBe67AN8akWi/kuCwuLjRh2HTwTYqriZZsW+16JojiiBOxhl8Y3t6AYnCJSZoa07
5BElT/jcSwNiUfZODO4J+aXE0oHdHheH3WDsei8mGq3FyMtyRiLyp+WyPSut/KFo
NzzKzGr0ugsojZA/2hOirLTyALlbOLdIl+jID39X6tkoYN9Ie7vYX6GbdbTWopn4
nGjWvjhpOZkRnJno8B9xwLEOnlYwDcArJlWpy26aTIB9dKQKy4IUAt+NpuEpfDu8
D2kUQ8UlhOsHbTMJvSI=
=E26P
-----END PGP SIGNATURE-----

--tSK9oQO1sHTNwwju--
