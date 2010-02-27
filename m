From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2] UNIXSOCK plugin (v5)
Date: Sat, 27 Feb 2010 11:46:23 +0100
Message-ID: <1267267584.26341.25.camel@ice-age>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-akGbITt91TwwOVv6o+5d"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:51016 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965389Ab0B0Kqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:46:43 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3BDFE94011F
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2010 11:46:37 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 57B24940165
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Feb 2010 11:46:35 +0100 (CET)
In-Reply-To: <1267217680-22677-1-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-akGbITt91TwwOVv6o+5d
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 26 f=E9vrier 2010 =E0 21:54 +0100, Pierre Chifflier a =E9crit :
> Hi,
>=20
> Here is an updated version of the UNIXSOCK plugin.
>=20
> Changes for v5:
> - align all structures on 64 bits instead of 32
>   This has been tested on a sparc64 (thanks to Jan)
> - update pcap2ulog to handle different pcap formats

As change with previous version are quiet small, I don't think there
will be a "long" discussion anymore.

I will give it some tests and push this patchset to the tree if I did
not detect problem with it.

BR,

>=20
> Changes for v4:
> - use structures instead of reading integers directly
> - all structures and fields are now aligned (4 bytes)
> - update pcap2ulog script to use aligned data as well
>=20
> Changes for v3:
> - if the bufsize value (from conf) is 0, try to guess the buffer size
>   using getsockopt(SOL_SOCKET, SO_RCVBUF ..)
> - set default path to /var/run/ulogd/ulogd2.sock with mode 0600
> - add new configuration options perms, owner and group to be able
>   to set these parameters on the created socket
> - change the input algorithm to make it more robust against junk data (wh=
ich
>   can happen if the client is desynchronized)
> - fixed a few bugs
>=20
> Description:
>=20
> [1] add new input plugin UNISOCK, using a unix socket. This allows usersp=
ace
> applications to send packets to ulogd, for example to send packets offlin=
e.
> It uses a key-length-value protocol to handle optional fields or extensio=
ns.
>=20
> [2] is a Perl script to load a PCAP file and send it to ulogd using the
> UNIXSOCK plugin.
>=20
> Pierre
>=20


--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-akGbITt91TwwOVv6o+5d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLiPf5nxA7CdMWjzIRAjPyAJ9CB31L84nsyx9/gOBBwXx2WSqGyQCfU7F6
Uw6Wp3X4g+UZjww/x7FVNag=
=Pp12
-----END PGP SIGNATURE-----

--=-akGbITt91TwwOVv6o+5d--

