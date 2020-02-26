Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D1AC4BA10
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFBA520838
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgBZM0g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 07:26:36 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33548 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgBZM0g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 07:26:36 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6vlq-0002Ye-Vk; Wed, 26 Feb 2020 13:26:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] expressions: concat: add typeof support
Date:   Wed, 26 Feb 2020 13:26:26 +0100
Message-Id: <20200226122627.27835-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous patches allow to pass concatenations as the mapped-to
data type.

This doesn't work with typeof() because the concat expression has
no support to store the typeof data in the kernel, leading to:

map t2 {
    typeof numgen inc mod 2 : ip daddr . tcp dport

being shown as
     type 0 : ipv4_addr . inet_service

... which can't be parsed back by nft.

This allows the concat expression to store the sub-expressions
in set of nested attributes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index a2694f4ab0e4..863cf86ec1d0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -829,6 +829,140 @@ static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
 	compound_expr_print(expr, " . ", octx);
 }
 
+#define NFTNL_UDATA_SET_KEY_CONCAT_NEST 0
+#define NFTNL_UDATA_SET_KEY_CONCAT_NEST_MAX  NFT_REG32_SIZE
+
+#define NFTNL_UDATA_SET_KEY_CONCAT_SUB_TYPE 0
+#define NFTNL_UDATA_SET_KEY_CONCAT_SUB_DATA 1
+#define NFTNL_UDATA_SET_KEY_CONCAT_SUB_MAX  2
+
+static int concat_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				    const struct expr *concat_expr)
+{
+	struct nftnl_udata *nest;
+	unsigned int i = 0;
+	struct expr *expr;
+
+	list_for_each_entry(expr, &concat_expr->expressions, list) {
+		struct nftnl_udata *nest_expr;
+		int err;
+
+		if (!expr_ops(expr)->build_udata || i >= NFT_REG32_SIZE)
+			return -1;
+
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_CONCAT_NEST + i);
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_CONCAT_SUB_TYPE, expr->etype);
+		nest_expr = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_CONCAT_SUB_DATA);
+		err = expr_ops(expr)->build_udata(udbuf, expr);
+		if (err < 0)
+			return err;
+		nftnl_udata_nest_end(udbuf, nest_expr);
+		nftnl_udata_nest_end(udbuf, nest);
+		i++;
+	}
+
+	return 0;
+}
+
+static int concat_parse_udata_nest(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	if (type >= NFTNL_UDATA_SET_KEY_CONCAT_NEST_MAX)
+		return -1;
+
+	if (len <= sizeof(uint32_t))
+		return -1;
+
+	ud[type] = attr;
+	return 0;
+}
+
+static int concat_parse_udata_nested(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_SET_KEY_CONCAT_SUB_TYPE:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	case NFTNL_UDATA_SET_KEY_CONCAT_SUB_DATA:
+		if (len <= sizeof(uint32_t))
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_KEY_CONCAT_NEST_MAX] = {};
+	struct expr *concat_expr;
+	struct datatype *dtype;
+	unsigned int i;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				concat_parse_udata_nest, ud);
+	if (err < 0)
+		return NULL;
+
+	concat_expr = concat_expr_alloc(&internal_location);
+	if (!concat_expr)
+		return NULL;
+
+	dtype = xzalloc(sizeof(*dtype));
+
+	for (i = 0; i < array_size(ud); i++) {
+		const struct nftnl_udata *nest_ud[NFTNL_UDATA_SET_KEY_CONCAT_SUB_MAX];
+		const struct nftnl_udata *nested, *subdata;
+		const struct expr_ops *ops;
+		struct expr *expr;
+		uint32_t etype;
+
+		if (ud[NFTNL_UDATA_SET_KEY_CONCAT_NEST + i] == NULL)
+			break;
+
+		nested = ud[NFTNL_UDATA_SET_KEY_CONCAT_NEST + i];
+		err = nftnl_udata_parse(nftnl_udata_get(nested), nftnl_udata_len(nested),
+					concat_parse_udata_nested, nest_ud);
+		if (err < 0)
+			goto err_free;
+
+		etype = nftnl_udata_get_u32(nest_ud[NFTNL_UDATA_SET_KEY_CONCAT_SUB_TYPE]);
+		ops = expr_ops_by_type(etype);
+		if (!ops || !ops->parse_udata)
+			goto err_free;
+
+		subdata = nest_ud[NFTNL_UDATA_SET_KEY_CONCAT_SUB_DATA];
+		expr = ops->parse_udata(subdata);
+		if (!expr)
+			goto err_free;
+
+		dtype->subtypes++;
+		compound_expr_add(concat_expr, expr);
+		dtype->size += round_up(expr->len, BITS_PER_BYTE * sizeof(uint32_t));
+	}
+
+	concat_expr->dtype = dtype;
+	concat_expr->len = dtype->size;
+
+	return concat_expr;
+
+err_free:
+	expr_free(concat_expr);
+	return NULL;
+}
+
 static const struct expr_ops concat_expr_ops = {
 	.type		= EXPR_CONCAT,
 	.name		= "concat",
@@ -836,6 +970,8 @@ static const struct expr_ops concat_expr_ops = {
 	.json		= concat_expr_json,
 	.clone		= compound_expr_clone,
 	.destroy	= concat_expr_destroy,
+	.build_udata	= concat_expr_build_udata,
+	.parse_udata	= concat_expr_parse_udata,
 };
 
 struct expr *concat_expr_alloc(const struct location *loc)
-- 
2.24.1

