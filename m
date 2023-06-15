Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DBBEB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 14:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjFOOoc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbjFOOob (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 10:44:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F83273B
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YvQcRzOPCyp1Bp16CCM02Y++GyWm54R44ZeXT5CJJug=; b=EK0ii0coamdhTCzNmRQZrKFRLC
        WxR7yI+v/x0vgAzKhNwFf9Gi90tk+gPRuMR/JZI/6b/GUj4CaHwdz01vBelCmzTvjQaaovSFsiewU
        TVy991mWfhZJEe6VpnkM4O+qkzakN7Q9ZoKbfdhVATYFc0LDsdQbvvT6Sx9p/7/JwcUIqLKwjYaQ/
        ftzdcG4yJ5YTl33Kt8lWhADIAOJqB/XQXFfYkUj3TkcBmr7XNZtmWjad/igft7uQj7VQ6dmTnJvr4
        87QauUbOYc9ptAfXMmbx8Y4pQ/NJ2uduGr28/vURrufeFOhrdGwU1bsqU+kWLXxg3+vQb5YZyLXn9
        yGfm0afw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q9oD6-0003nC-T2; Thu, 15 Jun 2023 16:44:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/3] evaluate: Cache looked up set for list commands
Date:   Thu, 15 Jun 2023 16:44:13 +0200
Message-Id: <20230615144414.1393-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230615144414.1393-1-phil@nwl.cc>
References: <20230615144414.1393-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Evaluation phase checks the given table and set exist in cache. Relieve
execution phase from having to perform the lookup again by storing the
set reference in cmd->set. Just have to increase the ref counter so
cmd_free() does the right thing (which lacked handling of MAP and METER
objects for some reason).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c |  1 +
 src/json.c     |  9 ++++++---
 src/rule.c     | 12 ++++++++----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3983fcaa35880..af7c273c3a0b2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5355,6 +5355,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
+		cmd->set = set_get(set);
 		return 0;
 	case CMD_OBJ_CHAIN:
 		table = table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/json.c b/src/json.c
index 981d177b75d4f..12eac36edba93 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1783,10 +1783,13 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 static json_t *do_list_set_json(struct netlink_ctx *ctx,
 				struct cmd *cmd, struct table *table)
 {
-	struct set *set = set_cache_find(table, cmd->handle.set.name);
+	struct set *set = cmd->set;
 
-	if (set == NULL)
-		return json_null();
+	if (!set) {
+		set = set_cache_find(table, cmd->handle.set.name);
+		if (set == NULL)
+			return json_null();
+	}
 
 	return json_pack("[o]", set_print_json(&ctx->nft->output, set));
 }
diff --git a/src/rule.c b/src/rule.c
index 633a5a12486d0..900352d25d6d4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1356,6 +1356,8 @@ void cmd_free(struct cmd *cmd)
 				set_free(cmd->elem.set);
 			break;
 		case CMD_OBJ_SET:
+		case CMD_OBJ_MAP:
+		case CMD_OBJ_METER:
 		case CMD_OBJ_SETELEMS:
 			set_free(cmd->set);
 			break;
@@ -2289,11 +2291,13 @@ static void __do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		       struct table *table)
 {
-	struct set *set;
+	struct set *set = cmd->set;
 
-	set = set_cache_find(table, cmd->handle.set.name);
-	if (set == NULL)
-		return -1;
+	if (!set) {
+		set = set_cache_find(table, cmd->handle.set.name);
+		if (set == NULL)
+			return -1;
+	}
 
 	__do_list_set(ctx, cmd, set);
 
-- 
2.40.0

