From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 5/6] netfilter: ipset: expose userspace-relevant parts in ip_set.h
Date: Tue,  6 Sep 2011 21:59:06 +0200
Message-ID: <1315339147-9617-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44388 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab1IFT7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:59:45 -0400
In-Reply-To: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

iptables's libxt_SET.c depends on these.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 3540c6e..c853158 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/types.h>
+
 /* The protocol version */
 #define IPSET_PROTOCOL		6
 
@@ -168,19 +170,10 @@ enum ipset_adt {
 	IPSET_CADT_MAX,
 };
 
-#ifdef __KERNEL__
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/vmalloc.h>
-#include <net/netlink.h>
-
 /* Sets are identified by an index in kernel space. Tweak with ip_set_id_t
  * and IPSET_INVALID_ID if you want to increase the max number of sets.
  */
-typedef u16 ip_set_id_t;
+typedef __u16 ip_set_id_t;
 
 #define IPSET_INVALID_ID		65535
 
@@ -203,6 +196,15 @@ enum ip_set_kopt {
 	IPSET_DIM_THREE_SRC = (1 << IPSET_DIM_THREE),
 };
 
+#ifdef __KERNEL__
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/vmalloc.h>
+#include <net/netlink.h>
+
 /* Set features */
 enum ip_set_feature {
 	IPSET_TYPE_IP_FLAG = 0,
@@ -450,6 +452,8 @@ bitmap_bytes(u32 a, u32 b)
 	return 4 * ((((b - a + 8) / 8) + 3) / 4);
 }
 
+#endif /* __KERNEL__ */
+
 /* Interface to iptables/ip6tables */
 
 #define SO_IP_SET		83
@@ -475,6 +479,4 @@ struct ip_set_req_version {
 	unsigned version;
 };
 
-#endif	/* __KERNEL__ */
-
 #endif /*_IP_SET_H */
-- 
1.7.0.4

