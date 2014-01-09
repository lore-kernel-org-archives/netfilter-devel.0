From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables next-3.14 v2] src: fix compilation due to missing NFPROTO_INET definition
Date: Fri, 10 Jan 2014 00:27:00 +0100
Message-ID: <1389310020-12628-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46585 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaAIX1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:27:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds a copy of the include/linux/netfilter.h kernel header
that defines NFPROTO_INET, so libnftables compiles with relatively
old kernel headers in the system.

chain.c: In function 'nft_hooknum2str':
chain.c:53:7: error: 'NFPROTO_INET' undeclared (first use in this function)

This required to reorder and remove unneeded headers in src/expr/data_reg.c
to avoid a compilation warning due to redefinition of __visible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h |   73 +++++++++++++++++++++++++++++++++++++++++++++
 src/expr/data_reg.c       |    7 ++---
 2 files changed, 76 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/netfilter.h

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
new file mode 100644
index 0000000..ef1b1f8
--- /dev/null
+++ b/include/linux/netfilter.h
@@ -0,0 +1,73 @@
+#ifndef _UAPI__LINUX_NETFILTER_H
+#define _UAPI__LINUX_NETFILTER_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/sysctl.h>
+
+
+/* Responses from hook functions. */
+#define NF_DROP 0
+#define NF_ACCEPT 1
+#define NF_STOLEN 2
+#define NF_QUEUE 3
+#define NF_REPEAT 4
+#define NF_STOP 5
+#define NF_MAX_VERDICT NF_STOP
+
+/* we overload the higher bits for encoding auxiliary data such as the queue
+ * number or errno values. Not nice, but better than additional function
+ * arguments. */
+#define NF_VERDICT_MASK 0x000000ff
+
+/* extra verdict flags have mask 0x0000ff00 */
+#define NF_VERDICT_FLAG_QUEUE_BYPASS	0x00008000
+
+/* queue number (NF_QUEUE) or errno (NF_DROP) */
+#define NF_VERDICT_QMASK 0xffff0000
+#define NF_VERDICT_QBITS 16
+
+#define NF_QUEUE_NR(x) ((((x) << 16) & NF_VERDICT_QMASK) | NF_QUEUE)
+
+#define NF_DROP_ERR(x) (((-x) << 16) | NF_DROP)
+
+/* only for userspace compatibility */
+#ifndef __KERNEL__
+/* Generic cache responses from hook functions.
+   <= 0x2000 is used for protocol-flags. */
+#define NFC_UNKNOWN 0x4000
+#define NFC_ALTERED 0x8000
+
+/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
+#define NF_VERDICT_BITS 16
+#endif
+
+enum nf_inet_hooks {
+	NF_INET_PRE_ROUTING,
+	NF_INET_LOCAL_IN,
+	NF_INET_FORWARD,
+	NF_INET_LOCAL_OUT,
+	NF_INET_POST_ROUTING,
+	NF_INET_NUMHOOKS
+};
+
+enum {
+	NFPROTO_UNSPEC =  0,
+	NFPROTO_INET   =  1,
+	NFPROTO_IPV4   =  2,
+	NFPROTO_ARP    =  3,
+	NFPROTO_BRIDGE =  7,
+	NFPROTO_IPV6   = 10,
+	NFPROTO_DECNET = 12,
+	NFPROTO_NUMPROTO,
+};
+
+union nf_inet_addr {
+	__u32		all[4];
+	__be32		ip;
+	__be32		ip6[4];
+	struct in_addr	in;
+	struct in6_addr	in6;
+};
+
+#endif /* _UAPI__LINUX_NETFILTER_H */
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 76231af..a198c67 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -18,14 +18,13 @@
 #include <netinet/in.h>
 
 #include <libmnl/libmnl.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
 #include <libnftables/expr.h>
 #include <libnftables/rule.h>
-#include "expr_ops.h"
-#include "data_reg.h"
 #include "internal.h"
 
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
 #ifdef JSON_PARSING
 static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, json_t *data)
 {
-- 
1.7.10.4

