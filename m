Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489BBC2D0D1
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23FF721582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLQRRL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from correo.us.es ([193.147.175.20]:37916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfLQRRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D65B41C4448
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7882DA713
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD0D3DA711; Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0237DA709;
        Tue, 17 Dec 2019 18:17:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A68F64265A5A;
        Tue, 17 Dec 2019 18:17:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 01/11] meta: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:52 +0100
Message-Id: <20191217171702.31493-2-pablo@netfilter.org>
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
 src/expression.c |  4 ++--
 src/meta.c       | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index a7bbde7eec1a..a79c6f55a548 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1226,8 +1226,8 @@ const struct expr_ops *expr_ops(const struct expr *e)
 const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 {
 	switch (etype) {
-	case EXPR_PAYLOAD:
-		return &payload_expr_ops;
+	case EXPR_PAYLOAD: return &payload_expr_ops;
+	case EXPR_META: return &meta_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/meta.c b/src/meta.c
index 796d8e941486..135f84b51c55 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -807,6 +807,55 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 	}
 }
 
+#define NFTNL_UDATA_META_KEY 0
+#define NFTNL_UDATA_META_MAX 1
+
+static int meta_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				 const struct expr *expr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_META_KEY, expr->meta.key);
+
+	return 0;
+}
+
+static int meta_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_META_KEY:
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
+static struct expr *meta_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_META_MAX + 1] = {};
+	uint32_t key;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				meta_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_META_KEY])
+		return NULL;
+
+	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_META_KEY]);
+
+	return meta_expr_alloc(&internal_location, key);
+}
+
 const struct expr_ops meta_expr_ops = {
 	.type		= EXPR_META,
 	.name		= "meta",
@@ -815,6 +864,8 @@ const struct expr_ops meta_expr_ops = {
 	.cmp		= meta_expr_cmp,
 	.clone		= meta_expr_clone,
 	.pctx_update	= meta_expr_pctx_update,
+	.build_udata	= meta_expr_build_udata,
+	.parse_udata	= meta_expr_parse_udata,
 };
 
 struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
-- 
2.11.0

