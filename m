From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack: remove ability to use masks for
 expectation destinations
Date: Tue, 26 Jun 2007 15:59:45 +0200
Message-ID: <46811BD1.30905@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030606040702040901090804"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------030606040702040901090804
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------030606040702040901090804
Content-Type: text/x-diff;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

[NETFILTER]: nf_conntrack: remove ability to use masks for expectation destinations

Since the expectations currently allow masks for every bit, we can't
hash them and have to keep them on a global list that is searched for
every new connection. This obviously sucks, so this patch removes
the (never used) ability to use masks for the destination part of the
expectation tuple.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 873139d6b6e37954fd70dab4fe9362490da3f00b
tree 85d96c06423ce00ff40c5dfc1ff5f50435b2ba5c
parent 9b4fedd621050b1ab63dda01526b2902cd238871
author Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:50 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:50 +0200

 include/net/netfilter/nf_conntrack_expect.h |    9 ++-
 net/netfilter/nf_conntrack_expect.c         |   97 ++++++++++++++-------------
 net/netfilter/nf_conntrack_netbios_ns.c     |    7 +-
 net/netfilter/nf_conntrack_netlink.c        |   15 +++-
 4 files changed, 71 insertions(+), 57 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 173c7c1..337ab71 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -10,13 +10,20 @@ extern struct list_head nf_conntrack_expect_list;
 extern struct kmem_cache *nf_conntrack_expect_cachep;
 extern const struct file_operations exp_file_ops;
 
+struct nf_conntrack_expect_mask
+{
+	union nf_conntrack_address u3;
+	union nf_conntrack_man_proto u;
+};
+
 struct nf_conntrack_expect
 {
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
 
 	/* We expect this tuple, with the following mask */
-	struct nf_conntrack_tuple tuple, mask;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_expect_mask mask;
 
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 504fb6c..d7c7ab7 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -57,13 +57,42 @@ static void expectation_timed_out(unsigned long ul_expect)
 	nf_conntrack_expect_put(exp);
 }
 
+static int nf_ct_exp_mask_equal(const struct nf_conntrack_expect_mask *m1,
+				const struct nf_conntrack_expect_mask *m2)
+{
+	return (m1->u3.all[0] == m2->u3.all[0] &&
+		m1->u3.all[1] == m2->u3.all[1] &&
+		m1->u3.all[2] == m2->u3.all[2] &&
+		m1->u3.all[3] == m2->u3.all[3] &&
+		m1->u.all == m2->u.all);
+}
+
+static int nf_ct_exp_tuple_cmp(const struct nf_conntrack_tuple *t,
+			       const struct nf_conntrack_tuple *tuple,
+			       const struct nf_conntrack_expect_mask *mask)
+{
+	int count = 0;
+
+	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++) {
+		if ((t->src.u3.all[count] ^ tuple->src.u3.all[count]) &
+		    mask->u3.all[count])
+			return 0;
+	}
+
+	if ((t->src.u.all ^ tuple->src.u.all) & mask->u.all ||
+	    (t->src.l3num != tuple->src.l3num))
+		return 0;
+
+	return nf_ct_tuple_dst_equal(t, tuple);
+}
+
 struct nf_conntrack_expect *
 __nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
 	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
+		if (nf_ct_exp_tuple_cmp(tuple, &i->tuple, &i->mask))
 			return i;
 	}
 	return NULL;
@@ -141,26 +170,17 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 {
 	/* Part covered by intersection of masks must be unequal,
 	   otherwise they clash */
-	struct nf_conntrack_tuple intersect_mask;
+	struct nf_conntrack_expect_mask intersect_mask;
 	int count;
 
-	intersect_mask.src.l3num = a->mask.src.l3num & b->mask.src.l3num;
-	intersect_mask.src.u.all = a->mask.src.u.all & b->mask.src.u.all;
-	intersect_mask.dst.u.all = a->mask.dst.u.all & b->mask.dst.u.all;
-	intersect_mask.dst.protonum = a->mask.dst.protonum
-					& b->mask.dst.protonum;
+	intersect_mask.u.all = a->mask.u.all & b->mask.u.all;
 
 	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-		intersect_mask.src.u3.all[count] =
-			a->mask.src.u3.all[count] & b->mask.src.u3.all[count];
+		intersect_mask.u3.all[count] =
+			a->mask.u3.all[count] & b->mask.u3.all[count];
 	}
 
-	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-		intersect_mask.dst.u3.all[count] =
-			a->mask.dst.u3.all[count] & b->mask.dst.u3.all[count];
-	}
-
-	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
+	return nf_ct_exp_tuple_cmp(&a->tuple, &b->tuple, &intersect_mask);
 }
 
 static inline int expect_matches(const struct nf_conntrack_expect *a,
@@ -168,7 +188,7 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 {
 	return a->master == b->master
 		&& nf_ct_tuple_equal(&a->tuple, &b->tuple)
-		&& nf_ct_tuple_equal(&a->mask, &b->mask);
+		&& nf_ct_exp_mask_equal(&a->mask, &b->mask);
 }
 
 /* Generally a bad idea to call this: could have matched already. */
@@ -224,8 +244,6 @@ void nf_conntrack_expect_init(struct nf_conntrack_expect *exp, int family,
 	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
-	exp->mask.src.l3num = 0xFFFF;
-	exp->mask.dst.protonum = 0xFF;
 
 	if (saddr) {
 		memcpy(&exp->tuple.src.u3, saddr, len);
@@ -233,45 +251,30 @@ void nf_conntrack_expect_init(struct nf_conntrack_expect *exp, int family,
 			/* address needs to be cleared for nf_ct_tuple_equal */
 			memset((void *)&exp->tuple.src.u3 + len, 0x00,
 			       sizeof(exp->tuple.src.u3) - len);
-		memset(&exp->mask.src.u3, 0xFF, len);
-		if (sizeof(exp->mask.src.u3) > len)
-			memset((void *)&exp->mask.src.u3 + len, 0x00,
-			       sizeof(exp->mask.src.u3) - len);
+		memset(&exp->mask.u3, 0xFF, len);
+		if (sizeof(exp->mask.u3) > len)
+			memset((void *)&exp->mask.u3 + len, 0x00,
+			       sizeof(exp->mask.u3) - len);
 	} else {
 		memset(&exp->tuple.src.u3, 0x00, sizeof(exp->tuple.src.u3));
-		memset(&exp->mask.src.u3, 0x00, sizeof(exp->mask.src.u3));
-	}
-
-	if (daddr) {
-		memcpy(&exp->tuple.dst.u3, daddr, len);
-		if (sizeof(exp->tuple.dst.u3) > len)
-			/* address needs to be cleared for nf_ct_tuple_equal */
-			memset((void *)&exp->tuple.dst.u3 + len, 0x00,
-			       sizeof(exp->tuple.dst.u3) - len);
-		memset(&exp->mask.dst.u3, 0xFF, len);
-		if (sizeof(exp->mask.dst.u3) > len)
-			memset((void *)&exp->mask.dst.u3 + len, 0x00,
-			       sizeof(exp->mask.dst.u3) - len);
-	} else {
-		memset(&exp->tuple.dst.u3, 0x00, sizeof(exp->tuple.dst.u3));
-		memset(&exp->mask.dst.u3, 0x00, sizeof(exp->mask.dst.u3));
+		memset(&exp->mask.u3, 0x00, sizeof(exp->mask.u3));
 	}
 
 	if (src) {
 		exp->tuple.src.u.all = (__force u16)*src;
-		exp->mask.src.u.all = 0xFFFF;
+		exp->mask.u.all = 0xFFFF;
 	} else {
 		exp->tuple.src.u.all = 0;
-		exp->mask.src.u.all = 0;
+		exp->mask.u.all = 0;
 	}
 
-	if (dst) {
-		exp->tuple.dst.u.all = (__force u16)*dst;
-		exp->mask.dst.u.all = 0xFFFF;
-	} else {
-		exp->tuple.dst.u.all = 0;
-		exp->mask.dst.u.all = 0;
-	}
+	memcpy(&exp->tuple.dst.u3, daddr, len);
+	if (sizeof(exp->tuple.dst.u3) > len)
+		/* address needs to be cleared for nf_ct_tuple_equal */
+		memset((void *)&exp->tuple.dst.u3 + len, 0x00,
+		       sizeof(exp->tuple.dst.u3) - len);
+
+	exp->tuple.dst.u.all = (__force u16)*dst;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_init);
 
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 1093478..804ca32 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -81,11 +81,8 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 	exp->tuple.src.u.udp.port = htons(NMBD_PORT);
 
-	exp->mask.src.u3.ip       = mask;
-	exp->mask.src.u.udp.port  = htons(0xFFFF);
-	exp->mask.dst.u3.ip       = htonl(0xFFFFFFFF);
-	exp->mask.dst.u.udp.port  = htons(0xFFFF);
-	exp->mask.dst.protonum    = 0xFF;
+	exp->mask.u3.ip           = mask;
+	exp->mask.u.udp.port      = htons(0xFFFF);
 
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d56f36..188eb79 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1094,22 +1094,29 @@ nfattr_failure:
 static inline int
 ctnetlink_exp_dump_mask(struct sk_buff *skb,
 			const struct nf_conntrack_tuple *tuple,
-			const struct nf_conntrack_tuple *mask)
+			const struct nf_conntrack_expect_mask *mask)
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
+	struct nf_conntrack_tuple m;
+	struct nfattr *nest_parms;
+
+	memset(&m, 0xFF, sizeof(m));
+	m.src.u.all = mask->u.all;
+	memcpy(&m.src.u3, &mask->u3, sizeof(m.src.u3));
+
+	nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
-	ret = ctnetlink_dump_tuples_ip(skb, mask, l3proto);
+	ret = ctnetlink_dump_tuples_ip(skb, &m, l3proto);
 	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
 		goto nfattr_failure;
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
-	ret = ctnetlink_dump_tuples_proto(skb, mask, l4proto);
+	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
 	nf_ct_l4proto_put(l4proto);
 	if (unlikely(ret < 0))
 		goto nfattr_failure;

--------------030606040702040901090804--
