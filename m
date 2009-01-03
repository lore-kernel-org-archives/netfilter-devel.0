From: Eric Leblond <eric@inl.fr>
Subject: Re: Bug in Netfiler_queue when using small packets in 100Mb traffic
Date: Sat, 03 Jan 2009 16:32:39 +0100
Message-ID: <1230996759.28326.101.camel@ice-age>
References: <d579762c0901030638k3ddcac6dy8ee175244eaddbe9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nmsiJmwv+NDP8HGZc37S"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:37600 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbZACPcp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:32:45 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=[192.168.1.129])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1LJ8UU-0006x2-S6
	for netfilter-devel@vger.kernel.org; Sat, 03 Jan 2009 16:32:43 +0100
In-Reply-To: <d579762c0901030638k3ddcac6dy8ee175244eaddbe9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-nmsiJmwv+NDP8HGZc37S
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 03 janvier 2009 =E0 15:38 +0100, VPF a =E9crit :
> Hi, I encountered a problem with the example nfqnl_test.c when I sent
> 100Mb/s of <200ko packets. The program stopped running quickly and
> printed "unbinding from queue 0". It appears that the call recv(fd,
> buf, sizeof(buf), 0) returns an error after a few packets. (errno 105
> : No buffer space available).
>=20
> Do you see any solution to this problem?

This problem is well known. This is linked with the size of the
nfnetlink buffer. The buffer is too small to contains the data when
trafic is high. A typical workaround is to increase this size.=20

It can be done by using the nfnl_rcvbufsiz(). The code should looks
like:
 nfnl_rcvbufsiz(nfq_nfnlh(h), SIZE);

This workaround may not be sufficient and in this case a unbinding,
rebinding of the queue is needed.

BR,
--=20
Eric Leblond <eleblond@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/

--=-nmsiJmwv+NDP8HGZc37S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJX4URnxA7CdMWjzIRAgm/AJ46eoY8dEbG2GLGXfAbuR+h0rEkbQCfRMdC
znXpBfyZDKgaGy7CrkEekO8=
=QMwF
-----END PGP SIGNATURE-----

--=-nmsiJmwv+NDP8HGZc37S--

