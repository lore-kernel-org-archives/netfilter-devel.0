Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98735966
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2025 13:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763212556; cv=none; b=ZS+004OefterqntOOjLrQR13w3ptnOPVND9SB+l7CuxgAuyq0lhRphYJxbiJbb0Q3kTEYmQGlszKPmFiI5qUunV7TVG+LJAKURt2/4jnY74B0jJnNq0bvknXpKnxLWz4HwFIghRYEDpVxD79ABpl69DswCA0c5NzbPYvl7weNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763212556; c=relaxed/simple;
	bh=T4CY9cQTw/YY0u9B3vAND5impotqXJBxDfDiIlXIid8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwj+qUO53JXiVCYfCcHPvVgauIdn/+DMejAWBqqffO4yS+LXiS+3aL6CIN1wW9rylgEcUCSNbMc4ovcFZi5rowkUK3m+ODgYZT4fJuStZlFGwbhuQ2kP4dAVSwePtOLvEyLeL+Ou05Z1vcodkd3R5eC4d3B7qfTLRxJWcabhBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=PIlaV1nh; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="PIlaV1nh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lnwyov/mTvyIWsjQkDPa6T1Fk5SbRjgahZSOmlviqUs=; b=PIlaV1nhp0jJ4BycRDs8Ul+4aI
	c4iS/pCiX0mLA1kZwBamAueSek/VlcGYl3aZhd1MHFwrce4UalZQUpTMiUvUfwpP4FpydBKJ1BUrF
	CCj2QfJXwTVd9rx9FeCPPk2rDzNuBilILBJyLBdwWCoQfRlW01WgvIS/luzORxU/TqV4PcADAVLaO
	xE0M7NpDdIIayqqtMOTXoBSBWUYrfTRwNwOdHsB/5r9Y7qcIY9b48jlmJQkCygPZhsvKmw2D7MoGe
	oAy65+/bu74U4bVhY5lXRXRkyxtgxl5g/LpHHAeHmbStYugEOC/xMx3R8CipGliAboTrKRdNguxCE
	th8IQf7A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vKG88-0000000211Z-3Llj;
	Sat, 15 Nov 2025 13:15:52 +0000
Date: Sat, 15 Nov 2025 13:15:51 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <20251115131551.GD269079@celephais.dreamlands>
References: <20251114210109.1825562-1-jeremy@azazel.net>
 <20251114213718.GB269079@celephais.dreamlands>
 <aRhotOKf6VjOWX2f@strlen.de>
 <20251115125435.GC269079@celephais.dreamlands>
 <aRh7oi9SGQKCfhWP@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4a4z/UG30SE4x4GQ"
Content-Disposition: inline
In-Reply-To: <aRh7oi9SGQKCfhWP@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--4a4z/UG30SE4x4GQ
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-11-15, at 14:09:54 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2025-11-15, at 12:49:24 +0100, Florian Westphal wrote:
> > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> > > > > Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_chec=
k()"), if
> > > > > multiple commands were given, options which were legal for any of=
 the commands
> > > > > were considered legal for all of them.  This allowed one to do th=
ings like:
> > > >
> > > >	# iptables -n -L -Z chain
> > >
> > > Whats wrong with it?
> > >
> > > This failed before
> > > 192c3a6bc18f ("xshared: Accept an option if any given command allows =
it"), yes.
> > >
> > > Is it still broken?  If yes, what isn't working?
> >
> > The iptables man-page description of the `-L` command includes the
> > following:
> >
> > 	Please note that it is often used with the -n option, in order
> > 	to avoid long reverse DNS lookups.  It is legal to specify the
> > 	-Z (zero) option as well, in which case the chain(s) will be
> > 	atomically listed and zeroed.
> >
> > This works as expected in 1.8.10:
> >
> > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -=
-version
> > 	iptables v1.8.10 (nf_tables)
> > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -=
n -L -Z INPUT
> > 	# Warning: iptables-legacy tables present, use iptables-legacy to see =
them
> > 	Chain INPUT (policy ACCEPT)
> > 	target     prot opt source               destination
> > 	LIBVIRT_INP  0    --  0.0.0.0/0            0.0.0.0/0
> >
> > However, it does not work in 1.8.11:
> >
> > 	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -=
n -L -Z INPUT
> > 	iptables v1.8.11 (nf_tables): Illegal option `--numeric' with this com=
mand
> > 	Try `iptables -h' or 'iptables --help' for more information.
>=20
> But this works in git :-/
>=20
> So again, what exactly is broken? AFAICS everything works as expected:
>=20
> iptables/xtables-nft-multi iptables -n -L -v -Z foo
> Chain foo (1 references)
>  pkts bytes target     prot opt in     out     source               desti=
nation
>     1    36            all  --  *      *       0.0.0.0/0            0.0.0=
=2E0/0
> Zeroing chain `foo'
> iptables/xtables-nft-multi iptables -n -L -v -Z foo
> Chain foo (1 references)
>  pkts bytes target     prot opt in     out     source               desti=
nation
>     0     0            all  --  *      *       0.0.0.0/0            0.0.0=
=2E0/0
> Zeroing chain `foo'

Damn it.  You're right.  Obviously, it's already been fixed.  Apologies.
Been rather unwell this week and clearly I'm still somewhat dim-witted.

Thanks, Florian.

J.

--4a4z/UG30SE4x4GQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpGH0GCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcneVEHFk0Key7sYBiPJwg9K+L/3S73so4Rsr9Y59XC
CRYhBGwdtFNj70A3vVbVFymGrAq98QQNAAB6nw//RShreGpgWYdILecptK/8GEbd
zIkto2GRbU738xywA4wDMCTgRGsjnt+/lqzPUPlovmeH8hmiwqds/RDy2OVhjHTY
hZse2wimeQGmvvTXDgRjhOCPJHZQaWqH6RHLKUmE0Y53OL+64+aTZzP1yoQHsczU
BSwFzIS5M0ryG3FZjPIxH59Ax1Vnb9WWeQCchfxQqIiI4OwUsQpVoaKcUh48lWL1
mntjxFVbg+nvZvAWQp4LslivY9Ct2oPcRXN3I3jRQKGbAIvjr2zTE9QJ5Hmx0H36
4+TweiyRXj0vDFTLU+EzEKmyJPBu5rHqenZVRwQPAxjdtdx2ca8Ou8ZlOKZ47aU7
81Faeks4M50Uv09waXn/hzVKvnEWn3A7hEBDxkJm+32RsBGjvXoHHR5fWBn9uF87
snfROfbUkI7Tzigm6kT+1J272ho367PuXmiLRMUN6w5/bw5Ty2nZvhPUa1qfTRxa
L+KK0zgf2bfQyTOIeANht/5g2WbQYbbZJY8VnGg4RMmux4fcXknabKSqsygf2bPr
N34IFgBINMrBJjjJL7LYgp9ER/IBgClsK6DEwqtdu53V9psobMIDyKa++2uZFETI
a/9KAmPheMJJd/3FtcUI7BmeDJ/5un+RQoa+gxUSfpFeWJAhXoVq9KRNJllEyuSi
YaHKyngx3r0w1lrguYs=
=9dm+
-----END PGP SIGNATURE-----

--4a4z/UG30SE4x4GQ--
