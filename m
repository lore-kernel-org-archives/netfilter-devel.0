From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH v2 1/2] arptables-compat: add support for the
 CLASSIFY target
Date: Thu, 05 Mar 2015 19:47:38 +0100
Message-ID: <20150305184720.4584.92956.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42623 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751083AbbCESrt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 13:47:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to arptables-compat for the CLASSIFY target.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: split in two patches

 extensions/libxt_CLASSIFY.c |   44 +++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

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

