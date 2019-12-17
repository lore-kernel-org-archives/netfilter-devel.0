Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C3CC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD1621582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfLQRRM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:12 -0500
Received: from correo.us.es ([193.147.175.20]:37932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfLQRRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CB8F1C4434
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F929DA711
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85666DA702; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C810DA70D;
        Tue, 17 Dec 2019 18:17:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 62D674265A5A;
        Tue, 17 Dec 2019 18:17:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 03/11] exthdr: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:54 +0100
Message-Id: <20191217171702.31493-4-pablo@netfilter.org>
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
 src/exthdr.c     | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index a79c6f55a548..847c88ee82c5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1227,6 +1227,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 {
 	switch (etype) {
 	case EXPR_PAYLOAD: return &payload_expr_ops;
+	case EXPR_EXTHDR: return &exthdr_expr_ops;
 	case EXPR_META: return &meta_expr_ops;
 	default:
 		break;
diff --git a/src/exthdr.c b/src/exthdr.c
index 925b52329003..0b23e0d38b91 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -91,6 +91,78 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 	new->exthdr.flags = expr->exthdr.flags;
 }
 
+#define NFTNL_UDATA_EXTHDR_DESC 0
+#define NFTNL_UDATA_EXTHDR_TYPE 1
+#define NFTNL_UDATA_EXTHDR_MAX 2
+
+static int exthdr_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_EXTHDR_DESC:
+	case NFTNL_UDATA_EXTHDR_TYPE:
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
+static struct expr *exthdr_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_EXTHDR_MAX + 1] = {};
+	const struct exthdr_desc *desc;
+	unsigned int type;
+	uint32_t desc_id;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				exthdr_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_EXTHDR_DESC] ||
+	    !ud[NFTNL_UDATA_EXTHDR_TYPE])
+		return NULL;
+
+	desc_id = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_DESC]);
+	desc = exthdr_find_desc(desc_id);
+	if (!desc)
+		return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_TYPE]);
+
+	return exthdr_expr_alloc(&internal_location, desc, type);
+}
+
+static unsigned int expr_exthdr_type(const struct exthdr_desc *desc,
+				     const struct proto_hdr_template *tmpl)
+{
+	unsigned int offset = (unsigned int)(tmpl - &desc->templates[0]);
+
+	return offset / sizeof(*tmpl);
+}
+
+static int exthdr_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				   const struct expr *expr)
+{
+	const struct proto_hdr_template *tmpl = expr->exthdr.tmpl;
+	const struct exthdr_desc *desc = expr->exthdr.desc;
+	unsigned int type = expr_exthdr_type(desc, tmpl);
+
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_DESC, desc->id);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_TYPE, type);
+
+	return 0;
+}
+
 const struct expr_ops exthdr_expr_ops = {
 	.type		= EXPR_EXTHDR,
 	.name		= "exthdr",
@@ -98,6 +170,8 @@ const struct expr_ops exthdr_expr_ops = {
 	.json		= exthdr_expr_json,
 	.cmp		= exthdr_expr_cmp,
 	.clone		= exthdr_expr_clone,
+	.build_udata	= exthdr_expr_build_udata,
+	.parse_udata	= exthdr_expr_parse_udata,
 };
 
 static const struct proto_hdr_template exthdr_unknown_template =
-- 
2.11.0

