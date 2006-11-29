From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/33]: remove remaining ASSERT_{READ,WRITE}_LOCK
Date: Wed, 29 Nov 2006 03:09:32 +0100 (MET)
Message-ID: <20061129020931.21082.82635.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: remove remaining ASSERT_{READ,WRITE}_LOCK

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dd917f544f23dd2581635ef3791a51dd7528bbcb
tree b0ae50fd9becd9029845961e1d23d2d3c216ab4e
parent 80edc7ee5b534c039c0f1839af3ce5348417fd54
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:06 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:54 +0100

 net/ipv4/netfilter/ip_conntrack_core.c       |    6 ------
 net/ipv4/netfilter/ip_conntrack_proto_gre.c  |    2 --
 net/ipv4/netfilter/ip_conntrack_standalone.c |    4 ----
 net/ipv4/netfilter/ipt_CLUSTERIP.c           |    3 ---
 net/netfilter/nf_conntrack_helper.c          |    3 ---
 5 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 4d1f954..f4b0e68 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -40,9 +40,6 @@ #include <linux/notifier.h>
 
 /* ip_conntrack_lock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -201,7 +198,6 @@ ip_ct_invert_tuple(struct ip_conntrack_t
 /* ip_conntrack_expect helper functions */
 void ip_ct_unlink_expect(struct ip_conntrack_expect *exp)
 {
-	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
 	list_del(&exp->list);
 	CONNTRACK_STAT_INC(expect_delete);
@@ -294,7 +290,6 @@ static void
 clean_from_lists(struct ip_conntrack *ct)
 {
 	DEBUGP("clean_from_lists(%p)\n", ct);
-	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
 	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	list_del(&ct->tuplehash[IP_CT_DIR_REPLY].list);
 
@@ -373,7 +368,6 @@ __ip_conntrack_find(const struct ip_conn
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
 
-	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
 		if (tuplehash_to_ctrack(h) != ignored_conntrack &&
 		    ip_ct_tuple_equal(tuple, &h->tuple)) {
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_gre.c b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
index 5fe026f..ac1c49e 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_gre.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
@@ -34,8 +34,6 @@ #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
 static DEFINE_RWLOCK(ip_ct_gre_lock);
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
 
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 2df6753..86efb54 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -28,9 +28,6 @@ #include <net/checksum.h>
 #include <net/ip.h>
 #include <net/route.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
@@ -139,7 +136,6 @@ static int ct_seq_show(struct seq_file *
 	const struct ip_conntrack *conntrack = tuplehash_to_ctrack(hash);
 	struct ip_conntrack_protocol *proto;
 
-	ASSERT_READ_LOCK(&ip_conntrack_lock);
 	IP_NF_ASSERT(conntrack);
 
 	/* we only want to print DIR_ORIGINAL */
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 7a29d6e..5d43a63 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -40,8 +40,6 @@ #else
 #define DEBUGP
 #endif
 
-#define ASSERT_READ_LOCK(x)
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables target for CLUSTERIP");
@@ -123,7 +121,6 @@ __clusterip_config_find(__be32 clusterip
 {
 	struct list_head *pos;
 
-	ASSERT_READ_LOCK(&clusterip_lock);
 	list_for_each(pos, &clusterip_configs) {
 		struct clusterip_config *c = list_entry(pos, 
 					struct clusterip_config, list);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 5cbe55f..03b3ed8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -21,9 +21,6 @@ #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 
-#define ASSERT_READ_LOCK(x)
-#define ASSERT_WRITE_LOCK(x)
-
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
