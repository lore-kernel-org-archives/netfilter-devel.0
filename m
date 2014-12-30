From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: fix segfault in rules w/o
 target
Date: Tue, 30 Dec 2014 16:44:44 +0100
Message-ID: <20141230154444.25515.55322.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52704 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbaL3Po7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:44:59 -0500
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
 iptables/nft-bridge.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 90bcd63..79abf73 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -114,6 +114,12 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
 {
 	int ret = 0;
 
+	if (cs->jumpto == NULL)
+		return 0;
+
+	if (strcmp(cs->jumpto, "CONTINUE") == 0)
+		return 0;
+
 	/* If no target at all, add nothing (default to continue) */
 	if (cs->target != NULL) {
 		/* Standard target? */
@@ -462,6 +468,10 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 		}
 	}
 
+	if (strcmp(cs.jumpto, "") == 0) {
+		printf("CONTINUE");
+	}
+
 	if (!(format & FMT_NOCOUNTS))
 		printf(" , pcnt = %"PRIu64" -- bcnt = %"PRIu64"",
 		       (uint64_t)cs.counters.pcnt, (uint64_t)cs.counters.bcnt);

