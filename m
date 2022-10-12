Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FE1C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJLPbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJLPbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:31:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F79BCA894
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EIykTHimQ37TiCu3R2IgpiLWSVA83Ng2IwJG72aMLzY=; b=AtTjJdrAi09PX9/NjxMH1S/5Nx
        dvQoawxitPBIUw9ANLOebDdHfgFif5gEV2U/tzu35+cVmU4nNdImd8HotILic+/I97dhEWg0x044N
        wcF0vJxNWIebZmJCtpcwO3k9N/X1u1XwkPmaDyIXt/sGDgpDYfkqIgoKpruaFK1SeL2vgUbKjPVLj
        itRnE6ahDv7KpKOYbaN5ZvlLizFUDNdYWjqicVhLOxkGK8kO+33JVtofiQl9cdpP9SRc7f03ibq1C
        ozW0OYp0q2FcppeSlEG3A8ze6m+VL2XUavl67ceOn3IgdAWZfcQHJvwf9h4BQkBsX1AxHHSQLUIlp
        qPgTNHSA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidhU-00031V-BU; Wed, 12 Oct 2022 17:31:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>,
        netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Warn for tables with compat expressions in rules
Date:   Wed, 12 Oct 2022 17:31:07 +0200
Message-Id: <20221012153107.24574-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While being able to "look inside" compat expressions using nft is a nice
feature, it is also (yet another) pitfall for unaware users, deceiving
them into assuming interchangeability (or at least compatibility)
between iptables-nft and nft.

In reality, which involves 'nft list ruleset | nft -f -', any correctly
translated compat expressions will turn into native nftables ones not
understood by (the version of) iptables-nft which created them in the
first place. Other compat expressions will vanish, potentially
compromising the firewall ruleset.

Emit a warning (as comment) to give users a chance to stop and
reconsider before shooting their own foot.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Sorry for the dup, forgot to Cc netfilter-devel.
---
 include/rule.h |  1 +
 src/rule.c     | 16 +++++++++++++---
 src/xt.c       |  2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ad9f912737228..00a1bac5a7737 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -169,6 +169,7 @@ struct table {
 	unsigned int		refcnt;
 	uint32_t		owner;
 	const char		*comment;
+	bool			has_xt_stmts;
 };
 
 extern struct table *table_alloc(void);
diff --git a/src/rule.c b/src/rule.c
index 1caee58fb7622..e9f9b232aa244 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1227,6 +1227,11 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
 
+	if (table->has_xt_stmts)
+		fprintf(octx->error_fp,
+			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
+			family, table->handle.table.name);
+
 	nft_print(octx, "table %s %s {", family, table->handle.table.name);
 	if (nft_output_handle(octx) || table->flags & TABLE_F_OWNER)
 		nft_print(octx, " #");
@@ -2381,9 +2386,14 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 static void table_print_declaration(struct table *table,
 				    struct output_ctx *octx)
 {
-	nft_print(octx, "table %s %s {\n",
-		  family2str(table->handle.family),
-		  table->handle.table.name);
+	const char *family = family2str(table->handle.family);
+
+	if (table->has_xt_stmts)
+		fprintf(octx->error_fp,
+			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
+			family, table->handle.table.name);
+
+	nft_print(octx, "table %s %s {\n", family, table->handle.table.name);
 }
 
 static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
diff --git a/src/xt.c b/src/xt.c
index 789de9926261b..a54173522c229 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -238,6 +238,7 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_MATCH;
 #endif
+	ctx->table->has_xt_stmts = true;
 	rule_stmt_append(ctx->rule, stmt);
 }
 
@@ -283,6 +284,7 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_TARGET;
 #endif
+	ctx->table->has_xt_stmts = true;
 	rule_stmt_append(ctx->rule, stmt);
 }
 
-- 
2.34.1

