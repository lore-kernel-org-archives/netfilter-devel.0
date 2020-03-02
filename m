Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABABC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 22:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F70221739
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 22:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VH5SbMmR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBWTS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 17:19:18 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41470 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCBWTS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 17:19:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3XNUV945vuFPO5/vYAcnw8ubdWAOQtfI2p5pTaCSifQ=; b=VH5SbMmReMEsidvkeBGvcEkD6/
        Py9BNohVM861vFIG4ho7cHUaQO8v/UpO/ro4cwHHMZ0yzRhJJqtvwr2pVDcBuhy6H+kqS77B8AcoT
        6+Z+Ja4f8r0Obzygo4GVRzk0gM50tvtIQuByHlH4LcWgpZjQnw+CU2xu6oV19PPwE8DIS+b1ZuQYl
        W3gNJdD8YIGCfzH1gC0e2dBQkEF81fWf8UrzVr9OMQH7DlTjTNjFIwo4a5ii+sNkGePilRQkOfhal
        OOsIVKLjyIEDbjMdGjsPjyy+kfeIf2WzBUcjxa+axFa0nDBeKo6btexiMpI6pUML8FSpINRltCyy7
        G8R+bw7Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j8tPA-0000Sg-7S; Mon, 02 Mar 2020 22:19:16 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 01/18] evaluate: add separate variables for lshift and xor binops.
Date:   Mon,  2 Mar 2020 22:18:59 +0000
Message-Id: <20200302221916.1005019-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302221916.1005019-1-jeremy@azazel.net>
References: <20200302221916.1005019-1-jeremy@azazel.net>
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
2.25.1

