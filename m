From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] include: Add proc_info symbols to nf_tables.h
Date: Mon, 15 May 2017 16:51:53 +0200
Message-ID: <20170515145154.26189-2-phil@nwl.cc>
References: <20170515145154.26189-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44317 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965550AbdEOOwY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 10:52:24 -0400
In-Reply-To: <20170515145154.26189-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nf_tables.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 683f6f88fcace..2a73c80f80f65 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -114,6 +114,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_GETOBJ,
 	NFT_MSG_DELOBJ,
 	NFT_MSG_GETOBJ_RESET,
+	NFT_MSG_PROC_INFO,
 	NFT_MSG_MAX,
 };
 
@@ -1375,4 +1376,18 @@ enum nft_ng_types {
 };
 #define NFT_NG_MAX	(__NFT_NG_MAX - 1)
 
+/**
+ * enum nft_proc_info_attributes - nf_tables process information netlink attributes
+ *
+ * @NFTA_PROC_PID: process id (NLA_U32)
+ * @NFTA_PROC_NAME: process name (NLA_STRING)
+ */
+enum nft_proc_info_attributes {
+        NFTA_PROC_UNSPEC,
+        NFTA_PROC_PID,
+        NFTA_PROC_NAME,
+        __NFTA_PROC_MAX
+};
+#define NFTA_PROC_MAX   (__NFTA_PROC_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
-- 
2.11.0

