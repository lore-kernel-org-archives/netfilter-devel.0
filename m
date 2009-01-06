From: Eric Leblond <eric@inl.fr>
Subject: Re: Using TRACE with ulogd2
Date: Tue, 06 Jan 2009 11:34:12 +0100
Message-ID: <1231238052.15452.32.camel@khasse.inl.fr>
References: <alpine.LSU.2.00.0901061119270.28823@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jyzqakxSU90QEjstBHSt"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sean.donner@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:44877 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZAFKeO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:34:14 -0500
In-Reply-To: <alpine.LSU.2.00.0901061119270.28823@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-jyzqakxSU90QEjstBHSt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 06 janvier 2009 =C3=A0 11:28 +0100, Jan Engelhardt a =C3=A9crit :
> Hi,
>=20
>=20
> from discussions on IRC and after looking at the kernel's code, I got=20
> the impression that xt_TRACE's output can currently not be fed into=20
> ulogd2, as xt_NFLOG does not make itself available for NF Core logging=20
> through nf_log_packet() as it does not register with nf_log.c's
> nf_log_register().
> Could you consider adding this?

In fact, it should work but it can be a little tricky. You need to
declare a stack starting with a NFLOG input plugin. This plugin has to
listen to event on nflog group 0:

stack=3Dlog1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,e=
mu1:LOGEMU

[log1]
group=3D0

Under that condition, you should receive messages from TRACE.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-jyzqakxSU90QEjstBHSt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkljM6EACgkQnxA7CdMWjzJoPQCeNAdZppgT0yoLjN96NVIJpxBv
NnUAn0TpkkijHJDoJglLv/tO5+kCGCKy
=RdiD
-----END PGP SIGNATURE-----

--=-jyzqakxSU90QEjstBHSt--

