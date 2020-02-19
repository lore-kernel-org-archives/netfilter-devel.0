Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAA1C34047
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E8B24654
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 14:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgBSOvb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:51:31 -0500
Received: from correo.us.es ([193.147.175.20]:53308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgBSOvb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 09:51:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE9A51E2C7F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEDD9DA38F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B48D2DA736; Wed, 19 Feb 2020 15:51:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FC5FDA3C3
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 15:51:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6882742EF4E0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 15:51:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] mnl: extended error support for create command
Date:   Wed, 19 Feb 2020 15:51:21 +0100
Message-Id: <20200219145123.667618-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft create table x
 Error: Could not process rule: File exists
 create table x
              ^

 # nft create chain x y
 Error: Could not process rule: File exists
 create chain x y
                ^

 # nft create set x y { typeof ip saddr\; }
 Error: Could not process rule: File exists
 create set x y { typeof ip saddr; }
              ^

 # nft create counter x y
 Error: Could not process rule: File exists
 create counter x y
                  ^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h | 10 +++++-----
 src/mnl.c     | 50 +++++++++++++++++++++++++++++++++-----------------
 src/rule.c    |  2 +-
 3 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 07669957a6a6..6d247ccae4d1 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -37,7 +37,7 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd);
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
 					  int family);
 
-int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
 int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
@@ -46,14 +46,14 @@ int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 					    int family);
 
-int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
 int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
 					    int family);
 
-int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags);
 int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
@@ -72,14 +72,14 @@ struct nftnl_obj_list *mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 					const char *table,
 					const char *name, uint32_t type,
 					bool dump, bool reset);
-int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags);
 int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type);
 
 struct nftnl_flowtable_list *
 mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table);
 
-int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags);
 int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
diff --git a/src/mnl.c b/src/mnl.c
index ee82db804b17..f959196922fc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -592,7 +592,7 @@ err:
 /*
  * Chain
  */
-int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
 	int priority, policy, i = 0;
@@ -607,8 +607,6 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
-	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, cmd->handle.table.name);
-	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, cmd->handle.chain.name);
 
 	if (cmd->chain) {
 		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
@@ -654,6 +652,12 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				    NFT_MSG_NEWCHAIN,
 				    cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
+	mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 	nftnl_chain_free(nlc);
 
@@ -778,7 +782,7 @@ err:
 /*
  * Table
  */
-int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
 	struct nftnl_table *nlt;
@@ -789,7 +793,6 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
-	nftnl_table_set_str(nlt, NFTNL_TABLE_NAME, cmd->handle.table.name);
 	if (cmd->table)
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
 	else
@@ -799,6 +802,9 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				    NFT_MSG_NEWTABLE,
 				    cmd->handle.family,
 				    flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 	nftnl_table_free(nlt);
 
@@ -910,10 +916,10 @@ static void set_key_expression(struct netlink_ctx *ctx,
 /*
  * Set
  */
-int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
-	const struct handle *h = &cmd->handle;
+	struct handle *h = &cmd->handle;
 	struct nftnl_udata_buf *udbuf;
 	struct set *set = cmd->set;
 	struct nftnl_set *nls;
@@ -924,8 +930,6 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FAMILY, h->family);
-	nftnl_set_set_str(nls, NFTNL_SET_TABLE, h->table.name);
-	nftnl_set_set_str(nls, NFTNL_SET_NAME, h->set.name);
 	nftnl_set_set_u32(nls, NFTNL_SET_ID, h->set_id);
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
@@ -998,6 +1002,12 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				    NFT_MSG_NEWSET,
 				    h->family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	mnl_attr_put_strz(nlh, NFTA_SET_TABLE, h->table.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &h->set.location);
+	mnl_attr_put_strz(nlh, NFTA_SET_NAME, h->set.name);
+
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 	nftnl_set_free(nls);
 
@@ -1099,7 +1109,7 @@ err:
 	return NULL;
 }
 
-int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
 	struct obj *obj = cmd->object;
@@ -1111,8 +1121,6 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_FAMILY, cmd->handle.family);
-	nftnl_obj_set_str(nlo, NFTNL_OBJ_TABLE, cmd->handle.table.name);
-	nftnl_obj_set_str(nlo, NFTNL_OBJ_NAME, cmd->handle.obj.name);
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, obj->type);
 
 	switch (obj->type) {
@@ -1190,6 +1198,12 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWOBJ, cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_OBJ_TABLE, cmd->handle.table.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.obj.location);
+	mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, cmd->handle.obj.name);
+
 	nftnl_obj_nlmsg_build_payload(nlh, nlo);
 	nftnl_obj_free(nlo);
 
@@ -1533,7 +1547,7 @@ err:
 	return NULL;
 }
 
-int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
+int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags)
 {
 	struct nftnl_flowtable *flo;
@@ -1549,10 +1563,6 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
-	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_TABLE,
-				cmd->handle.table.name);
-	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
-				cmd->handle.flowtable.name);
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
 				cmd->flowtable->hooknum);
 	mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
@@ -1576,6 +1586,12 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWFLOWTABLE, cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_TABLE, cmd->handle.table.name);
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.flowtable.location);
+	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME, cmd->handle.flowtable.name);
+
 	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
 	nftnl_flowtable_free(flo);
 
diff --git a/src/rule.c b/src/rule.c
index 9307dad54b6f..9e58ee66f984 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1579,7 +1579,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 	return __do_add_setelems(ctx, set, init, flags);
 }
 
-static int do_add_set(struct netlink_ctx *ctx, const struct cmd *cmd,
+static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		      uint32_t flags)
 {
 	struct set *set = cmd->set;
-- 
2.11.0

