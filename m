From: Eric Leblond <eric@inl.fr>
Subject: Re: [libnetfilter_queue 4/4] Switch documentation style to doxygen.
Date: Mon, 22 Dec 2008 11:55:43 +0100
Message-ID: <1229943343.26038.2.camel@khasse.inl.fr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
	 <1229722591-7836-5-git-send-email-eric@inl.fr>
	 <494F6FB5.3090204@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wXMnqKeSTkmwNLBb/YSY"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:51948 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYLVKzp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:55:45 -0500
In-Reply-To: <494F6FB5.3090204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-wXMnqKeSTkmwNLBb/YSY
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 22 d=C3=A9cembre 2008 =C3=A0 11:45 +0100, Pablo Neira Ayuso a =C3=
=A9crit :
> Eric Leblond wrote:
> > This patch modifies the documentation format to switch to doxygen
> > format. This leads to a interesting and useful output. An example
> > can be found at the following url:
> > 	http://www.nufw.org/doc/libnetfilter_queue/
>=20
> I was thinking about using kerneldoc utility, but doxygen is better at
> this moment.

Good choice, doxygen is really fine and the documentation task was quiet
painful ;)

>  Could you also send the doxygen configuration file to put
> it in the git tree?

The patch will be in the following mail.

> Once I generate the doxygen documentation, I'm going to add it to the
> netfilter website.

Fine.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-wXMnqKeSTkmwNLBb/YSY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklPcioACgkQnxA7CdMWjzKJ7wCfUjsdpQYgEjCjPMUYNEi/KqQJ
xlsAn2VVyk1iYf0HMdGwCjJSGpWfZpoZ
=S6Q4
-----END PGP SIGNATURE-----

--=-wXMnqKeSTkmwNLBb/YSY--

