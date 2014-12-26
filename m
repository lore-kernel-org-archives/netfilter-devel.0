From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: fix printing of extension
Date: Fri, 26 Dec 2014 13:49:52 +0100
Message-ID: <20141226124952.16163.81787.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60953 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbaLZMuE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:50:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix printing of ebt extensions:

% sudo ebtables-compat -L
[...]
Bridge chain: FORWARD, entries: 1, policy: ACCEPT
--802_3-type 0x0012 -j ACCEPT
[...]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |   23 +++++++----------------
 iptables/nft-bridge.h |    4 ++++
 iptables/nft-shared.c |   17 ++++++++++++++++-
 3 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 807c4da..90bcd63 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -370,6 +370,7 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
 static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 				      unsigned int format)
 {
+	struct xtables_rule_match *matchp;
 	struct ebtables_command_state cs = {};
 	char *addr;
 
@@ -443,23 +444,13 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 		print_iface(cs.fw.out);
 	}
 
-	/* old code to adapt
-	m_l = hlp->m_list;
-	while (m_l) {
-		m = ebt_find_match(m_l->m->u.name);
-		if (!m)
-			ebt_print_bug("Match not found");
-		m->print(hlp, m_l->m);
-		m_l = m_l->next;
+	for (matchp = cs.matches; matchp; matchp = matchp->next) {
+		if (matchp->match->print != NULL) {
+			matchp->match->print(&cs.fw, matchp->match->m,
+					     format & FMT_NUMERIC);
+		}
 	}
-	w_l = hlp->w_list;
-	while (w_l) {
-		w = ebt_find_watcher(w_l->w->u.name);
-		if (!w)
-			ebt_print_bug("Watcher not found");
-		w->print(hlp, w_l->w);
-		w_l = w_l->next;
-	}*/
+
 	printf("-j ");
 	if (!(format & FMT_NOTARGET))
 		printf("%s", cs.jumpto);
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index fd8bc9f..fac172e 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -15,6 +15,10 @@
 /* Be backwards compatible, so don't use '+' in kernel */
 #define IF_WILDCARD 1
 
+#ifndef ETH_ALEN
+#define ETH_ALEN 6
+#endif /* ETH_ALEN */
+
 extern unsigned char eb_mac_type_unicast[ETH_ALEN];
 extern unsigned char eb_msk_type_unicast[ETH_ALEN];
 extern unsigned char eb_mac_type_multicast[ETH_ALEN];
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 71c4476..0ba9742 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -26,6 +26,7 @@
 #include <libnftnl/expr.h>
 
 #include "nft-shared.h"
+#include "nft-bridge.h"
 #include "xshared.h"
 #include "nft.h"
 
@@ -326,9 +327,23 @@ void nft_parse_match(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	const char *mt_name = nft_rule_expr_get_str(e, NFT_EXPR_MT_NAME);
 	const void *mt_info = nft_rule_expr_get(e, NFT_EXPR_MT_INFO, &mt_len);
 	struct xtables_match *match;
+	struct xtables_rule_match **matches;
 	struct xt_entry_match *m;
 
-	match = xtables_find_match(mt_name, XTF_TRY_LOAD, &ctx->state.cs->matches);
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		matches = &ctx->state.cs->matches;
+		break;
+	case NFPROTO_BRIDGE:
+		matches = &ctx->state.cs_eb->matches;
+		break;
+	default:
+		fprintf(stderr, "BUG: nft_parse_match() unhandled family\n");
+		break;
+	}
+
+	match = xtables_find_match(mt_name, XTF_TRY_LOAD, matches);
 	if (match == NULL)
 		return;
 

