Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C61C6FA99
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCEKaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E079D309
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TSFK+H6vNxQfhys/126VdD+ibHJXI+PbOLdW2X5yghs=; b=lrvVdGUIhkuCiQ513StmgbAZNH
        avnSHoGpWd0F6+IHrhmWIjaxEY9s+a884LEC88msRwgoYzkie+QdHrALUnWvIjdDMFn2MvFfZrUgi
        pgfWn7UHUhw47J/I28qJuBV4ZA73JzJNbELri6hIX3m6T0Ywzbw9cf1d2ZOB+jph0uTSk4rUitd1K
        jOKqFsRpO6pUTT99kPuLvoHWBMAewfBnfrj7E/3E9OLhMSdOducAm5jft08qASJ33fazZFscEvtP7
        3nwKQrKUS20u7cBn9vZs1vpu/kEVTWOlJm0sQDfL5Qi6bqZbafqQrTvXpo+yBylRxYfUB/vYMz0lc
        TY1DbZEQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcu-00DzC0-Oj
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 2/8] masq: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:14:12 +0000
Message-Id: <20230305101418.2233910-3-jeremy@azazel.net>
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

Support for shifted port-ranges was recently added for nat statements.
Extend this to masq statements.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 16 +++++++++++++++-
 src/netlink_linearize.c   |  5 +++--
 src/parser_bison.y        | 11 +++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index bdfd37870b50..867ca914cf96 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1442,7 +1442,7 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 			       const struct location *loc,
 			       const struct nftnl_expr *nle)
 {
-	enum nft_registers reg1, reg2;
+	enum nft_registers reg1, reg2, reg3;
 	struct expr *proto;
 	struct stmt *stmt;
 	uint32_t flags = 0;
@@ -1477,6 +1477,20 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 		if (stmt->nat.proto != NULL)
 			proto = range_expr_alloc(loc, stmt->nat.proto, proto);
 		stmt->nat.proto = proto;
+
+		reg3 = netlink_parse_register(nle, NFTNL_EXPR_MASQ_REG_PROTO_BASE);
+		if (reg3) {
+			proto = netlink_get_register(ctx, loc, reg3);
+			if (proto == NULL) {
+				netlink_error(ctx, loc,
+					      "MASQUERADE statement has no base proto expression");
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
index 72a38341e39e..a018290a7f56 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1219,8 +1219,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nle = alloc_nft_expr("masq");
 
 		nftnl_flag_attr = NFTNL_EXPR_MASQ_FLAGS;
-		nftnl_reg_pmin = NFTNL_EXPR_MASQ_REG_PROTO_MIN;
-		nftnl_reg_pmax = NFTNL_EXPR_MASQ_REG_PROTO_MAX;
+		nftnl_reg_pmin  = NFTNL_EXPR_MASQ_REG_PROTO_MIN;
+		nftnl_reg_pmax  = NFTNL_EXPR_MASQ_REG_PROTO_MAX;
+		nftnl_reg_pbase = NFTNL_EXPR_MASQ_REG_PROTO_BASE;
 		break;
 	case NFT_NAT_REDIR:
 		nle = alloc_nft_expr("redir");
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c4e274544355..8a7c5f066daa 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3928,11 +3928,22 @@ masq_stmt_args		:	TO 	COLON	stmt_expr
 			{
 				$<stmt>0->nat.proto = $3;
 			}
+			|	TO	COLON	range_stmt_expr	SLASH	primary_stmt_expr
+			{
+				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
+			}
 			|	TO 	COLON	stmt_expr	nf_nat_flags
 			{
 				$<stmt>0->nat.proto = $3;
 				$<stmt>0->nat.flags = $4;
 			}
+			|	TO	COLON	range_stmt_expr	SLASH	primary_stmt_expr	nf_nat_flags
+			{
+				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
+				$<stmt>0->nat.flags = $6;
+			}
 			|	nf_nat_flags
 			{
 				$<stmt>0->nat.flags = $1;
-- 
2.39.2

