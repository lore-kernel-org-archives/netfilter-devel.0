From: John Leach <john@johnleach.co.uk>
Subject: ipt_ROUTE bug
Date: Wed, 09 Mar 2005 12:11:18 +0000
Message-ID: <1110370278.7508.13.camel@lion>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-VPVRW7dx9rryvUi9X+DM"
Cc: delaunois@info.ucl.ac.be
To: netfilter-devel@lists.netfilter.org
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


--=-VPVRW7dx9rryvUi9X+DM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

on compiling 2.6.11 with the ROUTE target patched in from patch-o-matic
snapshot 20050307, I get the following compile error:

  CC      net/ipv4/netfilter/ipt_ROUTE.o
net/ipv4/netfilter/ipt_ROUTE.c: In function `init':
net/ipv4/netfilter/ipt_ROUTE.c:452: error: structure has no member named
`initialized'
make[4]: *** [net/ipv4/netfilter/ipt_ROUTE.o] Error 1
make[3]: *** [net/ipv4/netfilter] Error 2
make[2]: *** [net/ipv4] Error 2
make[1]: *** [net] Error 2

the lines causing the problem are in the init() function:

        /* Initialize fake conntrack so that NAT will skip it */
        route_tee_track.nat.info.initialized |=3D
                (1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);

looking at ip_nat_init() in ip_nat_core.c my guess would be this should
be replaced with:

        route_tee_track.status |=3D IPS_NAT_DONE_MASK;

any comments?  I'm not at all familiar with the netfilter code, or even
kernel programming :S

John.


--=20
GPG: B89C D450 5B2C 74D8 58FB A360 9B06 B5C2 26F0 3047
WEB: http://johnleach.co.uk

--=-VPVRW7dx9rryvUi9X+DM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCLufmmwa1wibwMEcRAmO8AKCb7QF/HosCPH9+15/RVuxFfw5wlwCfTJMM
T8PBqvqVpKHoV8Fy7iuzjsk=
=Pwzz
-----END PGP SIGNATURE-----

--=-VPVRW7dx9rryvUi9X+DM--
