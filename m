From: =?utf-8?q?R=C3=A9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: Need an iptables module for hiding NAT.
Date: Mon, 5 Feb 2007 23:16:06 +0200
Message-ID: <200702052316.14477@auguste.remlab.net>
References: <45C75479.3090605@arturaz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart18584777.0EYgtNNfh1";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org,
	=?utf-8?q?Art=C5=ABras_=C5=A0lajus?= <x11@arturaz.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C75479.3090605@arturaz.net>
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

--nextPart18584777.0EYgtNNfh1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le lundi 5 f=C3=A9vrier 2007 17:59, Art=C5=ABras =C5=A0lajus a =C3=A9crit :
> I need iptables module which would hide NAT. It means that all
> traffic being routed through the machine which is running netfilter
> and doing routing should be seen as originating from that host.
(...)

I think QEMU already does that when using the "userland" driver on the=20
host side for the guest NIC. As far as I understand, this is done using=20
an antique piece of BSD code known as slirp. It should not be very=20
complicated to reuse modify slirp to use a network card (the=20
internal-side NIC of the stealth NAT box) instead of a PPP interface=20
(as slirp originally did) or a virtual NE2000 (as QEMU does). A small=20
extra tweak will probably be needed to steal packets from Linux IP=20
stack.

Of course, it's not exactly hiding the NAT, since there is no more real=20
NAT.

> I hope somebody can help me, any shared thoughts about difficulty of
> doing such task and time involved would be appreciated (i'm a
> programmer myself, just not C and kernel ;-))

=2D-=20
R=C3=A9mi Denis-Courmont
http://www.remlab.net/

--nextPart18584777.0EYgtNNfh1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkXHnp4ACgkQw+xtvt1tEr2GOACbB5b6g59iZ0D1IWh6ObhcEL9A
gtwAoOqvAhT1Ir2mL2OoanijNOPiU3Qt
=GZyz
-----END PGP SIGNATURE-----

--nextPart18584777.0EYgtNNfh1--
