Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E231FC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC5421582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfLQRRO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:14 -0500
Received: from correo.us.es ([193.147.175.20]:37966 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbfLQRRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3CDD1F0D06
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B56C6DA707
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB30BDA703; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83CEFDA70C;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6B3284265A5A;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 07/11] numgen: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:58 +0100
Message-Id: <20191217171702.31493-8-pablo@netfilter.org>
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
 src/numgen.c     | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 14bf329e25c3..1791454ea466 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1232,6 +1232,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_SOCKET: return &socket_expr_ops;
 	case EXPR_OSF: return &osf_expr_ops;
 	case EXPR_CT: return &ct_expr_ops;
+	case EXPR_NUMGEN: return &numgen_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/numgen.c b/src/numgen.c
index 8318d0a2a796..ea2b262605f7 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -51,6 +51,66 @@ static void numgen_expr_clone(struct expr *new, const struct expr *expr)
 	new->numgen.offset = expr->numgen.offset;
 }
 
+#define NFTNL_UDATA_NUMGEN_TYPE 0
+#define NFTNL_UDATA_NUMGEN_MOD 1
+#define NFTNL_UDATA_NUMGEN_OFFSET 2
+#define NFTNL_UDATA_NUMGEN_MAX 3
+
+static int numgen_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				   const struct expr *expr)
+{
+        nftnl_udata_put_u32(udbuf, NFTNL_UDATA_NUMGEN_TYPE, expr->numgen.type);
+        nftnl_udata_put_u32(udbuf, NFTNL_UDATA_NUMGEN_MOD, expr->numgen.mod);
+        nftnl_udata_put_u32(udbuf, NFTNL_UDATA_NUMGEN_OFFSET, expr->numgen.offset);
+
+        return 0;
+}
+
+static int numgen_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+        const struct nftnl_udata **ud = data;
+        uint8_t type = nftnl_udata_type(attr);
+        uint8_t len = nftnl_udata_len(attr);
+
+        switch (type) {
+        case NFTNL_UDATA_NUMGEN_TYPE:
+        case NFTNL_UDATA_NUMGEN_MOD:
+        case NFTNL_UDATA_NUMGEN_OFFSET:
+                if (len != sizeof(uint32_t))
+                        return -1;
+                break;
+        default:
+                return 0;
+        }
+
+        ud[type] = attr;
+        return 0;
+}
+
+static struct expr *numgen_expr_parse_udata(const struct nftnl_udata *attr)
+{
+        const struct nftnl_udata *ud[NFTNL_UDATA_NUMGEN_MAX + 1] = {};
+	enum nft_ng_types type;
+	uint32_t mod, offset;
+        int err;
+
+        err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+                                numgen_parse_udata, ud);
+        if (err < 0)
+                return NULL;
+
+        if (!ud[NFTNL_UDATA_NUMGEN_TYPE] ||
+	    !ud[NFTNL_UDATA_NUMGEN_MOD] ||
+	    !ud[NFTNL_UDATA_NUMGEN_OFFSET])
+                return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_NUMGEN_TYPE]);
+	mod = nftnl_udata_get_u32(ud[NFTNL_UDATA_NUMGEN_MOD]);
+	offset = nftnl_udata_get_u32(ud[NFTNL_UDATA_NUMGEN_OFFSET]);
+
+	return numgen_expr_alloc(&internal_location, type, mod, offset);
+}
+
 const struct expr_ops numgen_expr_ops = {
 	.type		= EXPR_NUMGEN,
 	.name		= "numgen",
@@ -58,6 +118,8 @@ const struct expr_ops numgen_expr_ops = {
 	.json		= numgen_expr_json,
 	.cmp		= numgen_expr_cmp,
 	.clone		= numgen_expr_clone,
+	.parse_udata	= numgen_expr_parse_udata,
+	.build_udata	= numgen_expr_build_udata,
 };
 
 struct expr *numgen_expr_alloc(const struct location *loc,
-- 
2.11.0

