From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: fix ACCEPT printing by
 simplifying logic
Date: Tue, 13 Jan 2015 18:36:10 +0100
Message-ID: <20150113173610.3965.9202.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55962 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753012AbbAMRgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:36:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The commit bc543af ("ebtables-compat: fix segfault in rules w/o target")
doesn't handle all possible cases of target printing, and ACCEPT is left
behind.

BTW, the logic of target (-j XXX) printing is a bit weird. This patch
simplifies it.

I assume:
 * cs->jumpto is only filled by nft_immediate.
 * cs->target is only filled by nft_target.

So we end with these cases:
 * nft_immediate contains a 'standard' target (ACCEPT, DROP, CONTINUE, RETURN, chain)
  Then cs->jumpto contains the target already. We have the rule.
 * No standard target. If nft_target contains a target, try to load it.
 * Neither nft_target nor nft_immediate exist. Then, assume CONTINUE.

The printing path is then straight forward: either cs.jumpto or cs.target
contains the target.

As there isn't support for target extensions yet, there is no way to test the
nft_target (cs.target) path.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index fd9554e..9747405 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -337,12 +337,13 @@ void nft_rule_to_ebtables_command_state(struct nft_rule *r,
 
 	nft_rule_expr_iter_destroy(iter);
 
-	if (cs->target != NULL)
-		cs->jumpto = cs->target->name;
-	else if (cs->jumpto != NULL)
-		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+	if (cs->jumpto != NULL)
+		return;
+
+	if (cs->target != NULL && cs->target->name != NULL)
+		cs->target = xtables_find_target(cs->target->name, XTF_TRY_LOAD);
 	else
-		cs->jumpto = "";
+		cs->jumpto = "CONTINUE";
 }
 
 static void print_iface(const char *iface)
@@ -455,17 +456,11 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 	}
 
 	printf("-j ");
-	if (cs.target != NULL) {
-		if (cs.target->print != NULL) {
-			cs.target->print(&cs.fw, cs.target->t,
-					    format & FMT_NUMERIC);
-		}
-	} else {
-		if (strcmp(cs.jumpto, "") == 0)
-			printf("CONTINUE");
-		else
-			printf("%s", cs.jumpto);
-	}
+
+	if (cs.jumpto != NULL)
+		printf("%s", cs.jumpto);
+	else if (cs.target != NULL && cs.target->print != NULL)
+		cs.target->print(&cs.fw, cs.target->t, format & FMT_NUMERIC);
 
 	if (!(format & FMT_NOCOUNTS))
 		printf(" , pcnt = %"PRIu64" -- bcnt = %"PRIu64"",

