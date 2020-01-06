Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACCDC33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90AD42080A
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cux2vGQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgAFWfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 17:35:12 -0500
Received: from kadath.azazel.net ([81.187.231.250]:36338 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFWfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 17:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IMnRIMGTBMNlnmBljDoEE3yUx1DEMRdpt6Z8UUWnlB0=; b=cux2vGQMwvmuKW2hYz9cS4Q5tL
        SHmLdO0rUpiAJkht6GMwhSql72XgnPgqeeIeCNuRHKcAi3DuwFd2MzoZgKUlC9xMYjIn3xAflv2E+
        nEvnKb+qms19UL5T7UaT0H3zcYJjwZ4jnM6hrzR4JF2sLslmkVECWC/v02nVeJwCzfaYLN7qGyW4W
        RaQsiSDoPNvKw51I95hyYGXHlEiISsci84NuDE5MJhxUyeLI0vucrMwixlJ95oWLZH6i/EpmwtU4g
        nttC+e/yGoUmoH4P5CTC3SbsEBwFS5qsmTayKxQL9bU5ypkphN5K5BRNtsi3XYHdMtKdKAWo3PVGV
        wv2mFnOg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ioaxq-0005uC-RN; Mon, 06 Jan 2020 22:35:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3] evaluate: fix expr_set_context call for shift binops.
Date:   Mon,  6 Jan 2020 22:35:10 +0000
Message-Id: <20200106223510.496948-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106092842.tp2pxubgmfcptthq@salvia>
References: <20200106092842.tp2pxubgmfcptthq@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

expr_evaluate_binop calls expr_set_context for shift expressions to set
the context data-type to `integer`.  This clobbers the byte-order of the
context, resulting in unexpected conversions to NBO.  For example:

  $ sudo nft flush ruleset
  $ sudo nft add table t
  $ sudo nft add chain t c '{ type filter hook output priority mangle; }'
  $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0x10 | 0xe'
  $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0xf << 1'
  $ sudo nft list table t
  table ip t {
          chain c {
                  type filter hook output priority mangle; policy accept;
                  oif "lo" tcp dport 22 ct mark set 0x0000001e
                  oif "lo" tcp dport 22 ct mark set 0x1e000000
          }
  }

Replace it with a call to __expr_set_context and set the byteorder to
that of the left operand since this is the value being shifted.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Since v2:

  * set the byte-order to that of the left operand, rather than hard-
    coding it as host-endian.

Since v1:

  * replace expr_set_context with __expr_set_context (and explicity set
    the byte-order) instead of removing it altogether in order to ensure
    that the right operand has integer type.

diff --git a/src/evaluate.c b/src/evaluate.c
index 817b23220bb9..34e4473e4c9a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1145,7 +1145,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	left = op->left;
 
 	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
-		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
+		__expr_set_context(&ctx->ectx, &integer_type,
+				   left->byteorder, ctx->ectx.len, 0);
 	if (expr_evaluate(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
-- 
2.24.1

