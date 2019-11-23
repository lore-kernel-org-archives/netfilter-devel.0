Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27892C432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD35720679
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bHeaQm+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKWQWx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 11:22:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37604 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfKWQWx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 11:22:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so12304925wrv.4
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 08:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hpYik/JVTPQq7+Tt7iBiVkBWFzBWnMtdsYukAsY2NI=;
        b=bHeaQm+TssZpKcxf/eD6ZNX0m3MqWYoytmH/YSILkwYmFPjCV6U58CDorGZeEeb7rO
         JeFJ1a/jTz36dwxygujG5FaKcu9XbkwuAkrLwmSicCX8yjFqRtUoFDdAQCNsa2nPToa/
         MOm3WJqtasePnFuU7FbCT7YucqBDDzcFWwAWIFUCuIrJ0b+HY777+EOJ6AZ0x1mSAxPL
         rGN7kZJnZBxwekd4wNzLqEl7fkNwNudlSvbrZ+/t1f+gCwd+HJXu2v0KA6WghBPzbbXa
         3GegVZtto/NWAv52ARywgNvonMm235pbNau2r442vCg7lHCs74e9/S0bVrbQkhZ7C1MH
         ubPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hpYik/JVTPQq7+Tt7iBiVkBWFzBWnMtdsYukAsY2NI=;
        b=uBa0FAqU+yDE72ZRf49bU4lodg4A7Ns8I2MYt0yjLNcA/cHqbcao0XjgHl/cJ4AcDs
         bgr2BOlysp4fP81FVB9X5Qk/Oa/32cQlBr+MVKfSuKmmLporgcKgOBAmHHW0AYK9ZaU7
         RQLkUHKl7xNz/mTiSJQS+L4m8/TdPwSRVkPuJKlYhvbKXAqV8HHLili+1vbfsvEZLaj9
         11zWdDO/dYYKoHdgFUdFUOHROwT6/jr5brs78UWA3GX90VP1dNKt9yp9bJLa2+Fw7otc
         e+Imhz7C+H1k5P+O9nJg7Za20Df31etQIrL5hND8Odwyxt3/NffvLqG/MLYZzGGAwvtJ
         NUCQ==
X-Gm-Message-State: APjAAAVfrhi0SOS521MW79Th7UDGLPSk8FT/vTSDxbn3MbW44KTTYn5s
        EyB7eBsMXXJvWUYKQT14Aw8yo6vr
X-Google-Smtp-Source: APXvYqySwDy+hok1SZNSIabh8K08skLJpBa/nJYTC6Wa8LPcei3nEPM0/CpJvk2w/nwYOuTcQSudBQ==
X-Received: by 2002:adf:a31a:: with SMTP id c26mr22412813wrb.330.1574526170143;
        Sat, 23 Nov 2019 08:22:50 -0800 (PST)
Received: from desktopdebian.localdomain (x5f708d68.dyn.telefonica.de. [95.112.141.104])
        by smtp.gmail.com with ESMTPSA id z15sm2286598wmi.12.2019.11.23.08.22.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 08:22:49 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables v2 1/2] src: add ability to set/get secmarks to/from connection
Date:   Sat, 23 Nov 2019 17:22:39 +0100
Message-Id: <20191123162240.14571-1-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
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

This patch also disallow constant value on the right hand side.

    # nft add rule x y meta secmark 12
    Error: Cannot be used with right hand side constant value
    add rule x y meta secmark 12
                 ~~~~~~~~~~~~ ^^
    # nft add rule x y ct secmark 12
    Error: Cannot be used with right hand side constant value
    add rule x y ct secmark 12
                 ~~~~~~~~~~ ^^
    # nft add rule x y ct secmark set 12
    Error: ct secmark must not be set to constant value
    add rule x y ct secmark set 12
                 ^^^^^^^^^^^^^^^^^

This patch improves 3bc84e5c1fdd ("src: add support for setting secmark").

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v2: - incorporate changes suggested by Pablo Neira Ayuso
    - invalidate setting ct secmark to a constant value, like:
        ct secmark set 12
      Note:
      statements setting the meta secmark, like
        meta secmark set 12
      must accept constant values, cause the secmark object identifier
      is a string
        meta secmark set "icmp_client"
      12 is probably not a used secmark object identifier, so it will
      fail:
        nft add rule inet filter input meta secmark set 12
        Error: Could not process rule: No such file or directory
        add rule inet filter input meta secmark set 12
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 src/ct.c           |  2 ++
 src/evaluate.c     | 24 ++++++++++++++++++++++--
 src/meta.c         |  2 ++
 src/parser_bison.y | 14 +++++++++++---
 4 files changed, 37 insertions(+), 5 deletions(-)

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
index e54eaf1a..a865902c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1784,6 +1784,18 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 					 left->dtype->desc,
 					 right->dtype->desc);
 
+	/*
+	 * Statements like 'ct secmark 12' are parsed as relational,
+	 * disallow constant value on the right hand side.
+	 */
+	if (((left->etype == EXPR_META &&
+	      left->meta.key == NFT_META_SECMARK) ||
+	     (left->etype == EXPR_CT &&
+	      left->ct.key == NFT_CT_SECMARK)) &&
+	    right->flags & EXPR_F_CONSTANT)
+		return expr_binary_error(ctx->msgs, right, left,
+					 "Cannot be used with right hand side constant value");
+
 	switch (rel->op) {
 	case OP_EQ:
 	case OP_IMPLICIT:
@@ -2319,11 +2331,19 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	return stmt_evaluate_arg(ctx, stmt,
+	if (stmt_evaluate_arg(ctx, stmt,
 				 stmt->ct.tmpl->dtype,
 				 stmt->ct.tmpl->len,
 				 stmt->ct.tmpl->byteorder,
-				 &stmt->ct.expr);
+				 &stmt->ct.expr) < 0)
+		return -1;
+
+	if (stmt->ct.key == NFT_CT_SECMARK &&
+	    expr_is_constant(stmt->ct.expr))
+		return stmt_error(ctx, stmt,
+				  "ct secmark must not be set to constant value");
+
+	return 0;
 }
 
 static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
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

