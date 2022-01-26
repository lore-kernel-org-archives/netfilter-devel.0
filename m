Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A722DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiAZWdU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:33:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58146 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAZWdU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:33:20 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 92AD060256
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:30:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 1/4] optimize: add __expr_cmp()
Date:   Wed, 26 Jan 2022 23:33:11 +0100
Message-Id: <20220126223314.297735-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126223314.297735-1-pablo@netfilter.org>
References: <20220126223314.297735-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to compare expression to allow for reuse.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 98 ++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 46 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index b5fb2c4179d0..c52966a86e2c 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -33,6 +33,57 @@ struct optimize_ctx {
 	uint32_t num_rules;
 };
 
+static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
+{
+	if (expr_a->etype != expr_b->etype)
+		return false;
+
+	switch (expr_a->etype) {
+	case EXPR_PAYLOAD:
+		if (expr_a->payload.desc != expr_b->payload.desc)
+			return false;
+		if (expr_a->payload.tmpl != expr_b->payload.tmpl)
+			return false;
+		break;
+	case EXPR_EXTHDR:
+		if (expr_a->exthdr.desc != expr_b->exthdr.desc)
+			return false;
+		if (expr_a->exthdr.tmpl != expr_b->exthdr.tmpl)
+			return false;
+		break;
+	case EXPR_META:
+		if (expr_a->meta.key != expr_b->meta.key)
+			return false;
+		if (expr_a->meta.base != expr_b->meta.base)
+			return false;
+		break;
+	case EXPR_CT:
+		if (expr_a->ct.key != expr_b->ct.key)
+			return false;
+		if (expr_a->ct.base != expr_b->ct.base)
+			return false;
+		if (expr_a->ct.direction != expr_b->ct.direction)
+			return false;
+		if (expr_a->ct.nfproto != expr_b->ct.nfproto)
+			return false;
+		break;
+	case EXPR_RT:
+		if (expr_a->rt.key != expr_b->rt.key)
+			return false;
+		break;
+	case EXPR_SOCKET:
+		if (expr_a->socket.key != expr_b->socket.key)
+			return false;
+		if (expr_a->socket.level != expr_b->socket.level)
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 {
 	struct expr *expr_a, *expr_b;
@@ -45,52 +96,7 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 		expr_a = stmt_a->expr;
 		expr_b = stmt_b->expr;
 
-		if (expr_a->left->etype != expr_b->left->etype)
-			return false;
-
-		switch (expr_a->left->etype) {
-		case EXPR_PAYLOAD:
-			if (expr_a->left->payload.desc != expr_b->left->payload.desc)
-				return false;
-			if (expr_a->left->payload.tmpl != expr_b->left->payload.tmpl)
-				return false;
-			break;
-		case EXPR_EXTHDR:
-			if (expr_a->left->exthdr.desc != expr_b->left->exthdr.desc)
-				return false;
-			if (expr_a->left->exthdr.tmpl != expr_b->left->exthdr.tmpl)
-				return false;
-			break;
-		case EXPR_META:
-			if (expr_a->left->meta.key != expr_b->left->meta.key)
-				return false;
-			if (expr_a->left->meta.base != expr_b->left->meta.base)
-				return false;
-			break;
-		case EXPR_CT:
-			if (expr_a->left->ct.key != expr_b->left->ct.key)
-				return false;
-			if (expr_a->left->ct.base != expr_b->left->ct.base)
-				return false;
-			if (expr_a->left->ct.direction != expr_b->left->ct.direction)
-				return false;
-			if (expr_a->left->ct.nfproto != expr_b->left->ct.nfproto)
-				return false;
-			break;
-		case EXPR_RT:
-			if (expr_a->left->rt.key != expr_b->left->rt.key)
-				return false;
-			break;
-		case EXPR_SOCKET:
-			if (expr_a->left->socket.key != expr_b->left->socket.key)
-				return false;
-			if (expr_a->left->socket.level != expr_b->left->socket.level)
-				return false;
-			break;
-		default:
-			return false;
-		}
-		break;
+		return __expr_cmp(expr_a->left, expr_b->left);
 	case STMT_COUNTER:
 	case STMT_NOTRACK:
 		break;
-- 
2.30.2

