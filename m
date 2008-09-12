From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Fri, 12 Sep 2008 08:53:22 +0200
Message-ID: <20080912065322.GD20985@ice-age>
References: <1221166085-23435-3-git-send-email-eric@inl.fr> <48C99429.2020406@netfilter.org> <20080911221504.GC20985@ice-age> <48C99D1E.3010506@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks301150.kimsufi.com ([91.121.73.151]:48510 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYILGx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2008 02:53:28 -0400
Content-Disposition: inline
In-Reply-To: <48C99D1E.3010506@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Friday, 2008 September 12 at  0:35:10 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> >=20
> > On Thursday, 2008 September 11 at 23:56:57 +0200, Pablo Neira Ayuso wro=
te:
> >> Eric Leblond wrote:
> >>> This patch modifies the build system behaviour to be able to compile
> >>> ulogd on system without recent release of libnetfilter library. If
> >>> a library is absent or too old, it will simply not compile the concer=
ned
> >>> input module.
> >> I don't see any gain from this patch. We had this sort of conditional
> >> compilation in iptables - that we finally removed - and it was source =
of
> >> user-side problems.
> >=20
> > Hmm, even if you think autodetection is a mistake, it is useful to
> > be able to compile ulogd on system where NFLOG or NFCT is not installed
> > or not usable (too old kernel).
>=20
> We're having this discussion over and over again :), ulogd is intended
> for new systems. The ULOG target support should be legacy. You know how
> limited the ULOG target is, and how many headache gives to add new
> features to it ;)

Yes :). I was not thinking about maintaining ULOG support when doing the
work for this patch.

> > What do you think about a --without flag to be able to manually disable
> > the compilation ?
>=20
> Well, I'd prefer that but, sincerely, your obsession with legacy systems
> go really that far.

Not as far as Harald's one who put this feature in the TODO list ;)

But, my point was not really intendend to address legacy systems. I just
want to have something clean for people who for example want only to use NF=
LOG.
That will be stupid for them to compile and install libnetfilter_conntrack
on their system and not to use it.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIyhHinxA7CdMWjzIRApV+AJ9uWJsGlNkqSTgIViPgD6qkYyuYbQCeLbKm
4KFlbs3lAZVzcVp5IGg+ijM=
=hlrJ
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
