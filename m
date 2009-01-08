From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/6] rework of nf_log refactoring
Date: Thu, 08 Jan 2009 23:01:33 +0100
Message-ID: <1231452093.10299.2.camel@ice-age>
References: <1231312622.4137.7.camel@ice-age>
	 <1231358734-20958-5-git-send-email-eric@inl.fr>
	 <alpine.LSU.2.00.0901080054080.29344@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qcfgvNhRDBZZgWtYA7qc"
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:53920 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZAHWBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:01:40 -0500
In-Reply-To: <alpine.LSU.2.00.0901080054080.29344@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-qcfgvNhRDBZZgWtYA7qc
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 08 janvier 2009 =E0 00:56 +0100, Jan Engelhardt a =E9crit :
> On Wednesday 2009-01-07 21:05, Eric Leblond wrote:
> >--- a/net/netfilter/nf_log.c
> >+++ b/net/netfilter/nf_log.c
> >@@ -172,13 +172,26 @@ static int seq_show(struct seq_file *s, void *v)
> > {
> > 	loff_t *pos =3D v;
> > 	const struct nf_logger *logger;
> >+	struct nf_logger *t;
> >+	char loggers_string[256];
> >+	int len =3D 256;
>=20

Thanks Jan for your help. I've updated the patchset to follow
your remarks. It uses seq_printf instead of a strncat for the
proc modification and I've added the __read_mostly attribute.

Last modification of the patchset is a fix a of a bug in sysctl
handling.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-qcfgvNhRDBZZgWtYA7qc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJZne6nxA7CdMWjzIRAj8WAJ0WAbxJUdyUd57p0aoan0uiYEWReACcCdoi
d1s4j360GGzP6MzCL76exd8=
=hknY
-----END PGP SIGNATURE-----

--=-qcfgvNhRDBZZgWtYA7qc--

