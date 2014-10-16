From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 1/3] ebtables-compat: fix print_header
Date: Thu, 16 Oct 2014 16:29:51 +0200
Message-ID: <1413469793-21382-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45067 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJPOaA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:30:00 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so3880371wgh.29
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 07:29:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This prints the header like ebtables.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-bridge.c | 3 +--
 iptables/nft.c        | 7 +++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index ab97881..1fe10ed 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -362,8 +362,7 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
 				    const struct xt_counters *counters,
 				    bool basechain, uint32_t refs)
 {
-	/* FIXME: Giuseppe replace this with ebtables format */
-	print_header(format, chain, pol, counters, basechain, refs);
+	printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, refs, pol);
 }
 
 static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
diff --git a/iptables/nft.c b/iptables/nft.c
index bab2834..0cdf027 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2006,6 +2006,9 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (iter == NULL)
 		goto err;
 
+	if (h->family == NFPROTO_BRIDGE)
+		printf("Bridge table: %s\n\n", table);
+
 	c = nft_chain_list_iter_next(iter);
 	while (c != NULL) {
 		const char *chain_table =
@@ -2033,8 +2036,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (found)
 			printf("\n");
 
-		ops->print_header(format, chain_name, policy_name[policy],
-				  &ctrs, basechain, refs);
+		ops->print_header(format, chain_name,
+				  policy_name[policy], &ctrs, basechain, refs);
 
 		__nft_rule_list(h, chain_name, table,
 				rulenum, format, ops->print_firewall);
-- 
1.9.1

