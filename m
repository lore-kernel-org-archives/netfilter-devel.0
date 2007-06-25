From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 01/10] nf_nat: Moves NAT declarations from
 nf_conntrack_ipv4.h to nf_nat.h
Date: Tue, 26 Jun 2007 02:21:09 +0900 (JST)
Message-ID: <200706251721.l5PHLAKa022985@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   23 +----------------------
 include/net/netfilter/nf_conntrack.h           |    1 +
 include/net/netfilter/nf_nat.h                 |   16 ++++++++++++++++
 include/net/netfilter/nf_nat_core.h            |    1 +
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 1401ccc..3ed4e14 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -9,29 +9,8 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
-#ifdef CONFIG_NF_NAT_NEEDED
-#include <net/netfilter/nf_nat.h>
-#include <linux/netfilter/nf_conntrack_pptp.h>
-
-/* per conntrack: nat application helper private data */
-union nf_conntrack_nat_help {
-        /* insert nat helper private data here */
-	struct nf_nat_pptp nat_pptp_info;
-};
-
-struct nf_conn_nat {
-	struct nf_nat_info info;
-	union nf_conntrack_nat_help help;
-#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
-	int masq_index;
-#endif
-};
-#endif /* CONFIG_NF_NAT_NEEDED */
-
 /* Returns new sk_buff, or NULL */
-struct sk_buff *
-nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
+struct sk_buff *nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4732432..12a0e79 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -280,6 +280,7 @@ nf_conntrack_unregister_cache(u_int32_t features);
  * nat: nf_conn .. nf_conn_nat, nf_conn .. nf_conn_nat .. nf_conn help
  */
 #ifdef CONFIG_NF_NAT_NEEDED
+#include <net/netfilter/nf_nat.h>
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
 	unsigned int offset = sizeof(struct nf_conn);
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index bc57dd7..62f6782 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -51,6 +51,7 @@ struct nf_nat_multi_range_compat
 
 #ifdef __KERNEL__
 #include <linux/list.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
 
 /* The structure embedded in the conntrack structure. */
 struct nf_nat_info
@@ -59,6 +60,21 @@ struct nf_nat_info
 	struct nf_nat_seq seq[IP_CT_DIR_MAX];
 };
 
+/* per conntrack: nat application helper private data */
+union nf_conntrack_nat_help {
+        /* insert nat helper private data here */
+	struct nf_nat_pptp nat_pptp_info;
+};
+
+struct nf_conn_nat {
+	struct nf_nat_info info;
+	union nf_conntrack_nat_help help;
+#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
+	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
+	int masq_index;
+#endif
+};
+
 struct nf_conn;
 
 /* Set up the info structure to map into this range. */
diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
index 9778ffa..c3cd127 100644
--- a/include/net/netfilter/nf_nat_core.h
+++ b/include/net/netfilter/nf_nat_core.h
@@ -2,6 +2,7 @@
 #define _NF_NAT_CORE_H
 #include <linux/list.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_nat.h>
 
 /* This header used to share core functionality between the standalone
    NAT module, and the compatibility layer's use of NAT for masquerading. */
-- 
1.5.2.2
