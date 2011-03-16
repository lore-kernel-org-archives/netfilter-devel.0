From: Thomas Graf <tgraf@infradead.org>
Subject: [PATCH] ebtables: Fix xt_AUDIT to work with ebtables, return
 EBT_CONTINUE if NFPROTO_BRIDGE
Date: Wed, 16 Mar 2011 05:20:32 -0400
Message-ID: <20110316092032.GA10096@canuck.infradead.org>
References: <20110316003307.GB26145@canuck.infradead.org>
 <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1CPJUf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:20:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Even though ebtables uses xtables it still requires targets to
return EBT_CONTINUE instead of XT_CONTINUE. This prevented
xt_AUDIT to work as ebt module.

Upon Jan's suggestion, use a separate struct xt_target for
NFPROTO_BRIDGE having its own target callback returning
EBT_CONTINUE instead of cloning the module.

Signed-off-by: Thomas Graf <tgraf@redhat.com>

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 81802d2..363a99e 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_AUDIT.h>
+#include <linux/netfilter_bridge/ebtables.h>
 #include <net/ipv6.h>
 #include <net/ip.h>
 
@@ -168,6 +169,13 @@ errout:
 	return XT_CONTINUE;
 }
 
+static unsigned int
+audit_tg_ebt(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	audit_tg(skb, par);
+	return EBT_CONTINUE;
+}
+
 static int audit_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_audit_info *info = par->targinfo;
@@ -181,23 +189,33 @@ static int audit_tg_check(const struct xt_tgchk_param *par)
 	return 0;
 }
 
-static struct xt_target audit_tg_reg __read_mostly = {
-	.name		= "AUDIT",
-	.family		= NFPROTO_UNSPEC,
-	.target		= audit_tg,
-	.targetsize	= sizeof(struct xt_audit_info),
-	.checkentry	= audit_tg_check,
-	.me		= THIS_MODULE,
+static struct xt_target audit_tg_reg[] __read_mostly = {
+	{
+		.name		= "AUDIT",
+		.family		= NFPROTO_UNSPEC,
+		.target		= audit_tg,
+		.targetsize	= sizeof(struct xt_audit_info),
+		.checkentry	= audit_tg_check,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "AUDIT",
+		.family		= NFPROTO_BRIDGE,
+		.target		= audit_tg_ebt,
+		.targetsize	= sizeof(struct xt_audit_info),
+		.checkentry	= audit_tg_check,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init audit_tg_init(void)
 {
-	return xt_register_target(&audit_tg_reg);
+	return xt_register_targets(audit_tg_reg, ARRAY_SIZE(audit_tg_reg));
 }
 
 static void __exit audit_tg_exit(void)
 {
-	xt_unregister_target(&audit_tg_reg);
+	xt_unregister_targets(audit_tg_reg, ARRAY_SIZE(audit_tg_reg));
 }
 
 module_init(audit_tg_init);
