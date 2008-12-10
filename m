From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/4] Link ulogd2 with libpthread
Date: Wed, 10 Dec 2008 12:00:36 +0100
Message-ID: <1228906836.2872.20.camel@khasse.inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
	 <1228135316-12578-2-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bf6+yJi3kjYL8AXlsNc4"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:41747 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLJLAj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:00:39 -0500
In-Reply-To: <1228135316-12578-2-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Bf6+yJi3kjYL8AXlsNc4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 01 d=C3=A9cembre 2008 =C3=A0 13:41 +0100, Pierre Chifflier a =C3=
=A9crit :
> Explicitly link with libpthread. This allows to run ulogd within gdb,
> else it fails with message: Cannot find new threads: generic error

Applied, thanks.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-Bf6+yJi3kjYL8AXlsNc4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/oU8ACgkQnxA7CdMWjzK90ACfSDKDTIi/8HlS2UIy79EZ4uey
TVIAnjhKxKgt/WYIPiT43Ykoaw5qBP/H
=vWiw
-----END PGP SIGNATURE-----

--=-Bf6+yJi3kjYL8AXlsNc4--

