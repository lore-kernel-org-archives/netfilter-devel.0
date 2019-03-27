Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A882C10F12
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8CF92146F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="lKGFil0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbfC0KiB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:38:01 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55506 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfC0KiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 06:38:01 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 242DC1B9057
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 03:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1553683080; bh=CTw4+cpjFEj4iYwiXqm41n5pfZ8uHY85HH6EnGMNfaY=;
        h=From:To:Cc:Subject:Date:From;
        b=lKGFil0DCosjP9q+krEdz+hkA68KhTZDgXebk7Sdm4k634f5fCJPcYbSABhmHk3Uh
         FJPgQdCE6s8KCSAPoLmhD0zGUmuNSm3Sk9eFa/V1u29z4Xig0pyWa1r4kv43+u7SaP
         jefJlu39P1f3X1s0q6V19ARTxSJEvQmyqfhtP0Lk=
X-Riseup-User-ID: 59B769BB154A8BDA709C2325D2F7E65148A00E5F1D1E1FA4928E0F716291CED0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 41CE71205E8;
        Wed, 27 Mar 2019 03:37:59 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/6 nft v3] osf: add version fingerprint support
Date:   Wed, 27 Mar 2019 11:37:56 +0100
Message-Id: <20190327103801.2049-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for version fingerprint in "osf" expression. Example:

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
		osf ttl skip name "Linux"
		osf ttl skip version "Linux:4.20"
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  6 ++++++
 include/osf.h                       |  3 ++-
 src/netlink_delinearize.c           |  4 +++-
 src/netlink_linearize.c             |  1 +
 src/osf.c                           | 13 ++++++++++---
 src/parser_bison.y                  |  8 ++++++--
 7 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6d72f64..6416ac0 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -350,6 +350,7 @@ struct expr {
 		struct {
 			/* EXPR_OSF */
 			uint8_t			ttl;
+			uint32_t		flags;
 		} osf;
 	};
 };
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 37036be..09a7b9e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -944,15 +944,21 @@ enum nft_socket_keys {
  *
  * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
  */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
 	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
 	__NFTA_OSF_MAX
 };
 #define NFT_OSF_MAX		(__NFTA_OSF_MAX - 1)
 
+enum nft_osf_flags {
+	NFT_OSF_F_VERSION	= 1 << 0,	/* check fingerprint version */
+};
+
 /**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
diff --git a/include/osf.h b/include/osf.h
index 23ea34d..8f6f584 100644
--- a/include/osf.h
+++ b/include/osf.h
@@ -1,7 +1,8 @@
 #ifndef NFTABLES_OSF_H
 #define NFTABLES_OSF_H
 
-struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl);
+struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
+			    const uint32_t flags);
 
 extern int nfnl_osf_load_fingerprints(struct netlink_ctx *ctx, int del);
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d0eaf5b..9a2d63d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -655,10 +655,12 @@ static void netlink_parse_osf(struct netlink_parse_ctx *ctx,
 {
 	enum nft_registers dreg;
 	struct expr *expr;
+	uint32_t flags;
 	uint8_t ttl;
 
 	ttl = nftnl_expr_get_u8(nle, NFTNL_EXPR_OSF_TTL);
-	expr = osf_expr_alloc(loc, ttl);
+	flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_OSF_FLAGS);
+	expr = osf_expr_alloc(loc, ttl, flags);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_OSF_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 61149bf..8df82d5 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -228,6 +228,7 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("osf");
 	netlink_put_register(nle, NFTNL_EXPR_OSF_DREG, dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_OSF_TTL, expr->osf.ttl);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_OSF_FLAGS, expr->osf.flags);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/osf.c b/src/osf.c
index 9252934..f0c2239 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -19,17 +19,22 @@ static void osf_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const char *ttl_str = osf_ttl_int_to_str(expr->osf.ttl);
 
-	nft_print(octx, "osf %sname", ttl_str);
+	if (expr->osf.flags & NFT_OSF_F_VERSION)
+		nft_print(octx, "osf %sversion", ttl_str);
+	else
+		nft_print(octx, "osf %sname", ttl_str);
 }
 
 static void osf_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->osf.ttl = expr->osf.ttl;
+	new->osf.flags = expr->osf.flags;
 }
 
 static bool osf_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return e1->osf.ttl == e2->osf.ttl;
+	return (e1->osf.ttl == e2->osf.ttl) &&
+	       (e1->osf.flags == e2->osf.flags);
 }
 
 const struct expr_ops osf_expr_ops = {
@@ -41,7 +46,8 @@ const struct expr_ops osf_expr_ops = {
 	.json		= osf_expr_json,
 };
 
-struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl)
+struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
+			    const uint32_t flags)
 {
 	unsigned int len = NFT_OSF_MAXGENRELEN * BITS_PER_BYTE;
 	const struct datatype *type = &string_type;
@@ -50,6 +56,7 @@ struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl)
 	expr = expr_alloc(loc, EXPR_OSF, type,
 			  BYTEORDER_HOST_ENDIAN, len);
 	expr->osf.ttl = ttl;
+	expr->osf.flags = flags;
 
 	return expr;
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 65b3fb3..6e1bb88 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3190,9 +3190,13 @@ fib_tuple		:  	fib_flag	DOT	fib_tuple
 			|	fib_flag
 			;
 
-osf_expr		:	OSF	osf_ttl		NAME
+osf_expr		:	OSF	osf_ttl		HDRVERSION
 			{
-				$$ = osf_expr_alloc(&@$, $2);
+				$$ = osf_expr_alloc(&@$, $2, NFT_OSF_F_VERSION);
+			}
+			|	OSF	osf_ttl		NAME
+			{
+				$$ = osf_expr_alloc(&@$, $2, 0);
 			}
 			;
 
-- 
2.20.1

