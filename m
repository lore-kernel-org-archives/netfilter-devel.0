From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] netfilter: ipset: expose userspace-relevant parts in ip_set.h
Date: Wed, 31 Aug 2011 14:10:05 +0200
Message-ID: <1314792606-9930-3-git-send-email-jengelh@medozas.de>
References: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60288 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1HaMKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:10:10 -0400
In-Reply-To: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables's libxt_SET.c depends on these.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
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
1.7.3.4

