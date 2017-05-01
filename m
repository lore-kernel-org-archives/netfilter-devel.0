From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/53] netfilter: conntrack: move helper struct to nf_conntrack_helper.h
Date: Mon,  1 May 2017 12:46:53 +0200
Message-ID: <1493635640-24325-27-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S378905AbdEAKsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:48:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 663E720991D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5572BA6C1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4234D91F2
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:48 +0200 (CEST)
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

its definition is not needed in nf_conntrack.h.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

