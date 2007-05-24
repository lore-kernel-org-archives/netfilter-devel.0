From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 11:50:51 +0200
Message-ID: <1180000251.2028.8.camel@henriknordstrom.net>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com>  <46555D5C.7030406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Wvw9vr8iwyGr2zzStvPt"
Cc: netfilter-devel@lists.netfilter.org
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46555D5C.7030406@gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-Wvw9vr8iwyGr2zzStvPt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tor 2007-05-24 klockan 11:39 +0200 skrev Andrea:

> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko]
> undefined!
> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko]
> undefined!
> WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko]
> undefined!
> WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>=20
>=20
> Maybe because I've iptables just installed, before kernel
> recompilation?
> are these warnings important?

The driver warnings is something to send to the kernel janitor to take
care of.. not related to ipset.

But the above warnings is important. The module won't work with these
warnings..

Regards
Henrik

--=-Wvw9vr8iwyGr2zzStvPt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlVf+ENPQ5Kbx8daAQIgDgP/RseIVCXQ0PMVtJBFL2xxDL6xUWqvb0mo
G7vUvV55LdEhBAl6WGKsFs2xxbMGw5C3fwFUj1GB5lObRpdzgLldbS/78ZBatbc/
y9lPk6VDfRRmVkTV3ExhNN+SLx9Ul5RpZZmie/fdqUlqdLakUaS1rFmcm8/Hftmo
kmzyDU7HThI=
=iazF
-----END PGP SIGNATURE-----

--=-Wvw9vr8iwyGr2zzStvPt--
