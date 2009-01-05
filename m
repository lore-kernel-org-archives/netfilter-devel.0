From: Eric Leblond <eric@inl.fr>
Subject: Re: Hi again, get the process id associated to a packet
Date: Mon, 05 Jan 2009 02:23:40 +0100
Message-ID: <1231118620.3927.18.camel@ice-age>
References: <92770c820901041643t1b460c2bj4323a60ffcfc2c94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kqenxLbUThW1Ss2Ws/zb"
Cc: netfilter-devel@vger.kernel.org
To: ilninno <ilninno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:39138 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZAEBXq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:23:46 -0500
In-Reply-To: <92770c820901041643t1b460c2bj4323a60ffcfc2c94@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-kqenxLbUThW1Ss2Ws/zb
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 05 janvier 2009 =E0 01:43 +0100, ilninno a =E9crit :
> Hello again, im the insistent newbie :)
>=20
> Im trying to get packet pid (process identifier) but netfilter and
> nfnetlink functions aren't very clear:
>=20
> I saw a reference to packed pid in:
>=20
>  struct nlmsghdr
> {
> 	__u32		nlmsg_len;	/* Length of message including header */
> 	__u16		nlmsg_type;	/* Message content */
> 	__u16		nlmsg_flags;	/* Additional flags */
> 	__u32		nlmsg_seq;	/* Sequence number */
> 	__u32		nlmsg_pid;	/* Sending process port ID */
> };

You won't find the process id information in the kernel to userspace
message. The list of available fields is available in the
(linux_)nfnetlink_queue.h file:

https://git.netfilter.org/cgi-bin/gitweb.cgi?p=3Dlibnetfilter_queue.git;a=
=3Dblob;f=3Dinclude/libnetfilter_queue/linux_nfnetlink_queue.h;h=3D191b094b=
4ae071dddefb50d04b2c08b6fcadd488;hb=3DHEAD#l35

By the way, you will find some libnetfilter_queue documentation here:
http://www.nufw.org/doc/libnetfilter_queue/

PS: for your privately send question (please avoid this), you can't bind
two programs to the same queue.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-kqenxLbUThW1Ss2Ws/zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJYWEZnxA7CdMWjzIRAnEgAJ9EgLzvW+RSM1KOaPreB9CWL/v9SACfe9Lc
8z/7iC4FUceldu4YdY32N94=
=WEsR
-----END PGP SIGNATURE-----

--=-kqenxLbUThW1Ss2Ws/zb--

