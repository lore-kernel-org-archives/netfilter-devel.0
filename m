From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 02/14] Suppress ip_as_string configuration
	variable.
Date: Sat, 5 Apr 2008 21:00:43 +0200
Message-ID: <20080405190042.GH5333@bayen.regit.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895222096-git-send-email-eric@inl.fr> <47F7952C.1030005@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:33114 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYDETAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:00:46 -0400
Content-Disposition: inline
In-Reply-To: <47F7952C.1030005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 April  5 at 17:05:16 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch suppress a now unused option. Each database module
> > have now to be used with a defined IP storage type.
>=20
> As far as I can remember, this parameter was introduced because some
> sysadmins queried the sql database directly to look for certain IPs. I
> know that this isn't good for performance but it has some clients in
> ulogd 1.x.
>=20
> Does mysql have something like the PgSQL's inet type?=20

No, there is no advanced types in MySQL.

> Looking at the
> database definitions, we are storing the IPs in binary format in mysql
> and in inet type in PgSQL. Does this mean that there's no replacement
> for the ip_as_string in mysql?

I think it could be achieved by working on a VIEW which could display
the binary field in IP string format. An other solution could be to
provide two database schemas (as it was before).

In any cases, it is not related to ulogd C code: the list of keys (with
their associated type) is given by the content of a table. Thus, there
is no need for the option ip_as_string.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH98xanxA7CdMWjzIRAgxMAJ9DzbJp5fxkETahmNayMNev6u8qSQCfU5GQ
EOmWI583IQxIf01h58WX+kI=
=Sfkb
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
