From: Eric Leblond <eric@inl.fr>
Subject: Re: NFLOG - missing packets?
Date: Thu, 15 May 2008 01:01:27 +0200
Message-ID: <20080514230127.GA7267@bayen.regit.org>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com> <20080511161837.GJ11778@ice-age> <200805121224.12073.anton.vazir@gmail.com> <482B2626.8080902@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Cc: Anton <anton.vazir@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:43633 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYENXBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 19:01:23 -0400
Content-Disposition: inline
In-Reply-To: <482B2626.8080902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wednesday, 2008 May 14 at 19:49:26 +0200, Pablo Neira Ayuso wrote:
> Anton wrote:
> > Just some extra results,
> >=20
> > seems DB drivers does such a difference, since while logging=20
> > to LOGEMU (only) target - I've go result which looks true.=20
> > But - If I enable DB logger - results in DB and LOGEMU -=20
> > are the same. Looks like DB transfers makes ULOG to not=20
> > accept packets from kernelspace
>=20
> The problem is netlink that cannot back off. Netlink is the underlying
> communication subsystem that we use to communicate kernel with usepace
> space. Since Netlink is unreliable, some log messages can vanish under
> heavy load. I guess that database insertions consumes lots of CPU
> resouces. Thus, doing online database logging in a scalable manner turns
> really hard.

IMHO, this problem is more linked with a treatment delay due to the
database connection. I will try to switch the database plugin to=20
non-blocking query and I will send you results and a patch (if results
are good).

> Instead, if you need scalability, I'd suggest to use logemu
> or whatever plain text logging facility and then convert it to a
> database *offline* if you really need advanced queries.

It will be sad to do so ;)

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIK29HnxA7CdMWjzIRAn0fAJ9WzcDw8iQjlk47i3rAMgV4z5ZysgCfYDDs
rKNhUR51dZVf3HidLLHoINU=
=Zg2L
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
