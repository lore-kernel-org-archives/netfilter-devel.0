From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 12 Feb 2007 18:08:01 +0200
Message-ID: <200702121808.04643@auguste.remlab.net>
References: <20070114192011.GA6270@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1351427.FdJYKqlN8S";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: David Madore <david.madore@ens.fr>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070114192011.GA6270@clipper.ens.fr>
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

--nextPart1351427.FdJYKqlN8S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le dimanche 14 janvier 2007 21:20, David Madore a =E9crit :
> Implement TCPMSS target for IPv6 by shamelessly copying from
> Marc Boucher's IPv4 implementation.

Most of the code seems to be TCP- rather IPvXY- specific. Would it not=20
make more sense to just write a xt_TCPMSS implementation to rule them=20
all?

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/

--nextPart1351427.FdJYKqlN8S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkXQkOQACgkQw+xtvt1tEr0ujQCg+FGknjWn90221/FXKfV1qZQT
piMAoNVHCJ/jZMgo3Ohl+8XPBPhb5IlW
=avpw
-----END PGP SIGNATURE-----

--nextPart1351427.FdJYKqlN8S--
