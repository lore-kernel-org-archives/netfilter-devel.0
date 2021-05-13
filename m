Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599A0C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 00:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E87A613F7
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 May 2021 00:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhEMArD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 May 2021 20:47:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59988 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbhEMApE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 May 2021 20:45:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DE25F64143
        for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2021 02:43:02 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] parser_bison: add shortcut syntax for matching flags without binary operations
Date:   Thu, 13 May 2021 02:43:48 +0200
Message-Id: <20210513004348.23640-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the following shortcut syntax:

	expression flags / flags

instead of:

	expression and flags == flags

For example:

	tcp flags syn,ack / syn,ack,fin,rst
                  ^^^^^^^   ^^^^^^^^^^^^^^^
                   value         mask

instead of:

	tcp flags and (syn|ack|fin|rst) == syn|ack

The second list of comma-separated flags represents the mask which are
examined and the first list of comma-separated flags must be set.

You can also use the != operator with this syntax:

	tcp flags != fin,rst / syn,ack,fin,rst

This short is based on the prefix notation, but it is also similar to
the iptables tcp matching syntax.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
netlink delinearize code update to list this new syntax is missing in
this patch.

 src/parser_bison.y | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b50b60649d2e..0747601e551d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4469,6 +4469,34 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
 			}
+			|	expr	/* implicit */	basic_rhs_expr	SLASH	list_rhs_expr
+			{
+				struct expr *expr;
+
+				expr = binop_expr_alloc(&@$, OP_AND, $1, $4);
+				$$ = relational_expr_alloc(&@$, OP_EQ, expr, $2);
+			}
+			|	expr	/* implicit */	list_rhs_expr	SLASH	list_rhs_expr
+			{
+				struct expr *expr;
+
+				expr = binop_expr_alloc(&@$, OP_AND, $1, $4);
+				$$ = relational_expr_alloc(&@$, OP_EQ, expr, $2);
+			}
+			|	expr	relational_op	basic_rhs_expr	SLASH	list_rhs_expr
+			{
+				struct expr *expr;
+
+				expr = binop_expr_alloc(&@$, OP_AND, $1, $5);
+				$$ = relational_expr_alloc(&@$, $2, expr, $3);
+			}
+			|	expr	relational_op	list_rhs_expr	SLASH	list_rhs_expr
+			{
+				struct expr *expr;
+
+				expr = binop_expr_alloc(&@$, OP_AND, $1, $5);
+				$$ = relational_expr_alloc(&@$, $2, expr, $3);
+			}
 			|	expr	relational_op	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
-- 
2.20.1

