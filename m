From: Karl Hiramoto <karl@hiramoto.org>
Subject: [RFC 2/4] nf_conntrack_queue: define struct that will be stored in nf_ct_extend
Date: Sat, 24 Jul 2010 17:44:43 +0200
Message-ID: <1279986285-11665-3-git-send-email-karl@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Cc: Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:60989 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0GXPqV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:46:21 -0400
Received: from homiemail-a30.g.dreamhost.com (caiajhbdccah.dreamhost.com [208.97.132.207])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 2FA5B17C78B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 08:46:19 -0700 (PDT)
In-Reply-To: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 include/net/netfilter/nf_conntrack_queue.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_queue.h

diff --git a/include/net/netfilter/nf_conntrack_queue.h b/include/net/netfilter/nf_conntrack_queue.h
new file mode 100644
index 0000000..417820f
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_queue.h
@@ -0,0 +1,17 @@
+#ifndef _NF_CONNTRACK_QUEUE_H
+#define _NF_CONNTRACK_QUEUE_H
+
+
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conntrack_queue {
+	spinlock_t lock;
+	union {
+		u32     connbytes;
+		u32     tcp_seq; /* TCP sequence number */
+	} dir[IP_CT_DIR_MAX];
+};
+
+#endif
+#endif /* _NF_CONNTRACK_QUEUE_H */
-- 
1.7.1

