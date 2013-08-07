From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 1/3] nft: Remove useless test on rulenum in nft_rule_list()
Date: Wed,  7 Aug 2013 11:31:35 +0300
Message-ID: <1375864297-9347-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab3HGIbv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:31:51 -0400
In-Reply-To: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rulenum is already handled before the loop, making this test useless.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index a87d303..15c50a7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2537,10 +2537,9 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (found)
 			printf("\n");
 
-		if (!rulenum) {
-			print_header(format, chain_name, policy_name[policy],
+		print_header(format, chain_name, policy_name[policy],
 				     &ctrs, basechain, refs);
-		}
+
 		__nft_rule_list(h, chain_name, table,
 				rulenum, format, print_firewall);
 
-- 
1.8.3.2

