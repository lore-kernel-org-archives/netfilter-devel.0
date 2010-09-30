From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 3/6] build: add debug configure flag
Date: Thu, 30 Sep 2010 23:22:01 +0200
Message-ID: <1285881721.21111.1.camel@ice-age>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
	 <1285116442-32490-4-git-send-email-eric@inl.fr>
	 <4CA45D5E.9010103@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HZhZpDDvbeGkN+MgXB6r"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57974 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab0I3VWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:22:17 -0400
In-Reply-To: <4CA45D5E.9010103@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-HZhZpDDvbeGkN+MgXB6r
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 30 septembre 2010 =E0 11:50 +0200, Pablo Neira Ayuso a =E9crit :
> On 22/09/10 02:47, Eric Leblond wrote:
> > --- a/src/Makefile.am
> > +++ b/src/Makefile.am
> > @@ -6,4 +6,8 @@ AM_CPPFLAGS =3D $(all_includes) -I$(top_srcdir)/include=
 \
> >  sbin_PROGRAMS =3D ulogd
> > =20
> >  ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c hash.c
> > +if HAVE_DEBUG
> > +ulogd_LDFLAGS =3D -lpthread -export-dynamic
>=20
> Do we still have the gdb pthread issue?

I've got it on my debian "sid" and it seems someone has got it on
bugzilla.

BR,
--=20
Eric Leblond <eric@inl.fr>
NuFW: http://www.nufw.org/

--=-HZhZpDDvbeGkN+MgXB6r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMpP92nxA7CdMWjzIRAkxHAJ9CQrlWHeuf1NlPnhRTotE06cKkdgCfWhye
lzCtll+NMvVgztItA0ALOFk=
=I0+Q
-----END PGP SIGNATURE-----

--=-HZhZpDDvbeGkN+MgXB6r--

