From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 1/2] nft: Optimize chain listing if only one is looked for
Date: Wed, 17 Jul 2013 10:34:14 +0300
Message-ID: <1374046455-19234-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab3GQHeY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:34:24 -0400
In-Reply-To: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index f9a88c9..f33faa5 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2495,6 +2495,9 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		}
 		__nft_rule_list(h, c, table, rulenum, format, print_firewall);
 
+		if (chain && strcmp(chain, chain_name) == 0)
+			break;
+
 		found = true;
 
 next:
@@ -2593,6 +2596,9 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 
 		ret = __nft_rule_list(h, c, table, rulenum,
 				      counters ? 0 : FMT_NOCOUNTS, list_save);
+
+		if (chain && strcmp(chain, chain_name) != 0)
+			break;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
-- 
1.8.2.1

