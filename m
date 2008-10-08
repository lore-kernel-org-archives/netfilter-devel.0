From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 59/79: ebtables: use generic table checking
Date: Wed,  8 Oct 2008 12:47:40 +0200 (MEST)
Message-ID: <20081008104740.10423.53341.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYJHKrm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:42 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f2ff525c8dae57b3cda51d76443f60f764f34202
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:15 2008 +0200

    netfilter: ebtables: use generic table checking
    
    Ebtables ORs (1 << NF_BR_NUMHOOKS) into the hook mask to indicate that
    the extension was called from a base chain. So this also needs to be
    present in the extensions' ->hooks.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 8071b64..0e51c8d 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -73,8 +73,6 @@ ebt_arpreply_tg_check(const char *tablename, const void *entry,
 	    e->invflags & EBT_IPROTO)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
-		return false;
 	return true;
 }
 
@@ -82,6 +80,8 @@ static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
 	.name		= "arpreply",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
+	.table		= "nat",
+	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING),
 	.target		= ebt_arpreply_tg,
 	.checkentry	= ebt_arpreply_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_arpreply_info)),
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index d2211c4..cb80101 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -51,6 +51,8 @@ static struct xt_target ebt_dnat_tg_reg __read_mostly = {
 	.name		= "dnat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
+	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING) |
+			  (1 << NF_BR_LOCAL_OUT) | (1 << NF_BR_BROUTING),
 	.target		= ebt_dnat_tg,
 	.checkentry	= ebt_dnat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 1b7684f..a50ffbe 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -56,6 +56,8 @@ static struct xt_target ebt_redirect_tg_reg __read_mostly = {
 	.name		= "redirect",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
+	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_PRE_ROUTING) |
+			  (1 << NF_BR_BROUTING),
 	.target		= ebt_redirect_tg,
 	.checkentry	= ebt_redirect_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_redirect_info)),
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index c90217a..8a55c7d 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -56,10 +56,6 @@ ebt_snat_tg_check(const char *tablename, const void *e,
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat"))
-		return false;
-	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
-		return false;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
 		return false;
@@ -73,6 +69,8 @@ static struct xt_target ebt_snat_tg_reg __read_mostly = {
 	.name		= "snat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
+	.table		= "nat",
+	.hooks		= (1 << NF_BR_NUMHOOKS) | (1 << NF_BR_POST_ROUTING),
 	.target		= ebt_snat_tg,
 	.checkentry	= ebt_snat_tg_check,
 	.targetsize	= XT_ALIGN(sizeof(struct ebt_nat_info)),
