From: Eric Leblond <eric@regit.org>
Subject: Re: Ulogd crashes - NFCT polling mode + NACCT
Date: Wed, 18 Jul 2012 20:52:16 +0200
Message-ID: <1342637536.5282.8.camel@tiger.regit.org>
References: <CAAJpzgZdfV3_r4ymFLvWroRjJkaQVtUdwb4P-vf57fyGJL7bzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-oCHQz/zZ5Lb/DeucpOg1"
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36433 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2GRSxI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:53:08 -0400
In-Reply-To: <CAAJpzgZdfV3_r4ymFLvWroRjJkaQVtUdwb4P-vf57fyGJL7bzw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-oCHQz/zZ5Lb/DeucpOg1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le mercredi 18 juillet 2012 =C3=A0 08:21 -0700, Gomathivinayagam
Muthuvinayagam a =C3=A9crit :
> Hi,
>=20
> I try to use ulogd with NFCT polling mode and NACCT output. Ulogd

Can you send us information about your configuration like the stack used
for logging.

Other questions: do conntrack -L work ?

> crashes with this options, and stacktrace is given as below
> Could someone help me the reason for this failure?
>=20
> =3D=3D Stacktrace =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> #0  0x00007fe46c334445 in raise () from /lib/x86_64-linux-gnu/libc.so.6
> No symbol table info available.
> #1  0x00007fe46c337bab in abort () from /lib/x86_64-linux-gnu/libc.so.6
> No symbol table info available.
> #2  0x00007fe46c32d10e in ?? () from /lib/x86_64-linux-gnu/libc.so.6
> No symbol table info available.
> #3  0x00007fe46c32d1b2 in __assert_fail () from /lib/x86_64-linux-gnu/lib=
c.so.6
> No symbol table info available.
> #4  0x00007fe46b8d6274 in nfct_query (h=3D0x0, qt=3D<optimized out>,

If we have a NULL handle that explain the crash. Question is how we
manage to get this.

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-oCHQz/zZ5Lb/DeucpOg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAHBeAACgkQnxA7CdMWjzKt1ACeMA8QAVUsQsEMxLlReHuz6V3P
rJMAn1VefbeG1uY7X0Ztd0OIXfAzL8K0
=wiwS
-----END PGP SIGNATURE-----

--=-oCHQz/zZ5Lb/DeucpOg1--

