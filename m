Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76174C6FD1A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCEKaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A7D33A
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tccSj9qLiu//3N9QU1NxJccSOmdiRkF+t8paJfXmLCQ=; b=aNlhu9YW4FAcMrY1Odsj/UNZAR
        wy9kPrWTdzEhHOkIKHbio8uKBBFh2nLzcelmAci5/cqTVFp2wz4YvamEFT0peYXV8NOiay4vYn4iZ
        leQGWj4Y9KIufShigB1ovnvlze+DgKjQYRdNI1vtdi/3bCYD75OGV760RYYGmy+G+dR9b2lqujsHI
        psRSvYJJHaMHY2zF3eMflDQxDZmIaaJWZTR0oTh5VSK2VFFc4A8sdtjTn7ZpWX8sWEj1EmTyrOX3T
        eMaT0KaIV4AqcdoeI6ajMbCSNT3mxnbepm6XNtiAyhhOlCWEu6ecV6RDsD6F3YWK3wCYzfzh/pdHX
        V3kcla4g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcu-00DzC0-Va
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 3/8] redir: add support for shifted port-ranges
Date:   Sun,  5 Mar 2023 10:14:13 +0000
Message-Id: <20230305101418.2233910-4-jeremy@azazel.net>
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

Support for shifted port-ranges was recently added to nat statements.
Extend this to redir statements.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 16 +++++++++++++++-
 src/netlink_linearize.c   |  5 +++--
 src/parser_bison.y        | 11 +++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 867ca914cf96..0c48cdd70428 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1505,7 +1505,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 {
 	struct stmt *stmt;
 	struct expr *proto;
-	enum nft_registers reg1, reg2;
+	enum nft_registers reg1, reg2, reg3;
 	uint32_t flags;
 
 	stmt = nat_stmt_alloc(loc, NFT_NAT_REDIR);
@@ -1542,6 +1542,20 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 			proto = range_expr_alloc(loc, stmt->nat.proto,
 						 proto);
 		stmt->nat.proto = proto;
+
+		reg3 = netlink_parse_register(nle, NFTNL_EXPR_REDIR_REG_PROTO_BASE);
+		if (reg3) {
+			proto = netlink_get_register(ctx, loc, reg3);
+			if (proto == NULL) {
+				netlink_error(ctx, loc,
+					      "redirect statement has no base proto expression");
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
index a018290a7f56..684cfdcaf91c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1227,8 +1227,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nle = alloc_nft_expr("redir");
 
 		nftnl_flag_attr = NFTNL_EXPR_REDIR_FLAGS;
-		nftnl_reg_pmin = NFTNL_EXPR_REDIR_REG_PROTO_MIN;
-		nftnl_reg_pmax = NFTNL_EXPR_REDIR_REG_PROTO_MAX;
+		nftnl_reg_pmin  = NFTNL_EXPR_REDIR_REG_PROTO_MIN;
+		nftnl_reg_pmax  = NFTNL_EXPR_REDIR_REG_PROTO_MAX;
+		nftnl_reg_pbase = NFTNL_EXPR_REDIR_REG_PROTO_BASE;
 		break;
 	default:
 		BUG("unknown nat type %d\n", stmt->nat.type);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8a7c5f066daa..5b8e48363233 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3965,6 +3965,11 @@ redir_stmt_arg		:	TO	stmt_expr
 			{
 				$<stmt>0->nat.proto = $3;
 			}
+			|	TO	COLON	range_stmt_expr	SLASH	primary_stmt_expr
+			{
+				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
+			}
 			|	nf_nat_flags
 			{
 				$<stmt>0->nat.flags = $1;
@@ -3979,6 +3984,12 @@ redir_stmt_arg		:	TO	stmt_expr
 				$<stmt>0->nat.proto = $3;
 				$<stmt>0->nat.flags = $4;
 			}
+			|	TO	COLON	range_stmt_expr	SLASH	primary_stmt_expr	nf_nat_flags
+			{
+				$<stmt>0->nat.proto = $3;
+				$<stmt>0->nat.proto_base = $5;
+				$<stmt>0->nat.flags = $6;
+			}
 			;
 
 dup_stmt		:	DUP	TO	stmt_expr
-- 
2.39.2

