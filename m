From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 12:32:56 +0200
Message-ID: <1180002776.17774.18.camel@henriknordstrom.net>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com> <46555D5C.7030406@gmail.com>
	<Pine.LNX.4.64.0705241153430.18888@blackhole.kfki.hu>
	<4655668B.6000401@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-WbfQj/82wvsE9W6oYn21"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4655668B.6000401@gmail.com>
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


--=-WbfQj/82wvsE9W6oYn21
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tor 2007-05-24 klockan 12:18 +0200 skrev Andrea:
> > Please check out patch-o-matic-ng from the svn repository: I committed=20
> > the required changes yesterday to support kernel versions 2.6.21 and ab=
ove.
>=20
> is this snapshot compatible with 2.6.21?
>=20
> http://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-2=
0070523.tar.bz2

Should be fine. That snapshot is 10.5 hours old, and Jozsef's changed
ipset 25 hours ago.

If in doubt verify that
patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c is modified
yesterday after unpacking the snapshot.

  ls -l patchlets/set/linux-2.6/net/ipv4/netfilter/ipt_SET.c

Regards
Henrik

--=-WbfQj/82wvsE9W6oYn21
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlVp1UNPQ5Kbx8daAQIr7gP9GfaCQyNpVj9KM8TwO9bMeP6x7tVzdz7f
wMuZdJIMDjk39yW3i1kLjM+g6iQGVs0oUfxs6E14Ns7aOGeZcHY3ePJTN65aiCYR
boEfhTqoD/nEn8TSlH6363vHAb1SJPji6aYJmSfyTvnvt5AUKHxVI8uVXxxdAcPg
ubcktel/H8M=
=bPHu
-----END PGP SIGNATURE-----

--=-WbfQj/82wvsE9W6oYn21--
