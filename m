From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/6] netfilter: conntrack: move helper struct to nf_conntrack_helper.h
Date: Sun, 16 Apr 2017 01:29:14 +0200
Message-ID: <20170415232919.13671-2-fw@strlen.de>
References: <20170415232919.13671-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57828 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754704AbdDOX3G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 19:29:06 -0400
In-Reply-To: <20170415232919.13671-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

its definition is not needed in nf_conntrack.h.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h        | 19 -------------------
 include/net/netfilter/nf_conntrack_helper.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4978a82b75fa..8ece3612d0cd 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -50,25 +50,6 @@ union nf_conntrack_expect_proto {
 #define NF_CT_ASSERT(x)
 #endif
 
-struct nf_conntrack_helper;
-
-/* Must be kept in sync with the classes defined by helpers */
-#define NF_CT_MAX_EXPECT_CLASSES	4
-
-/* nf_conn feature for connections that have a helper */
-struct nf_conn_help {
-	/* Helper. if any */
-	struct nf_conntrack_helper __rcu *helper;
-
-	struct hlist_head expectations;
-
-	/* Current number of expected connections */
-	u8 expecting[NF_CT_MAX_EXPECT_CLASSES];
-
-	/* private helper information. */
-	char data[];
-};
-
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1eaac1f4cd6a..15d746558665 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -52,6 +52,23 @@ struct nf_conntrack_helper {
 	unsigned int queue_num;		/* For user-space helpers. */
 };
 
+/* Must be kept in sync with the classes defined by helpers */
+#define NF_CT_MAX_EXPECT_CLASSES	4
+
+/* nf_conn feature for connections that have a helper */
+struct nf_conn_help {
+	/* Helper. if any */
+	struct nf_conntrack_helper __rcu *helper;
+
+	struct hlist_head expectations;
+
+	/* Current number of expected connections */
+	u8 expecting[NF_CT_MAX_EXPECT_CLASSES];
+
+	/* private helper information. */
+	char data[];
+};
+
 struct nf_conntrack_helper *__nf_conntrack_helper_find(const char *name,
 						       u16 l3num, u8 protonum);
 
-- 
2.10.2

