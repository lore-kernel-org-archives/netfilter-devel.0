From: Eric Leblond <eric@inl.fr>
Subject: Re: nlif_open() - nlif_close() - memory leak?
Date: Thu, 22 May 2008 09:43:19 +0200
Message-ID: <20080522074319.GD7436@bayen.regit.org>
References: <200805221053.41058.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52231 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbYEVHl7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 03:41:59 -0400
Content-Disposition: inline
In-Reply-To: <200805221053.41058.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 22 at 10:53:40 +0500, Anton wrote:
> Hello!
>=20
> Just doing some testuing of NFQUEUE, and noticed that in the=20
> simple case, if I do the following (yes, there is=20
> no "nlif_catch", but anyway) - I'm experiencing a memory=20
> leak for every open - close cycle?
> Anything I'm missing?
>=20
>        struct nlif_handle *h;
>         h =3D nlif_open();
>         if (h !=3D NULL) {
>          nlif_query(h);
>          nfq_get_indev_name(h,tb,agg.iname);
>          nfq_get_outdev_name(h,tb,agg.oname);
>          nlif_close(h);
>         }

You should not call nlif_open, nlif_close at each resolution:

Information about nlif usage:
http://software.inl.fr/trac/wiki/articles/using_nlif

Anyway, I will investigate to see what's going on. We definitely should
not have a memory leak.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINSQXnxA7CdMWjzIRAldgAJ99fBjf4JbNpTRI0HieEGIs7uWHPACdGrOj
YTc1OSj3os9mrYnDMpIRubs=
=k79R
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
