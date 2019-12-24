Return-Path: <SRS0=zFhn=2O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBC1C2D0C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Dec 2019 23:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AA6206D3
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Dec 2019 23:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="EfynfSsf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLXXOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Dec 2019 18:14:30 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49730 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfLXXO3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Dec 2019 18:14:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VfL88Kj6Ji058gwVAjRc1Am9Ejv1zAUdboufPO2D670=; b=EfynfSsf0TryyeeZlO4mKem0vb
        qqJ1Y300MpXq1lkrJyRTBBUy4FW5VGnIy4Cw3So4lo7+U+zLwgil3D0V8FyYB3SnzFRwsQSVo5O7+
        v1xp+OQzQVY1bBTAu9/dWk/ptS71Ej3zgAbgA0nvMnfL2tRMxM6yLbyLf5OutM3Y0V+b/EdDrBnLk
        84gMux4iB6hnkbHHgILqqgqRI/Ja7IcNYSobUHRHM/AWEgYu7CxnXs8GuA/ydTQQiWtQesP50brP9
        2gFk4Ghg6Kih0EyQguAMEZN942p+T9NKAu+sTIhNKw+f1OTQfmIKePUcxDuuC8ib6DwuuJzo0iwrk
        ChoVkmNQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ijtNk-00026o-GY
        for netfilter-devel@vger.kernel.org; Tue, 24 Dec 2019 23:14:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2] evaluate: fix expr_set_context call for shift binops.
Date:   Tue, 24 Dec 2019 23:14:28 +0000
Message-Id: <20191224231428.1972155-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191220190215.1743199-1-jeremy@azazel.net>
References: <20191220190215.1743199-1-jeremy@azazel.net>
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

Replace it with a call to __expr_set_context in order to preserve host
endianness.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Change-log:

  In v1, I just dropped the expr_set_context call; however, it is needed
  to ensure that the right operand has integer type.  Instead, I now
  change it to __expr_set_context in order to ensure that the byte-order
  is correct.

diff --git a/src/evaluate.c b/src/evaluate.c
index a865902c0fc7..43637e1cf6c8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1145,7 +1145,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	left = op->left;
 
 	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
-		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
+		__expr_set_context(&ctx->ectx, &integer_type,
+				   BYTEORDER_HOST_ENDIAN, ctx->ectx.len, 0);
 	if (expr_evaluate(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
-- 
2.24.0

