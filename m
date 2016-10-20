From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: add notrack expression
Date: Thu, 20 Oct 2016 18:07:15 +0200
Message-ID: <1476979636-1314-2-git-send-email-pablo@netfilter.org>
References: <1476979636-1314-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938813AbcJTQH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 12:07:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75F1080F3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 641CCBAC26
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B836BAC2F
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 18:07:25 +0200 (CEST)
In-Reply-To: <1476979636-1314-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Register this simple expression with no attributes. Make sure libnftnl
doesn't crash when no build and parse indirections are defined, as it
is the case for this expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr.c     | 7 +++++--
 src/expr_ops.c | 5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/expr.c b/src/expr.c
index 51413ab70397..2779b3c42217 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -213,13 +213,15 @@ bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
 }
 EXPORT_SYMBOL(nftnl_expr_cmp);
 
-void
-nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
+void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
 {
 	struct nlattr *nest;
 
 	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, expr->ops->name);
 
+	if (!expr->ops->build)
+		return;
+
 	nest = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
 	expr->ops->build(nlh, expr);
 	mnl_attr_nest_end(nlh, nest);
@@ -261,6 +263,7 @@ struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr)
 		goto err1;
 
 	if (tb[NFTA_EXPR_DATA] &&
+	    expr->ops->parse &&
 	    expr->ops->parse(expr, tb[NFTA_EXPR_DATA]) < 0)
 		goto err2;
 
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 55748d64989a..96b1f8df9d3b 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -31,6 +31,10 @@ extern struct expr_ops expr_ops_target;
 extern struct expr_ops expr_ops_dynset;
 extern struct expr_ops expr_ops_hash;
 
+static struct expr_ops expr_ops_notrack = {
+	.name	= "notrack",
+};
+
 static struct expr_ops *expr_ops[] = {
 	&expr_ops_bitwise,
 	&expr_ops_byteorder,
@@ -49,6 +53,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_meta,
 	&expr_ops_ng,
 	&expr_ops_nat,
+	&expr_ops_notrack,
 	&expr_ops_payload,
 	&expr_ops_range,
 	&expr_ops_redir,
-- 
2.1.4

