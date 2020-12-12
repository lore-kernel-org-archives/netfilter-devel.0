Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD35C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 19:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFD8E22B30
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 19:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439851AbgLLTTX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:19:23 -0500
Received: from correo.us.es ([193.147.175.20]:46198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgLLTTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Dec 2020 14:19:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CF301C4381
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 20:18:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AC07DA722
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 20:18:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 00736DA704; Sat, 12 Dec 2020 20:18:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B47CADA730
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 20:18:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 12 Dec 2020 20:18:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9E38C4265A5A
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 20:18:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 3/3] src: add NFTNL_EXPR_DYNSET_EXPRESSIONS
Date:   Sat, 12 Dec 2020 20:18:32 +0100
Message-Id: <20201212191832.27781-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212191832.27781-1-pablo@netfilter.org>
References: <20201212191832.27781-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFTNL_EXPR_DYNSET_EXPR defines the stateful expression type that
an element stores when added from the packet path.

This patch adds support for the set expression list, which generalizes
NFTNL_EXPR_DYNSET_EXPR.

This patch also adds nftnl_expr_add_expr() to add new expressions to
elements and nftnl_set_expr_expr_foreach() to iterate over the list of
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expr_ops.h      |   1 +
 include/libnftnl/expr.h |   7 +++
 src/expr.c              |   3 ++
 src/expr/dynset.c       | 111 +++++++++++++++++++++++++++++++++++-----
 src/libnftnl.map        |   2 +
 5 files changed, 110 insertions(+), 14 deletions(-)

diff --git a/include/expr_ops.h b/include/expr_ops.h
index a7f1b9a6abfd..5237ac791588 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -12,6 +12,7 @@ struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
 	int	max_attr;
+	void	(*init)(const struct nftnl_expr *e);
 	void	(*free)(const struct nftnl_expr *e);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index c2b2d8644bcd..14cfc858a76e 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -38,6 +38,12 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
 
 void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr);
 
+/* For dynset expressions. */
+void nftnl_expr_add_expr(struct nftnl_expr *expr, uint32_t type, struct nftnl_expr *e);
+int nftnl_expr_expr_foreach(struct nftnl_expr *e,
+			    int (*cb)(struct nftnl_expr *e, void *data),
+			    void *data);
+
 int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
@@ -167,6 +173,7 @@ enum {
 	NFTNL_EXPR_DYNSET_SET_NAME,
 	NFTNL_EXPR_DYNSET_SET_ID,
 	NFTNL_EXPR_DYNSET_EXPR,
+	NFTNL_EXPR_DYNSET_EXPRESSIONS,
 };
 
 enum {
diff --git a/src/expr.c b/src/expr.c
index ed2f60e1429f..8e0bce2643b1 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -42,6 +42,9 @@ struct nftnl_expr *nftnl_expr_alloc(const char *name)
 	expr->flags |= (1 << NFTNL_EXPR_NAME);
 	expr->ops = ops;
 
+	if (ops->init)
+		ops->init(expr);
+
 	return expr;
 }
 
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 91dbea930715..24ac1366c7b2 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -26,7 +26,7 @@ struct nftnl_expr_dynset {
 	enum nft_registers	sreg_data;
 	enum nft_dynset_ops	op;
 	uint64_t		timeout;
-	struct nftnl_expr	*expr;
+	struct list_head	expr_list;
 	char			*set_name;
 	uint32_t		set_id;
 };
@@ -36,6 +36,7 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 			 const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+	struct nftnl_expr *expr, *next;
 
 	switch (type) {
 	case NFTNL_EXPR_DYNSET_SREG_KEY:
@@ -59,7 +60,11 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&dynset->set_id, data, sizeof(dynset->set_id));
 		break;
 	case NFTNL_EXPR_DYNSET_EXPR:
-		dynset->expr = (void *)data;
+		list_for_each_entry_safe(expr, next, &dynset->expr_list, head)
+			nftnl_expr_free(expr);
+
+		expr = (void *)data;
+		list_add(&expr->head, &dynset->expr_list);
 		break;
 	default:
 		return -1;
@@ -72,6 +77,7 @@ nftnl_expr_dynset_get(const struct nftnl_expr *e, uint16_t type,
 			 uint32_t *data_len)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+	struct nftnl_expr *expr;
 
 	switch (type) {
 	case NFTNL_EXPR_DYNSET_SREG_KEY:
@@ -93,7 +99,9 @@ nftnl_expr_dynset_get(const struct nftnl_expr *e, uint16_t type,
 		*data_len = sizeof(dynset->set_id);
 		return &dynset->set_id;
 	case NFTNL_EXPR_DYNSET_EXPR:
-		return dynset->expr;
+		list_for_each_entry(expr, &dynset->expr_list, head)
+			break;
+		return expr;
 	}
 	return NULL;
 }
@@ -137,6 +145,7 @@ nftnl_expr_dynset_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nlattr *nest;
+	int num_exprs = 0;
 
 	if (e->flags & (1 << NFTNL_EXPR_DYNSET_SREG_KEY))
 		mnl_attr_put_u32(nlh, NFTA_DYNSET_SREG_KEY, htonl(dynset->sreg_key));
@@ -150,11 +159,55 @@ nftnl_expr_dynset_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_strz(nlh, NFTA_DYNSET_SET_NAME, dynset->set_name);
 	if (e->flags & (1 << NFTNL_EXPR_DYNSET_SET_ID))
 		mnl_attr_put_u32(nlh, NFTA_DYNSET_SET_ID, htonl(dynset->set_id));
-	if (e->flags & (1 << NFTNL_EXPR_DYNSET_EXPR)) {
-		nest = mnl_attr_nest_start(nlh, NFTA_DYNSET_EXPR);
-		nftnl_expr_build_payload(nlh, dynset->expr);
-		mnl_attr_nest_end(nlh, nest);
+	if (!list_empty(&dynset->expr_list)) {
+		struct nftnl_expr *expr;
+
+		list_for_each_entry(expr, &dynset->expr_list, head)
+			num_exprs++;
+
+		if (num_exprs == 1) {
+			nest = mnl_attr_nest_start(nlh, NFTA_DYNSET_EXPR);
+			list_for_each_entry(expr, &dynset->expr_list, head)
+				nftnl_expr_build_payload(nlh, expr);
+			mnl_attr_nest_end(nlh, nest);
+		} else if (num_exprs > 1) {
+			struct nlattr *nest1, *nest2;
+
+			nest1 = mnl_attr_nest_start(nlh, NFTA_DYNSET_EXPRESSIONS);
+			list_for_each_entry(expr, &dynset->expr_list, head) {
+				nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+				nftnl_expr_build_payload(nlh, expr);
+				mnl_attr_nest_end(nlh, nest2);
+			}
+			mnl_attr_nest_end(nlh, nest1);
+		}
+	}
+}
+
+EXPORT_SYMBOL(nftnl_expr_add_expr);
+void nftnl_expr_add_expr(struct nftnl_expr *e, uint32_t type,
+			 struct nftnl_expr *expr)
+{
+	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+
+	list_add_tail(&expr->head, &dynset->expr_list);
+}
+
+EXPORT_SYMBOL(nftnl_expr_expr_foreach);
+int nftnl_expr_expr_foreach(struct nftnl_expr *e,
+			   int (*cb)(struct nftnl_expr *e, void *data),
+			   void *data)
+{
+	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+	struct nftnl_expr *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &dynset->expr_list, head) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
 	}
+	return 0;
 }
 
 static int
@@ -162,6 +215,7 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
+	struct nftnl_expr *expr, *next;
 	int ret = 0;
 
 	if (mnl_attr_parse_nested(attr, nftnl_expr_dynset_cb, tb) < 0)
@@ -195,13 +249,34 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_SET_ID);
 	}
 	if (tb[NFTA_DYNSET_EXPR]) {
-		e->flags |= (1 << NFTNL_EXPR_DYNSET_EXPR);
-		dynset->expr = nftnl_expr_parse(tb[NFTA_DYNSET_EXPR]);
-		if (dynset->expr == NULL)
+		expr = nftnl_expr_parse(tb[NFTA_DYNSET_EXPR]);
+		if (expr == NULL)
 			return -1;
+
+		list_add(&expr->head, &dynset->expr_list);
+		e->flags |= (1 << NFTNL_EXPR_DYNSET_EXPR);
+	} else if (tb[NFTA_DYNSET_EXPRESSIONS]) {
+		struct nlattr *attr2;
+
+		mnl_attr_for_each_nested(attr2, tb[NFTA_DYNSET_EXPRESSIONS]) {
+			if (mnl_attr_get_type(attr2) != NFTA_LIST_ELEM)
+				goto out_dynset_expr;
+
+			expr = nftnl_expr_parse(attr2);
+			if (!expr)
+				goto out_dynset_expr;
+
+			list_add_tail(&expr->head, &dynset->expr_list);
+		}
+		e->flags |= (1 << NFTNL_EXPR_DYNSET_EXPRESSIONS);
 	}
 
 	return ret;
+out_dynset_expr:
+	list_for_each_entry_safe(expr, next, &dynset->expr_list, head)
+		nftnl_expr_free(expr);
+
+	return -1;
 }
 
 static const char *op2str_array[] = {
@@ -239,8 +314,7 @@ nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
 			       dynset->timeout);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
-	if (e->flags & (1 << NFTNL_EXPR_DYNSET_EXPR)) {
-		expr = dynset->expr;
+	list_for_each_entry(expr, &dynset->expr_list, head) {
 		ret = snprintf(buf + offset, remain, "expr [ %s ",
 			       expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -272,19 +346,28 @@ nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static void nftnl_expr_dynset_init(const struct nftnl_expr *e)
+{
+	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+
+	INIT_LIST_HEAD(&dynset->expr_list);
+}
+
 static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
+	struct nftnl_expr *expr, *next;
 
 	xfree(dynset->set_name);
-	if (dynset->expr)
-		nftnl_expr_free(dynset->expr);
+	list_for_each_entry_safe(expr, next, &dynset->expr_list, head)
+		nftnl_expr_free(expr);
 }
 
 struct expr_ops expr_ops_dynset = {
 	.name		= "dynset",
 	.alloc_len	= sizeof(struct nftnl_expr_dynset),
 	.max_attr	= NFTA_DYNSET_MAX,
+	.init		= nftnl_expr_dynset_init,
 	.free		= nftnl_expr_dynset_free,
 	.set		= nftnl_expr_dynset_set,
 	.get		= nftnl_expr_dynset_get,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7078a5d38ba8..e707b89cfdfd 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -380,4 +380,6 @@ LIBNFTNL_16 {
   nftnl_set_expr_foreach;
   nftnl_set_elem_add_expr;
   nftnl_set_elem_expr_foreach;
+  nftnl_expr_add_expr;
+  nftnl_expr_expr_foreach;
 } LIBNFTNL_15;
-- 
2.20.1

