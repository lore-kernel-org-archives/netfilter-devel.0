From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 1/5] nft: Add useful debug output when a builtin table is created
Date: Tue, 11 Feb 2014 18:36:42 +0200
Message-ID: <1392136606-10339-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaBKQg5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:36:57 -0500
In-Reply-To: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is useful to know if a builtin table is requested to be created.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index fc9db99..968fe8c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -451,6 +451,14 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
 
+#ifdef NLDEBUG
+	char tmp[1024];
+
+	nft_table_snprintf(tmp, sizeof(tmp), t, 0, 0);
+	printf("DEBUG: table: %s", tmp);
+	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
+#endif
+
 	ret = mnl_talk(h, nlh, NULL, NULL);
 	if (ret < 0) {
 		if (errno != EEXIST)
-- 
1.8.3.2

