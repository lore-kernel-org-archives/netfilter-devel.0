From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xtables: print hook name instead of mask
Date: Sun, 5 Apr 2009 10:44:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904051043390.21858@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42060 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZDEIoy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:44:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent b8dfe498775de912116f275680ddb57c8799d9ef (v2.6.29-rc5-884-gb8dfe49)
commit fc00a21ec88ca113f9c20416998279f0f1699e75
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Apr 5 10:43:09 2009 +0200

netfilter: xtables: print hook name instead of mask

Users cannot make anything of these numbers. Let's just tell them
directly.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |   42 ++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index bfcac92..013eb14 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -329,6 +329,32 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
+static char *textify_hooks(char *buf, size_t size, unsigned int mask)
+{
+	static const char *const names[] = {
+		"PREROUTING", "INPUT", "FORWARD",
+		"OUTPUT", "POSTROUTING", "BROUTING",
+	};
+	unsigned int i;
+	char *p = buf;
+	bool np = false;
+	int res;
+
+	*p = '\0';
+	for (i = 0; i < ARRAY_SIZE(names); ++i) {
+		if (!(mask & (1 << i)))
+			continue;
+		res = snprintf(p, size, "%s%s", np ? "/" : "", names[i]);
+		if (res > 0) {
+			size -= res;
+			p += res;
+		}
+		np = true;
+	}
+
+	return buf;
+}
+
 int xt_check_match(struct xt_mtchk_param *par,
 		   unsigned int size, u_int8_t proto, bool inv_proto)
 {
@@ -351,9 +377,13 @@ int xt_check_match(struct xt_mtchk_param *par,
 		return -EINVAL;
 	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
-		printk("%s_tables: %s match: bad hook_mask %#x/%#x\n",
+		char used[64], allow[64];
+
+		printk("%s_tables: %s match: used from hooks %s, but only "
+		       "valid from %s\n",
 		       xt_prefix[par->family], par->match->name,
-		       par->hook_mask, par->match->hooks);
+		       textify_hooks(used, sizeof(used), par->hook_mask),
+		       textify_hooks(allow, sizeof(allow), par->match->hooks));
 		return -EINVAL;
 	}
 	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
@@ -497,9 +527,13 @@ int xt_check_target(struct xt_tgchk_param *par,
 		return -EINVAL;
 	}
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
-		printk("%s_tables: %s target: bad hook_mask %#x/%#x\n",
+		char used[64], allow[64];
+
+		printk("%s_tables: %s target: used from hooks %s, but only "
+		       "usable from %s\n",
 		       xt_prefix[par->family], par->target->name,
-		       par->hook_mask, par->target->hooks);
+		       textify_hooks(used, sizeof(used), par->hook_mask),
+		       textify_hooks(allow, sizeof(allow), par->target->hooks));
 		return -EINVAL;
 	}
 	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
-- 
# Created with git-export-patch

