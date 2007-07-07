From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/50]: nf_nat: move NAT declarations from
	nf_conntrack_ipv4.h to nf_nat.h
Date: Sat,  7 Jul 2007 14:23:21 +0200 (MEST)
Message-ID: <20070707122236.1589.12531.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: move NAT declarations from nf_conntrack_ipv4.h to nf_nat.h

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e9c14f81268617f64722e73f180eb8b79d928a06
tree e0fa60cd53c1677944024f9d0b5014ebad6be9b8
parent 1a88670786aabfcb521f6efcafe8556d86fe5487
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:25 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:25 +0200

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   23 +----------------------
 include/net/netfilter/nf_conntrack.h           |    1 +
 include/net/netfilter/nf_nat.h                 |   18 ++++++++++++++++++
 include/net/netfilter/nf_nat_core.h            |    1 +
 4 files changed, 21 insertions(+), 22 deletions(-)

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
index bc57dd7..47d3dc1 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -51,6 +51,7 @@ struct nf_nat_multi_range_compat
 
 #ifdef __KERNEL__
 #include <linux/list.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
 
 /* The structure embedded in the conntrack structure. */
 struct nf_nat_info
@@ -59,6 +60,23 @@ struct nf_nat_info
 	struct nf_nat_seq seq[IP_CT_DIR_MAX];
 };
 
+/* per conntrack: nat application helper private data */
+union nf_conntrack_nat_help
+{
+	/* insert nat helper private data here */
+	struct nf_nat_pptp nat_pptp_info;
+};
+
+struct nf_conn_nat
+{
+	struct nf_nat_info info;
+	union nf_conntrack_nat_help help;
+#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
+    defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
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
