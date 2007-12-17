From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 45/64]: nf_log: move logging stuff to seperate header
Date: Tue, 18 Dec 2007 00:47:14 +0100 (MET)
Message-ID: <20071217234714.23601.19512.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39020 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbXLQXrP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:15 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_log: move logging stuff to seperate header

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 976e0f77fc8fdb417e7d5526d5e0b2d97c64c74b
tree cd0b5f187216818c0d77412d813db637b9675330
parent 977f2f4eedc00948e79a6e1cbb385b3a946228cc
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:34 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 include/linux/netfilter.h                      |   55 ----------------------
 include/net/netfilter/nf_log.h                 |   59 ++++++++++++++++++++++++
 net/bridge/netfilter/ebt_log.c                 |    1 
 net/bridge/netfilter/ebt_ulog.c                |    1 
 net/ipv4/netfilter/ip_tables.c                 |    1 
 net/ipv4/netfilter/ipt_LOG.c                   |    1 
 net/ipv4/netfilter/ipt_ULOG.c                  |    1 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    1 
 net/ipv6/netfilter/ip6_tables.c                |    1 
 net/ipv6/netfilter/ip6t_LOG.c                  |    1 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 
 net/netfilter/nf_conntrack_proto_tcp.c         |    1 
 net/netfilter/nf_conntrack_proto_udp.c         |    1 
 net/netfilter/nf_conntrack_proto_udplite.c     |    1 
 net/netfilter/nf_log.c                         |    1 
 net/netfilter/nfnetlink_log.c                  |    1 
 net/netfilter/xt_NFLOG.c                       |    1 
 17 files changed, 74 insertions(+), 55 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f25eec5..368b7ed 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -124,61 +124,6 @@ extern struct ctl_table nf_net_ipv4_netfilter_sysctl_path[];
 
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
 
-/* those NF_LOG_* defines and struct nf_loginfo are legacy definitios that will
- * disappear once iptables is replaced with pkttables.  Please DO NOT use them
- * for any new code! */
-#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
-#define NF_LOG_IPOPT		0x04	/* Log IP options */
-#define NF_LOG_UID		0x08	/* Log UID owning local socket */
-#define NF_LOG_MASK		0x0f
-
-#define NF_LOG_TYPE_LOG		0x01
-#define NF_LOG_TYPE_ULOG	0x02
-
-struct nf_loginfo {
-	u_int8_t type;
-	union {
-		struct {
-			u_int32_t copy_len;
-			u_int16_t group;
-			u_int16_t qthreshold;
-		} ulog;
-		struct {
-			u_int8_t level;
-			u_int8_t logflags;
-		} log;
-	} u;
-};
-
-typedef void nf_logfn(unsigned int pf,
-		      unsigned int hooknum,
-		      const struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const struct nf_loginfo *li,
-		      const char *prefix);
-
-struct nf_logger {
-	struct module	*me;
-	nf_logfn 	*logfn;
-	char		*name;
-};
-
-/* Function to register/unregister log function. */
-int nf_log_register(int pf, struct nf_logger *logger);
-void nf_log_unregister(struct nf_logger *logger);
-void nf_log_unregister_pf(int pf);
-
-/* Calls the registered backend logging function */
-void nf_log_packet(int pf,
-		   unsigned int hooknum,
-		   const struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   struct nf_loginfo *li,
-		   const char *fmt, ...);
-
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *), int thresh);
diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
new file mode 100644
index 0000000..f0426e5
--- /dev/null
+++ b/include/net/netfilter/nf_log.h
@@ -0,0 +1,59 @@
+#ifndef _NF_LOG_H
+#define _NF_LOG_H
+
+/* those NF_LOG_* defines and struct nf_loginfo are legacy definitios that will
+ * disappear once iptables is replaced with pkttables.  Please DO NOT use them
+ * for any new code! */
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_MASK		0x0f
+
+#define NF_LOG_TYPE_LOG		0x01
+#define NF_LOG_TYPE_ULOG	0x02
+
+struct nf_loginfo {
+	u_int8_t type;
+	union {
+		struct {
+			u_int32_t copy_len;
+			u_int16_t group;
+			u_int16_t qthreshold;
+		} ulog;
+		struct {
+			u_int8_t level;
+			u_int8_t logflags;
+		} log;
+	} u;
+};
+
+typedef void nf_logfn(unsigned int pf,
+		      unsigned int hooknum,
+		      const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const struct nf_loginfo *li,
+		      const char *prefix);
+
+struct nf_logger {
+	struct module	*me;
+	nf_logfn 	*logfn;
+	char		*name;
+};
+
+/* Function to register/unregister log function. */
+int nf_log_register(int pf, struct nf_logger *logger);
+void nf_log_unregister(struct nf_logger *logger);
+void nf_log_unregister_pf(int pf);
+
+/* Calls the registered backend logging function */
+void nf_log_packet(int pf,
+		   unsigned int hooknum,
+		   const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   struct nf_loginfo *li,
+		   const char *fmt, ...);
+
+#endif /* _NF_LOG_H */
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 457815f..fcb3b54 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -17,6 +17,7 @@
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/spinlock.h>
+#include <net/netfilter/nf_log.h>
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index e7cfd30..1b9ca07 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -38,6 +38,7 @@
 #include <linux/netdevice.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ulog.h>
+#include <net/netfilter/nf_log.h>
 #include <net/sock.h>
 #include "../br_private.h"
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 439b292..271f6a5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -26,6 +26,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index f8c613a..4b346e5 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -22,6 +22,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 4139042..1d8e146 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -43,6 +43,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
+#include <net/netfilter/nf_log.h>
 #include <net/sock.h>
 #include <linux/bitops.h>
 #include <asm/unaligned.h>
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 3e2e5cd..cd0d669 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -18,6 +18,7 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_log.h>
 
 static unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d910d56..bb50d0e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -28,6 +28,7 @@
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 1952324..e6a2b1e 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -23,6 +23,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_DESCRIPTION("IP6 tables LOG target module");
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 44689d4..02d60df 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
+#include <net/netfilter/nf_log.h>
 
 static unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 600b476..1d496b9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_log.h>
 
 /* Protects conntrack->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 570a2e1..7ac6073 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -21,6 +21,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_log.h>
 
 static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 7e116d5..6518bcd 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -22,6 +22,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_log.h>
 
 static unsigned int nf_ct_udplite_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udplite_timeout_stream __read_mostly = 180*HZ;
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index d67c4fb..fad97d6 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -6,6 +6,7 @@
 #include <linux/netfilter.h>
 #include <linux/seq_file.h>
 #include <net/protocol.h>
+#include <net/netfilter/nf_log.h>
 
 #include "nf_internals.h"
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2c7bd2e..959a0cb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -29,6 +29,7 @@
 #include <linux/jhash.h>
 #include <linux/random.h>
 #include <net/sock.h>
+#include <net/netfilter/nf_log.h>
 
 #include <asm/atomic.h>
 
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 83af124..866facf 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -12,6 +12,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("x_tables NFLOG target");
