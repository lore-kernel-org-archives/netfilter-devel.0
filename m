From: Eric Leblond <eric@inl.fr>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 16:11:26 +0200
Message-ID: <20080522141126.GN7436@bayen.regit.org>
References: <200805221500.35587.anton.vazir@gmail.com> <20080522124801.GK7436@bayen.regit.org> <4835703C.7070801@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AYsPlKobQGgtCvjI"
Cc: Anton <anton.vazir@gmail.com>,
	Netfilter Mailinglist <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:35329 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYEVOKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 10:10:04 -0400
Content-Disposition: inline
In-Reply-To: <4835703C.7070801@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--AYsPlKobQGgtCvjI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again,

On Thursday, 2008 May 22 at 15:08:12 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Hello,
> >=20
> > I attach a patch which is working for me.
>=20
> Oh, I didn't notice this patch. I think that my patch results in a
> cleaner code. The current list handling is a bit error prone. What do
> you think?

I'm not really found of fixing it with a huge patch because libnfnetlink
code is currently stable and because the code should not evolve much
(All features are implemented and base netlink implementation is old and
stable).

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--AYsPlKobQGgtCvjI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINX8OnxA7CdMWjzIRAqUrAJ0fUhN8eEBPUOEeQ65anMB3qiAOdgCfaymL
rxvffta0h5J+yzcmAcw/jFo=
=RT8V
-----END PGP SIGNATURE-----

--AYsPlKobQGgtCvjI--
