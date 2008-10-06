From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/23] netfilter: ebtables: use generic table checking
Date: Mon,  6 Oct 2008 08:15:06 -0400
Message-ID: <ed9e91413b5b344265e42cf5019b8374ee85bf18.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57089 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYJFMP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:29 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ebtables ORs (1 << NF_BR_NUMHOOKS) into the hook mask to indicate that
the extension was called from a base chain. So this also needs to be
present in the extensions' ->hooks.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_arpreply.c |    4 ++--
 net/bridge/netfilter/ebt_dnat.c     |    2 ++
 net/bridge/netfilter/ebt_redirect.c |    2 ++
 net/bridge/netfilter/ebt_snat.c     |    6 ++----
 4 files changed, 8 insertions(+), 6 deletions(-)

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
-- 
1.6.0.1

