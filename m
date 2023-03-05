Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04519C61DA4
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjCEKaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD5E900C
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CErKrx80nW6nlUapumUtoe3qAi050NiZWuSGRUiN4mU=; b=N7z3ruA3b1eRwcjKOJOpI2uBmX
        Z4J2DMJ7DD5MprUhnyXmPYf2Umtv1FcNXKg/+my6XMUPXhh7P3dnw+dp/SAuKO5iWwShUFfJZGdUV
        eCLaHNsdqXHYvUgPsPRIE/ffHSdQmFcXoHp2DVcgMs3kgR13rLkRs82gl5szbBcvYd/qufz2uaIEh
        bBYCsId1fiSBSjGradCdAmBEE9E2uwLv9M9IYdLLOV8NP3DeqLiChJm7Vyib1208uvAvoI3vtEJZE
        Km6EXKVWMidZhz/fWY3MFBvVIZzP404vIK5ICR1eIiKHWtTdIAO/BUqEDsPPakTKCAJ3EWwUvLyJ3
        DfJwnZ4A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcu-00DzC0-HM
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 1/8] nat: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:14:11 +0000
Message-Id: <20230305101418.2233910-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for shifted port-ranges was added to iptables for DNAT in 2018.
This allows one to redirect packets intended for one port to another in
a range in such a way that the new port chosen has the same offset in
the range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

Make this functionality available in nftables:

  add rule t c ip daddr 10.0.0.1 tcp dport 2000-3000 dnat to 10.10.0.1:12000-13000/2000 persistent

In contrast to iptables, where shifting is only available for DNAT, both DNAT
and SNAT are supported.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970672
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1501
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/statement.h       |  1 +
 src/evaluate.c            | 10 ++++++++++
 src/netlink_delinearize.c | 16 +++++++++++++++-
 src/netlink_linearize.c   | 19 +++++++++++++++----
 src/parser_bison.y        | 33 +++++++++++++++++++++++++++++++--
 src/statement.c           |  4 ++++
 6 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 720a6ac2c754..762ea45d4b89 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -144,6 +144,7 @@ struct nat_stmt {
 	enum nft_nat_etypes	type;
 	struct expr		*addr;
 	struct expr		*proto;
+	struct expr		*proto_base;
 	uint32_t		flags;
 	uint8_t			family;
 	uint32_t		type_flags;
diff --git a/src/evaluate.c b/src/evaluate.c
index 47caf3b0d716..339c428e5aa9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3772,6 +3772,16 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 			return err;
 
 		stmt->nat.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+
+		if (stmt->nat.proto_base != NULL) {
+			err = stmt_evaluate_arg(ctx, stmt,
+						&inet_service_type,
+						sizeof(uint16_t) * BITS_PER_BYTE,
+						BYTEORDER_BIG_ENDIAN,
+						&stmt->nat.proto_base);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	stmt->flags |= STMT_F_TERMINAL;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 60350cd6cd96..bdfd37870b50 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1257,7 +1257,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 {
 	struct stmt *stmt;
 	struct expr *addr, *proto;
-	enum nft_registers reg1, reg2;
+	enum nft_registers reg1, reg2, reg3;
 	int family;
 
 	stmt = nat_stmt_alloc(loc,
@@ -1352,6 +1352,20 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		if (stmt->nat.proto != NULL)
 			proto = range_expr_alloc(loc, stmt->nat.proto, proto);
 		stmt->nat.proto = proto;
+
+		reg3 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_PROTO_BASE);
+		if (reg3) {
+			proto = netlink_get_register(ctx, loc, reg3);
+			if (proto == NULL) {
+				netlink_error(ctx, loc,
+					      "NAT statement has no proto offset expression");
+				goto out_err;
+			}
+
+			expr_set_type(proto, &inet_service_type,
+				      BYTEORDER_BIG_ENDIAN);
+			stmt->nat.proto_base = proto;
+		}
 	}
 
 	ctx->stmt = stmt;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 11cf48a3f9d0..72a38341e39e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1195,11 +1195,11 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 {
 	struct nftnl_expr *nle;
 	enum nft_registers amin_reg, amax_reg;
-	enum nft_registers pmin_reg, pmax_reg;
+	enum nft_registers pmin_reg, pmax_reg, pbase_reg;
 	uint8_t family = 0;
 	int registers = 0;
 	int nftnl_flag_attr;
-	int nftnl_reg_pmin, nftnl_reg_pmax;
+	int nftnl_reg_pmin, nftnl_reg_pmax, nftnl_reg_pbase;
 
 	switch (stmt->nat.type) {
 	case NFT_NAT_SNAT:
@@ -1211,8 +1211,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_NAT_FAMILY, family);
 
 		nftnl_flag_attr = NFTNL_EXPR_NAT_FLAGS;
-		nftnl_reg_pmin = NFTNL_EXPR_NAT_REG_PROTO_MIN;
-		nftnl_reg_pmax = NFTNL_EXPR_NAT_REG_PROTO_MAX;
+		nftnl_reg_pmin  = NFTNL_EXPR_NAT_REG_PROTO_MIN;
+		nftnl_reg_pmax  = NFTNL_EXPR_NAT_REG_PROTO_MAX;
+		nftnl_reg_pbase = NFTNL_EXPR_NAT_REG_PROTO_BASE;
 		break;
 	case NFT_NAT_MASQ:
 		nle = alloc_nft_expr("masq");
@@ -1308,6 +1309,16 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			netlink_gen_expr(ctx, stmt->nat.proto->right, pmax_reg);
 			netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
 			netlink_put_register(nle, nftnl_reg_pmax, pmax_reg);
+
+			if (stmt->nat.proto_base) {
+				pbase_reg = get_register(ctx, NULL);
+				registers++;
+
+				netlink_gen_expr(ctx, stmt->nat.proto_base,
+						 pbase_reg);
+				netlink_put_register(nle, nftnl_reg_pbase,
+						     pbase_reg);
+			}
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.proto, pmin_reg);
 			netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b1b67623cf66..c4e274544355 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3833,24 +3833,53 @@ nat_stmt_args		:	stmt_expr
 				$<stmt>0->nat.addr = $1;
 				$<stmt>0->nat.proto = $3;
 			}
+			|	stmt_expr	COLON	range_stmt_expr	SLASH	primary_stmt_expr
+			{
+				$<stmt>0->nat.addr = $1;
+				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
+			}
 			|	TO	stmt_expr	COLON	stmt_expr
 			{
 				$<stmt>0->nat.addr = $2;
 				$<stmt>0->nat.proto = $4;
 			}
+			|	TO	stmt_expr	COLON	range_stmt_expr	SLASH	primary_stmt_expr
+			{
+				$<stmt>0->nat.addr = $2;
+				$<stmt>0->nat.proto = $4;
+				$<stmt>0->nat.proto_base = $6;
+			}
 			|	nf_key_proto	TO	 stmt_expr	COLON	stmt_expr
 			{
 				$<stmt>0->nat.family = $1;
 				$<stmt>0->nat.addr = $3;
 				$<stmt>0->nat.proto = $5;
 			}
-			|	COLON		stmt_expr
+			|	nf_key_proto	TO	stmt_expr	COLON	range_stmt_expr	SLASH	primary_stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $3;
+				$<stmt>0->nat.proto = $5;
+				$<stmt>0->nat.proto_base = $7;
+			}
+			|	COLON	stmt_expr
+			{
+				$<stmt>0->nat.proto = $2;
+			}
+			|	COLON	range_stmt_expr	SLASH	primary_stmt_expr
 			{
 				$<stmt>0->nat.proto = $2;
+				$<stmt>0->nat.proto_base = $4;
+			}
+			|	TO	COLON	stmt_expr
+			{
+				$<stmt>0->nat.proto = $3;
 			}
-			|	TO	COLON		stmt_expr
+			|	TO	COLON	range_stmt_expr	SLASH	primary_stmt_expr
 			{
 				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
 			}
 			|       nat_stmt_args   nf_nat_flags
 			{
diff --git a/src/statement.c b/src/statement.c
index 72455522c2c9..23eee84eb4dc 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -733,6 +733,10 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			nft_print(octx, " ");
 		nft_print(octx, ":");
 		expr_print(stmt->nat.proto, octx);
+		if (stmt->nat.proto_base) {
+			nft_print(octx, "/");
+			expr_print(stmt->nat.proto_base, octx);
+		}
 	}
 
 	print_nf_nat_flags(stmt->nat.flags, octx);
-- 
2.39.2

