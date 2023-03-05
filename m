Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB8C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCEKkY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCEKkW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:40:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDAD126E6
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vYU1r4Mv7UZianIqQMxC2KKgLLjruAPfmJLzl71N9s4=; b=H2MrlhKQT+c17NdHvEuHgIRyjr
        AV+3QnkhpjzJS00TRCEqHCVX02VmzhikI//Ms9iwKeNQ2KdLm/2F3D4yHV3AirdlI3S1Hiy1MOO8f
        af/a/jSB9zOoRxTtSnBDGkB97yrx3CMAau0JcejaQlZmiZHsDmnTynjXKwTDZ2KQuY+R1QcE9G7Je
        3glmokd9D89Nm1VOPG2Iahk72O4uDjAoTXFCmL7s5ZrqRUg9+aT8GPKAvkEEgTe4nCSWVecUYSOVQ
        cN8YpUnlW7jiw5oIctWenjP1H0HNprkkbV5ClFGU4oWtby7ycWafAOrhXG0yb3AvEtOztdjsUS3Cr
        oSQoH1Tw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlmt-00DzM9-FL
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:40:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 2/3] masq: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:24:39 +0000
Message-Id: <20230305102440.2234017-3-jeremy@azazel.net>
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
to the nft_masq kernel module, so make it available in user space.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/masq.c                     | 25 +++++++++++++++++++++++--
 tests/nft-expr_masq-test.c          |  4 ++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index e118a57d4769..18d17d6368a8 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -243,6 +243,7 @@ enum {
 	NFTNL_EXPR_MASQ_FLAGS		= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_MASQ_REG_PROTO_MIN,
 	NFTNL_EXPR_MASQ_REG_PROTO_MAX,
+	NFTNL_EXPR_MASQ_REG_PROTO_BASE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5c7a47ac8746..3b86bddac67c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1453,12 +1453,14 @@ enum nft_tproxy_attributes {
  * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  * @NFTA_MASQ_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_MASQ_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_MASQ_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_masq_attributes {
 	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
 	NFTA_MASQ_REG_PROTO_MIN,
 	NFTA_MASQ_REG_PROTO_MAX,
+	NFTA_MASQ_REG_PROTO_BASE,
 	__NFTA_MASQ_MAX
 };
 #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
diff --git a/src/expr/masq.c b/src/expr/masq.c
index e6e528d9acca..be6f523ab20c 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -24,11 +24,12 @@ struct nftnl_expr_masq {
 	uint32_t		flags;
 	enum nft_registers	sreg_proto_min;
 	enum nft_registers	sreg_proto_max;
+	enum nft_registers	sreg_proto_base;
 };
 
 static int
 nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
-		       const void *data, uint32_t data_len)
+		    const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
@@ -42,6 +43,9 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
 		memcpy(&masq->sreg_proto_max, data, sizeof(masq->sreg_proto_max));
 		break;
+	case NFTNL_EXPR_MASQ_REG_PROTO_BASE:
+		memcpy(&masq->sreg_proto_base, data, sizeof(masq->sreg_proto_base));
+		break;
 	default:
 		return -1;
 	}
@@ -50,7 +54,7 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
 
 static const void *
 nftnl_expr_masq_get(const struct nftnl_expr *e, uint16_t type,
-		       uint32_t *data_len)
+		    uint32_t *data_len)
 {
 	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
 
@@ -64,6 +68,9 @@ nftnl_expr_masq_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
 		*data_len = sizeof(masq->sreg_proto_max);
 		return &masq->sreg_proto_max;
+	case NFTNL_EXPR_MASQ_REG_PROTO_BASE:
+		*data_len = sizeof(masq->sreg_proto_base);
+		return &masq->sreg_proto_base;
 	}
 	return NULL;
 }
@@ -79,6 +86,7 @@ static int nftnl_expr_masq_cb(const struct nlattr *attr, void *data)
 	switch (type) {
 	case NFTA_MASQ_REG_PROTO_MIN:
 	case NFTA_MASQ_REG_PROTO_MAX:
+	case NFTA_MASQ_REG_PROTO_BASE:
 	case NFTA_MASQ_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
@@ -102,6 +110,9 @@ nftnl_expr_masq_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX))
 		mnl_attr_put_u32(nlh, NFTA_MASQ_REG_PROTO_MAX,
 				 htobe32(masq->sreg_proto_max));
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_BASE))
+		mnl_attr_put_u32(nlh, NFTA_MASQ_REG_PROTO_BASE,
+				 htobe32(masq->sreg_proto_base));
 }
 
 static int
@@ -127,6 +138,11 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
 			be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_REG_PROTO_MAX]));
 		e->flags |= (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX);
 	}
+	if (tb[NFTA_MASQ_REG_PROTO_BASE]) {
+		masq->sreg_proto_base =
+			be32toh(mnl_attr_get_u32(tb[NFTA_MASQ_REG_PROTO_BASE]));
+		e->flags |= (1 << NFTNL_EXPR_MASQ_REG_PROTO_BASE);
+	}
 
 	return 0;
 }
@@ -147,6 +163,11 @@ static int nftnl_expr_masq_snprintf(char *buf, size_t remain,
 			       masq->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_BASE)) {
+		ret = snprintf(buf + offset, remain, "proto_base reg %u ",
+			       masq->sreg_proto_base);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
 	if (e->flags & (1 << NFTNL_EXPR_MASQ_FLAGS)) {
 		ret = snprintf(buf + offset, remain, "flags 0x%x ", masq->flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 09179149421e..2bb93c47da54 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -37,6 +37,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MASQ_REG_PROTO_MAX) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MASQ_REG_PROTO_MAX))
 		print_err("Expr NFTNL_EXPR_MASQ_REG_PROTO_MAX mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_MASQ_REG_PROTO_BASE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_MASQ_REG_PROTO_BASE))
+		print_err("Expr NFTNL_EXPR_MASQ_REG_PROTO_BASE mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -59,6 +62,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_FLAGS, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MIN, 0x5432178);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_MAX, 0x8765421);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_MASQ_REG_PROTO_BASE, 0x0f1facdb);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.39.2

