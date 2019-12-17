Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40B2C47409
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF08E24655
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfLQRRP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:15 -0500
Received: from correo.us.es ([193.147.175.20]:37964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfLQRRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6BBA1F0D0A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8582DA707
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE0A2DA703; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5BBDDA709;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AA4064265A5A;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 08/11] hash: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:59 +0100
Message-Id: <20191217171702.31493-9-pablo@netfilter.org>
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
 src/hash.c       | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 1791454ea466..7cca342b2f1a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1233,6 +1233,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_OSF: return &osf_expr_ops;
 	case EXPR_CT: return &ct_expr_ops;
 	case EXPR_NUMGEN: return &numgen_expr_ops;
+	case EXPR_HASH: return &hash_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/hash.c b/src/hash.c
index 08e09099024e..42c504073ae8 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -61,6 +61,76 @@ static void hash_expr_destroy(struct expr *expr)
 	expr_free(expr->hash.expr);
 }
 
+#define NFTNL_UDATA_HASH_TYPE 0
+#define NFTNL_UDATA_HASH_OFFSET 1
+#define NFTNL_UDATA_HASH_MOD 2
+#define NFTNL_UDATA_HASH_SEED 3
+#define NFTNL_UDATA_HASH_SEED_SET 4
+#define NFTNL_UDATA_HASH_MAX 5
+
+static int hash_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				 const struct expr *expr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_HASH_TYPE, expr->hash.type);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_HASH_OFFSET, expr->hash.offset);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_HASH_MOD, expr->hash.mod);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_HASH_SEED, expr->hash.seed);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_HASH_SEED_SET, expr->hash.seed_set);
+
+	return 0;
+}
+
+static int hash_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_HASH_TYPE:
+	case NFTNL_UDATA_HASH_OFFSET:
+	case NFTNL_UDATA_HASH_SEED:
+	case NFTNL_UDATA_HASH_SEED_SET:
+	case NFTNL_UDATA_HASH_MOD:
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
+static struct expr *hash_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_HASH_MAX + 1] = {};
+	uint32_t type, seed, seed_set, mod, offset;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				hash_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_HASH_TYPE] ||
+	    !ud[NFTNL_UDATA_HASH_OFFSET] ||
+	    !ud[NFTNL_UDATA_HASH_SEED] ||
+	    !ud[NFTNL_UDATA_HASH_MOD] ||
+	    !ud[NFTNL_UDATA_HASH_SEED_SET])
+		return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_HASH_TYPE]);
+	offset = nftnl_udata_get_u32(ud[NFTNL_UDATA_HASH_OFFSET]);
+	seed = nftnl_udata_get_u32(ud[NFTNL_UDATA_HASH_SEED]);
+	seed_set = nftnl_udata_get_u32(ud[NFTNL_UDATA_HASH_SEED_SET]);
+	mod = nftnl_udata_get_u32(ud[NFTNL_UDATA_HASH_MOD]);
+
+	return hash_expr_alloc(&internal_location, mod, seed_set, seed,
+			       offset, type);
+}
+
 const struct expr_ops hash_expr_ops = {
 	.type		= EXPR_HASH,
 	.name		= "hash",
@@ -69,6 +139,8 @@ const struct expr_ops hash_expr_ops = {
 	.cmp		= hash_expr_cmp,
 	.clone		= hash_expr_clone,
 	.destroy	= hash_expr_destroy,
+	.parse_udata	= hash_expr_parse_udata,
+	.build_udata	= hash_expr_build_udata,
 };
 
 struct expr *hash_expr_alloc(const struct location *loc,
-- 
2.11.0

