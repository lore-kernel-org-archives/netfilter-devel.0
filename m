From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC PATCH  07/15] nft: Add support for xtables extensions callback to change cs
Date: Fri, 19 Jul 2013 18:17:36 +0300
Message-ID: <1374247064-3361-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21979 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3GSPSF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:05 -0400
In-Reply-To: <1374247064-3361-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-xt-ext.c | 20 ++++++++++++++++++++
 iptables/nft-xt-ext.h |  2 ++
 iptables/nft.c        |  3 ++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index 387d6fa..ffc53f0 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -146,3 +146,23 @@ int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree)
 
 	return 0;
 }
+
+int nft_xt_ext_parse_callback(const char *ident, void *data, void *user_data)
+{
+	struct nft_to_cs_data *i2cs = user_data;
+	struct xtables_target *target;
+	struct xtables_match *match;
+
+	target = xtables_find_target(ident, XTF_TRY_LOAD);
+	match = xtables_find_match(ident, XTF_TRY_LOAD, &i2cs->cs->matches);
+
+	if (target != NULL) {
+		target->t = data;
+		i2cs->cs->target = target;
+	} else if (match != NULL)
+		match->m = data;
+	else
+		return -1;
+
+	return 0;
+}
diff --git a/iptables/nft-xt-ext.h b/iptables/nft-xt-ext.h
index a367277..f3e6491 100644
--- a/iptables/nft-xt-ext.h
+++ b/iptables/nft-xt-ext.h
@@ -10,3 +10,5 @@
 #include <nft-translator.h>
 
 int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree);
+
+int nft_xt_ext_parse_callback(const char *ident, void *data, void *user_data);
diff --git a/iptables/nft.c b/iptables/nft.c
index 2f00486..57bc3d8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1831,7 +1831,8 @@ nft_rule_to_iptables_command_state(struct nft_rule *r,
 	i2cs.family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
 	i2cs.cs = cs;
 
-	nft_trans_rule_translate_to_instructions(xt_nft_tree, r, NULL, &i2cs);
+	nft_trans_rule_translate_to_instructions(xt_nft_tree, r,
+					nft_xt_ext_parse_callback, &i2cs);
 
 	if (i2cs.cs->target != NULL)
 		i2cs.cs->jumpto = i2cs.cs->target->name;
-- 
1.8.3.2

