From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 07/16] nft: Add support for xtables extensions callback to change cs
Date: Fri,  9 Aug 2013 16:31:21 +0300
Message-ID: <1376055090-26551-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:49 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This add the support of xtables extension expressed in pure nft through
the nft translator. Thus feeding give command structure with the right
target or match. This has been implemented as a callback, in the core,
to let the extentions being able to feed the command structure. Which
command structure they cannot handle (its declaration is private to the core).

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c |  3 ++-
 iptables/nft-xt-ext.c | 20 ++++++++++++++++++++
 iptables/nft-xt-ext.h |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b3682c4..8bef696 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -512,7 +512,8 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 	i2cs.family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
 	i2cs.cs = cs;
 
-	nft_trans_rule_translate_to_instructions(xt_nft_tree, r, NULL, &i2cs);
+	nft_trans_rule_translate_to_instructions(xt_nft_tree, r,
+					nft_xt_ext_parse_callback, &i2cs);
 
 	if (i2cs.cs->target != NULL)
 		i2cs.cs->jumpto = i2cs.cs->target->name;
diff --git a/iptables/nft-xt-ext.c b/iptables/nft-xt-ext.c
index f013493..660e417 100644
--- a/iptables/nft-xt-ext.c
+++ b/iptables/nft-xt-ext.c
@@ -143,3 +143,23 @@ int nft_xt_ext_into_translation_tree(struct nft_trans_instruction_tree *tree)
 
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
-- 
1.8.3.2

