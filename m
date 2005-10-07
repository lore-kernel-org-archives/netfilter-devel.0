From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 1/5] NETFILTER ctnetlink: use ENOMEM instead of -1
Date: Sat, 8 Oct 2005 00:19:48 +0200
Message-ID: <20051007221948.GL4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dPW7zu3hTOhZvCDO"
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


--dPW7zu3hTOhZvCDO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

I think this can still go into 2.6.14, since it is very obvious and
actually fixes a bug.  Please apply, thanks.

[NETFILTER] ctnetlink: use ENOMEM instead of -1 (-ENOPERM)

Fix the return value of NFA_PUT on fail. Now it returns -ENOMEM
instead of -1 (-ENOPERM) since NFA_PUT only fails if there's no
enough space in the netlink message for the new attribute that
will be added. Thanks to Patrick McHardy for spotting this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit c12716a196b7d9fc9fc64a8c7982c2564c3c998f
tree 2d7bd287926008f17bbf0df3431f6642f6bcc041
parent 4714eea267d67e65aabb6518cbfa81b8c45c2147
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:34:46 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:34:46 +0=
200

 net/ipv4/netfilter/ip_conntrack_netlink.c    |   42 +++++++++++++---------=
----
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |    2 +
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c  |    2 +
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -68,7 +68,7 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -89,7 +89,7 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -100,7 +100,7 @@ ctnetlink_dump_status(struct sk_buff *sk
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -118,7 +118,7 @@ ctnetlink_dump_timeout(struct sk_buff *s
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -143,7 +143,7 @@ ctnetlink_dump_protoinfo(struct sk_buff=20
 	return ret;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -165,7 +165,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 #ifdef CONFIG_IP_NF_CT_ACCT
@@ -188,7 +188,7 @@ ctnetlink_dump_counters(struct sk_buff *
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
 #else
 #define ctnetlink_dump_counters(a, b, c) (0)
@@ -204,7 +204,7 @@ ctnetlink_dump_mark(struct sk_buff *skb,
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
 #else
 #define ctnetlink_dump_mark(a, b) (0)
@@ -218,7 +218,7 @@ ctnetlink_dump_id(struct sk_buff *skb, c
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -230,7 +230,7 @@ ctnetlink_dump_use(struct sk_buff *skb,=20
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 #define tuple(ct, dir) (&(ct)->tuplehash[dir].tuple)
@@ -283,7 +283,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 nlmsg_failure:
 nfattr_failure:
 	skb_trim(skb, b - skb->data);
-	return -1;
+	return -ENOMEM;
 }
=20
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
@@ -499,7 +499,7 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static const int cta_min_proto[CTA_PROTO_MAX] =3D {
@@ -541,7 +541,7 @@ ctnetlink_parse_tuple_proto(struct nfatt
 	return ret;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -585,7 +585,7 @@ ctnetlink_parse_tuple(struct nfattr *cda
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 #ifdef CONFIG_IP_NF_NAT_NEEDED
@@ -628,7 +628,7 @@ static int ctnetlink_parse_nat_proto(str
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static inline int
@@ -667,7 +667,7 @@ ctnetlink_parse_nat(struct nfattr *cda[]
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
 #endif
=20
@@ -689,7 +689,7 @@ ctnetlink_parse_help(struct nfattr *attr
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static int
@@ -827,7 +827,7 @@ ctnetlink_get_conntrack(struct sock *ctn
 out:
 	if (skb2)
 		kfree_skb(skb2);
-	return -1;
+	return err;
 }
=20
 static inline int
@@ -1093,7 +1093,7 @@ ctnetlink_exp_dump_tuple(struct sk_buff=20
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }		=09
=20
 static inline int
@@ -1119,7 +1119,7 @@ ctnetlink_exp_dump_expect(struct sk_buff
 	return 0;
 =09
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static int
@@ -1152,7 +1152,7 @@ ctnetlink_exp_fill_info(struct sk_buff *
 nlmsg_failure:
 nfattr_failure:
 	skb_trim(skb, b - skb->data);
-	return -1;
+	return -ENOMEM;
 }
=20
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfil=
ter/ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -289,7 +289,7 @@ static int icmp_tuple_to_nfattr(struct s
 	return 0;
=20
 nfattr_failure:
-	return -1;
+	return -ENOMEM;
 }
=20
 static int icmp_nfattr_to_tuple(struct nfattr *tb[],
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilt=
er/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -350,7 +350,7 @@ static int tcp_to_nfattr(struct sk_buff=20
=20
 nfattr_failure:
 	read_unlock_bh(&tcp_lock);
-	return -1;
+	return -ENOMEM;
 }
 #endif
=20
--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--dPW7zu3hTOhZvCDO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvSEXaXGVTD0i/8RAq7HAJ9FUnD/YZU+746UAlT+mohWiKz4KgCeIm22
wwfuJqkPHEWA/0XQOlN+0NU=
=FozN
-----END PGP SIGNATURE-----

--dPW7zu3hTOhZvCDO--
