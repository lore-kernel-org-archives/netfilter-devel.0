From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if
	NFLOG_GID is not available.
Date: Fri, 27 Jun 2008 21:41:33 +0200
Message-ID: <20080627194133.GA6761@bayen.regit.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr> <485FB260.3020004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:42926 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbYF0Tga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:36:30 -0400
Content-Disposition: inline
In-Reply-To: <485FB260.3020004@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday, 2008 June 23 at 16:25:36 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch fixes a warning about an unused variable if NFLOG_GID is not=
 available
> > in libnetfilter_log.
>=20
> AFAIK, this warning happens if we use an old version of the library, righ=
t?


Yes.

> As I'm about to conclude a massive release of libraries and the tools, I
> think that forcing the use of a recent library version is better as it
> also contains several bugfixes.

Users prefer to use the library packaged in their system and it will
take some time before every distribution includes the required
libnfnetlink_log. This patch finishes to provide a clean backward
compatibility at a really low cost.

Furthermore, I don't think a gcc warning about "unused variable" will
force a lot of people to upgrade ;)

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZUJtnxA7CdMWjzIRAtKpAJ90lhNX/kviPXA8fcgZabWc5qPCeQCfZwCS
Wuze6UBUGkRjlClH2iTi4Dc=
=PEWt
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
