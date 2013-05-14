From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 1/6] xtables: initialize xtables defaults even on listing rules
Date: Tue, 14 May 2013 13:52:02 +0300
Message-ID: <1368528727-10127-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab3ENKwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:14 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Output of the tool should be the same as for iptables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index e68d112..f5d96bc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2477,6 +2477,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
 
+	/* If built-in chains don't exist for this table, create them */
+	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
+		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+
 	list = nft_chain_dump(h);
 
 	iter = nft_chain_list_iter_create(list);
-- 
1.8.2.1

