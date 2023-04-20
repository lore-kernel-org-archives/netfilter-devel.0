Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389F8C7618E
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 22:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjDTWs2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDTWs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 18:48:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B31B226A9
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 15:48:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 1/2] mnl: flowtable support for extended netlink error reporting
Date:   Fri, 21 Apr 2023 00:48:20 +0200
Message-Id: <20230420224821.322008-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends existing flowtable support to improve error
reporting:

 # nft add flowtable inet x y '{ devices = { x } ; }'
 Error: Could not process rule: No such file or directory
 add flowtable inet x y { devices = { x } ; }
                                      ^
 # nft delete flowtable inet x y '{ devices = { x } ; }'
 Error: Could not process rule: No such file or directory
 delete flowtable inet x y { devices = { x } ; }
                                         ^
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fixes to make tests/shell happy

 src/mnl.c | 142 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 82 insertions(+), 60 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index ce9e4ee1c059..4c16facaccab 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -718,6 +718,51 @@ err:
 /*
  * Chain
  */
+
+struct nft_dev {
+	const char	*ifname;
+	struct location	*location;
+};
+
+static struct nft_dev *nft_dev_array(const struct expr *dev_expr, int *num_devs)
+{
+	struct nft_dev *dev_array;
+	unsigned int ifname_len;
+	char ifname[IFNAMSIZ];
+	int i = 0, len = 1;
+	struct expr *expr;
+
+	list_for_each_entry(expr, &dev_expr->expressions, list)
+		len++;
+
+	dev_array = xmalloc(sizeof(struct nft_dev) * len);
+
+	list_for_each_entry(expr, &dev_expr->expressions, list) {
+		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+		memset(ifname, 0, sizeof(ifname));
+		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
+				ifname_len);
+		dev_array[i].ifname = xstrdup(ifname);
+		dev_array[i].location = &expr->location;
+		i++;
+	}
+
+	dev_array[i].ifname = NULL;
+	*num_devs = i;
+
+	return dev_array;
+}
+
+static void nft_dev_array_free(const struct nft_dev *dev_array)
+{
+	int i = 0;
+
+	while (dev_array[i].ifname != NULL)
+		xfree(dev_array[i++].ifname);
+
+	xfree(dev_array);
+}
+
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
@@ -1907,48 +1952,30 @@ err:
 	return NULL;
 }
 
-static const char **nft_flowtable_dev_array(struct cmd *cmd)
+static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 {
-	unsigned int ifname_len;
-	const char **dev_array;
-	char ifname[IFNAMSIZ];
-	int i = 0, len = 1;
-	struct expr *expr;
+	const struct expr *dev_expr = cmd->flowtable->dev_expr;
+	const struct nft_dev *dev_array;
+	struct nlattr *nest_dev;
+	int i, num_devs= 0;
 
-	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
-		len++;
-
-	dev_array = xmalloc(sizeof(char *) * len);
-
-	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list) {
-		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
-		memset(ifname, 0, sizeof(ifname));
-		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
-				ifname_len);
-		dev_array[i++] = xstrdup(ifname);
+	dev_array = nft_dev_array(dev_expr, &num_devs);
+	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
+	for (i = 0; i < num_devs; i++) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[i].location);
+		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
 	}
 
-	dev_array[i] = NULL;
-
-	return dev_array;
-}
-
-static void nft_flowtable_dev_array_free(const char **dev_array)
-{
-	int i = 0;
-
-	while (dev_array[i] != NULL)
-		xfree(dev_array[i++]);
-
-	free(dev_array);
+	mnl_attr_nest_end(nlh, nest_dev);
+	nft_dev_array_free(dev_array);
 }
 
 int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags)
 {
 	struct nftnl_flowtable *flo;
-	const char **dev_array;
 	struct nlmsghdr *nlh;
+	struct nlattr *nest;
 	int priority;
 
 	flo = nftnl_flowtable_alloc();
@@ -1958,24 +1985,6 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
 
-	if (cmd->flowtable->hook.name) {
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
-					cmd->flowtable->hook.num);
-		mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
-				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
-	} else {
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM, 0);
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
-	}
-
-	if (cmd->flowtable->dev_expr) {
-		dev_array = nft_flowtable_dev_array(cmd);
-		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
-					 dev_array, 0);
-		nft_flowtable_dev_array_free(dev_array);
-	}
-
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FLAGS,
 				cmd->flowtable->flags);
 
@@ -1991,6 +2000,21 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME, cmd->handle.flowtable.name);
 
 	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
+
+	nest = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK);
+
+	if (cmd->flowtable && cmd->flowtable->priority.expr) {
+		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_HOOK_NUM, htonl(cmd->flowtable->hook.num));
+		mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(priority));
+	}
+
+	if (cmd->flowtable->dev_expr)
+		mnl_nft_ft_devs_build(nlh, cmd);
+
+	mnl_attr_nest_end(nlh, nest);
+
 	nftnl_flowtable_free(flo);
 
 	mnl_nft_batch_continue(ctx->batch);
@@ -2002,8 +2026,8 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	enum nf_tables_msg_types msg_type = NFT_MSG_DELFLOWTABLE;
 	struct nftnl_flowtable *flo;
-	const char **dev_array;
 	struct nlmsghdr *nlh;
+	struct nlattr *nest;
 
 	flo = nftnl_flowtable_alloc();
 	if (!flo)
@@ -2012,16 +2036,6 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
 
-	if (cmd->flowtable && cmd->flowtable->dev_expr) {
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM, 0);
-		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
-
-		dev_array = nft_flowtable_dev_array(cmd);
-		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
-					 dev_array, 0);
-		nft_flowtable_dev_array_free(dev_array);
-	}
-
 	if (cmd->op == CMD_DESTROY)
 		msg_type = NFT_MSG_DESTROYFLOWTABLE;
 
@@ -2044,6 +2058,14 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
+
+	if (cmd->op == CMD_DELETE &&
+	    cmd->flowtable && cmd->flowtable->dev_expr) {
+		nest = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK);
+		mnl_nft_ft_devs_build(nlh, cmd);
+		mnl_attr_nest_end(nlh, nest);
+	}
+
 	nftnl_flowtable_free(flo);
 
 	mnl_nft_batch_continue(ctx->batch);
-- 
2.30.2

