Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121D8C2D0D2
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14E021582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLQRRR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:17 -0500
Received: from correo.us.es ([193.147.175.20]:37968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfLQRRO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B4B81F0D13
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C10CDA707
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51AB7DA703; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BA73DA714;
        Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 32B204265A5A;
        Tue, 17 Dec 2019 18:17:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 10/11] fib: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:17:01 +0100
Message-Id: <20191217171702.31493-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191217171702.31493-1-pablo@netfilter.org>
References: <20191217171702.31493-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for meta userdata area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |  1 +
 src/fib.c        | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 386309b5ca27..43d2c9f94a84 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1235,6 +1235,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_NUMGEN: return &numgen_expr_ops;
 	case EXPR_HASH: return &hash_expr_ops;
 	case EXPR_RT: return &rt_expr_ops;
+	case EXPR_FIB: return &fib_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/fib.c b/src/fib.c
index f2bfef1deda1..c6ad0f9c5d15 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -1,7 +1,7 @@
 /*
  * FIB expression.
  *
- * Copyright (c) Red Hat GmbH.  Author: Florian Westphal <fw@strlen.de>
+ * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -91,7 +91,7 @@ static void fib_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return  e1->fib.result == e2->fib.result &&
+	return	e1->fib.result == e2->fib.result &&
 		e1->fib.flags == e2->fib.flags;
 }
 
@@ -101,6 +101,60 @@ static void fib_expr_clone(struct expr *new, const struct expr *expr)
 	new->fib.flags= expr->fib.flags;
 }
 
+#define NFTNL_UDATA_FIB_RESULT 0
+#define NFTNL_UDATA_FIB_FLAGS 1
+#define NFTNL_UDATA_FIB_MAX 2
+
+static int fib_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				 const struct expr *expr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_FIB_RESULT, expr->fib.result);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_FIB_FLAGS, expr->fib.flags);
+
+	return 0;
+}
+
+static int fib_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_FIB_RESULT:
+	case NFTNL_UDATA_FIB_FLAGS:
+		if (len != sizeof(uint32_t))
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
+static struct expr *fib_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_FIB_MAX + 1] = {};
+	uint32_t flags, result;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				fib_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_FIB_RESULT] ||
+	    !ud[NFTNL_UDATA_FIB_FLAGS])
+		return NULL;
+
+	result = nftnl_udata_get_u32(ud[NFTNL_UDATA_FIB_RESULT]);
+	flags = nftnl_udata_get_u32(ud[NFTNL_UDATA_FIB_FLAGS]);
+
+	return fib_expr_alloc(&internal_location, flags, result);
+}
+
 const struct expr_ops fib_expr_ops = {
 	.type		= EXPR_FIB,
 	.name		= "fib",
@@ -108,6 +162,8 @@ const struct expr_ops fib_expr_ops = {
 	.json		= fib_expr_json,
 	.cmp		= fib_expr_cmp,
 	.clone		= fib_expr_clone,
+	.parse_udata	= fib_expr_parse_udata,
+	.build_udata	= fib_expr_build_udata,
 };
 
 struct expr *fib_expr_alloc(const struct location *loc,
-- 
2.11.0

