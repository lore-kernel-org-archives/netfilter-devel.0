From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 1/6] remove bogus memset() calls from ip_conntrack_netlink.c
Date: Tue, 2 Aug 2005 12:55:29 +0200
Message-ID: <20050802105529.GH4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+G3HLlWI7eRTl+h"
Cc: Linux Netdev List <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--k+G3HLlWI7eRTl+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] remove bogus memset() calls from ip_conntrack_netlink.c

nfattr_parse_nested() calls nfattr_parse() which in turn does a memset on
the 'tb' array.  All callers therefore don't need to memset before calling
it.

Signed-off-by: Pablo Neira <pablo@eurodev.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit c4e2485887523a16e9c37a21a1d95ac10633ef0a
tree a86946c1fa855ed8a76be2efe4fef3c8a5a1c7a6
parent 883b2070f68548537042038d9868c829fc20d463
author Harald Welte <laforge@netfilter.org> Mo, 01 Aug 2005 22:21:59 +0200
committer Harald Welte <laforge@netfilter.org> Mo, 01 Aug 2005 22:21:59 +02=
00

 net/ipv4/netfilter/ip_conntrack_netlink.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -479,7 +479,6 @@ ctnetlink_parse_tuple_ip(struct nfattr *
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
-	memset(tb, 0, CTA_IP_MAX * sizeof(tb));
 =09
 	if (nfattr_parse_nested(tb, CTA_IP_MAX, attr) < 0)
 		goto nfattr_failure;
@@ -522,8 +521,6 @@ ctnetlink_parse_tuple_proto(struct nfatt
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
-	memset(tb, 0, CTA_PROTO_MAX * sizeof(tb));
-=09
 	if (nfattr_parse_nested(tb, CTA_PROTO_MAX, attr) < 0)
 		goto nfattr_failure;
=20
@@ -556,7 +553,6 @@ ctnetlink_parse_tuple(struct nfattr *cda
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
-	memset(tb, 0, CTA_TUPLE_MAX * sizeof(tb));
 	memset(tuple, 0, sizeof(*tuple));
=20
 	if (nfattr_parse_nested(tb, CTA_TUPLE_MAX, cda[type-1]) < 0)
@@ -607,8 +603,6 @@ static int ctnetlink_parse_nat_proto(str
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
-	memset(tb, 0, CTA_PROTONAT_MAX * sizeof(tb));
-
 	if (nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr) < 0)
 		goto nfattr_failure;
=20
@@ -646,7 +640,6 @@ ctnetlink_parse_nat(struct nfattr *cda[]
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
-	memset(tb, 0, CTA_NAT_MAX * sizeof(tb));
 	memset(range, 0, sizeof(*range));
 =09
 	if (nfattr_parse_nested(tb, CTA_NAT_MAX, cda[CTA_NAT-1]) < 0)
@@ -684,7 +677,6 @@ ctnetlink_parse_help(struct nfattr *attr
 	struct nfattr *tb[CTA_HELP_MAX];
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
-	memset(tb, 0, CTA_HELP_MAX * sizeof(tb));
=20
 	if (nfattr_parse_nested(tb, CTA_HELP_MAX, attr) < 0)
 		goto nfattr_failure;
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--k+G3HLlWI7eRTl+h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC71EfXaXGVTD0i/8RAvkyAJoDoYgliOek3da6zaOLwfjUrIpxTQCdHaMc
muj28WhT8vIhsPRjUMdL2OQ=
=Aj6C
-----END PGP SIGNATURE-----

--k+G3HLlWI7eRTl+h--
