Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFB9C6FA9E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjCEKkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCEKkX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:40:23 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39340B759
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MMacNT3oeRRv0QFKrDrtEjKZ51ic+XUiBp41ecy+/uo=; b=NOfTaedp7PYlbnG+UcBIqm1kTW
        k60hl/hIUN+d5hCpOVD5qXXNWw/vvqlxZmA4r/sXUnjMnMdtXk9lsyztTEnJeZrf3JzlqtfbBN0Ov
        Pnr6g+DdXjJ7pIcriIXTRG5L60iWdoK7BFy17IrUukPUzeeMa1vHd4kH0O8r7itaEMqF9Zzz14yhK
        7QKVU8AedT05A1kLKUO5/Gk8DwUqgf2rcFoJ3o6/jenkYMNMGHU2VZPvzrywawOhGcgKVCB/dVgn1
        dfagVU5rUXMvP+OSyZVlQBKvzeECDMMX0VWl4jMIaZrqM5qzJMNBjCk2b5youUDewFJQ4RHsQG/PW
        /6cDh+SQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlmt-00DzM9-VP
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:40:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 3/3] redir: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:24:40 +0000
Message-Id: <20230305102440.2234017-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305102440.2234017-1-jeremy@azazel.net>
References: <20230305102440.2234017-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for using shift port-ranges when masquerading has now been added
to the nft_redir kernel module, so make it available in user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/redir.c                    | 29 ++++++++++++++++++++++++-----
 tests/nft-expr_redir-test.c         |  4 ++++
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 18d17d6368a8..f3ff4fde046c 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -250,6 +250,7 @@ enum {
 	NFTNL_EXPR_REDIR_REG_PROTO_MIN	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_REDIR_REG_PROTO_MAX,
 	NFTNL_EXPR_REDIR_FLAGS,
+	NFTNL_EXPR_REDIR_REG_PROTO_BASE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 3b86bddac67c..5a6814fcf191 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1471,12 +1471,14 @@ enum nft_masq_attributes {
  * @NFTA_REDIR_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_REDIR_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  * @NFTA_REDIR_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_REDIR_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_redir_attributes {
 	NFTA_REDIR_UNSPEC,
 	NFTA_REDIR_REG_PROTO_MIN,
 	NFTA_REDIR_REG_PROTO_MAX,
 	NFTA_REDIR_FLAGS,
+	NFTA_REDIR_REG_PROTO_BASE,
 	__NFTA_REDIR_MAX
 };
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 87c2accb923f..595397da3d4c 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -23,12 +23,13 @@
 struct nftnl_expr_redir {
 	enum nft_registers sreg_proto_min;
 	enum nft_registers sreg_proto_max;
-	uint32_t	flags;
+	enum nft_registers sreg_proto_base;
+	uint32_t           flags;
 };
 
 static int
 nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
-			const void *data, uint32_t data_len)
+		     const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
@@ -39,6 +40,9 @@ nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_REDIR_REG_PROTO_MAX:
 		memcpy(&redir->sreg_proto_max, data, sizeof(redir->sreg_proto_max));
 		break;
+	case NFTNL_EXPR_REDIR_REG_PROTO_BASE:
+		memcpy(&redir->sreg_proto_base, data, sizeof(redir->sreg_proto_base));
+		break;
 	case NFTNL_EXPR_REDIR_FLAGS:
 		memcpy(&redir->flags, data, sizeof(redir->flags));
 		break;
@@ -50,7 +54,7 @@ nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
 
 static const void *
 nftnl_expr_redir_get(const struct nftnl_expr *e, uint16_t type,
-			uint32_t *data_len)
+		     uint32_t *data_len)
 {
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
@@ -61,6 +65,9 @@ nftnl_expr_redir_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_REDIR_REG_PROTO_MAX:
 		*data_len = sizeof(redir->sreg_proto_max);
 		return &redir->sreg_proto_max;
+	case NFTNL_EXPR_REDIR_REG_PROTO_BASE:
+		*data_len = sizeof(redir->sreg_proto_base);
+		return &redir->sreg_proto_base;
 	case NFTNL_EXPR_REDIR_FLAGS:
 		*data_len = sizeof(redir->flags);
 		return &redir->flags;
@@ -79,6 +86,7 @@ static int nftnl_expr_redir_cb(const struct nlattr *attr, void *data)
 	switch (type) {
 	case NFTA_REDIR_REG_PROTO_MIN:
 	case NFTA_REDIR_REG_PROTO_MAX:
+	case NFTA_REDIR_REG_PROTO_BASE:
 	case NFTA_REDIR_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
@@ -100,6 +108,9 @@ nftnl_expr_redir_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	if (e->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_MAX))
 		mnl_attr_put_u32(nlh, NFTA_REDIR_REG_PROTO_MAX,
 				 htobe32(redir->sreg_proto_max));
+	if (e->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_BASE))
+		mnl_attr_put_u32(nlh, NFTA_REDIR_REG_PROTO_BASE,
+				 htobe32(redir->sreg_proto_base));
 	if (e->flags & (1 << NFTNL_EXPR_REDIR_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_REDIR_FLAGS, htobe32(redir->flags));
 }
@@ -123,6 +134,11 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_REDIR_REG_PROTO_MAX]));
 		e->flags |= (1 << NFTNL_EXPR_REDIR_REG_PROTO_MAX);
 	}
+	if (tb[NFTA_REDIR_REG_PROTO_BASE]) {
+		redir->sreg_proto_base =
+			ntohl(mnl_attr_get_u32(tb[NFTA_REDIR_REG_PROTO_BASE]));
+		e->flags |= (1 << NFTNL_EXPR_REDIR_REG_PROTO_BASE);
+	}
 	if (tb[NFTA_REDIR_FLAGS]) {
 		redir->flags = be32toh(mnl_attr_get_u32(tb[NFTA_REDIR_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_REDIR_FLAGS);
@@ -143,13 +159,16 @@ nftnl_expr_redir_snprintf(char *buf, size_t remain,
 			       redir->sreg_proto_min);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
-
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MAX)) {
 		ret = snprintf(buf + offset, remain, "proto_max reg %u ",
 			       redir->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
-
+	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_BASE)) {
+		ret = snprintf(buf + offset, remain, "proto_base reg %u ",
+			       redir->sreg_proto_base);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_FLAGS)) {
 		ret = snprintf(buf + offset, remain, "flags 0x%x ",
 			       redir->flags);
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 8e1f30c43332..fc20e74e0196 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -34,6 +34,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_REG_PROTO_MAX) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_REG_PROTO_MAX))
 		print_err("Expr NFTNL_EXPR_REDIR_REG_PROTO_MAX mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_REG_PROTO_BASE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_REG_PROTO_BASE))
+		print_err("Expr NFTNL_EXPR_REDIR_REG_PROTO_BASE mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_REDIR_FLAGS) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_REDIR_FLAGS))
 		print_err("Expr NFTNL_EXPR_REDIR_FLAGS mismatches");
@@ -58,6 +61,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MIN, 0x12345678);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_MAX, 0x56781234);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_REG_PROTO_BASE, 0x14e4cd3c);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_REDIR_FLAGS, 0x12003400);
 
 	nftnl_rule_add_expr(a, ex);
-- 
2.39.2

