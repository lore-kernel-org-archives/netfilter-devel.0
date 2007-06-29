From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/20]: nf_conntrack: reduce masks to a subset of tuples
Date: Fri, 29 Jun 2007 02:45:06 +0200 (MEST)
Message-ID: <20070629004404.25566.47447.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: reduce masks to a subset of tuples

Since conntrack currently allows to use masks for every bit of both
helper and expectation tuples, we can't hash them and have to keep
them on two global lists that are searched for every new connection.

This patch removes the never used ability to use masks for the
destination part of the expectation tuple and completely removes
masks from helpers since the only reasonable choice is a full
match on l3num, protonum and src.u.all.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c0a3afa700989b3b3fb003cef94629194a4ccd0d
tree 661de6b7cf466720a86ce0a3a692f0156aa35162
parent 0e695813c65bdcb288476afc5c2875ed3ebb3060
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:08:57 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:08:57 +0200

 include/net/netfilter/nf_conntrack_expect.h |    3 +
 include/net/netfilter/nf_conntrack_helper.h |    5 +-
 include/net/netfilter/nf_conntrack_tuple.h  |   65 ++++++++++++++++++---------
 net/ipv4/netfilter/nf_nat_snmp_basic.c      |    6 --
 net/netfilter/nf_conntrack_amanda.c         |    6 --
 net/netfilter/nf_conntrack_expect.c         |   44 ++++--------------
 net/netfilter/nf_conntrack_ftp.c            |    3 -
 net/netfilter/nf_conntrack_h323_main.c      |   14 ------
 net/netfilter/nf_conntrack_helper.c         |    3 +
 net/netfilter/nf_conntrack_irc.c            |    3 -
 net/netfilter/nf_conntrack_netbios_ns.c     |    6 --
 net/netfilter/nf_conntrack_netlink.c        |   18 +++++--
 net/netfilter/nf_conntrack_pptp.c           |    3 -
 net/netfilter/nf_conntrack_sane.c           |    2 -
 net/netfilter/nf_conntrack_sip.c            |    3 -
 net/netfilter/nf_conntrack_tftp.c           |    3 -
 16 files changed, 71 insertions(+), 116 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index c0b1d1f..13643f7 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -16,7 +16,8 @@ struct nf_conntrack_expect
 	struct list_head list;
 
 	/* We expect this tuple, with the following mask */
-	struct nf_conntrack_tuple tuple, mask;
+	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_tuple_mask mask;
 
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index b43a75b..d62e6f0 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -24,10 +24,9 @@ struct nf_conntrack_helper
 					 * expected connections */
 	unsigned int timeout;		/* timeout for expecteds */
 
-	/* Mask of things we will help (compared against server response) */
+	/* Tuple of things we will help (compared against server response) */
 	struct nf_conntrack_tuple tuple;
-	struct nf_conntrack_tuple mask;
-	
+
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
 	int (*help)(struct sk_buff **pskb,
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index d02ce87..99934ab 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -100,6 +100,14 @@ struct nf_conntrack_tuple
 	} dst;
 };
 
+struct nf_conntrack_tuple_mask
+{
+	struct {
+		union nf_conntrack_address u3;
+		union nf_conntrack_man_proto u;
+	} src;
+};
+
 /* This is optimized opposed to a memset of the whole structure.  Everything we
  * really care about is the  source/destination unions */
 #define NF_CT_TUPLE_U_BLANK(tuple)                              	\
@@ -161,31 +169,44 @@ static inline int nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
 	return nf_ct_tuple_src_equal(t1, t2) && nf_ct_tuple_dst_equal(t1, t2);
 }
 
+static inline int nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
+					 const struct nf_conntrack_tuple_mask *m2)
+{
+	return (m1->src.u3.all[0] == m2->src.u3.all[0] &&
+		m1->src.u3.all[1] == m2->src.u3.all[1] &&
+		m1->src.u3.all[2] == m2->src.u3.all[2] &&
+		m1->src.u3.all[3] == m2->src.u3.all[3] &&
+		m1->src.u.all == m2->src.u.all);
+}
+
+static inline int nf_ct_tuple_src_mask_cmp(const struct nf_conntrack_tuple *t1,
+					   const struct nf_conntrack_tuple *t2,
+					   const struct nf_conntrack_tuple_mask *mask)
+{
+	int count;
+
+	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++) {
+		if ((t1->src.u3.all[count] ^ t2->src.u3.all[count]) &
+		    mask->src.u3.all[count])
+			return 0;
+	}
+
+	if ((t1->src.u.all ^ t2->src.u.all) & mask->src.u.all)
+		return 0;
+
+	if (t1->src.l3num != t2->src.l3num ||
+	    t1->dst.protonum != t2->dst.protonum)
+		return 0;
+
+	return 1;
+}
+
 static inline int nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
 				       const struct nf_conntrack_tuple *tuple,
-				       const struct nf_conntrack_tuple *mask)
+				       const struct nf_conntrack_tuple_mask *mask)
 {
-	int count = 0;
-
-        for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-                if ((t->src.u3.all[count] ^ tuple->src.u3.all[count]) &
-                    mask->src.u3.all[count])
-                        return 0;
-        }
-
-        for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-                if ((t->dst.u3.all[count] ^ tuple->dst.u3.all[count]) &
-                    mask->dst.u3.all[count])
-                        return 0;
-        }
-
-        if ((t->src.u.all ^ tuple->src.u.all) & mask->src.u.all ||
-            (t->dst.u.all ^ tuple->dst.u.all) & mask->dst.u.all ||
-            (t->src.l3num ^ tuple->src.l3num) & mask->src.l3num ||
-            (t->dst.protonum ^ tuple->dst.protonum) & mask->dst.protonum)
-                return 0;
-
-        return 1;
+	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
+	       nf_ct_tuple_dst_equal(t, tuple);
 }
 
 #endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 6e88505..6bfcd3a 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1276,9 +1276,6 @@ static struct nf_conntrack_helper snmp_helper __read_mostly = {
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(SNMP_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.mask.src.l3num		= 0xFFFF,
-	.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-	.mask.dst.protonum	= 0xFF,
 };
 
 static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
@@ -1290,9 +1287,6 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(SNMP_TRAP_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.mask.src.l3num		= 0xFFFF,
-	.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-	.mask.dst.protonum	= 0xFF,
 };
 
 /*****************************************************************************
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d21359e..e42ab23 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -174,9 +174,6 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= __constant_htons(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 	},
 	{
 		.name			= "amanda",
@@ -187,9 +184,6 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.udp.port	= __constant_htons(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4130ea6..83b5ad8 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -141,25 +141,16 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 {
 	/* Part covered by intersection of masks must be unequal,
 	   otherwise they clash */
-	struct nf_conntrack_tuple intersect_mask;
+	struct nf_conntrack_tuple_mask intersect_mask;
 	int count;
 
-	intersect_mask.src.l3num = a->mask.src.l3num & b->mask.src.l3num;
 	intersect_mask.src.u.all = a->mask.src.u.all & b->mask.src.u.all;
-	intersect_mask.dst.u.all = a->mask.dst.u.all & b->mask.dst.u.all;
-	intersect_mask.dst.protonum = a->mask.dst.protonum
-					& b->mask.dst.protonum;
 
 	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
 		intersect_mask.src.u3.all[count] =
 			a->mask.src.u3.all[count] & b->mask.src.u3.all[count];
 	}
 
-	for (count = 0; count < NF_CT_TUPLE_L3SIZE; count++){
-		intersect_mask.dst.u3.all[count] =
-			a->mask.dst.u3.all[count] & b->mask.dst.u3.all[count];
-	}
-
 	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
 }
 
@@ -168,7 +159,7 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 {
 	return a->master == b->master
 		&& nf_ct_tuple_equal(&a->tuple, &b->tuple)
-		&& nf_ct_tuple_equal(&a->mask, &b->mask);
+		&& nf_ct_tuple_mask_equal(&a->mask, &b->mask);
 }
 
 /* Generally a bad idea to call this: could have matched already. */
@@ -224,8 +215,6 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
-	exp->mask.src.l3num = 0xFFFF;
-	exp->mask.dst.protonum = 0xFF;
 
 	if (saddr) {
 		memcpy(&exp->tuple.src.u3, saddr, len);
@@ -242,21 +231,6 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 		memset(&exp->mask.src.u3, 0x00, sizeof(exp->mask.src.u3));
 	}
 
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
-	}
-
 	if (src) {
 		exp->tuple.src.u.all = (__force u16)*src;
 		exp->mask.src.u.all = 0xFFFF;
@@ -265,13 +239,13 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 		exp->mask.src.u.all = 0;
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
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 9ad1519..198330b 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -560,9 +560,6 @@ static int __init nf_conntrack_ftp_init(void)
 		for (j = 0; j < 2; j++) {
 			ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			ftp[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			ftp[i][j].mask.src.l3num = 0xFFFF;
-			ftp[i][j].mask.src.u.tcp.port = htons(0xFFFF);
-			ftp[i][j].mask.dst.protonum = 0xFF;
 			ftp[i][j].max_expected = 1;
 			ftp[i][j].timeout = 5 * 60;	/* 5 Minutes */
 			ftp[i][j].me = THIS_MODULE;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 61ae90f..8c57b81 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -626,8 +626,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.max_expected		= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
 	.timeout		= 240,
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-	.mask.dst.protonum	= 0xFF,
 	.help			= h245_help
 };
 
@@ -1173,9 +1171,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.tcp.port	= __constant_htons(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.tcp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 		.help			= q931_help
 	},
 	{
@@ -1187,9 +1182,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.tcp.port	= __constant_htons(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.tcp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 		.help			= q931_help
 	},
 };
@@ -1751,9 +1743,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= __constant_htons(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 		.help			= ras_help,
 	},
 	{
@@ -1764,9 +1753,6 @@ static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.udp.port	= __constant_htons(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
-		.mask.src.l3num		= 0xFFFF,
-		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-		.mask.dst.protonum	= 0xFF,
 		.help			= ras_help,
 	},
 };
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 89a5f73..fdabf82 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -34,9 +34,10 @@ struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *h;
+	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 
 	list_for_each_entry(h, &helpers, list) {
-		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
+		if (nf_ct_tuple_src_mask_cmp(tuple, &h->tuple, &mask))
 			return h;
 	}
 	return NULL;
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 79da93e..8c73407 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -239,9 +239,6 @@ static int __init nf_conntrack_irc_init(void)
 		irc[i].tuple.src.l3num = AF_INET;
 		irc[i].tuple.src.u.tcp.port = htons(ports[i]);
 		irc[i].tuple.dst.protonum = IPPROTO_TCP;
-		irc[i].mask.src.l3num = 0xFFFF;
-		irc[i].mask.src.u.tcp.port = htons(0xFFFF);
-		irc[i].mask.dst.protonum = 0xFF;
 		irc[i].max_expected = max_dcc_channels;
 		irc[i].timeout = dcc_timeout;
 		irc[i].me = THIS_MODULE;
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index ea585c7..1d59fab 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -83,9 +83,6 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 
 	exp->mask.src.u3.ip       = mask;
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
-	exp->mask.dst.u3.ip       = htonl(0xFFFFFFFF);
-	exp->mask.dst.u.udp.port  = htons(0xFFFF);
-	exp->mask.dst.protonum    = 0xFF;
 
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
@@ -104,9 +101,6 @@ static struct nf_conntrack_helper helper __read_mostly = {
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.udp.port	= __constant_htons(NMBD_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-	.mask.src.l3num		= 0xFFFF,
-	.mask.src.u.udp.port	= __constant_htons(0xFFFF),
-	.mask.dst.protonum	= 0xFF,
 	.max_expected		= 1,
 	.me			= THIS_MODULE,
 	.help			= help,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 954cc58..2064914 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1094,22 +1094,29 @@ nfattr_failure:
 static inline int
 ctnetlink_exp_dump_mask(struct sk_buff *skb,
 			const struct nf_conntrack_tuple *tuple,
-			const struct nf_conntrack_tuple *mask)
+			const struct nf_conntrack_tuple_mask *mask)
 {
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
+	struct nf_conntrack_tuple m;
+	struct nfattr *nest_parms;
+
+	memset(&m, 0xFF, sizeof(m));
+	m.src.u.all = mask->src.u.all;
+	memcpy(&m.src.u3, &mask->src.u3, sizeof(m.src.u3));
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
@@ -1447,7 +1454,8 @@ ctnetlink_create_expect(struct nfattr *cda[], u_int8_t u3)
 	exp->master = ct;
 	exp->helper = NULL;
 	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));
-	memcpy(&exp->mask, &mask, sizeof(struct nf_conntrack_tuple));
+	memcpy(&exp->mask.src.u3, &mask.src.u3, sizeof(exp->mask.src.u3));
+	exp->mask.src.u.all = mask.src.u.all;
 
 	err = nf_ct_expect_related(exp);
 	nf_ct_expect_put(exp);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 916e106..63dac5e 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -585,9 +585,6 @@ static struct nf_conntrack_helper pptp __read_mostly = {
 	.tuple.src.l3num	= AF_INET,
 	.tuple.src.u.tcp.port	= __constant_htons(PPTP_CONTROL_PORT),
 	.tuple.dst.protonum	= IPPROTO_TCP,
-	.mask.src.l3num		= 0xffff,
-	.mask.src.u.tcp.port	= __constant_htons(0xffff),
-	.mask.dst.protonum	= 0xff,
 	.help			= conntrack_pptp_help,
 	.destroy		= pptp_destroy_siblings,
 };
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 28ed303..edd10df 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -206,8 +206,6 @@ static int __init nf_conntrack_sane_init(void)
 		for (j = 0; j < 2; j++) {
 			sane[i][j].tuple.src.u.tcp.port = htons(ports[i]);
 			sane[i][j].tuple.dst.protonum = IPPROTO_TCP;
-			sane[i][j].mask.src.u.tcp.port = 0xFFFF;
-			sane[i][j].mask.dst.protonum = 0xFF;
 			sane[i][j].max_expected = 1;
 			sane[i][j].timeout = 5 * 60;	/* 5 Minutes */
 			sane[i][j].me = THIS_MODULE;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1f17f80..5b78f0e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -506,9 +506,6 @@ static int __init nf_conntrack_sip_init(void)
 		for (j = 0; j < 2; j++) {
 			sip[i][j].tuple.dst.protonum = IPPROTO_UDP;
 			sip[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			sip[i][j].mask.src.l3num = 0xFFFF;
-			sip[i][j].mask.src.u.udp.port = htons(0xFFFF);
-			sip[i][j].mask.dst.protonum = 0xFF;
 			sip[i][j].max_expected = 2;
 			sip[i][j].timeout = 3 * 60; /* 3 minutes */
 			sip[i][j].me = THIS_MODULE;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 53d57b4..db0387c 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -126,9 +126,6 @@ static int __init nf_conntrack_tftp_init(void)
 		for (j = 0; j < 2; j++) {
 			tftp[i][j].tuple.dst.protonum = IPPROTO_UDP;
 			tftp[i][j].tuple.src.u.udp.port = htons(ports[i]);
-			tftp[i][j].mask.src.l3num = 0xFFFF;
-			tftp[i][j].mask.dst.protonum = 0xFF;
-			tftp[i][j].mask.src.u.udp.port = htons(0xFFFF);
 			tftp[i][j].max_expected = 1;
 			tftp[i][j].timeout = 5 * 60; /* 5 minutes */
 			tftp[i][j].me = THIS_MODULE;
