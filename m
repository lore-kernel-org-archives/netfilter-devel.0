Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F73EC2BB9A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E7A32396F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgLQQjN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:39:13 -0500
Received: from correo.us.es ([193.147.175.20]:58546 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgLQQjN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 11:39:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13252C1060
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:38:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03EC0DA844
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:38:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED896DA840; Thu, 17 Dec 2020 17:38:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87221DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:38:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 17:38:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 68DCC426CC85
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:38:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/3 libnftnl,v2] src: add NFTNL_SET_EXPRESSIONS
Date:   Thu, 17 Dec 2020 17:38:22 +0100
Message-Id: <20201217163823.24180-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201217163823.24180-1-pablo@netfilter.org>
References: <20201217163823.24180-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFTNL_SET_EXPR defines the stateful expression type that this set stores
in each element. This provides the set definition in terms of stateful
expressions. The expression that is passed via NFNTL_SET_ELEM_EXPR must
equal to this set stateful expression type, otherwise the kernel bails
out.

This patch adds support for the set expression list, which generalizes
NFTNL_SET_EXPR.

This patch also adds nftnl_set_add_expr() to add new expressions to a set
and nftnl_set_elem_expr_foreach() to iterate over the list of expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: constify first parameter of _foreach function

 include/libnftnl/set.h |   7 +++
 include/set.h          |   2 +-
 src/libnftnl.map       |   2 +
 src/set.c              | 111 +++++++++++++++++++++++++++++++++++------
 4 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 1804850dc92b..1eae024c8523 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -31,6 +31,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_HANDLE,
 	NFTNL_SET_DESC_CONCAT,
 	NFTNL_SET_EXPR,
+	NFTNL_SET_EXPRESSIONS,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
@@ -80,6 +81,12 @@ int nftnl_set_list_foreach(struct nftnl_set_list *set_list, int (*cb)(struct nft
 struct nftnl_set *nftnl_set_list_lookup_byname(struct nftnl_set_list *set_list,
 					       const char *set);
 
+struct nftnl_expr;
+void nftnl_set_add_expr(struct nftnl_set *s, struct nftnl_expr *expr);
+int nftnl_set_expr_foreach(const struct nftnl_set *s,
+			   int (*cb)(struct nftnl_expr *e, void *data),
+			   void *data);
+
 struct nftnl_set_list_iter;
 struct nftnl_set_list_iter *nftnl_set_list_iter_create(const struct nftnl_set_list *l);
 struct nftnl_set *nftnl_set_list_iter_cur(const struct nftnl_set_list_iter *iter);
diff --git a/include/set.h b/include/set.h
index 66ac129836de..55018b6b9ba9 100644
--- a/include/set.h
+++ b/include/set.h
@@ -33,7 +33,7 @@ struct nftnl_set {
 	uint32_t		flags;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
-	struct nftnl_expr	*expr;
+	struct list_head	expr_list;
 };
 
 struct nftnl_set_list;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ce1c0820de2d..7078a5d38ba8 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -376,6 +376,8 @@ LIBNFTNL_15 {
 } LIBNFTNL_14;
 
 LIBNFTNL_16 {
+  nftnl_set_add_expr;
+  nftnl_set_expr_foreach;
   nftnl_set_elem_add_expr;
   nftnl_set_elem_expr_foreach;
 } LIBNFTNL_15;
diff --git a/src/set.c b/src/set.c
index 15fa29d5f02c..8c5025d16206 100644
--- a/src/set.c
+++ b/src/set.c
@@ -37,6 +37,7 @@ struct nftnl_set *nftnl_set_alloc(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&s->element_list);
+	INIT_LIST_HEAD(&s->expr_list);
 	return s;
 }
 
@@ -44,6 +45,7 @@ EXPORT_SYMBOL(nftnl_set_free);
 void nftnl_set_free(const struct nftnl_set *s)
 {
 	struct nftnl_set_elem *elem, *tmp;
+	struct nftnl_expr *expr, *next;
 
 	if (s->flags & (1 << NFTNL_SET_TABLE))
 		xfree(s->table);
@@ -51,8 +53,9 @@ void nftnl_set_free(const struct nftnl_set *s)
 		xfree(s->name);
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		xfree(s->user.data);
-	if (s->flags & (1 << NFTNL_SET_EXPR))
-		nftnl_expr_free(s->expr);
+
+	list_for_each_entry_safe(expr, next, &s->expr_list, head)
+		nftnl_expr_free(expr);
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
 		list_del(&elem->head);
@@ -70,6 +73,8 @@ bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr)
 EXPORT_SYMBOL(nftnl_set_unset);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 {
+	struct nftnl_expr *expr, *tmp;
+
 	if (!(s->flags & (1 << attr)))
 		return;
 
@@ -99,7 +104,9 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 		xfree(s->user.data);
 		break;
 	case NFTNL_SET_EXPR:
-		nftnl_expr_free(s->expr);
+	case NFTNL_SET_EXPRESSIONS:
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+			nftnl_expr_free(expr);
 		break;
 	default:
 		return;
@@ -127,6 +134,8 @@ EXPORT_SYMBOL(nftnl_set_set_data);
 int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		       uint32_t data_len)
 {
+	struct nftnl_expr *expr, *tmp;
+
 	nftnl_assert_attr_exists(attr, NFTNL_SET_MAX);
 	nftnl_assert_validate(data, nftnl_set_validate, attr, data_len);
 
@@ -201,10 +210,11 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		s->user.len = data_len;
 		break;
 	case NFTNL_SET_EXPR:
-		if (s->flags & (1 << NFTNL_SET_EXPR))
-			nftnl_expr_free(s->expr);
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+			nftnl_expr_free(expr);
 
-		s->expr = (void *)data;
+		expr = (void *)data;
+		list_add(&expr->head, &s->expr_list);
 		break;
 	}
 	s->flags |= (1 << attr);
@@ -239,6 +249,8 @@ EXPORT_SYMBOL(nftnl_set_get_data);
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 			       uint32_t *data_len)
 {
+	struct nftnl_expr *expr;
+
 	if (!(s->flags & (1 << attr)))
 		return NULL;
 
@@ -295,7 +307,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 		*data_len = s->user.len;
 		return s->user.data;
 	case NFTNL_SET_EXPR:
-		return s->expr;
+		list_for_each_entry(expr, &s->expr_list, head)
+			break;
+		return expr;
 	}
 	return NULL;
 }
@@ -414,6 +428,8 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
 void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 {
+	int num_exprs = 0;
+
 	if (s->flags & (1 << NFTNL_SET_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_SET_TABLE, s->table);
 	if (s->flags & (1 << NFTNL_SET_NAME))
@@ -445,15 +461,55 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
-	if (s->flags & (1 << NFTNL_SET_EXPR)) {
-		struct nlattr *nest1;
-
-		nest1 = mnl_attr_nest_start(nlh, NFTA_SET_EXPR);
-		nftnl_expr_build_payload(nlh, s->expr);
-		mnl_attr_nest_end(nlh, nest1);
+	if (!list_empty(&s->expr_list)) {
+		struct nftnl_expr *expr;
+
+		list_for_each_entry(expr, &s->expr_list, head)
+			num_exprs++;
+
+		if (num_exprs == 1) {
+			struct nlattr *nest1;
+
+			nest1 = mnl_attr_nest_start(nlh, NFTA_SET_EXPR);
+			list_for_each_entry(expr, &s->expr_list, head)
+				nftnl_expr_build_payload(nlh, expr);
+
+			mnl_attr_nest_end(nlh, nest1);
+		} else if (num_exprs > 1) {
+			struct nlattr *nest1, *nest2;
+
+			nest1 = mnl_attr_nest_start(nlh, NFTA_SET_EXPRESSIONS);
+			list_for_each_entry(expr, &s->expr_list, head) {
+				nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+				nftnl_expr_build_payload(nlh, expr);
+				mnl_attr_nest_end(nlh, nest2);
+			}
+			mnl_attr_nest_end(nlh, nest1);
+		}
 	}
 }
 
+EXPORT_SYMBOL(nftnl_set_add_expr);
+void nftnl_set_add_expr(struct nftnl_set *s, struct nftnl_expr *expr)
+{
+	list_add_tail(&expr->head, &s->expr_list);
+}
+
+EXPORT_SYMBOL(nftnl_set_expr_foreach);
+int nftnl_set_expr_foreach(const struct nftnl_set *s,
+			   int (*cb)(struct nftnl_expr *e, void *data),
+			   void *data)
+{
+	struct nftnl_expr *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &s->expr_list, head) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
 
 static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -493,6 +549,8 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_SET_DESC:
+	case NFTA_SET_EXPR:
+	case NFTA_SET_EXPRESSIONS:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
@@ -578,6 +636,7 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	struct nftnl_expr *expr, *next;
 	int ret;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_set_parse_attr_cb, tb) < 0)
@@ -656,17 +715,37 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 			return ret;
 	}
 	if (tb[NFTA_SET_EXPR]) {
-		s->expr = nftnl_expr_parse(tb[NFTA_SET_EXPR]);
-		if (!s->expr)
-			return -1;
+		expr = nftnl_expr_parse(tb[NFTA_SET_EXPR]);
+		if (!expr)
+			goto out_set_expr;
 
+		list_add(&expr->head, &s->expr_list);
 		s->flags |= (1 << NFTNL_SET_EXPR);
+	} else if (tb[NFTA_SET_EXPRESSIONS]) {
+		struct nlattr *attr;
+
+		mnl_attr_for_each_nested(attr, tb[NFTA_SET_EXPRESSIONS]) {
+			if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
+				goto out_set_expr;
+
+			expr = nftnl_expr_parse(attr);
+			if (expr == NULL)
+				goto out_set_expr;
+
+			list_add_tail(&expr->head, &s->expr_list);
+		}
+		s->flags |= (1 << NFTNL_SET_EXPRESSIONS);
 	}
 
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
 
 	return 0;
+out_set_expr:
+	list_for_each_entry_safe(expr, next, &s->expr_list, head)
+		nftnl_expr_free(expr);
+
+	return -1;
 }
 
 static int nftnl_set_do_parse(struct nftnl_set *s, enum nftnl_parse_type type,
-- 
2.20.1

