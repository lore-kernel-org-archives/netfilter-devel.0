From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 6/6] don't use nested attributes for conntrack_expect
Date: Tue, 2 Aug 2005 12:59:22 +0200
Message-ID: <20050802105922.GM4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00sTfE/IIAT5d2r5"
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


--00sTfE/IIAT5d2r5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] don't use nested attributes for conntrack_expect

We used to use nested nfattr structures for ip_conntrack_expect.  This is
bogus, since ip_conntrack and ip_conntrack_expect are communicated in
different netlink message types.  both should be encoded at the top level
attributes, no extra nexting required.  This patch addresses the issue.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 2c431226a413ddc7071c8db7e4be560a1b49203a
tree c45ad65d012604adc37d597bf27f1634d484d9ff
parent 2f6e0aaca19a462e324ed78f01dfa06e36d73054
author Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:49:18 +0200
committer Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:49:18 +02=
00

 include/linux/netfilter/nfnetlink_conntrack.h |    3 +
 net/ipv4/netfilter/ip_conntrack_netlink.c     |   85 +++++++++++----------=
----
 2 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/=
netfilter/nfnetlink_conntrack.h
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -33,7 +33,6 @@ enum ctattr_type {
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
 	CTA_USE,
-	CTA_EXPECT,
 	CTA_ID,
 	__CTA_MAX
 };
@@ -103,10 +102,12 @@ enum ctattr_protonat {
=20
 enum ctattr_expect {
 	CTA_EXPECT_UNSPEC,
+	CTA_EXPECT_MASTER,
 	CTA_EXPECT_TUPLE,
 	CTA_EXPECT_MASK,
 	CTA_EXPECT_TIMEOUT,
 	CTA_EXPECT_ID,
+	CTA_EXPECT_HELP_NAME,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1100,18 +1100,21 @@ static inline int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
                           const struct ip_conntrack_expect *exp)
 {
+	struct ip_conntrack *master =3D exp->master;
 	u_int32_t timeout =3D htonl((exp->timeout.expires - jiffies) / HZ);
 	u_int32_t id =3D htonl(exp->id);
-	struct nfattr *nest_parms =3D NFA_NEST(skb, CTA_EXPECT);
=20
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nfattr_failure;
 	if (ctnetlink_exp_dump_tuple(skb, &exp->mask, CTA_EXPECT_MASK) < 0)
 		goto nfattr_failure;
+	if (ctnetlink_exp_dump_tuple(skb,
+				 &master->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				 CTA_EXPECT_MASTER) < 0)
+		goto nfattr_failure;
 =09
 	NFA_PUT(skb, CTA_EXPECT_TIMEOUT, sizeof(timeout), &timeout);
 	NFA_PUT(skb, CTA_EXPECT_ID, sizeof(u_int32_t), &id);
-	NFA_NEST_END(skb, nest_parms);
=20
 	return 0;
 =09
@@ -1259,10 +1262,8 @@ ctnetlink_get_expect(struct sock *ctnl,=20
 		return 0;
 	}
=20
-	if (cda[CTA_TUPLE_ORIG-1])
-		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
-	else if (cda[CTA_TUPLE_REPLY-1])
-		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY);
+	if (cda[CTA_EXPECT_MASTER-1])
+		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER);
 	else
 		return -EINVAL;
=20
@@ -1310,13 +1311,33 @@ ctnetlink_del_expect(struct sock *ctnl,=20
 	struct ip_conntrack_helper *h;
 	int err;
=20
-	/* delete by tuple needs either orig or reply tuple */
-	if (cda[CTA_TUPLE_ORIG-1])
-		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG);
-	else if (cda[CTA_TUPLE_REPLY-1])
-		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY);
-	else if (cda[CTA_HELP_NAME-1]) {
-		char *name =3D NFA_DATA(cda[CTA_HELP_NAME-1]);
+	if (cda[CTA_EXPECT_TUPLE-1]) {
+		/* delete a single expect by tuple */
+		err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
+		if (err < 0)
+			return err;
+
+		/* bump usage count to 2 */
+		exp =3D ip_conntrack_expect_find_get(&tuple);
+		if (!exp)
+			return -ENOENT;
+
+		if (cda[CTA_EXPECT_ID-1]) {
+			u_int32_t id =3D=20
+				*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+			if (exp->id !=3D ntohl(id)) {
+				ip_conntrack_expect_put(exp);
+				return -ENOENT;
+			}
+		}
+
+		/* after list removal, usage count =3D=3D 1 */
+		ip_conntrack_unexpect_related(exp);
+		/* have to put what we 'get' above.=20
+		 * after this line usage count =3D=3D 0 */
+		ip_conntrack_expect_put(exp);
+	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
+		char *name =3D NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]);
=20
 		/* delete all expectations for this helper */
 		write_lock_bh(&ip_conntrack_lock);
@@ -1332,7 +1353,6 @@ ctnetlink_del_expect(struct sock *ctnl,=20
 				__ip_ct_expect_unlink_destroy(exp);
 		}
 		write_unlock(&ip_conntrack_lock);
-		return 0;
 	} else {
 		/* This basically means we have to flush everything*/
 		write_lock_bh(&ip_conntrack_lock);
@@ -1342,30 +1362,8 @@ ctnetlink_del_expect(struct sock *ctnl,=20
 				__ip_ct_expect_unlink_destroy(exp);
 		}
 		write_unlock_bh(&ip_conntrack_lock);
-		return 0;
-	}
-
-	if (err < 0)
-		return err;
-
-	/* bump usage count to 2 */
-	exp =3D ip_conntrack_expect_find_get(&tuple);
-	if (!exp)
-		return -ENOENT;
-
-	if (cda[CTA_EXPECT_ID-1]) {
-		u_int32_t id =3D *(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
-		if (exp->id !=3D ntohl(id)) {
-			ip_conntrack_expect_put(exp);
-			return -ENOENT;
-		}
 	}
=20
-	/* after list removal, usage count =3D=3D 1 */
-	ip_conntrack_unexpect_related(exp);
-	/* have to put what we 'get' above. after this line usage count =3D=3D 0 =
*/
-	ip_conntrack_expect_put(exp);
-
 	return 0;
 }
 static int
@@ -1385,21 +1383,14 @@ ctnetlink_create_expect(struct nfattr *c
=20
 	DEBUGP("entered %s\n", __FUNCTION__);
=20
+	/* caller guarantees that those three CTA_EXPECT_* exist */
 	err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
 	if (err < 0)
 		return err;
 	err =3D ctnetlink_parse_tuple(cda, &mask, CTA_EXPECT_MASK);
 	if (err < 0)
 		return err;
-
-	if (cda[CTA_TUPLE_ORIG-1])
-		err =3D ctnetlink_parse_tuple(cda, &master_tuple, CTA_TUPLE_ORIG);
-	else if (cda[CTA_TUPLE_REPLY-1])
-		err =3D ctnetlink_parse_tuple(cda, &master_tuple,=20
-					    CTA_TUPLE_REPLY);
-	else
-		return -EINVAL;
-
+	err =3D ctnetlink_parse_tuple(cda, &master_tuple, CTA_EXPECT_MASTER);
 	if (err < 0)
 		return err;
=20
@@ -1444,7 +1435,9 @@ ctnetlink_new_expect(struct sock *ctnl,=20
=20
 	DEBUGP("entered %s\n", __FUNCTION__);=09
=20
-	if (!cda[CTA_EXPECT_TUPLE-1] || !cda[CTA_EXPECT_MASK-1])
+	if (!cda[CTA_EXPECT_TUPLE-1]
+	    || !cda[CTA_EXPECT_MASK-1]
+	    || !cda[CTA_EXPECT_MASTER-1])
 		return -EINVAL;
=20
 	err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--00sTfE/IIAT5d2r5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC71IJXaXGVTD0i/8RAgsRAKCh4VSGtH2VxBIrHHx5+ux0Krw0xgCfeRuI
iMi9kUWkrGsF3X1FRiTbmYk=
=4Rpx
-----END PGP SIGNATURE-----

--00sTfE/IIAT5d2r5--
