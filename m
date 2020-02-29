Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7809AC3F2D4
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F803246A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QN5NptHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgB2L1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:27:35 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48672 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgB2L1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dckDMMQ4H4DcD9kwmZOxmF1xvj/Lyozd72BYFThrnpo=; b=QN5NptHVVA2O8gibuu7b8H3+cV
        nBmVvZ+2Krp8A8Y/j1qoaid7WOmBXXqshdGG9Yt/pC+fpbMBeUh/1lcPWAmT6dgql7dSsMjtTdL34
        Or4BRdfBdtjraSD+wRHJk/UHVQsPAeVZ5SlVsUYUBqOTBGYgaJe8WCU8xsEsCiPrmqM9Hb8pEQG1d
        YSyzg+9s1dIICG1A/0dOZcrgy6jIzjqXwES2d331lHMtCLChaW8ajlw7hSoe6yDGYwva/sFAfHu4a
        cgLbEq+ZuNIMv9RIQuRGcl9NlGNym33UIBp0yj2IjoEoYs9mn4DbOnx1NrQNzcvAYLFETlSKWnhqc
        2AIiNu1g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HL-0003Wm-KG; Sat, 29 Feb 2020 11:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 01/18] evaluate: add separate variables for lshift and xor binops.
Date:   Sat, 29 Feb 2020 11:27:14 +0000
Message-Id: <20200229112731.796417-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

stmt_evaluate_payload has distinct variables for some, but not all, the
binop expressions it creates.  Add variables for the rest.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b38ac9310656..fda30fd8001e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2204,7 +2204,7 @@ static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct expr *binop, *mask, *and, *payload_bytes;
+	struct expr *mask, *and, *xor, *payload_bytes;
 	unsigned int masklen, extra_len = 0;
 	unsigned int payload_byte_size, payload_byte_offset;
 	uint8_t shift_imm, data[NFT_REG_SIZE];
@@ -2251,22 +2251,21 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 
 	if (shift_imm) {
-		struct expr *off;
+		struct expr *off, *lshift;
 
 		off = constant_expr_alloc(&payload->location,
 					  expr_basetype(payload),
 					  BYTEORDER_HOST_ENDIAN,
 					  sizeof(shift_imm), &shift_imm);
 
-		binop = binop_expr_alloc(&payload->location, OP_LSHIFT,
-					 stmt->payload.val, off);
-		binop->dtype		= payload->dtype;
-		binop->byteorder	= payload->byteorder;
+		lshift = binop_expr_alloc(&payload->location, OP_LSHIFT,
+					  stmt->payload.val, off);
+		lshift->dtype     = payload->dtype;
+		lshift->byteorder = payload->byteorder;
 
-		stmt->payload.val = binop;
+		stmt->payload.val = lshift;
 	}
 
-
 	masklen = payload_byte_size * BITS_PER_BYTE;
 	mpz_init_bitmask(ff, masklen);
 
@@ -2295,16 +2294,17 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	and = binop_expr_alloc(&payload->location, OP_AND, payload_bytes, mask);
 
-	and->dtype		 = payload_bytes->dtype;
-	and->byteorder		 = payload_bytes->byteorder;
-	and->len		 = payload_bytes->len;
+	and->dtype	= payload_bytes->dtype;
+	and->byteorder	= payload_bytes->byteorder;
+	and->len	= payload_bytes->len;
+
+	xor = binop_expr_alloc(&payload->location, OP_XOR, and,
+			       stmt->payload.val);
+	xor->dtype	= payload->dtype;
+	xor->byteorder	= payload->byteorder;
+	xor->len	= mask->len;
 
-	binop = binop_expr_alloc(&payload->location, OP_XOR, and,
-				 stmt->payload.val);
-	binop->dtype		= payload->dtype;
-	binop->byteorder	= payload->byteorder;
-	binop->len		= mask->len;
-	stmt->payload.val = binop;
+	stmt->payload.val = xor;
 
 	return expr_evaluate(ctx, &stmt->payload.val);
 }
-- 
2.25.0

