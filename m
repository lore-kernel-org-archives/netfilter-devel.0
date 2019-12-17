Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722CCC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D2D324655
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfLQRRQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:16 -0500
Received: from correo.us.es ([193.147.175.20]:37952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfLQRRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66A481F0CF9
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59A0DDA70E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F4A1DA70D; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4889ADA707;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2F8044265A5A;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 06/11] ct: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:57 +0100
Message-Id: <20191217171702.31493-7-pablo@netfilter.org>
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
 src/ct.c         | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/expression.c |  1 +
 2 files changed, 57 insertions(+)

diff --git a/src/ct.c b/src/ct.c
index 9e6a8351ffb2..db1dabd319e9 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -367,6 +367,60 @@ static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
 	proto_ctx_update(ctx, left->ct.base + 1, &expr->location, desc);
 }
 
+#define NFTNL_UDATA_CT_KEY 0
+#define NFTNL_UDATA_CT_DIR 1
+#define NFTNL_UDATA_CT_MAX 2
+
+static int ct_expr_build_udata(struct nftnl_udata_buf *udbuf,
+			       const struct expr *expr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_CT_KEY, expr->ct.key);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_CT_DIR, expr->ct.direction);
+
+	return 0;
+}
+
+static int ct_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_CT_KEY:
+	case NFTNL_UDATA_CT_DIR:
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
+static struct expr *ct_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_CT_MAX + 1] = {};
+	uint32_t key, dir;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				ct_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_CT_KEY] ||
+	    !ud[NFTNL_UDATA_CT_DIR])
+		return NULL;
+
+	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_CT_KEY]);
+	dir = nftnl_udata_get_u32(ud[NFTNL_UDATA_CT_DIR]);
+
+	return ct_expr_alloc(&internal_location, key, dir);
+}
+
 const struct expr_ops ct_expr_ops = {
 	.type		= EXPR_CT,
 	.name		= "ct",
@@ -375,6 +429,8 @@ const struct expr_ops ct_expr_ops = {
 	.cmp		= ct_expr_cmp,
 	.clone		= ct_expr_clone,
 	.pctx_update	= ct_expr_pctx_update,
+	.parse_udata	= ct_expr_parse_udata,
+	.build_udata	= ct_expr_build_udata,
 };
 
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
diff --git a/src/expression.c b/src/expression.c
index 7d198222c90b..14bf329e25c3 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1231,6 +1231,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_META: return &meta_expr_ops;
 	case EXPR_SOCKET: return &socket_expr_ops;
 	case EXPR_OSF: return &osf_expr_ops;
+	case EXPR_CT: return &ct_expr_ops;
 	default:
 		break;
 	}
-- 
2.11.0

