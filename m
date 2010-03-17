From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/9] netfilter: xtables: do without explicit XT_ALIGN
Date: Wed, 17 Mar 2010 14:18:56 +0100
Message-ID: <1268831945-6041-2-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59340 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0CQNTQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:16 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

XT_ALIGN is already applied on matchsize/targetsize in x_tables.c,
so it is not strictly needed in the extensions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_CT.c  |    2 +-
 net/netfilter/xt_LED.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index fda603e..6509e03 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -137,7 +137,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
 static struct xt_target xt_ct_tg __read_mostly = {
 	.name		= "CT",
 	.family		= NFPROTO_UNSPEC,
-	.targetsize	= XT_ALIGN(sizeof(struct xt_ct_target_info)),
+	.targetsize	= sizeof(struct xt_ct_target_info),
 	.checkentry	= xt_ct_tg_check,
 	.destroy	= xt_ct_tg_destroy,
 	.target		= xt_ct_target,
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 8ff7843..f86dc52 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -141,7 +141,7 @@ static struct xt_target led_tg_reg __read_mostly = {
 	.revision	= 0,
 	.family		= NFPROTO_UNSPEC,
 	.target		= led_tg,
-	.targetsize	= XT_ALIGN(sizeof(struct xt_led_info)),
+	.targetsize	= sizeof(struct xt_led_info),
 	.checkentry	= led_tg_check,
 	.destroy	= led_tg_destroy,
 	.me		= THIS_MODULE,
-- 
1.7.0.2

