From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 5/5] netfilter: reduce NF_MAX_HOOKS define
Date: Thu,  7 Dec 2017 16:28:27 +0100
Message-ID: <20171207152827.24317-6-fw@strlen.de>
References: <20171207152827.24317-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45030 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753744AbdLGP3G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 10:29:06 -0500
In-Reply-To: <20171207152827.24317-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This can be same as NF_INET_NUMHOOKS if we don't support DECNET.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 new in v3.

 include/linux/netfilter_defs.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_defs.h b/include/linux/netfilter_defs.h
index fdcdf2bf34df..8dddfb151f00 100644
--- a/include/linux/netfilter_defs.h
+++ b/include/linux/netfilter_defs.h
@@ -4,13 +4,17 @@
 
 #include <uapi/linux/netfilter.h>
 
-/* Largest hook number + 1, see uapi/linux/netfilter_decnet.h */
-#define NF_MAX_HOOKS 8
-
 /* in/out/forward only */
 #define NF_ARP_NUMHOOKS 3
 
 /* max hook is NF_DN_ROUTE (6), also see uapi/linux/netfilter_decnet.h */
 #define NF_DN_NUMHOOKS 7
 
+#if IS_ENABLED(CONFIG_DECNET)
+/* Largest hook number + 1, see uapi/linux/netfilter_decnet.h */
+#define NF_MAX_HOOKS	NF_DN_NUMHOOKS
+#else
+#define NF_MAX_HOOKS	NF_INET_NUMHOOKS
+#endif
+
 #endif
-- 
2.13.6

