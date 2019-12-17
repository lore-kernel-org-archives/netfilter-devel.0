Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE91EC2D0BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BACC921582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfLQRRO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:14 -0500
Received: from correo.us.es ([193.147.175.20]:37974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLQRRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C45321F0CED
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B629FDA709
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ABB6FDA702; Tue, 17 Dec 2019 18:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA294DA702;
        Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 904114265A5A;
        Tue, 17 Dec 2019 18:17:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 11/11] xfrm: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:17:02 +0100
Message-Id: <20191217171702.31493-12-pablo@netfilter.org>
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
 src/xfrm.c       | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 43d2c9f94a84..cb11cda43792 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1236,6 +1236,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_HASH: return &hash_expr_ops;
 	case EXPR_RT: return &rt_expr_ops;
 	case EXPR_FIB: return &fib_expr_ops;
+	case EXPR_XFRM: return &xfrm_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/xfrm.c b/src/xfrm.c
index 4dd53c3213f6..d0773ab789f1 100644
--- a/src/xfrm.c
+++ b/src/xfrm.c
@@ -91,6 +91,65 @@ static void xfrm_expr_clone(struct expr *new, const struct expr *expr)
 	memcpy(&new->xfrm, &expr->xfrm, sizeof(new->xfrm));
 }
 
+#define NFTNL_UDATA_XFRM_KEY 0
+#define NFTNL_UDATA_XFRM_SPNUM 1
+#define NFTNL_UDATA_XFRM_DIR 2
+#define NFTNL_UDATA_XFRM_MAX 3
+
+static int xfrm_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				 const struct expr *expr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_XFRM_KEY, expr->xfrm.key);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_XFRM_SPNUM, expr->xfrm.spnum);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_XFRM_DIR, expr->xfrm.direction);
+
+	return 0;
+}
+
+static int xfrm_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_XFRM_KEY:
+	case NFTNL_UDATA_XFRM_SPNUM:
+	case NFTNL_UDATA_XFRM_DIR:
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
+static struct expr *xfrm_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_XFRM_MAX + 1] = {};
+	uint32_t key, dir, spnum;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				xfrm_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_XFRM_KEY] ||
+	    !ud[NFTNL_UDATA_XFRM_DIR] ||
+	    !ud[NFTNL_UDATA_XFRM_SPNUM])
+		return NULL;
+
+	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_XFRM_KEY]);
+	dir = nftnl_udata_get_u32(ud[NFTNL_UDATA_XFRM_DIR]);
+	spnum = nftnl_udata_get_u32(ud[NFTNL_UDATA_XFRM_SPNUM]);
+
+	return xfrm_expr_alloc(&internal_location, dir, spnum, key);
+}
+
 const struct expr_ops xfrm_expr_ops = {
 	.type		= EXPR_XFRM,
 	.name		= "xfrm",
@@ -98,6 +157,8 @@ const struct expr_ops xfrm_expr_ops = {
 	.json		= xfrm_expr_json,
 	.cmp		= xfrm_expr_cmp,
 	.clone		= xfrm_expr_clone,
+	.parse_udata	= xfrm_expr_parse_udata,
+	.build_udata	= xfrm_expr_build_udata,
 };
 
 struct expr *xfrm_expr_alloc(const struct location *loc,
-- 
2.11.0

