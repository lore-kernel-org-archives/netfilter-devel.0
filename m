From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 3/5] iptables: nft: Fix -D chain rulenum option
Date: Wed, 31 Oct 2012 11:31:06 +0200
Message-ID: <1351675868-14302-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:15 -0400
In-Reply-To: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 0454725..dfbffc7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2231,10 +2231,10 @@ __nft_rule_check(struct nft_handle *h, const char *chain, const char *table,
 
 		if (rulenum >= 0) {
 			/* Delete by rule number case */
-			if (rule_ctr != rulenum) {
-				rule_ctr++;
+			if (rule_ctr != rulenum)
 				goto next;
-			}
+			found = true;
+			break;
 		} else {
 			/* Delete by matching rule case */
 			DEBUGP("comparing with... ");
@@ -2266,6 +2266,7 @@ __nft_rule_check(struct nft_handle *h, const char *chain, const char *table,
 			break;
 		}
 next:
+		rule_ctr++;
 		r = nft_rule_list_iter_next(iter);
 	}
 
-- 
1.7.12.4

