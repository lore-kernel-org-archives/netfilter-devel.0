Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C455FC43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89892206F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgCZOIX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:08:23 -0400
Received: from correo.us.es ([193.147.175.20]:54300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbgCZOIX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:08:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B335612BFE0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A49F1DA3A1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A241DA390; Thu, 26 Mar 2020 15:08:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2D64DA3C2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 15:08:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8E7FF42EF4E1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add support for flowtable counter
Date:   Thu, 26 Mar 2020 15:08:16 +0100
Message-Id: <20200326140816.233848-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow users to enable flow counters via control plane toggle, e.g.

 table ip x {
	flowtable y {
		hook ingress priority 0;
		counter;
	}

	chain z {
		type filter hook ingress priority filter;
		flow add @z
	}
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 1 +
 src/mnl.c          | 3 +++
 src/netlink.c      | 2 ++
 src/parser_bison.y | 4 ++++
 src/rule.c         | 4 ++++
 5 files changed, 14 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 70c8c4cf7b43..db11b1d60658 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -491,6 +491,7 @@ struct flowtable {
 	const char		**dev_array;
 	struct expr		*dev_expr;
 	int			dev_array_len;
+	uint32_t		flags;
 	unsigned int		refcnt;
 };
 
diff --git a/src/mnl.c b/src/mnl.c
index 18a73e2878b6..2eea85e838fc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1629,6 +1629,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	free(dev_array);
 
+	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FLAGS,
+				cmd->flowtable->flags);
+
 	netlink_dump_flowtable(flo, ctx);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
diff --git a/src/netlink.c b/src/netlink.c
index b254753f7424..ab1afd42f60b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1342,6 +1342,8 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 						    &priority);
 	flowtable->hooknum =
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
+	flowtable->flags =
+		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FLAGS);
 
 	return flowtable;
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e14118ca971e..605eef53e544 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1892,6 +1892,10 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			{
 				$$->dev_expr = $4;
 			}
+			|	COUNTER
+			{
+				$$->flags |= NFT_FLOWTABLE_COUNTER;
+			}
 			;
 
 flowtable_expr		:	'{'	flowtable_list_expr	'}'
diff --git a/src/rule.c b/src/rule.c
index ab99bbd22616..92fa129be077 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2247,6 +2247,10 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 			nft_print(octx, ", ");
 	}
 	nft_print(octx, " }%s", opts->stmt_separator);
+
+	if (flowtable->flags & NFT_FLOWTABLE_COUNTER)
+		nft_print(octx, "%s%scounter%s", opts->tab, opts->tab,
+			  opts->stmt_separator);
 }
 
 static void do_flowtable_print(const struct flowtable *flowtable,
-- 
2.11.0

