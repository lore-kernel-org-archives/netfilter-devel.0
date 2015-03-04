From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] arptables-compat: add support for the CLASSIFY
 target
Date: Wed, 04 Mar 2015 17:50:26 +0100
Message-ID: <20150304165025.16011.70236.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43099 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757904AbbCDQug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 11:50:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to arptables-compat for the CLASSIFY target.

An extra space in the print path is deleted so the target is correctly
printed.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libxt_CLASSIFY.c |   44 +++++++++++++++++++++++++++++++------------
 iptables/nft-arp.c          |    2 +-
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index e04657a..cd016d8 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -73,20 +73,40 @@ CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 	       TC_H_MAJ(clinfo->priority)>>16, TC_H_MIN(clinfo->priority));
 }
 
-static struct xtables_target classify_target = { 
-	.family		= NFPROTO_UNSPEC,
-	.name		= "CLASSIFY",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.help		= CLASSIFY_help,
-	.print		= CLASSIFY_print,
-	.save		= CLASSIFY_save,
-	.x6_parse	= CLASSIFY_parse,
-	.x6_options	= CLASSIFY_opts,
+static void
+arpCLASSIFY_print(const void *ip, const struct xt_entry_target *target,
+		  int numeric)
+{
+	CLASSIFY_save(ip, target);
+}
+
+static struct xtables_target classify_target[] = {
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "CLASSIFY",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+		.help		= CLASSIFY_help,
+		.print		= CLASSIFY_print,
+		.save		= CLASSIFY_save,
+		.x6_parse	= CLASSIFY_parse,
+		.x6_options	= CLASSIFY_opts,
+	},
+	{
+		.family		= NFPROTO_ARP,
+		.name		= "CLASSIFY",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
+		.help		= CLASSIFY_help,
+		.print		= arpCLASSIFY_print,
+		.x6_parse	= CLASSIFY_parse,
+		.x6_options	= CLASSIFY_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&classify_target);
+	xtables_register_targets(classify_target, ARRAY_SIZE(classify_target));
 }
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 523b3ec..503c65a 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -593,7 +593,7 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 	if (cs.jumpto != NULL && strcmp(cs.jumpto, "") != 0) {
 		printf("-j %s", cs.jumpto);
 	} else if (cs.target) {
-		printf("-j %s ", cs.target->name);
+		printf("-j %s", cs.target->name);
 		cs.target->print(&cs.fw, cs.target->t, format & FMT_NUMERIC);
 	}
 

