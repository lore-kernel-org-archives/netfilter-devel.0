Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4176C433C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EEAB61A09
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhCXQUA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbhCXQTl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 12:19:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C46C6C061763
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2021 09:19:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2D136630BB
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:19:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] src: add datatype->describe()
Date:   Wed, 24 Mar 2021 17:19:32 +0100
Message-Id: <20210324161932.16387-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As an alternative to print the datatype values when no symbol table is
available. Use it to print protocols available via getprotobynumber()
which actually refers to /etc/protocols.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1503
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  1 +
 src/datatype.c     | 15 +++++++++++++++
 src/expression.c   |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 1061a389b0f0..a16f8f2bf5c4 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -164,6 +164,7 @@ struct datatype {
 	struct error_record		*(*parse)(struct parse_ctx *ctx,
 						  const struct expr *sym,
 						  struct expr **res);
+	void				(*describe)(struct output_ctx *octx);
 	const struct symbol_table	*sym_tbl;
 	unsigned int			refcnt;
 };
diff --git a/src/datatype.c b/src/datatype.c
index 7382307e9909..461ee33754b8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -619,6 +619,20 @@ static void inet_protocol_type_print(const struct expr *expr,
 	integer_type_print(expr, octx);
 }
 
+static void inet_protocol_type_describe(struct output_ctx *octx)
+{
+	struct protoent *p;
+	uint8_t protonum;
+
+	for (protonum = 0; protonum < 255; protonum++) {
+		p = getprotobynumber(protonum);
+		if (!p)
+			continue;
+
+		nft_print(octx, "\t%-30s\t%u\n", p->p_name, protonum);
+	}
+}
+
 static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
 						     const struct expr *sym,
 						     struct expr **res)
@@ -658,6 +672,7 @@ const struct datatype inet_protocol_type = {
 	.print		= inet_protocol_type_print,
 	.json		= inet_protocol_type_json,
 	.parse		= inet_protocol_type_parse,
+	.describe	= inet_protocol_type_describe,
 };
 
 static void inet_service_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/expression.c b/src/expression.c
index 0c5276d1118d..9fdf23d98446 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -172,6 +172,8 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 			nft_print(octx, "(in hexadecimal):\n");
 		symbol_table_print(edtype->sym_tbl, edtype,
 				   expr->byteorder, octx);
+	} else if (edtype->describe) {
+		edtype->describe(octx);
 	}
 }
 
-- 
2.30.2

