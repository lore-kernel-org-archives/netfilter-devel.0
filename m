From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH v2] ebtables-compat: fix segfault in rules
 w/o target
Date: Mon, 05 Jan 2015 15:28:46 +0100
Message-ID: <20150105142519.26315.13246.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52272 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754052AbbAEO3R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:29:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a segfault in rules without target.

Now, these two rules are allowed:

% ebtables-compat -A FORWARD -p 0x0600 -j CONTINUE
% ebtables-compat -A FORWARD -p 0x0600

And both are printed:

Bridge chain: FORWARD, entries: 1, policy: ACCEPT
-p 0x600 -j CONTINUE

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Pablo.

The printing path doesn't require special handling. There are 3 cases:
 * a target extension (unsupported yet)
 * an user-defined chain (in this case, cs->jumpto contains the chain name)
 * nothing (in this case, cs->jumpto contains "", and we should print CONTINUE)

 iptables/nft-bridge.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 90bcd63..fd9554e 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -114,6 +114,9 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
 {
 	int ret = 0;
 
+	if (cs->jumpto == NULL || strcmp(cs->jumpto, "CONTINUE") == 0)
+		return 0;
+
 	/* If no target at all, add nothing (default to continue) */
 	if (cs->target != NULL) {
 		/* Standard target? */
@@ -452,14 +455,16 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 	}
 
 	printf("-j ");
-	if (!(format & FMT_NOTARGET))
-		printf("%s", cs.jumpto);
-
 	if (cs.target != NULL) {
 		if (cs.target->print != NULL) {
 			cs.target->print(&cs.fw, cs.target->t,
 					    format & FMT_NUMERIC);
 		}
+	} else {
+		if (strcmp(cs.jumpto, "") == 0)
+			printf("CONTINUE");
+		else
+			printf("%s", cs.jumpto);
 	}
 
 	if (!(format & FMT_NOCOUNTS))

