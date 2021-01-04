Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE7CC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534022225E
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADUqi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:46:38 -0500
Received: from correo.us.es ([193.147.175.20]:46524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADUqi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 15:46:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 098F0396268
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:45:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F07D9DA72F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:45:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E62F8DA722; Mon,  4 Jan 2021 21:45:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2696DA72F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:45:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Jan 2021 21:45:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6ABFD426CC84
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:45:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: set on flags to request multi-statement support
Date:   Mon,  4 Jan 2021 21:45:48 +0100
Message-Id: <20210104204548.2635-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Old kernel reject requests for element with multiple statements because
userspace sets on the flags for multi-statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 3 +++
 src/evaluate.c                      | 8 ++++++++
 src/netlink_linearize.c             | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0b5fd5d52bb6..4ecf457f7317 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -279,6 +279,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  * @NFT_SET_CONCAT: set contains a concatenation
+ * @NFT_SET_EXPR: set contains expressions
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -289,6 +290,7 @@ enum nft_set_flags {
 	NFT_SET_EVAL			= 0x20,
 	NFT_SET_OBJECT			= 0x40,
 	NFT_SET_CONCAT			= 0x80,
+	NFT_SET_EXPR			= 0x100,
 };
 
 /**
@@ -686,6 +688,7 @@ enum nft_dynset_ops {
 
 enum nft_dynset_flags {
 	NFT_DYNSET_F_INV	= (1 << 0),
+	NFT_DYNSET_F_EXPR	= (1 << 1),
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index ab9357fa2ede..38dbc33d7826 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3671,7 +3671,9 @@ static int set_key_data_error(struct eval_ctx *ctx, const struct set *set,
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
+	unsigned int num_stmts = 0;
 	struct table *table;
+	struct stmt *stmt;
 	const char *type;
 
 	table = table_lookup_global(ctx);
@@ -3732,6 +3734,12 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (set->timeout)
 		set->flags |= NFT_SET_TIMEOUT;
 
+	list_for_each_entry(stmt, &set->stmt_list, list)
+		num_stmts++;
+
+	if (num_stmts > 1)
+		set->flags |= NFT_SET_EXPR;
+
 	if (set_is_anonymous(set->flags))
 		return 0;
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 09d0c61cfcc0..f1b3ff6940ea 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1429,6 +1429,8 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 			nftnl_expr_add_expr(nle, NFTNL_EXPR_DYNSET_EXPRESSIONS,
 					    netlink_gen_stmt_stateful(this));
 		}
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_FLAGS,
+				   NFT_DYNSET_F_EXPR);
 	}
 }
 
-- 
2.20.1

