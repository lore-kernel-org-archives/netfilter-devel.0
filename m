From: Thomas Woerner <twoerner@redhat.com>
Subject: [IPTABLES 2/2] iptables-compat: Increase rule number only for the selected table and chain
Date: Tue, 21 Jul 2015 15:45:42 +0200
Message-ID: <1437486342-6917-3-git-send-email-twoerner@redhat.com>
References: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Cc: Thomas Woerner <twoerner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbbGUNps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 09:45:48 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E3CFDBC91D
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 13:45:47 +0000 (UTC)
In-Reply-To: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the rule number handling in nft_rule_find and __nft_rule_list. The rule number is only valid in the selected table and chain and therefore may
not be increased for other tables or chains.

Signed-off-by: Thomas Woerner <twoerner@redhat.com>
---
:100644 100644 323f124... 139cf5a... M	iptables/nft.c
 iptables/nft.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 323f124..139cf5a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1746,17 +1746,17 @@ nft_rule_find(struct nft_handle *h, struct nft_rule_list *list,
 
 		if (rulenum >= 0) {
 			/* Delete by rule number case */
-			if (rule_ctr != rulenum)
-				goto next;
-			found = true;
-			break;
+			if (rule_ctr == rulenum) {
+			    found = true;
+			    break;
+			}
 		} else {
 			found = h->ops->rule_find(h->ops, r, data);
 			if (found)
 				break;
 		}
-next:
 		rule_ctr++;
+next:
 		r = nft_rule_list_iter_next(iter);
 	}
 
@@ -1965,12 +1965,12 @@ __nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		const char *rule_chain =
 			nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
 
-		rule_ctr++;
-
 		if (strcmp(table, rule_table) != 0 ||
 		    strcmp(chain, rule_chain) != 0)
 			goto next;
 
+		rule_ctr++;
+
 		if (rulenum > 0 && rule_ctr != rulenum) {
 			/* List by rule number case */
 			goto next;
-- 
2.4.3

