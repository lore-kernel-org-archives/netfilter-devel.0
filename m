From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if
	NFLOG_GID is not available.
Date: Fri, 27 Jun 2008 22:29:08 +0200
Message-ID: <20080627202908.GB6761@bayen.regit.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr> <485FB260.3020004@netfilter.org> <20080627194133.GA6761@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, chifflier@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:54339 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182AbYF0UX7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:23:59 -0400
Content-Disposition: inline
In-Reply-To: <20080627194133.GA6761@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Friday, 2008 June 27 at 21:41:33 +0200, Eric Leblond wrote:
> Hello,
> > As I'm about to conclude a massive release of libraries and the tools, I
> > think that forcing the use of a recent library version is better as it
> > also contains several bugfixes.

I did not really understand the meaning of the word "forcing" till I discov=
er
that you've forced the use of at least libnfnetlink 0.0.39 in configure.in.

IMHO, this is too strict and not an easy step into ulogd2 acceptance:
Instead of having a single software to compile, users will need to
compile almost all libnf* library :(

> Users prefer to use the library packaged in their system and it will
> take some time before every distribution includes the required
> libnfnetlink_log. This patch finishes to provide a clean backward
> compatibility at a really low cost.
>=20
> Furthermore, I don't think a gcc warning about "unused variable" will
> force a lot of people to upgrade ;)

But a strict configure.in will :/

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZU2UnxA7CdMWjzIRAqBCAKCFBVbhwDP+BWkvm+XbNX+k6zBoBACfQwuq
0RzrI8Wu6nEB8Ui9Zgv5pCA=
=8GD9
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
