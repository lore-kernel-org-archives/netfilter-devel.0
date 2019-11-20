Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B33C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAFBD2080F
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Fr7Sgd8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKTRoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 12:44:11 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:38313 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfKTRoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 12:44:11 -0500
Received: by mail-wm1-f47.google.com with SMTP id z19so572271wmk.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 09:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uZWFu26SBUmkZwJ619VG6TJ1evSOV64lf1h8b8/PjHY=;
        b=Fr7Sgd8mlvdBqu9LnfhE078kY/UMvN6CJKAOIFrteG/rywC2K3h2FhYA9F/F8s8VuE
         4Fg7cqxkqqfz4UIEfrRKHFFmbgMPfo0DaqcDUNjZD1RV/Zmpyn03QMEB/e6Ftlv5IEIr
         8RZ7bkQZW6LcbaM7/dl/CP9wAU6DSIovaKaTbm4C8AJ0wsX6Jd61ovFhq0/XDGdmOsaR
         bg5zjQD6XUPEVXlXlYuS9hjJcGfGe+qh4tC2UZ5Rs7ilNfKp4ym3LNYS1JQxCHiUgIEG
         ca5AuomnleVFXo1E+AZG+UXvfC33RFL58tT8QvEIiBQR8TBz+MjH9B3UU2Gh+VrBipk2
         nqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uZWFu26SBUmkZwJ619VG6TJ1evSOV64lf1h8b8/PjHY=;
        b=Nw8HXPRWak8aUvvB9zcULwFHU/Hvq567DVcqAB6ydxJ1Dc7dMZKNgENwG6GrxBGaIB
         tC15Wy/L83TZrCY69c34dl3m8fmN2gCohpBZbUD2V6cg894nnBIxvoaMdAm3NG9gPrb+
         3CW+eFgnHs84iAfnVXeUyEaxvoVPYlDTwYitEinHzhOUPqYSrTM69vZ6wa+RDgh+/PkO
         UqccN2jB63NuJm9gkJKAyLe4TO65VXpTJV5rTqyHXNCljwETZldgkI/qWzvH8CXXnqJG
         nU2dtIknqZujHs7+iVpIiANLlC669nB7Y1stvQVvTlYkCiDKGunVX3m4c1CYDyneVSqC
         k3ug==
X-Gm-Message-State: APjAAAX14s41GyQxfDWWRWojdqvrO7jWsCgBSjE/vKPXhUxWaIam+/VI
        IPKKzP8B7NamPJaI4jexxzexvfZS
X-Google-Smtp-Source: APXvYqw3WKwD4z1c4Eu01FovvWT5MzSJLxjcM+bfUXqS9OIQ7IhlR9X7bjB0y7GEQ+Ml9thyQGprRg==
X-Received: by 2002:a7b:c5d0:: with SMTP id n16mr731050wmk.78.1574271848648;
        Wed, 20 Nov 2019 09:44:08 -0800 (PST)
Received: from desktopdebian.localdomain (x4d06663e.dyn.telefonica.de. [77.6.102.62])
        by smtp.gmail.com with ESMTPSA id m3sm34558580wrb.67.2019.11.20.09.44.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 09:44:08 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [RFC 2/4] src: add ability to set/get secmarks to/from connection
Date:   Wed, 20 Nov 2019 18:43:55 +0100
Message-Id: <20191120174357.26112-2-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120174357.26112-1-cgzones@googlemail.com>
References: <20191120174357.26112-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Labeling established and related packets requires the secmark to be stored in the connection.
Add the ability to store and retrieve secmarks like:

    ...
    chain input {
        ...

        # label new incoming packets
        ct state new meta secmark set tcp dport map @secmapping_in

        # add label to connection
        ct state new ct secmark set meta secmark

        # set label for est/rel packets from connection
        ct state established,related meta secmark set ct secmark

        ...
    }
    ...
    chain output {
        ...

        # label new outgoing packets
        ct state new meta secmark set tcp dport map @secmapping_out

        # add label to connection
        ct state new ct secmark set meta secmark

        # set label for est/rel packets from connection
        ct state established,related meta secmark set ct secmark

        ...
        }
    ...

improves: 3bc84e5c1fdd1ff011af9788fe174e0514c2c9ea

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 src/ct.c           |  2 ++
 src/evaluate.c     | 10 ++++++++++
 src/meta.c         |  2 ++
 src/parser_bison.y | 14 +++++++++++---
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index ed458e6b..9e6a8351 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -299,6 +299,8 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_BIG_ENDIAN, 128),
 	[NFT_CT_DST_IP6]	= CT_TEMPLATE("ip6 daddr", &ip6addr_type,
 					      BYTEORDER_BIG_ENDIAN, 128),
+	[NFT_CT_SECMARK]	= CT_TEMPLATE("secmark", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/evaluate.c b/src/evaluate.c
index e54eaf1a..740d3c30 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1794,6 +1794,16 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		if (expr_is_singleton(right))
 			relational_expr_pctx_update(&ctx->pctx, rel);
 
+		/*
+		 * Statements like 'ct secmark 12 counter' are parsed as
+		 * relational expression with implicit operator.
+		 * Make them invalid.
+		 */
+		if ((left->etype == EXPR_META && left->meta.key == NFT_META_SECMARK)
+			|| (left->etype == EXPR_CT && left->ct.key == NFT_CT_SECMARK))
+			return expr_error(ctx->msgs, *expr,
+                                          "secmark is invalid with hardcoded ids");
+
 		/* fall through */
 	case OP_NEQ:
 		switch (right->etype) {
diff --git a/src/meta.c b/src/meta.c
index 69a897a9..796d8e94 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -698,6 +698,8 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_TIME_HOUR]	= META_TEMPLATE("hour", &hour_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SECMARK]	= META_TEMPLATE("secmark", &integer_type,
+						32, BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 631b7d68..707f4671 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4190,9 +4190,16 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				switch ($2) {
 				case NFT_META_SECMARK:
-					$$ = objref_stmt_alloc(&@$);
-					$$->objref.type = NFT_OBJECT_SECMARK;
-					$$->objref.expr = $4;
+					switch ($4->etype) {
+					case EXPR_CT:
+						$$ = meta_stmt_alloc(&@$, $2, $4);
+						break;
+					default:
+						$$ = objref_stmt_alloc(&@$);
+						$$->objref.type = NFT_OBJECT_SECMARK;
+						$$->objref.expr = $4;
+						break;
+					}
 					break;
 				default:
 					$$ = meta_stmt_alloc(&@$, $2, $4);
@@ -4388,6 +4395,7 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
+			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
 			|	ct_key_dir_optional
 			;
 
-- 
2.24.0

