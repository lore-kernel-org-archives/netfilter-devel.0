From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if
	NFLOG_GID  is not available.
Date: Sat, 28 Jun 2008 12:25:59 +0200
Message-ID: <20080628102559.GC6761@bayen.regit.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr> <485FB260.3020004@netfilter.org> <20080627194133.GA6761@bayen.regit.org> <20080627202908.GB6761@bayen.regit.org> <48660A46.8090805@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:36525 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYF1KUp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:20:45 -0400
Content-Disposition: inline
In-Reply-To: <48660A46.8090805@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Saturday, 2008 June 28 at 11:54:14 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > On Friday, 2008 June 27 at 21:41:33 +0200, Eric Leblond wrote:
> >> Hello,
> >>> As I'm about to conclude a massive release of libraries and the tools=
, I
> >>> think that forcing the use of a recent library version is better as it
> >>> also contains several bugfixes.
> >=20
> > I did not really understand the meaning of the word "forcing" till I di=
scover
> > that you've forced the use of at least libnfnetlink 0.0.39 in configure=
=2Ein.
> >=20
> > IMHO, this is too strict and not an easy step into ulogd2 acceptance:
> > Instead of having a single software to compile, users will need to
> > compile almost all libnf* library :(
>=20
> This latest library release-set includes several fixes. Having the
> lastest version installed always suppose an extra effort for the users.
> Moreover, bumping the dependencies is also a way to force packagers to
> upgrade.
>=20
> >> Users prefer to use the library packaged in their system and it will
> >> take some time before every distribution includes the required
> >> libnfnetlink_log. This patch finishes to provide a clean backward
> >> compatibility at a really low cost.
>=20
> The libraries are backward compatible. We did not break the API nor ABI
> so that users with the own applications are not forced to upgrade.

I know that. The point is really not here. Work done in this area is
clearly good.

> The thing changes if we discuss about the userspace tools. I think that
> they must use the latest library release. Thus, we avoid having people
> that report problems that has been already fixed.

I really don't like this policy because it is too efficient: You will have
any report before required version of library get into the distributions
because people won't test it it there is too much work to build a test
system.
=20
> >> Furthermore, I don't think a gcc warning about "unused variable" will
> >> force a lot of people to upgrade ;)
> >=20
> > But a strict configure.in will :/
>=20
> The gcc warning is anecdotic, it was not the main reason to bump the
> dependencies.

I know that, I was just talking about the discussed patch. But after
looking at the changelog and after using ulogd2 without problem with
older libraries, I don't think the dependencies bump was needed. If a
bug in the library was preventing ulogd2 to work correctly, I will be
the first to ask for a dependencies bump but it is far from being the
case here.

> Looking at the current state of the libraries, I think that it's the
> best for now. Later on, once they get more stable and well-tested, we
> may change this policy.

Please revert commit 3178606785161296dc5a1bd4d42d965db8b3e2cd if you
want to apply this strict policy. This code is now useless.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZhG3nxA7CdMWjzIRApwHAJ9u6b8Xr32YuT6xOY/L4DbFRlQmfgCfZBUb
7AHSQdQQsOADHcs/RXDAPsk=
=zTWb
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
