From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] xt: use NFTNL_* definitions
Date: Tue, 20 Dec 2016 14:08:21 +0100
Message-ID: <1482239301-19054-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757471AbcLTNIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 08:08:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 230DCED063
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 14:08:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 120A2179E28
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 14:08:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D523179E29
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 14:08:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not use obsolete definitions in libnftnl.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/xt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index c4b76c731bef..e24b0af05bab 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -201,19 +201,19 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 
 	xtables_set_nfproto(ctx->table->handle.family);
 
-	name = nftnl_expr_get_str(nle, NFT_EXPR_MT_NAME);
+	name = nftnl_expr_get_str(nle, NFTNL_EXPR_MT_NAME);
 
 	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
 	if (!mt)
 		BUG("XT match %s not found\n", name);
 
-	mtinfo = nftnl_expr_get(nle, NFT_EXPR_MT_INFO, &mt_len);
+	mtinfo = nftnl_expr_get(nle, NFTNL_EXPR_MT_INFO, &mt_len);
 
 	m = xzalloc(sizeof(struct xt_entry_match) + mt_len);
 	memcpy(&m->data, mtinfo, mt_len);
 
 	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
-	m->u.user.revision = nftnl_expr_get_u32(nle, NFT_EXPR_MT_REV);
+	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
 
 	stmt = xt_stmt_alloc(loc);
 	stmt->xt.name = strdup(name);
@@ -238,18 +238,18 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 
 	xtables_set_nfproto(ctx->table->handle.family);
 
-	name = nftnl_expr_get_str(nle, NFT_EXPR_TG_NAME);
+	name = nftnl_expr_get_str(nle, NFTNL_EXPR_TG_NAME);
 	tg = xtables_find_target(name, XTF_TRY_LOAD);
 	if (!tg)
 		BUG("XT target %s not found\n", name);
 
-	tginfo = nftnl_expr_get(nle, NFT_EXPR_TG_INFO, &tg_len);
+	tginfo = nftnl_expr_get(nle, NFTNL_EXPR_TG_INFO, &tg_len);
 
 	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
 	t = xzalloc(size);
 	memcpy(&t->data, tginfo, tg_len);
 	t->u.target_size = size;
-	t->u.user.revision = nftnl_expr_get_u32(nle, NFT_EXPR_TG_REV);
+	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
 	strcpy(t->u.user.name, tg->name);
 
 	stmt = xt_stmt_alloc(loc);
-- 
2.1.4

