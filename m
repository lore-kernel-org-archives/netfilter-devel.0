From: Eric Leblond <eric@inl.fr>
Subject: Re: [Resend ULOGD PATCH] Add event output and make event mask
	configurable   in NFCT.
Date: Sat, 5 Apr 2008 21:24:24 +0200
Message-ID: <20080405192424.GK5333@bayen.regit.org>
References: <47E99B88.9090200@netfilter.org> <12064930002868-git-send-email-eric@inl.fr> <47EA188B.4090807@netfilter.org> <20080405102137.GC5333@bayen.regit.org> <47F79AD0.5010805@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:34026 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYDETY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:24:27 -0400
Content-Disposition: inline
In-Reply-To: <47F79AD0.5010805@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 April  5 at 17:29:20 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > I've tested and applied all my not applied ulogd2 patches other current
> > subversion tree. They apply cleanly. I've published a git tree which
> > contains this patches.
> >=20
> > Git tree: http://home.regit.org/~regit/git/ulogd2.git
> > Gitweb: http://home.regit.org/cgi-bin/gitweb.cgi?p=3Dulogd2.git;a=3Dsho=
rtlog;h=3DML
> >=20
> > The ML branch is the one containing all the patches.
>=20
> I'm not against the fact of having you all personal git trees with your
> developments. However, it make more sense to me to keep development
> trees if you have something that will take some time (for different
> reasons [1]) to get into mainline, like for example, Krisztian Kovacs's
> tproxy.

In fact, it was just informative. I just give you the address in case
you may find some advantage in using it to retrieve the patches.

This git tree is only used internally at INL to be able to develop other
the subversion tree.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH99HonxA7CdMWjzIRAgFXAJ44/jLJRKdrBZQF2iSAG/S8pXaw1ACeMKC7
wcEdvm73eNTRVVa0mg570xY=
=RJMR
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
