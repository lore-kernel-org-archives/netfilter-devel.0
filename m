From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nft_compat: skip family comparison in case of NFPROTO_UNSPEC
Date: Mon, 14 Dec 2015 13:17:13 +0100
Message-ID: <1450095436-24855-3-git-send-email-pablo@netfilter.org>
References: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbbLNMR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3117C8E1E9
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 298A6DA801
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 255F9DA86E
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:22 +0100 (CET)
In-Reply-To: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ upstream commit ba378ca9c04a5fc1b2cf0f0274a9d02eb3d1bad9 ]

Fix lookup of existing match/target structures in the corresponding list
by skipping the family check if NFPROTO_UNSPEC is used.

This is resulting in the allocation and insertion of one match/target
structure for each use of them. So this not only bloats memory
consumption but also severely affects the time to reload the ruleset
from the iptables-compat utility.

After this patch, iptables-compat-restore and iptables-compat take
almost the same time to reload large rulesets.

Cc: <stable@vger.kernel.org> # 4.1.x
Cc: <stable@vger.kernel.org> # 4.2.x
Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 66def31..9c8fab0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -619,6 +619,13 @@ struct nft_xt {
 
 static struct nft_expr_type nft_match_type;
 
+static bool nft_match_cmp(const struct xt_match *match,
+			  const char *name, u32 rev, u32 family)
+{
+	return strcmp(match->name, name) == 0 && match->revision == rev &&
+	       (match->family == NFPROTO_UNSPEC || match->family == family);
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -626,7 +633,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	struct nft_xt *nft_match;
 	struct xt_match *match;
 	char *mt_name;
-	__u32 rev, family;
+	u32 rev, family;
 
 	if (tb[NFTA_MATCH_NAME] == NULL ||
 	    tb[NFTA_MATCH_REV] == NULL ||
@@ -641,8 +648,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	list_for_each_entry(nft_match, &nft_match_list, head) {
 		struct xt_match *match = nft_match->ops.data;
 
-		if (strcmp(match->name, mt_name) == 0 &&
-		    match->revision == rev && match->family == family) {
+		if (nft_match_cmp(match, mt_name, rev, family)) {
 			if (!try_module_get(match->me))
 				return ERR_PTR(-ENOENT);
 
@@ -693,6 +699,13 @@ static LIST_HEAD(nft_target_list);
 
 static struct nft_expr_type nft_target_type;
 
+static bool nft_target_cmp(const struct xt_target *tg,
+			   const char *name, u32 rev, u32 family)
+{
+	return strcmp(tg->name, name) == 0 && tg->revision == rev &&
+	       (tg->family == NFPROTO_UNSPEC || tg->family == family);
+}
+
 static const struct nft_expr_ops *
 nft_target_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
@@ -700,7 +713,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	struct nft_xt *nft_target;
 	struct xt_target *target;
 	char *tg_name;
-	__u32 rev, family;
+	u32 rev, family;
 
 	if (tb[NFTA_TARGET_NAME] == NULL ||
 	    tb[NFTA_TARGET_REV] == NULL ||
@@ -715,8 +728,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
-		if (strcmp(target->name, tg_name) == 0 &&
-		    target->revision == rev && target->family == family) {
+		if (nft_target_cmp(target, tg_name, rev, family)) {
 			if (!try_module_get(target->me))
 				return ERR_PTR(-ENOENT);
 
-- 
1.7.10.4

