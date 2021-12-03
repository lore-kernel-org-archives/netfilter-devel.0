Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EB0C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 16:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381985AbhLCQLf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381980AbhLCQLe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 11:11:34 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124B6C061751
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 08:08:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mtB6W-00027A-Gn; Fri, 03 Dec 2021 17:08:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] exthdr: support ip/tcp options and sctp chunks in typeof expressions
Date:   Fri,  3 Dec 2021 17:07:54 +0100
Message-Id: <20211203160755.8720-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203160755.8720-1-fw@strlen.de>
References: <20211203160755.8720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This did not store the 'op' member and listing always treated this as ipv6
extension header.

Add test cases for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/exthdr.c                                  | 47 ++++++++++++++++---
 .../testcases/sets/dumps/typeof_sets_0.nft    | 27 +++++++++++
 tests/shell/testcases/sets/typeof_sets_0      | 27 +++++++++++
 3 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 2357ab60648d..3e5f5cd8b73e 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -115,7 +115,8 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 
 #define NFTNL_UDATA_EXTHDR_DESC 0
 #define NFTNL_UDATA_EXTHDR_TYPE 1
-#define NFTNL_UDATA_EXTHDR_MAX 2
+#define NFTNL_UDATA_EXTHDR_OP	2
+#define NFTNL_UDATA_EXTHDR_MAX 3
 
 static int exthdr_parse_udata(const struct nftnl_udata *attr, void *data)
 {
@@ -126,6 +127,7 @@ static int exthdr_parse_udata(const struct nftnl_udata *attr, void *data)
 	switch (type) {
 	case NFTNL_UDATA_EXTHDR_DESC:
 	case NFTNL_UDATA_EXTHDR_TYPE:
+	case NFTNL_UDATA_EXTHDR_OP:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -140,6 +142,7 @@ static int exthdr_parse_udata(const struct nftnl_udata *attr, void *data)
 static struct expr *exthdr_expr_parse_udata(const struct nftnl_udata *attr)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_EXTHDR_MAX + 1] = {};
+	enum nft_exthdr_op op = NFT_EXTHDR_OP_IPV6;
 	const struct exthdr_desc *desc;
 	unsigned int type;
 	uint32_t desc_id;
@@ -154,14 +157,31 @@ static struct expr *exthdr_expr_parse_udata(const struct nftnl_udata *attr)
 	    !ud[NFTNL_UDATA_EXTHDR_TYPE])
 		return NULL;
 
-	desc_id = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_DESC]);
-	desc = exthdr_find_desc(desc_id);
-	if (!desc)
-		return NULL;
+	if (ud[NFTNL_UDATA_EXTHDR_OP])
+		op = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_OP]);
 
+	desc_id = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_DESC]);
 	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXTHDR_TYPE]);
 
-	return exthdr_expr_alloc(&internal_location, desc, type);
+	switch (op) {
+	case NFT_EXTHDR_OP_IPV6:
+		desc = exthdr_find_desc(desc_id);
+
+		return exthdr_expr_alloc(&internal_location, desc, type);
+	case NFT_EXTHDR_OP_TCPOPT:
+		return tcpopt_expr_alloc(&internal_location,
+					 desc_id, type);
+	case NFT_EXTHDR_OP_IPV4:
+		return ipopt_expr_alloc(&internal_location,
+					 desc_id, type);
+	case NFT_EXTHDR_OP_SCTP:
+		return sctp_chunk_expr_alloc(&internal_location,
+					     desc_id, type);
+	case __NFT_EXTHDR_OP_MAX:
+		return NULL;
+	}
+
+	return NULL;
 }
 
 static unsigned int expr_exthdr_type(const struct exthdr_desc *desc,
@@ -176,9 +196,22 @@ static int exthdr_expr_build_udata(struct nftnl_udata_buf *udbuf,
 	const struct proto_hdr_template *tmpl = expr->exthdr.tmpl;
 	const struct exthdr_desc *desc = expr->exthdr.desc;
 	unsigned int type = expr_exthdr_type(desc, tmpl);
+	enum nft_exthdr_op op = expr->exthdr.op;
 
-	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_DESC, desc->id);
 	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_TYPE, type);
+	switch (op) {
+	case NFT_EXTHDR_OP_IPV6:
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_DESC, desc->id);
+		break;
+	case NFT_EXTHDR_OP_TCPOPT:
+	case NFT_EXTHDR_OP_IPV4:
+	case NFT_EXTHDR_OP_SCTP:
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_OP, op);
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXTHDR_DESC, expr->exthdr.raw_type);
+		break;
+	default:
+		return -1;
+	}
 
 	return 0;
 }
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 06d891e682b7..8f11b110552c 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -19,6 +19,21 @@ table inet t {
 		elements = { 1, 1024 }
 	}
 
+	set s5 {
+		typeof ip option ra value
+		elements = { 1, 1024 }
+	}
+
+	set s6 {
+		typeof tcp option maxseg size
+		elements = { 1, 1024 }
+	}
+
+	set s7 {
+		typeof sctp chunk init num-inbound-streams
+		elements = { 1, 4 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -26,4 +41,16 @@ table inet t {
 	chain c2 {
 		vlan id @s2 accept
 	}
+
+	chain c5 {
+		ip option ra value @s5 accept
+	}
+
+	chain c6 {
+		tcp option maxseg size @s6 accept
+	}
+
+	chain c7 {
+		sctp chunk init num-inbound-streams @s7 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index a6ff8ca772e2..1e99e2987733 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -25,6 +25,21 @@ EXPECTED="table inet t {
 		elements = { 1, 1024 }
 	}
 
+	set s5 {
+		typeof ip option ra value
+		elements = { 1, 1024 }
+	}
+
+	set s6 {
+		typeof tcp option maxseg size
+		elements = { 1, 1024 }
+	}
+
+	set s7 {
+		typeof sctp chunk init num-inbound-streams
+		elements = { 1, 4 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -32,6 +47,18 @@ EXPECTED="table inet t {
 	chain c2 {
 		ether type vlan vlan id @s2 accept
 	}
+
+	chain c5 {
+		ip option ra value @s5 accept
+	}
+
+	chain c6 {
+		tcp option maxseg size @s6 accept
+	}
+
+	chain c7 {
+		sctp chunk init num-inbound-streams @s7 accept
+	}
 }"
 
 set -e
-- 
2.32.0

