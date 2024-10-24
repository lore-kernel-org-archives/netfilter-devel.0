Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889CE19DFB4
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785780; cv=none; b=kQ7PCzWxZp20ouygGUbgA+NORzqnPnzkmpZxreQmKj8xGsJH2MGAMD0qf1VwI5RQjb7bxJPAtpkON2SnUFBRPgG7M0C08gGaS5v6wuPIE/YAo3aARKnLyZ7k5IDVYAIsQbz1qUkLM2rKX6tY2KuT2WEHxG+54KjZgHyuK7rMtYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785780; c=relaxed/simple;
	bh=IODN4St1zf4o5lvxJh9E0pIRJdYqrp23FCqErrBPDRg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cq0SED68BZMugjlOjc2eATXPTGIHfbUqj0PiXBM1bHq9fawkQ14yaJuEefkqJhtkGux5ruvu0ImMiGZ3pEPNA/d7aVAz9sITs872PY0ZSs/tp9LqjUNb/NAFeB/ZH+DvTYVMk5rDl0avfeBroHn+wdPitguWpjPNAk0H2wQbFAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/4] mnl: update cmd_add_loc() to take struct nlmsghdr
Date: Thu, 24 Oct 2024 18:02:48 +0200
Message-Id: <20241024160250.871045-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241024160250.871045-1-pablo@netfilter.org>
References: <20241024160250.871045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for a fix for very large sets.

No functional change is intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/cmd.h |  2 +-
 src/cmd.c     |  4 +--
 src/mnl.c     | 77 +++++++++++++++++++++++++--------------------------
 3 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index 0a8779b1ea19..cf7e43bf46ec 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -1,7 +1,7 @@
 #ifndef _NFT_CMD_H_
 #define _NFT_CMD_H_
 
-void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
+void cmd_add_loc(struct cmd *cmd, const struct nlmsghdr *nlh, const struct location *loc);
 struct mnl_err;
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		   struct mnl_err *err);
diff --git a/src/cmd.c b/src/cmd.c
index e010dcb8113e..78a2aa3025ed 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -17,14 +17,14 @@
 #include <errno.h>
 #include <cache.h>
 
-void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
+void cmd_add_loc(struct cmd *cmd, const struct nlmsghdr *nlh, const struct location *loc)
 {
 	if (cmd->num_attrs >= cmd->attr_array_len) {
 		cmd->attr_array_len *= 2;
 		cmd->attr = xrealloc(cmd->attr, sizeof(struct nlerr_loc) * cmd->attr_array_len);
 	}
 
-	cmd->attr[cmd->num_attrs].offset = offset;
+	cmd->attr[cmd->num_attrs].offset = nlh->nlmsg_len;
 	cmd->attr[cmd->num_attrs].location = loc;
 	cmd->num_attrs++;
 }
diff --git a/src/mnl.c b/src/mnl.c
index c1691da2e51b..42d1b0d87ec1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -474,7 +474,7 @@ static int mnl_nft_expr_build_cb(struct nftnl_expr *nle, void *data)
 
 	eloc = nft_expr_loc_find(nle, ctx->lctx);
 	if (eloc)
-		cmd_add_loc(cmd, nlh->nlmsg_len, eloc->loc);
+		cmd_add_loc(cmd, nlh, eloc->loc);
 
 	nest = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
 	nftnl_expr_build_payload(nlh, nle);
@@ -527,9 +527,9 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	cmd_add_loc(cmd, nlh, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
+	cmd_add_loc(cmd, nlh, &h->chain.location);
 
 	if (h->chain_id)
 		mnl_attr_put_u32(nlh, NFTA_RULE_CHAIN_ID, htonl(h->chain_id));
@@ -578,11 +578,11 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 				    cmd->handle.family,
 				    NLM_F_REPLACE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	cmd_add_loc(cmd, nlh, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
+	cmd_add_loc(cmd, nlh, &h->chain.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
+	cmd_add_loc(cmd, nlh, &h->handle.location);
 	mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
 
 	mnl_nft_rule_build_ctx_init(&rule_ctx, nlh, cmd, &lctx);
@@ -621,14 +621,14 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    0, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	cmd_add_loc(cmd, nlh, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
 	if (h->chain.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
+		cmd_add_loc(cmd, nlh, &h->chain.location);
 		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
 	}
 	if (h->handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &h->handle.location);
+		cmd_add_loc(cmd, nlh, &h->handle.location);
 		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(h->handle.id));
 	}
 
@@ -792,12 +792,12 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[0].location);
+		cmd_add_loc(cmd, nlh, dev_array[0].location);
 		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
 		for (i = 0; i < num_devs; i++) {
-			cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[i].location);
+			cmd_add_loc(cmd, nlh, dev_array[i].location);
 			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
 			mnl_attr_nest_end(nlh, nest_dev);
 		}
@@ -842,9 +842,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.chain.location);
 
 	if (!cmd->chain || !(cmd->chain->flags & CHAIN_F_BINDING)) {
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
@@ -861,7 +861,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (cmd->chain && cmd->chain->policy) {
 		mpz_export_data(&policy, cmd->chain->policy->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->policy->location);
+		cmd_add_loc(cmd, nlh, &cmd->chain->policy->location);
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_POLICY, htonl(policy));
 	}
 
@@ -873,7 +873,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		struct nlattr *nest;
 
 		if (cmd->chain->type.str) {
-			cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->chain->type.loc);
+			cmd_add_loc(cmd, nlh, &cmd->chain->type.loc);
 			mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, cmd->chain->type.str);
 		}
 
@@ -949,13 +949,13 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 				    cmd->handle.family,
 				    0, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
 	if (cmd->handle.chain.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.chain.location);
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
 	} else if (cmd->handle.handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.handle.location);
 		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
@@ -1077,7 +1077,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    cmd->handle.family,
 				    flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 	nftnl_table_free(nlt);
@@ -1106,10 +1106,10 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd)
 			            cmd->handle.family, 0, ctx->seqnum);
 
 	if (cmd->handle.table.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 		mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
 	} else if (cmd->handle.handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.handle.location);
 		mnl_attr_put_u64(nlh, NFTA_TABLE_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
@@ -1325,9 +1325,9 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    h->family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
+	cmd_add_loc(cmd, nlh, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_SET_TABLE, h->table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->set.location);
+	cmd_add_loc(cmd, nlh, &h->set.location);
 	mnl_attr_put_strz(nlh, NFTA_SET_NAME, h->set.name);
 
 	nftnl_set_nlmsg_build_payload(nlh, nls);
@@ -1359,13 +1359,13 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
 				    h->family,
 				    0, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_SET_TABLE, cmd->handle.table.name);
 	if (h->set.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.set.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.set.location);
 		mnl_attr_put_strz(nlh, NFTA_SET_NAME, cmd->handle.set.name);
 	} else if (h->handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.handle.location);
 		mnl_attr_put_u64(nlh, NFTA_SET_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
@@ -1544,9 +1544,9 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    NFT_MSG_NEWOBJ, cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_OBJ_TABLE, cmd->handle.table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.obj.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.obj.location);
 	mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, cmd->handle.obj.name);
 
 	nftnl_obj_nlmsg_build_payload(nlh, nlo);
@@ -1577,14 +1577,14 @@ int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type)
 				    msg_type, cmd->handle.family,
 				    0, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_OBJ_TABLE, cmd->handle.table.name);
 
 	if (cmd->handle.obj.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.obj.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.obj.location);
 		mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, cmd->handle.obj.name);
 	} else if (cmd->handle.handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.handle.location);
 		mnl_attr_put_u64(nlh, NFTA_OBJ_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
@@ -1764,7 +1764,7 @@ next:
 	list_for_each_entry_from(expr, &set->expressions, list) {
 		nlse = alloc_nftnl_setelem(set, expr);
 
-		cmd_add_loc(cmd, nlh->nlmsg_len, &expr->location);
+		cmd_add_loc(cmd, nlh, &expr->location);
 		nest2 = mnl_attr_nest_start(nlh, ++i);
 		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
 		mnl_attr_nest_end(nlh, nest2);
@@ -2005,7 +2005,7 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
 	for (i = 0; i < num_devs; i++) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[i].location);
+		cmd_add_loc(cmd, nlh, dev_array[i].location);
 		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
 	}
 
@@ -2037,9 +2037,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				    NFT_MSG_NEWFLOWTABLE, cmd->handle.family,
 				    NLM_F_CREATE | flags, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_TABLE, cmd->handle.table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.flowtable.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.flowtable.location);
 	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME, cmd->handle.flowtable.name);
 
 	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
@@ -2086,16 +2086,15 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 				    msg_type, cmd->handle.family,
 				    0, ctx->seqnum);
 
-	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	cmd_add_loc(cmd, nlh, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_TABLE, cmd->handle.table.name);
 
 	if (cmd->handle.flowtable.name) {
-		cmd_add_loc(cmd, nlh->nlmsg_len,
-			    &cmd->handle.flowtable.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.flowtable.location);
 		mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME,
 				  cmd->handle.flowtable.name);
 	} else if (cmd->handle.handle.id) {
-		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		cmd_add_loc(cmd, nlh, &cmd->handle.handle.location);
 		mnl_attr_put_u64(nlh, NFTA_FLOWTABLE_HANDLE,
 				 htobe64(cmd->handle.handle.id));
 	}
-- 
2.30.2

