From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 5/5] nft: Pass a line after printing out a debug message
Date: Tue, 11 Feb 2014 18:36:46 +0200
Message-ID: <1392136606-10339-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbaBKQhC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:37:02 -0500
In-Reply-To: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In this specific places, libnftnl gives back a string on which iptables
should not assume any line break, thus it's up to iptables to add it.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 32d3dbb..f6d5263 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -458,7 +458,7 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	char tmp[1024];
 
 	nft_table_snprintf(tmp, sizeof(tmp), t, 0, 0);
-	printf("DEBUG: table: %s", tmp);
+	printf("DEBUG: table: %s\n", tmp);
 	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
 #endif
 
@@ -702,7 +702,7 @@ static void nft_chain_print_debug(struct nft_chain *c, struct nlmsghdr *nlh)
 	char tmp[1024];
 
 	nft_chain_snprintf(tmp, sizeof(tmp), c, 0, 0);
-	printf("DEBUG: chain: %s", tmp);
+	printf("DEBUG: chain: %s\n", tmp);
 	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
 #endif
 }
@@ -898,7 +898,7 @@ static void nft_rule_print_debug(struct nft_rule *r, struct nlmsghdr *nlh)
 	char tmp[1024];
 
 	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("DEBUG: rule: %s", tmp);
+	printf("DEBUG: rule: %s\n", tmp);
 	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
 #endif
 }
-- 
1.8.3.2

