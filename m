From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: problems applying ipset patch
Date: Sat, 26 May 2007 05:24:39 +0200
Message-ID: <1180149879.304.16.camel@henriknordstrom.net>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
	<1179910939.18674.46.camel@henriknordstrom.net>
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com> <46555D5C.7030406@gmail.com>
	<Pine.LNX.4.64.0705241153430.18888@blackhole.kfki.hu>
	<4655668B.6000401@gmail.com>
	<1180002776.17774.18.camel@henriknordstrom.net>
	<46556CBE.9000408@gmail.com>
	<Pine.LNX.4.64.0705241321370.18888@blackhole.kfki.hu>
	<46559618.8040708@gmail.com>
	<Pine.LNX.4.64.0705241544070.18888@blackhole.kfki.hu>
	<4655997E.7010407@gmail.com> <4655AEB6.5060004@gmail.com>
	<4655B3A8.10809@gmail.com>
	<Pine.LNX.4.64.0705251555200.21023@blackhole.kfki.hu>
	<4657147E.7040602@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-9pKZjTXngimU/+5YCpDc"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4657147E.7040602@gmail.com>
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


--=-9pKZjTXngimU/+5YCpDc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-05-25 klockan 18:53 +0200 skrev Andrea:

> is there a method to resolve this mess? I could try to remove old=20
> version of iptables with "yum remove iptables", but this command also=20
> removes dependency of Shorewall, wich I would preserve.

Specify the full path to the correct binary. You most likely have the
yum installed one in /sbin, and the manually installed one
in /usr/local/sbin/

Regards
Henrik

--=-9pKZjTXngimU/+5YCpDc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARleodENPQ5Kbx8daAQKgKQP9GGmKMsnigJ4XzJyJi2m3Rh8ZWg1BEi9g
kLkuBVTRBEEKv4qX52oCPGwzD37MHf7k/XfdNIQvS8+GYOafCEwOD/MUpfcTLZHk
KczAkzbPH6pym33/OLCT5kasEAVU4Ca7oBXyOxVde/a0mc7u5nir8iKPWg9RKETh
8rbB43MXCNk=
=AYi0
-----END PGP SIGNATURE-----

--=-9pKZjTXngimU/+5YCpDc--
