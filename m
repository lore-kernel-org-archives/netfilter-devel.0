From: Eric Leblond <eric@inl.fr>
Subject: Re: How can i leave a packet to continue the iptables ruleset
 checking?
Date: Fri, 02 Jan 2009 00:12:13 +0100
Message-ID: <1230851533.5185.20.camel@ice-age>
References: <92770c820812231302q709cba94ua93e0ec210a906a1@mail.gmail.com>
	 <92770c820901011255y76b557b7ha4850c54fd62b28e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yuex3CR4escrvmKoSLO8"
Cc: netfilter-devel@vger.kernel.org
To: ilninno <ilninno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:53122 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZAAXMX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jan 2009 18:12:23 -0500
In-Reply-To: <92770c820901011255y76b557b7ha4850c54fd62b28e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-yuex3CR4escrvmKoSLO8
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 01 janvier 2009 =E0 21:55 +0100, ilninno a =E9crit :
> Hello! I have some problems with netfilter_queue:
>=20
> I created a queue and registered my c program, when a packet matchs
> with the iptables rules my code get the event. i usually return
> NF_ACCEPT and NF_DROP, but sometimes i need to leave the packet to
> continue with iptables rules checking, i tried with:
>=20
> How can i leave the packet to continue in iptables ruleset without
> beginning again?  Thanks for your time.

You really can't. The only known workaround is to send the NF_REPEAT
verdict and mark the packet. The mark can then be used to "jump" to the
correct rule.

This is not really nice but it works.

I've recently cooked a patch for snort-inline using this method:
http://sourceforge.net/mailarchive/forum.php?thread_name=3D1228209364-7798-=
1-git-send-email-eric%40inl.fr&forum_name=3Dsnort-inline-users

The method seems to work quiet well but it may not be suitable for more
complex cases.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-yuex3CR4escrvmKoSLO8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJXU3KnxA7CdMWjzIRAqyXAJ4jOtu5KrCoeDjmZvFN6c24nrH93gCeJzxG
jBP/xuCDkRiGHQJBKdR/M3s=
=FgDc
-----END PGP SIGNATURE-----

--=-yuex3CR4escrvmKoSLO8--

