From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/52] netfilter: reduce NF_MAX_HOOKS define
Date: Mon,  8 Jan 2018 21:19:26 +0100
Message-ID: <20180108202000.12989-19-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This can be same as NF_INET_NUMHOOKS if we don't support DECNET.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.11.0
