From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2/5] NETFILTER ctnetlink: ICMP ID is not mandatory
Date: Sat, 8 Oct 2005 00:21:57 +0200
Message-ID: <20051007222157.GM4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCFQJunhLz1tFGpX"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--lCFQJunhLz1tFGpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

I think this, too,  can still go into 2.6.14, since it is very obvious
and actually fixes a bug that prevents us from creating ICMP conntracks
=66rom userspace (probably pretty useless feature, but anyway). =20

Please apply, thanks.

[NETFILTER] ctnetlink: ICMP ID is not mandatory

The ID is only required by ICMP type 8 (echo), so it's not
mandatory for all sort of ICMP connections. This patch makes
mandatory only the type and the code for ICMP netlink messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit cecb8a8d864562529a9798fd401411158ccadf4c
tree b95a5ed7006982af722b0ff60e6b106a698cb536
parent c12716a196b7d9fc9fc64a8c7982c2564c3c998f
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:36:19 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:36:19 +0=
200

 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfil=
ter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -296,8 +296,7 @@ static int icmp_nfattr_to_tuple(struct n
 				struct ip_conntrack_tuple *tuple)
 {
 	if (!tb[CTA_PROTO_ICMP_TYPE-1]
-	    || !tb[CTA_PROTO_ICMP_CODE-1]
-	    || !tb[CTA_PROTO_ICMP_ID-1])
+	    || !tb[CTA_PROTO_ICMP_CODE-1])
 		return -1;
=20
 	tuple->dst.u.icmp.type =3D=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lCFQJunhLz1tFGpX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvUFXaXGVTD0i/8RAl3PAKCVpW5ko7iVpWShaRNTIHTK9rYoAACgnHxi
q03q7yIBzJTkjedAeTK57Kg=
=mgqt
-----END PGP SIGNATURE-----

--lCFQJunhLz1tFGpX--
