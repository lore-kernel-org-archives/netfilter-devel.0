From: Eric Leblond <eric@inl.fr>
Subject: Re: ulogd2 commit
Date: Sat, 18 Apr 2009 13:17:50 +0200
Message-ID: <1240053470.10215.16.camel@ice-age>
References: <49E85F6D.9030008@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bWx+Ba0uLBYx1QCehJxH"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([91.121.73.151]:36581 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDRLSq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 07:18:46 -0400
In-Reply-To: <49E85F6D.9030008@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-bWx+Ba0uLBYx1QCehJxH
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 17 avril 2009 =E0 12:52 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Eric, Pierre,
>=20
> Please, could you justify the need for commit
> 0ff525cb0506b2c043bc9df6d7e7b486c865bc38?
>=20
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Dulogd2.git;a=3Dcommit;h=
=3D0ff525cb0506b2c043bc9df6d7e7b486c865bc38
>=20
> I don't think that it's a good idea to support external compilation of
> ulogd2 modules. We should promote people to push forward things to mainli=
ne.

I clearly agree with the goal of promoting people to push forward things
to mainline but it has to be done by openness and reactivity of
mainteners, not by technical means.

But let looks at the diffstat of this commit:
 include/Makefile.am       |    1 +
 include/ulogd/Makefile.am |    3 +--
 include/ulogd/ulogd.h     |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

That's really not a big work for anyone to arrive to the same result. An
other point is that compiling outside of tree require you to maintain
your own build system which is quiet boring.

Thus, using git to maintain you own forked branch is the easiest way to
keep your work hidden and/or non public.

IMHO, this patch does not change anything about external contribution.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-bWx+Ba0uLBYx1QCehJxH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ6bbWnxA7CdMWjzIRAuwbAJ0Wl7gQ0NgqDLzPe8EV4Hp+bEY5dwCgiLKQ
MKxTXS79c9Y/acWGF2+y/N8=
=bG4l
-----END PGP SIGNATURE-----

--=-bWx+Ba0uLBYx1QCehJxH--

