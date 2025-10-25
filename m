Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1430F93F
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Oct 2025 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761410026; cv=none; b=jl6RKiKBbXyxSoMe2gqBXQrVN6cdb7QTq29OJRNEnN4yXSpsFsajwRHVUjirekcCTCIkOZYIRZC4K8+Z7C9w+MSIQx/GUj1zEYPsEBXx0gy6pIr7lM+O7LcFIPWWQeqcZrLHlnV3a9epr/ZLdC5osyK7g6XTBHqe1zRv+0A0+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761410026; c=relaxed/simple;
	bh=tZhf1SNF/e9yXNH7/pIZy1QQoeFscXn365DYOS78Cng=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dK+cIlEBBV8C4VF9Z7tK5xAdmHBaKGyTwNeY2VFdIpTyLTt7j6Cf52L7koLNhWgmQKrx33aMFsac9KdFXSj5Hf+wG1ZFwMSpIcqPjPU+O5/bYmxsi8shCJeMpzPvTyKTXSAIjJhGTwR7iMc88xQXekNSHhNTxZ5oN/Qe6KcQ0Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=SiGnujyy; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SiGnujyy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1AdH5LOT6QBmMbz5VYHCxtMdW3IU9VjWsqkGURL6WC0=; b=SiGnujyyUOGoBZSMMUKmsuOw7g
	WRKnOfR0flwiiO2WOJ2N95ODsR1EVn3M62aMClX8V20zJXLacVeXZYafGAscfZzFv6T6s9rSaoCQG
	3sAMIICEeDu6d3QbgrnR3vEzr+uDM4BmfG+CicqrGJahAjQdxoKR7kPvqPDE6AHk09tUb+Z6Z+38B
	IKVQ9zLlmCQf4U0YPp91higDFHLopG8aQppvuyxLbWGJCT/6tjYFocnWhjnvRUOkvBAav20x3H3pD
	Cuwk/+AZySQwozFiclmVMD1ICkRInvy82l3HHw79fFsLeoj9U2f+SBma2hOCOWg9xynczI6VCR3N3
	Dx8gIRig==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vCgp3-00000004xES-1TSj
	for netfilter-devel@vger.kernel.org;
	Sat, 25 Oct 2025 17:08:53 +0100
Date: Sat, 25 Oct 2025 17:08:52 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: ipset download location
Message-ID: <20251025160852.GF4413@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zH0yeDb/avYSzGD0"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--zH0yeDb/avYSzGD0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

What is the canonical location for ipset release tar-balls?  The most
recent one at https://www.netfilter.org/pub/ipset/ (which is what we use
in Debian) is 7.22, but I spy 7.24 at
https://ipset.netfilter.org/install.html.

J.

--zH0yeDb/avYSzGD0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJo/PYFCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmd1A2U7y4KMnoCz66TumT1XqAeCfeNfW5Mj1BIdEKhE
KhYhBGwdtFNj70A3vVbVFymGrAq98QQNAABRvQ//RPp11z0K2EIOOQeR1QiBMyAx
02mRyacW3PjFcvPVapiq1mmUy+HQ49iNklHHEv/Cu2QScWaeG4LJOQAEUCAkiAys
Zb/z353avRr6r2ulPWmHW2AyTv7z2noaZYQc7xh7pjLyUhJ/0n0kY4iD+deYBWzj
3oms9dLrF+TfiApiC0VbbTyzeV0mHLjv481T2/dP25nNWVp3KjLifDn637ouKCPV
w5k3sI4eVxyKU7kQ4LxMWbwn8+b7mxbCJu2NSpHx9N5jjl2WZ2UixmkAGDoUuCnP
9QmYhdt+xJFyiwQMG5akIXetYlbSCU8nbpY8oh0LuYzzhlTpE+WHWJ2gXoL5wKch
BSdU+3rg6cB4S61E+gle3pNhhXYhEALKAQSPD5cfYJJGp4x2SsuVPcZ0kgpM5NS8
RVZkvCxvQgvPPwiVACNTENytDKzMVJETf/pMF4l82EtJhj/tzkkbHLhFvpSYdbXX
7xidv4v7F3VDk3iHPxkDpNmK0GGWhyGTvvoNbypq5UNLz0JiWDHH4+l+2jinwNFD
6zXFkAsvD2T2lxsMTaqEzfWdzTS7sALXzEQuNxB/mljsiX7ers4h/fCy+vYrcvuY
+xfkclXeoJgrVdSQGyJSJ2JOG+4d/xOHuMUtXulv6n0SR3XQW/SkuajQBb89cgQe
lZMi/a2zfGTFKcJc4Cg=
=jIZJ
-----END PGP SIGNATURE-----

--zH0yeDb/avYSzGD0--
