From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] netfilter: ipset: expose userspace-relevant parts in ip_set.h
Date: Sun, 28 Aug 2011 16:30:25 +0200
Message-ID: <1314541826-7448-3-git-send-email-jengelh@medozas.de>
References: <1314541826-7448-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54442 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1H1Oaa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 10:30:30 -0400
In-Reply-To: <1314541826-7448-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables's libxt_SET.c depends on these.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/ipset/ip_set.h |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 3540c6e..c5092de 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/types.h>
+
 /* The protocol version */
 #define IPSET_PROTOCOL		6
 
@@ -168,6 +170,13 @@ enum ipset_adt {
 	IPSET_CADT_MAX,
 };
 
+/* Sets are identified by an index in kernel space. Tweak with ip_set_id_t
+ * and IPSET_INVALID_ID if you want to increase the max number of sets.
+ */
+typedef __u16 ip_set_id_t;
+
+#define IPSET_INVALID_ID		65535
+
 #ifdef __KERNEL__
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -176,13 +185,7 @@ enum ipset_adt {
 #include <linux/netfilter/x_tables.h>
 #include <linux/vmalloc.h>
 #include <net/netlink.h>
-
-/* Sets are identified by an index in kernel space. Tweak with ip_set_id_t
- * and IPSET_INVALID_ID if you want to increase the max number of sets.
- */
-typedef u16 ip_set_id_t;
-
-#define IPSET_INVALID_ID		65535
+#endif /* __KERNEL__ */
 
 enum ip_set_dim {
 	IPSET_DIM_ZERO = 0,
@@ -195,6 +198,7 @@ enum ip_set_dim {
 	IPSET_DIM_MAX = 6,
 };
 
+#ifdef __KERNEL__
 /* Option flags for kernel operations */
 enum ip_set_kopt {
 	IPSET_INV_MATCH = (1 << IPSET_DIM_ZERO),
@@ -450,6 +454,8 @@ bitmap_bytes(u32 a, u32 b)
 	return 4 * ((((b - a + 8) / 8) + 3) / 4);
 }
 
+#endif /* __KERNEL__ */
+
 /* Interface to iptables/ip6tables */
 
 #define SO_IP_SET		83
@@ -475,6 +481,4 @@ struct ip_set_req_version {
 	unsigned version;
 };
 
-#endif	/* __KERNEL__ */
-
 #endif /*_IP_SET_H */
-- 
1.7.3.4

