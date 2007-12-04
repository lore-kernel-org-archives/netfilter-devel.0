From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/49]: nf_queue: move queueing related functions/struct to seperate header
Date: Tue,  4 Dec 2007 13:02:35 +0100 (MET)
Message-ID: <20071204120234.2442.35108.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62185 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXLDMCg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:36 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: move queueing related functions/struct to seperate header

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 39c53418dafbd3d8b9173420294bdd4a2c637b7c
tree 6d0c8cfa947c08415a32e79c3e4a480d1fc292e5
parent ed35b6d3d2fe607f86dff296349a4c13d0f38720
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:33 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:31:23 +0100

 include/linux/netfilter.h        |   32 ++------------------------------
 include/net/netfilter/nf_queue.h |   32 ++++++++++++++++++++++++++++++++
 net/ipv4/netfilter.c             |    1 +
 net/ipv4/netfilter/ip_queue.c    |    1 +
 net/ipv6/netfilter.c             |    1 +
 net/ipv6/netfilter/ip6_queue.c   |    1 +
 net/netfilter/nf_queue.c         |    1 +
 net/netfilter/nfnetlink_queue.c  |    1 +
 8 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 1ba6011..5fe4ef4 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -101,19 +101,6 @@ struct nf_sockopt_ops
 	struct module *owner;
 };
 
-/* Each queued (to userspace) skbuff has one of these. */
-struct nf_info
-{
-	/* The ops struct which sent us to userspace. */
-	struct nf_hook_ops *elem;
-	
-	/* If we're sent to userspace, this keeps housekeeping info */
-	int pf;
-	unsigned int hook;
-	struct net_device *indev, *outdev;
-	int (*okfn)(struct sk_buff *);
-};
-                                                                                
 /* Function to register/unregister hook points. */
 int nf_register_hook(struct nf_hook_ops *reg);
 void nf_unregister_hook(struct nf_hook_ops *reg);
@@ -274,21 +261,6 @@ int compat_nf_setsockopt(struct sock *sk, int pf, int optval,
 int compat_nf_getsockopt(struct sock *sk, int pf, int optval,
 		char __user *opt, int *len);
 
-/* Packet queuing */
-struct nf_queue_handler {
-	int (*outfn)(struct sk_buff *skb, struct nf_info *info,
-		     unsigned int queuenum);
-	char *name;
-};
-extern int nf_register_queue_handler(int pf,
-				     const struct nf_queue_handler *qh);
-extern int nf_unregister_queue_handler(int pf,
-				       const struct nf_queue_handler *qh);
-extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
-extern void nf_reinject(struct sk_buff *skb,
-			struct nf_info *info,
-			unsigned int verdict);
-
 /* FIXME: Before cache is ever used, this must be implemented for real. */
 extern void nf_invalidate_cache(int pf);
 
@@ -298,6 +270,8 @@ extern void nf_invalidate_cache(int pf);
 extern int skb_make_writable(struct sk_buff *skb, unsigned int writable_len);
 
 struct flowi;
+struct nf_info;
+
 struct nf_afinfo {
 	unsigned short	family;
 	__sum16		(*checksum)(struct sk_buff *skb, unsigned int hook,
@@ -334,8 +308,6 @@ nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
 extern int nf_register_afinfo(struct nf_afinfo *afinfo);
 extern void nf_unregister_afinfo(struct nf_afinfo *afinfo);
 
-#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
-
 #include <net/flow.h>
 extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
 
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
new file mode 100644
index 0000000..8c6b382
--- /dev/null
+++ b/include/net/netfilter/nf_queue.h
@@ -0,0 +1,32 @@
+#ifndef _NF_QUEUE_H
+#define _NF_QUEUE_H
+
+/* Each queued (to userspace) skbuff has one of these. */
+struct nf_info {
+	struct nf_hook_ops	*elem;
+	int			pf;
+	unsigned int		hook;
+	struct net_device	*indev;
+	struct net_device	*outdev;
+	int			(*okfn)(struct sk_buff *);
+};
+
+#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
+
+/* Packet queuing */
+struct nf_queue_handler {
+	int			(*outfn)(struct sk_buff *skb,
+					 struct nf_info *info,
+					 unsigned int queuenum);
+	char			*name;
+};
+
+extern int nf_register_queue_handler(int pf,
+				     const struct nf_queue_handler *qh);
+extern int nf_unregister_queue_handler(int pf,
+				       const struct nf_queue_handler *qh);
+extern void nf_unregister_queue_handlers(const struct nf_queue_handler *qh);
+extern void nf_reinject(struct sk_buff *skb, struct nf_info *info,
+			unsigned int verdict);
+
+#endif /* _NF_QUEUE_H */
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 599d448..f716608 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -7,6 +7,7 @@
 #include <net/route.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
+#include <net/netfilter/nf_queue.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
 int ip_route_me_harder(struct sk_buff *skb, unsigned addr_type)
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 08e7f8b..2966fbd 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -28,6 +28,7 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/route.h>
+#include <net/netfilter/nf_queue.h>
 
 #define IPQ_QMAX_DEFAULT 1024
 #define IPQ_PROC_FS_NAME "ip_queue"
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 281f732..55ea9c6 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -8,6 +8,7 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 #include <net/ip6_checksum.h>
+#include <net/netfilter/nf_queue.h>
 
 int ip6_route_me_harder(struct sk_buff *skb)
 {
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 5a9ca0d..7ff9915 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -29,6 +29,7 @@
 #include <net/sock.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
+#include <net/netfilter/nf_queue.h>
 #include <linux/netfilter_ipv4/ip_queue.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index c098ccb..bd71f43 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -7,6 +7,7 @@
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
 #include <net/protocol.h>
+#include <net/netfilter/nf_queue.h>
 
 #include "nf_internals.h"
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 94ec1c2..3a09f02 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -27,6 +27,7 @@
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/list.h>
 #include <net/sock.h>
+#include <net/netfilter/nf_queue.h>
 
 #include <asm/atomic.h>
 
