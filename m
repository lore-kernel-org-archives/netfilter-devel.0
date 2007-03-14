From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 23:21:34 +0100
Message-ID: <1173910894.1760.89.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>
	<45F85C89.7070107@trash.net>
	<1173905134.1760.59.camel@henriknordstrom.net>
	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2mNCpDVt4GEX9V8En8Lh"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>
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


--=-2mNCpDVt4GEX9V8En8Lh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 21:48 +0100 skrev Jan Engelhardt:

> >And frankly speaking, that rerouting could just as well be done by a
> >target.
>=20
> Haha... are you implying ipt_ROUTE? :p

Or whatever it will be in the successor to iptables..

just spewing ideas at this time. As Patrick I do not consider the core
iptables worth the effort of such redesign and if redesigning stuff then
something significantly better should be done. nf-HiPAC is one possible
alternative where a lot is done much smarter even if communication
between the projects is pretty distant at the moment.

The point is that with a good infrastructure a lot can be acheived,
without having to hardcode behavior such as mangle rerouting in the
infrastructure.

And with a little (not much) clever thinking not even the nat/filer
distinction is needed even if nat mostly applies to the first packet
only.. And regarding the ability to filter after nat: Remember that you
have the connection backing you. A NAT mapping is not much different
from a CONNMARK or other connection state.. it's just data which is
known about the packet once the rule has executed.

Regards
Henrik

--=-2mNCpDVt4GEX9V8En8Lh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfh1aUNPQ5Kbx8daAQKiUAP+JH6ZcKplsOflAdWxRsRb/Jc/JR0Rov3t
8rAfJ4kF8eUqESBb2KAJnG83QUdKf0HsWWahS6gjZY6zIRCeYpsx7HBIGS/lIIyd
R9ysSTQJ/igfcxDAPjeA5GYI9U8TlQL0keSZLYQLpB8hZvTPCAGFJHlUhCarTxqb
T8U+RRHmYI4=
=d+2z
-----END PGP SIGNATURE-----

--=-2mNCpDVt4GEX9V8En8Lh--
