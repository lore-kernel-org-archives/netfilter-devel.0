From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables-nftables 2/2] nft: pass ipt_entry to ->save_firewall hook
Date: Tue,  8 Oct 2013 11:11:19 +0200
Message-ID: <1381223479-1157-2-git-send-email-pablo@netfilter.org>
References: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab3JHJLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:11:30 -0400
In-Reply-To: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The extension needs the ipt_entry not to crash. Since cs->fw
actually points to an union that also contains cs->fw6, just
pass cs->fw to make it work.

This fixes:

-A INPUT -p tcp -m multiport --ports 1,2,3,4,6,7,8,9,10,11,12,13,14,15

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c |    4 ++--
 iptables/nft.c        |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 25cb177..ebcb969 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -633,14 +633,14 @@ void print_matches_and_target(struct iptables_command_state *cs,
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
 		if (matchp->match->print != NULL) {
-			matchp->match->print(NULL, matchp->match->m,
+			matchp->match->print(&cs->fw, matchp->match->m,
 					     format & FMT_NUMERIC);
 		}
 	}
 
 	if (cs->target != NULL) {
 		if (cs->target->print != NULL) {
-			cs->target->print(NULL, cs->target->t,
+			cs->target->print(&cs->fw, cs->target->t,
 					  format & FMT_NUMERIC);
 		}
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 50e756b..01e0264 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1040,8 +1040,10 @@ nft_rule_print_save(const struct iptables_command_state *cs,
 		} else
 			printf("-m %s", matchp->match->name);
 
-		if (matchp->match->save != NULL)
-			matchp->match->save(NULL, matchp->match->m);
+		if (matchp->match->save != NULL) {
+			/* cs->fw union makes the trick */
+			matchp->match->save(&cs->fw, matchp->match->m);
+		}
 		printf(" ");
 	}
 
@@ -1052,7 +1054,7 @@ nft_rule_print_save(const struct iptables_command_state *cs,
 			printf("-j %s", cs->jumpto);
 
 		if (cs->target->save != NULL)
-			cs->target->save(NULL, cs->target->t);
+			cs->target->save(&cs->fw, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0)
 		printf("-%c %s", ip_flags & IPT_F_GOTO ? 'g' : 'j',
 								cs->jumpto);
-- 
1.7.10.4

