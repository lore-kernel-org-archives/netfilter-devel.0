From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Mon, 05 Feb 2007 23:41:22 +0100
Message-ID: <1170715282.24701.13.camel@henriknordstrom.net>
References: <45C75479.3090605@arturaz.net>
	<200702052316.14477@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-xnob8QY8uD4rOM2+wZPo"
Cc: netfilter-devel@lists.netfilter.org,
	=?UTF-8?Q?Art=C5=ABras_=C5=A0lajus?= <x11@arturaz.net>
To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702052316.14477@auguste.remlab.net>
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


--=-xnob8QY8uD4rOM2+wZPo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

m=C3=A5n 2007-02-05 klockan 23:16 +0200 skrev R=C3=A9mi Denis-Courmont:

> I think QEMU already does that when using the "userland" driver on the=20
> host side for the guest NIC. As far as I understand, this is done using=20
> an antique piece of BSD code known as slirp. It should not be very=20
> complicated to reuse modify slirp to use a network card (the=20
> internal-side NIC of the stealth NAT box) instead of a PPP interface=20
> (as slirp originally did) or a virtual NE2000 (as QEMU does).

Indeed. The simplest way of doing so would be to grab slirpvde and
modify it slightly to run to a tun/tap device instead of vde. but slirp
do have some limitations..

I keep my recommendation of using a proxy, and netfilter NAT or TPROXY
to deliver the traffic to the proxy. If you want to get fancy you can
combine it with a NFQUEUE filter to defer SYN from being delivered to
the proxy until you know the site is reachable..

You still have full conntrack and shaping capabilities in such design.
Just needs to be applied slightly differently.

> A small=20
> extra tweak will probably be needed to steal packets from Linux IP=20
> stack.

Not much. Just a little policy routing and a tun/tap device to deliver
the packets to userland..

> Of course, it's not exactly hiding the NAT, since there is no more real=20
> NAT.

Also not much netfilter..

Regards
Henrik

--=-xnob8QY8uD4rOM2+wZPo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARceyjkNPQ5Kbx8daAQJKaQP+L8nHvZOoRzUFpFmoWJJKGW4AN67YKH57
8Kdy/Hil2S5doLBEDfRey7iXaDZ08e/u0fimb5ZYeZIZrjm++WI8oN/kGjIIjLzO
UFkSgfR0sZ7i916B4/lNsg9lfAC0UfFws2j1bifdC6LyguRks4NS3GdLQa/Ai4uA
Fd9PYHU9fOE=
=w8uR
-----END PGP SIGNATURE-----

--=-xnob8QY8uD4rOM2+wZPo--
