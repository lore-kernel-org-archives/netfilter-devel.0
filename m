From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 1/2] nft: print counter issues
Date: Tue, 25 Jun 2013 09:46:06 +0200
Message-ID: <20130625074606.4665.80766.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58580 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3FYHqL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:46:11 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so6542762eak.36
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2013 00:46:10 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.89.105])
        by mx.google.com with ESMTPSA id n5sm33912093eed.9.2013.06.25.00.46.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 25 Jun 2013 00:46:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch fixes the counter print, missing line,
and delete warnings.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 42bf50f..680b2f0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -18,6 +18,7 @@
 #include <netdb.h>	/* getprotobynumber */
 #include <time.h>
 #include <stdarg.h>
+#include <inttypes.h>
 
 #include <xtables.h>
 #include <libiptc/libxtc.h>
@@ -951,7 +952,7 @@ nft_print_counters(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		   bool counters)
 {
 	if (counters) {
-		printf("-c %lu %lu ",
+		printf("-c %"PRIu64" %"PRIu64" ",
 			nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS),
 			nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES));
 	}
@@ -1077,10 +1078,10 @@ static void nft_chain_print_save(struct nft_chain *c, bool basechain)
 		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_POLICY))
 			pol = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
 
-		printf(":%s %s [%lu:%lu]\n", chain, policy_name[pol],
+		printf(":%s %s [%"PRIu64":%"PRIu64"]\n", chain, policy_name[pol],
 					     pkts, bytes);
 	} else
-		printf(":%s - [%lu:%lu]\n", chain, pkts, bytes);
+		printf(":%s - [%"PRIu64":%"PRIu64"]\n", chain, pkts, bytes);
 }
 
 int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list,
@@ -2480,6 +2481,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
+	bool found = false;
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
@@ -2517,10 +2519,15 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (chain && strcmp(chain, chain_name) != 0)
 			goto next;
 
+		if (found) printf("\n");
+
 		print_header(format, chain_name, policy_name[policy], &ctrs,
 			     basechain, refs);
 
 		__nft_rule_list(h, c, table, rulenum, format, print_firewall);
+
+		found = true;
+
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
@@ -2567,7 +2574,7 @@ nft_rule_list_chain_save(struct nft_handle *h, const char *table,
 			printf("-P %s %s", chain_name, policy_name[policy]);
 
 			if (counters) {
-				printf(" -c %lu %lu\n",
+				printf(" -c %"PRIu64" %"PRIu64"\n",
 					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
 					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES));
 			} else

