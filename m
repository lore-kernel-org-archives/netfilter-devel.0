From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/6] ulogd.conf: Comment library dependant plugins
Date: Thu, 30 Sep 2010 23:23:57 +0200
Message-ID: <1285881837.21111.3.camel@ice-age>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
	 <1285116442-32490-3-git-send-email-eric@inl.fr>
	 <4CA45D9F.3050703@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8oNoBcyI8PFfc4fIOB+r"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60165 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab0I3VYK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:24:10 -0400
In-Reply-To: <4CA45D9F.3050703@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-8oNoBcyI8PFfc4fIOB+r
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 30 septembre 2010 =E0 11:51 +0200, Pablo Neira Ayuso a =E9crit :
> On 22/09/10 02:47, Eric Leblond wrote:
> > diff --git a/ulogd.conf.in b/ulogd.conf.in
> > index cda5bb9..de5bc11 100644
> > --- a/ulogd.conf.in
> > +++ b/ulogd.conf.in
> > @@ -25,9 +25,9 @@ loglevel=3D1
> >  # 2. options for each plugin in seperate section below
> > =20
> > =20
> > -plugin=3D"@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
> > +#plugin=3D"@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
> >  #plugin=3D"@libdir@/ulogd/ulogd_inppkt_ULOG.so"
> > -plugin=3D"@libdir@/ulogd/ulogd_inpflow_NFCT.so"
> > +#plugin=3D"@libdir@/ulogd/ulogd_inpflow_NFCT.so"
>=20
> I prefer leaving this there. I know that you are doing this because of
> the compile time new option that you have inserted. But these are the
> main plugins!

I'm ok with that. It may cause more difficulty than solve issue.

BR,
--=20
Eric Leblond <eric@inl.fr>
NuFW: http://www.nufw.org/

--=-8oNoBcyI8PFfc4fIOB+r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMpP/qnxA7CdMWjzIRAvPWAJ4xQxF6cNYqcLnttuLOuydmMCXV2QCfZBgp
iVY0HJU9UZ1G1cdWZT4s9Qg=
=qMEE
-----END PGP SIGNATURE-----

--=-8oNoBcyI8PFfc4fIOB+r--

