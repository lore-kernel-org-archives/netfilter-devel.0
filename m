Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ED9C43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 14:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642B2206F6
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 14:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbgDAOIw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 10:08:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39298 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732787AbgDAOIw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 10:08:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJe2z-0003vL-Un; Wed, 01 Apr 2020 16:08:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] concat: provide proper dtype when parsing typeof udata
Date:   Wed,  1 Apr 2020 16:08:44 +0200
Message-Id: <20200401140844.27314-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo reports following list bug:
table ip foo {
        map whitelist {
                typeof ip saddr . ip daddr : meta mark
                elements = { 0x0 [invalid type] . 0x0 [invalid type] : 0x00000001,
                             0x0 [invalid type] . 0x0 [invalid type] : 0x00000002 }
        }
}

Problem is that concat provided 'invalid' dtype.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 863cf86ec1d0..6605beb30407 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -906,8 +906,9 @@ static int concat_parse_udata_nested(const struct nftnl_udata *attr, void *data)
 static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_KEY_CONCAT_NEST_MAX] = {};
+	const struct datatype *dtype;
 	struct expr *concat_expr;
-	struct datatype *dtype;
+	uint32_t dt = 0;
 	unsigned int i;
 	int err;
 
@@ -920,8 +921,6 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 	if (!concat_expr)
 		return NULL;
 
-	dtype = xzalloc(sizeof(*dtype));
-
 	for (i = 0; i < array_size(ud); i++) {
 		const struct nftnl_udata *nest_ud[NFTNL_UDATA_SET_KEY_CONCAT_SUB_MAX];
 		const struct nftnl_udata *nested, *subdata;
@@ -948,11 +947,14 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 		if (!expr)
 			goto err_free;
 
-		dtype->subtypes++;
+		dt = concat_subtype_add(dt, expr->dtype->type);
 		compound_expr_add(concat_expr, expr);
-		dtype->size += round_up(expr->len, BITS_PER_BYTE * sizeof(uint32_t));
 	}
 
+	dtype = concat_type_alloc(dt);
+	if (!dtype)
+		goto err_free;
+
 	concat_expr->dtype = dtype;
 	concat_expr->len = dtype->size;
 
-- 
2.24.1

