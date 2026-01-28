Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA737350D62
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769604652; cv=none; b=IX2kU+ccWMFATuy0F025EYamJGBHqG5of6OHcFQEU1tl36E7p51oWercnVjpY4H3HTprc0OjNLzCDwtKQufh3UCE4RJg6Qu4PuEOCmYOm4P0cpdWJ8c6IJX7CWleOo18TCw/ZMwlfsvBxrgJenbPIfyyfNDEEnz9xU9XPBkCxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769604652; c=relaxed/simple;
	bh=Z0Z3m08NPdIUks4FhEeNaA98i/wGpgJhnBTgr0+YkXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKIp5sc/hBJPXkSetfiiuGomXZOY+LxpbiT6fIToDW1DtrKLt/O0rxP02GfJbRTGAdXuPvXzkwCR+ZKeSY9eRn7KixIqwGJvakzgZJgpCV7ZsVHx93QmbvM1Hc046JedDII/W1FbpeVmXoNfD523qf7/6GaA2A3iENkudPtZqmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=MHaDytAn; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MHaDytAn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5spJKNPQ+nFtmpJe/Pllz2hLv+5u3r2qxD9bLNNUw6E=; b=MHaDytAncETWP9CkCCNuuKR5PH
	Cn/u9TlBPxP5Nf6kuAVPqTXW7xmnKnBVqn84anWggbVdVaVP7tAR+srStfVBPcBuPBAhMC12GMnzZ
	nbWULt4a6Dly12ebBAcyQKLZBta3inVkH7cUfbAMzBGfhGm7ZvioJ6QGUtRG0jApyiTjbJpEF6dig
	Np0kagoY1wWxrwNm+VvTwaINk9Qh0Sy9pND+bCLDmPxeDUbbUmIDYgt7pnxq44Zt2gREQbY0HCmEZ
	5mVaCfLcKuVHQV1x2fBpOG1ZR3z37mqFwX8MoaejN4QUDpwUPL41SGErdqazWT/DyjgjxbxkNzFg9
	gaRg2Ibg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vl50K-0000000C9de-0daH;
	Wed, 28 Jan 2026 12:50:40 +0000
Date: Wed, 28 Jan 2026 12:50:38 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Philipp Bartsch <phil@grmr.de>,
	Arnout Engelen <arnout@bzzt.net>
Subject: Re: [nftables PATCH] build: support SOURCE_DATE_EPOCH for
 reproducible build
Message-ID: <20260128125038.GA2884714@celephais.dreamlands>
References: <20260123123137.2327427-1-phil@amsel.grmr.de>
 <20260123163615.GB1387959@celephais.dreamlands>
 <aXl0orzXWNXUumUB@chamomile>
 <aXoEvAQnTjh31ImG@orbyte.nwl.cc>
 <aXoFo8uNjMMLXvvI@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7ulz1ArGMfza63my"
Content-Disposition: inline
In-Reply-To: <aXoFo8uNjMMLXvvI@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--7ulz1ArGMfza63my
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-01-28, at 13:48:35 +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > > Generating one time-stamp in the Makefile is a pain in backside.
> > > > I have come up with a way to do it, but it's fiddly.  Florian,
> > > > Phil, would it suffice to generate the time-stamp in configure?
> >
> > I deliberately chose a build timestamp, not a configure one. In most
> > cases it won't matter, but since one could defeat the stamp by
> > recompiling after making changes without calling configure.
>=20
> I don't think thats a concern.  This is geared towards official
> releases only (and catching possible issues on update path on real
> deployments, not deveopment workstation).

This is my thinking.

> So I vote for configure-time.

J.

--7ulz1ArGMfza63my
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpegYOCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmfNyHHJadkgT8Y+aszXcHmJeuFa1gfPsvdXDuhf/uZH
KxYhBGwdtFNj70A3vVbVFymGrAq98QQNAACbnQ/+IyfLQBwg1vQ5vVBy6CsPZMKp
hU8HUga+Y+RRbXPD+GzPq1Tj6qwio7ljaXwHhJItuSFKO2vTheGa/b0LJWAuKtAD
vGuXVUeWhNxWO7RsMWHTRqbNF/DqRg/kVo5i8wfjREdOHmLFIDgd6hwhV+ilxKdQ
ML+exkrtFzgf8xSZBj0CKXso0BNJZyyMf1YyGSRZpAMRA7Mp+TyCcOcInoPbu92h
H/z/KfyyEtFWXtViyjoAaMwHPSxLiWcBzAKgsp8VQ/o/Q4r1gM20kHuqP0VGEY8b
H5P1S/u+apWK9FDLrWpUZ3HGMVXUIeDKahFtFAeVbdMgFldczvqQVcupOuOuW9b0
k70pXSNQA03rsjZ3LwmF7DbMAqbXdj8ZAvIfD6TidMlsly1GG31k7nZ4Tmx5ih5N
hUJJXTZr4kKe2p5rKhivACad56wNkjfjTCu9qTrYgyr6/yT811Ax5GzN7SN5VdJ8
Y4DItW2AV3IfXwf8JwkJKMBHiuywMGf/1xWRL4ndZPaRMM6HsRzKqq+Caj7gdkF4
6wYWcqDzqe6i6FGJBsj2DKf6TzS2ZbSqMSnOIakOekJg6352wRLfkkrJZhpTAG83
gnh6518EMeQ8Ukm6upTGwIdzklueaIvhjXxhj2LoChUCc0uh9BTF+VaeIk/d5ZTL
ANF+wzt2UfCCplijfBw=
=swx9
-----END PGP SIGNATURE-----

--7ulz1ArGMfza63my--
