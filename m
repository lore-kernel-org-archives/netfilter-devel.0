From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/20]: nf_conntrack: add helper function for
	expectation initialization
Date: Sat,  2 Dec 2006 15:49:51 +0100 (MET)
Message-ID: <20061202145256.1381.93970.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: add helper function for expectation initialization

Expectation address masks need to be differently initialized depending
on the address family, create helper function to avoid cluttering up
the code too much.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3aaeacdbed7ac9ef0fbf569f45c8a9ee4323ab19
tree 3288e7f3bae1c703aac53b7a2063e9adb74745ff
parent c36fe54cbb2515da933901095b4df503d9943bfd
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:07 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:07 +0100

 include/net/netfilter/nf_conntrack_expect.h |    4 ++
 include/net/netfilter/nf_conntrack_tuple.h  |   10 +---
 net/netfilter/nf_conntrack_expect.c         |   68 +++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index b969c43..54a3d03 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -68,6 +68,10 @@ void nf_conntrack_unexpect_related(struc
 /* Allocate space for an expectation: this is mandatory before calling
    nf_conntrack_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me);
+void nf_conntrack_expect_init(struct nf_conntrack_expect *, int,
+			      union nf_conntrack_address *,
+			      union nf_conntrack_address *,
+			      u_int8_t, __be16 *, __be16 *);
 void nf_conntrack_expect_put(struct nf_conntrack_expect *exp);
 int nf_conntrack_expect_related(struct nf_conntrack_expect *expect);
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index be9dc9a..c96a9c5 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -24,7 +24,7 @@ #define NF_CT_TUPLE_L3SIZE	4
 
 /* The l3 protocol-specific manipulable parts of the tuple: always in
    network order! */
-union nf_conntrack_man_l3proto {
+union nf_conntrack_address {
 	u_int32_t all[NF_CT_TUPLE_L3SIZE];
 	__be32 ip;
 	__be32 ip6[4];
@@ -54,7 +54,7 @@ union nf_conntrack_man_proto
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man
 {
-	union nf_conntrack_man_l3proto u3;
+	union nf_conntrack_address u3;
 	union nf_conntrack_man_proto u;
 	/* Layer 3 protocol */
 	u_int16_t l3num;
@@ -67,11 +67,7 @@ struct nf_conntrack_tuple
 
 	/* These are the parts of the tuple which are fixed. */
 	struct {
-		union {
-			u_int32_t all[NF_CT_TUPLE_L3SIZE];
-			u_int32_t ip;
-			u_int32_t ip6[4];
-		} u3;
+		union nf_conntrack_address u3;
 		union {
 			/* Add other protocols here. */
 			u_int16_t all;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index aa5903e..68623ae 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -196,6 +196,74 @@ struct nf_conntrack_expect *nf_conntrack
 	return new;
 }
 
+void nf_conntrack_expect_init(struct nf_conntrack_expect *exp, int family,
+			      union nf_conntrack_address *saddr,
+			      union nf_conntrack_address *daddr,
+			      u_int8_t proto, __be16 *src, __be16 *dst)
+{
+	int len;
+
+	if (family == AF_INET)
+		len = 4;
+	else
+		len = 16;
+
+	exp->flags = 0;
+	exp->expectfn = NULL;
+	exp->helper = NULL;
+	exp->tuple.src.l3num = family;
+	exp->tuple.dst.protonum = proto;
+	exp->mask.src.l3num = 0xFFFF;
+	exp->mask.dst.protonum = 0xFF;
+
+	if (saddr) {
+		memcpy(&exp->tuple.src.u3, saddr, len);
+		if (sizeof(exp->tuple.src.u3) > len)
+			/* address needs to be cleared for nf_ct_tuple_equal */
+			memset((void *)&exp->tuple.src.u3 + len, 0x00,
+			       sizeof(exp->tuple.src.u3) - len);
+		memset(&exp->mask.src.u3, 0xFF, len);
+		if (sizeof(exp->mask.src.u3) > len)
+			memset((void *)&exp->mask.src.u3 + len, 0x00,
+			       sizeof(exp->mask.src.u3) - len);
+	} else {
+		memset(&exp->tuple.src.u3, 0x00, sizeof(exp->tuple.src.u3));
+		memset(&exp->mask.src.u3, 0x00, sizeof(exp->mask.src.u3));
+	}
+
+	if (daddr) {
+		memcpy(&exp->tuple.dst.u3, daddr, len);
+		if (sizeof(exp->tuple.dst.u3) > len)
+			/* address needs to be cleared for nf_ct_tuple_equal */
+			memset((void *)&exp->tuple.dst.u3 + len, 0x00,
+			       sizeof(exp->tuple.dst.u3) - len);
+		memset(&exp->mask.dst.u3, 0xFF, len);
+		if (sizeof(exp->mask.dst.u3) > len)
+			memset((void *)&exp->mask.dst.u3 + len, 0x00,
+			       sizeof(exp->mask.dst.u3) - len);
+	} else {
+		memset(&exp->tuple.dst.u3, 0x00, sizeof(exp->tuple.dst.u3));
+		memset(&exp->mask.dst.u3, 0x00, sizeof(exp->mask.dst.u3));
+	}
+
+	if (src) {
+		exp->tuple.src.u.all = (__force u16)*src;
+		exp->mask.src.u.all = 0xFFFF;
+	} else {
+		exp->tuple.src.u.all = 0;
+		exp->mask.src.u.all = 0;
+	}
+
+	if (dst) {
+		exp->tuple.dst.u.all = (__force u16)*dst;
+		exp->mask.dst.u.all = 0xFFFF;
+	} else {
+		exp->tuple.dst.u.all = 0;
+		exp->mask.dst.u.all = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_expect_init);
+
 void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (atomic_dec_and_test(&exp->use))
