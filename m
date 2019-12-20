Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E93C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 19:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06B3C206D8
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 19:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="C2wBKpiR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfLTTCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:02:19 -0500
Received: from kadath.azazel.net ([81.187.231.250]:51476 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTTCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 14:02:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h+d8xRCBqMM0iBHFiL2cxqYadKH4RA21/v4sJMnhMVM=; b=C2wBKpiR3dLDLtdwrssC6hK3Xk
        ocTKtHztbToDOX9kzLrv+ggr6hw10EeUNkwwcPOWcVWuvObG20zAjk40HON+D2I5TxODyMlY0zDja
        RcYu+6nP6PiSgDmSkiIN0eAhucBWGZP5vIgAGIZeXBk+O3fHYS7xjU9CETs9H7UdWOLTiYD5nPUox
        ZweYGy5g3n3kuG4OEounzwz0iL15vouS/ONdTwaeO4Grmcq/vx7Mrfy0MpdOt9fL5NeSAQUY7SzyA
        K9ZyLmgk5rSsUHx7CQtCYnpCNiOQGOu2QpcLIK3lVnzBE9y9oIzbGmd2CR0OmJI9G/vtvZ/tbggdg
        LO7L7eFg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iiNXU-0007Ox-3q
        for netfilter-devel@vger.kernel.org; Fri, 20 Dec 2019 19:02:16 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables] evaluate: remove expr_set_context call.
Date:   Fri, 20 Dec 2019 19:02:15 +0000
Message-Id: <20191220190215.1743199-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
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
the context data-type to `integer`.  This doesn't seem to serve a
purpose, and its only effect is to clobber the byte-order of the
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a865902c0fc7..0feb7d484405 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1144,8 +1144,6 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	left = op->left;
 
-	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
-		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
 	if (expr_evaluate(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
-- 
2.24.0

