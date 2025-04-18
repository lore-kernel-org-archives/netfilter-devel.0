Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1080218AA5
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Apr 2025 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744999176; cv=none; b=me7FP1sG6C2C88i0PYA1wjoqoDwkN7rIwrrW9hEs5Dq8i8q+axbU7ZTUHAwmiF7bZ2S3tP03IslIwQ8oz3LEdEO835/PSQq62U0+A6QR9g6e8NyQVwRg7T62BbvkHrmqAdZyr3lmi6rFz59n1sU/VWkCBdZhv79VzOmbKxurh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744999176; c=relaxed/simple;
	bh=OdWONhkvSAOeQ87U7lLz0HzSCEe2EQSiKnWzAJBDhPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6xivTYQnhog+hjL7aaVet9w9TPsYxJP2fu/eB/5SX7jT6C/eYvxirTtIrEZNE37MKOaSEmVhAhAc/gAkq5PM7UuRyX6cbH7Ep5Me+yAOIbHCElcMghg5MK9ZoJjBRAux1pr0h5uTwZ0MTEpY6szrw83CINo2c48BPOO6rLN0Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=k6u9pBdr; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="k6u9pBdr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OdWONhkvSAOeQ87U7lLz0HzSCEe2EQSiKnWzAJBDhPY=; b=k6u9pBdrePyWW+t0eIGY//+13C
	xh9+7hAv4EP6lCVo2e4mRdHeMG4++lN/gNw9Fvv4QDgeDniUNPwDUkb7yo/MNfb3KOeTvtPgSf4PS
	DOkddK0K8Yyx3ag6IfOr2kz/5PqZ78J7qLDoW2WFI5Kztbqz3KCHSYNtVmM2ns7Ch4gz68Jvf9eFM
	uVtHY+wtcIf9nfZYz6xMc2gcxQPG5L1lKrGZ/eXQtuheX0ZBpFsrsvJEeJgmkiIeBdwciL8vP+mV8
	Dp9EWCyOQBy74F3MC7ZOnkhfnYPNBqMgTf5qEstXObpPjBv0tD9fgTmWuR1/HvKwqx4kpH5zOGuEc
	qW9EGkQQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u5pzp-003yVW-1s;
	Fri, 18 Apr 2025 18:59:25 +0100
Date: Fri, 18 Apr 2025 18:59:23 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ipset 2/2] bash-completion: restore fix for syntax error
Message-ID: <20250418175923.GB788356@celephais.dreamlands>
References: <20250207200813.9657-1-jeremy@azazel.net>
 <20250207200813.9657-2-jeremy@azazel.net>
 <0c582b07-9403-9525-e7b4-8b6efa0ed15b@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="29lRt5lX5/2mJDB7"
Content-Disposition: inline
In-Reply-To: <0c582b07-9403-9525-e7b4-8b6efa0ed15b@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--29lRt5lX5/2mJDB7
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-04-18, at 14:45:41 +0200, Jozsef Kadlecsik wrote:
> Sorry for the extremely long delay: your patches were set aside then were
> forgotten. Both of your patches are applied.

No problem. :)

Thanks,

J.

--29lRt5lX5/2mJDB7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJoApLuCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcPiYuWJJy2m29NBv6sUVUBLDQVsJ2umlIRpsIyMmTi
NxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAB4oQ/9EvGuE4kKNKmCu8cjPB06fGmd
R0fgNJvzuXsMC18Td8/N5sqKRN3sv9SdHWvo7EsZRYb8IOiyWdoGTt726icW7Xoi
HG6pyrl7gD5nnBl7qwnKYVRYKo1CIzf7Gv3/JKqaNQ5DuLWDoQzQ3OXvzIb90kWf
rl8C3EX9MDbo3KzGV38FKYDoESeK8Zpaet2cz87pbmPxMm1sJpZrMRowj7vN6L6T
M2tTq7D8TueiDWG9m4STowb7ZcJZ29NK07OLGA+ayZpMu5v2fE8oO28ZlZ3aPcb1
AVSZ0i5JC6tUK9Si94JPEhcIsA1xnvhgEHDZZV6SkwUwZLJG9choOGcnP6FET//l
LLa/kooqGJUvvIM6qCfMg63Rq1VIO5LKjzdvgmD4FQ0rZTf4vUyFEi8YA6Ly+TCB
DlW9W2kJ2IBtwV134yX1v+drtxz1fGP38Oqn8ee9FvU1GPymaBvTBgQpY7GlwiyR
EBpiD6+6um4vIajK2NEc3ZfeTO0NhTWTVboBiPffNEWwFbu91YWwcwRBEDBoNNKQ
1stiaBNpubl+GPV7PlMNd1CeDrHUmFj9ExjEBS7d406TwkWoxXxtP7FVc7pvOTgg
0Jd4aTuwVMt5HYpt/Ea+UYiAezKvEq1d7RX0HVS/nrDgk+mtMQYWEBt195rXgzF/
mr0Q4HKWJ9DMVHWiDYI=
=fAxN
-----END PGP SIGNATURE-----

--29lRt5lX5/2mJDB7--
