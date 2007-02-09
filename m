From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Fri, 09 Feb 2007 03:53:29 +0100
Message-ID: <1170989609.19283.17.camel@henriknordstrom.net>
References: <45C75479.3090605@arturaz.net>
	<200702052316.14477@auguste.remlab.net>
	<1170715282.24701.13.camel@henriknordstrom.net>
	<45C89337.4020907@arturaz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-W7TU6Fj4u7JhzZTHbnqg"
Cc: netfilter-devel@lists.netfilter.org
To: =?UTF-8?Q?Art=C5=ABras_=C5=A0lajus?= <x11@arturaz.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C89337.4020907@arturaz.net>
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


--=-W7TU6Fj4u7JhzZTHbnqg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

tis 2007-02-06 klockan 16:39 +0200 skrev Art=C5=ABras =C5=A0lajus:
> Henrik Nordstrom wrote:
> > I keep my recommendation of using a proxy, and netfilter NAT or TPROXY
> > to deliver the traffic to the proxy. If you want to get fancy you can
> > combine it with a NFQUEUE filter to defer SYN from being delivered to
> > the proxy until you know the site is reachable..
>=20
> excuse me, what do you mean using proxy? Something like squid?

Was thinking writing something simpler with less protocol knowledge,
acting mainly as a TCP/UDP proxy for Netfilter, and implementing the
little protocol helpers you may need.

You probably only need a TCP proxy to acheive your goals. It's quite
unlikely fingerprinting will detect SNAT:ed UDP or GRE traffic as
originating from different hosts..

Regards
Henrik

--=-W7TU6Fj4u7JhzZTHbnqg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARcviJUNPQ5Kbx8daAQK93wP5AXsmEgXQ/wxnrFf/VfMNJX087UScIl4R
fQ2ow6yX5agP5WD4OEbujsg9Qw0Swu07PLI3imODwPphr0BwI/y+Lj3ZJn4sRW/J
XNhz+z224J95axhnJWCv0LQws0UbPrWS1NvTqqoNON4MS+Ei+CCecGwe+8KjIFz+
bB7v8P0IqHY=
=vQqc
-----END PGP SIGNATURE-----

--=-W7TU6Fj4u7JhzZTHbnqg--
