From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables] nft: fix bad length when comparing extension data area
Date: Tue,  8 Oct 2013 12:32:08 +0200
Message-ID: <1381228328-29031-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59435 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3JHKcQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:32:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use ->userspacesize to compare the extension data area, otherwise
we also compare the internal private pointers which are only
meaningful to the kernelspace.

This fixes:

xtables -4 -D INPUT -m connlimit \
	--connlimit-above 10 --connlimit-mask 32 --connlimit-daddr

But it also fixes many other matches/targets which use internal
private data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index ebcb969..3987f74 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -683,7 +683,7 @@ compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2)
 		}
 
 		if (memcmp(m1->data, m2->data,
-			   m1->u.user.match_size - sizeof(*m1)) != 0) {
+			   mp1->match->userspacesize) != 0) {
 			DEBUGP("mismatch match data\n");
 			return false;
 		}
@@ -709,10 +709,8 @@ bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2)
 	if (strcmp(tg1->t->u.user.name, tg2->t->u.user.name) != 0)
 		return false;
 
-	if (memcmp(tg1->t->data, tg2->t->data,
-		   tg1->t->u.user.target_size - sizeof(*tg1->t)) != 0) {
+	if (memcmp(tg1->t->data, tg2->t->data, tg1->userspacesize) != 0)
 		return false;
-	}
 
 	return true;
 }
-- 
1.7.10.4

