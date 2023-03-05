Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812C3C6FA99
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjCEKkY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCEKkW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:40:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29386126D4
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kj8VrxY9eF2eQf73OWssH22OiZ3PUPfz6YRoOzAOA0g=; b=czyxVLfc1aOIWFQXnnPZK23uvF
        iRLWaCvSpYqPRhFgFjZCWpEwJ+CWkS6rhC/yFfugCxCWNOApwS7Bhryg6nqR1iynY99Hs+KXErxvT
        0hentbXLyVBOIBMzL8Keupjdx65xQqZ70TSdLqOzmEpZD+USSd0ZSuE4FTddYB4Y0O0jemN+BlQd8
        hV5eD+7dr4oWp0TbOyouW8gpkR2yqYA3aqhVIDhp5mdSZYv0aMKJsXO7yVeodBBNI/3wPGKXT3D7V
        FN1h1v5DQTo1KzbOO3Wkp35Eg4zWRC0kuRlvf24RcuM2MBRG0O9LV4e0loQ0lcN1a6+1SW3ZpEPi6
        SP3R79aw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlmt-00DzM9-07
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:40:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 1/3] nat: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:24:38 +0000
Message-Id: <20230305102440.2234017-2-jeremy@azazel.net>
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

Support for shifted port-ranges in DNAT was added to iptables in 2018.
This allows one to redirect packets intended for one port to another in
a range in such a way that the new port chosen has the same offset in
the range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

However, while support for this was added to the common NAT infra-
structure in the kernel, only the xt_nat module was updated to make use
of it.  This support has now also been added to the nft_nat module, so
make it available in user space.

In contrast to iptables, where shifting is only available for DNAT, both
DNAT and SNAT are supported.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/nat.c                      | 22 ++++++++++++++++++++++
 tests/nft-expr_nat-test.c           |  4 ++++
 4 files changed, 29 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 9873228dd794..e118a57d4769 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -150,6 +150,7 @@ enum {
 	NFTNL_EXPR_NAT_REG_PROTO_MIN,
 	NFTNL_EXPR_NAT_REG_PROTO_MAX,
 	NFTNL_EXPR_NAT_FLAGS,
+	NFTNL_EXPR_NAT_REG_PROTO_BASE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4608646f2103..5c7a47ac8746 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1415,6 +1415,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_NAT_REG_PROTO_BASE: source register of proto range base offset (NLA_U32: nft_registers)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -1425,6 +1426,7 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
 	NFTA_NAT_FLAGS,
+	NFTA_NAT_REG_PROTO_BASE,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/src/expr/nat.c b/src/expr/nat.c
index ca727be0cda6..6d304870d419 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -29,6 +29,7 @@ struct nftnl_expr_nat {
 	enum nft_registers sreg_addr_max;
 	enum nft_registers sreg_proto_min;
 	enum nft_registers sreg_proto_max;
+	enum nft_registers sreg_proto_base;
 	int                family;
 	enum nft_nat_types type;
 	uint32_t	   flags;
@@ -59,6 +60,9 @@ nftnl_expr_nat_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NAT_REG_PROTO_MAX:
 		memcpy(&nat->sreg_proto_max, data, sizeof(nat->sreg_proto_max));
 		break;
+	case NFTNL_EXPR_NAT_REG_PROTO_BASE:
+		memcpy(&nat->sreg_proto_base, data, sizeof(nat->sreg_proto_base));
+		break;
 	case NFTNL_EXPR_NAT_FLAGS:
 		memcpy(&nat->flags, data, sizeof(nat->flags));
 		break;
@@ -94,6 +98,9 @@ nftnl_expr_nat_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NAT_REG_PROTO_MAX:
 		*data_len = sizeof(nat->sreg_proto_max);
 		return &nat->sreg_proto_max;
+	case NFTNL_EXPR_NAT_REG_PROTO_BASE:
+		*data_len = sizeof(nat->sreg_proto_base);
+		return &nat->sreg_proto_base;
 	case NFTNL_EXPR_NAT_FLAGS:
 		*data_len = sizeof(nat->flags);
 		return &nat->flags;
@@ -116,6 +123,7 @@ static int nftnl_expr_nat_cb(const struct nlattr *attr, void *data)
 	case NFTA_NAT_REG_ADDR_MAX:
 	case NFTA_NAT_REG_PROTO_MIN:
 	case NFTA_NAT_REG_PROTO_MAX:
+	case NFTA_NAT_REG_PROTO_BASE:
 	case NFTA_NAT_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
@@ -163,6 +171,11 @@ nftnl_expr_nat_parse(struct nftnl_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_PROTO_MAX]));
 		e->flags |= (1 << NFTNL_EXPR_NAT_REG_PROTO_MAX);
 	}
+	if (tb[NFTA_NAT_REG_PROTO_BASE]) {
+		nat->sreg_proto_base =
+			ntohl(mnl_attr_get_u32(tb[NFTA_NAT_REG_PROTO_BASE]));
+		e->flags |= (1 << NFTNL_EXPR_NAT_REG_PROTO_BASE);
+	}
 	if (tb[NFTA_NAT_FLAGS]) {
 		nat->flags = ntohl(mnl_attr_get_u32(tb[NFTA_NAT_FLAGS]));
 		e->flags |= (1 << NFTNL_EXPR_NAT_FLAGS);
@@ -192,6 +205,9 @@ nftnl_expr_nat_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MAX))
 		mnl_attr_put_u32(nlh, NFTA_NAT_REG_PROTO_MAX,
 				 htonl(nat->sreg_proto_max));
+	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_BASE))
+		mnl_attr_put_u32(nlh, NFTA_NAT_REG_PROTO_BASE,
+				 htonl(nat->sreg_proto_base));
 	if (e->flags & (1 << NFTNL_EXPR_NAT_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_NAT_FLAGS, htonl(nat->flags));
 }
@@ -258,6 +274,12 @@ nftnl_expr_nat_snprintf(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
+	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_BASE)) {
+		ret = snprintf(buf + offset, remain,
+			       "proto_base reg %u ", nat->sreg_proto_base);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
 	if (e->flags & (1 << NFTNL_EXPR_NAT_FLAGS)) {
 		ret = snprintf(buf + offset, remain, "flags 0x%x ", nat->flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 3a365dd307c2..1204c4b7be62 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -49,6 +49,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_PROTO_MAX) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_PROTO_MAX))
 		print_err("Expr NFTNL_EXPR_NAT_REG_PROTO_MAX mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_REG_PROTO_BASE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_REG_PROTO_BASE))
+		print_err("Expr NFTNL_EXPR_NAT_REG_PROTO_BASE mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NAT_FLAGS) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NAT_FLAGS))
 		print_err("Expr NFTNL_EXPR_NAT_FLAGS mismatches");
@@ -77,6 +80,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MAX, 0x5134682);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MIN, 0x6124385);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MAX, 0x2153846);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_BASE, 0xbf3c0fbf);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FLAGS, 0x4213683);
 
 	nftnl_rule_add_expr(a, ex);
-- 
2.39.2

