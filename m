From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Sun, 3 Feb 2008 12:50:28 +0100
Message-ID: <20080203115028.GA25411@bayen.regit.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <47A5A411.9040307@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Cc: Holger Eitzenberger <holger@eitzenberger.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:42323 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYBCLuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:50:35 -0500
Content-Disposition: inline
In-Reply-To: <47A5A411.9040307@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sunday, 2008 February  3 at 12:22:57 +0100, Pablo Neira Ayuso wrote:
> Applied. Thanks. BTW, one question:
>=20
> >  	mi->stmt_val =3D mi->stmt + strlen(mi->stmt);
> > =20
> >  	ulogd_log(ULOGD_DEBUG, "stmt=3D'%s'\n", mi->stmt);
>=20
> Since now we use user-defined procedures and call them, we have to
> remove the old mysql and pgsql definitions from doc/ as well which does
> not use it,

You're right?

> and what about sqlite3?

I don't think sqlite3 will be able to support SQL things used in this
schema. Holger, do you confirm that ?

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHpaqEnxA7CdMWjzIRAsU3AKCTF53IrAgDH/sWW3475WGYnNtGJQCdFP7p
QvXIfirnkm3qADH1GkFecmA=
=jWTG
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
