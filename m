Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA812C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 18:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E6920679
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 18:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="mGAkYmHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgASSMF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 13:12:05 -0500
Received: from kadath.azazel.net ([81.187.231.250]:46022 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgASSME (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 13:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xOxlmIxLMFWFHY/nTKSk2TyzQW0BYjxiFwyDi6N519Y=; b=mGAkYmHgUIINNWx/mZW9wZffMC
        xC3h+/oXVAiTyhy9OXF5cGSWv3Up+OoAI05FqrR88Vc/3VgwOpQsq0uxV4xMPRp3jzZtcKPu0Kucn
        GwQVudGI/ASTVLH7BsWg5E0OJt9eeaaa2PaZD/Ezj8aApqbUy7YsAz0z7nAtLoxJokRKBbt4eqApZ
        Ud2Z7Z8bujgR5mD1fSrvK3piW3FFS0YNn8HSLDPnVqFhmol6W4P5EdOViWC9SoUjsQtJSECWQzByi
        KDdlsGxbnNaNRzDl03DBBi+jE3ScmTDkA7asJKcSV4Eb9i5F0gobaWynTYBoh+FgYET/Bl7zf8nVw
        vhPR8dcw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itF3L-0004um-Q6
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 18:12:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] evaluate: don't eval unary arguments.
Date:   Sun, 19 Jan 2020 18:12:03 +0000
Message-Id: <20200119181203.60884-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When a unary expression is inserted to implement a byte-order
conversion, the expression being converted has already been evaluated
and so expr_evaluate_unary doesn't need to do so.  For most types of
expression, the double evaluation doesn't matter since evaluation is
idempotent.  However, in the case of payload expressions which are
munged during evaluation, it can cause unexpected errors:

  # nft add table ip t
  # nft add chain ip t c '{ type filter hook input priority filter; }'
  # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
  Error: Value 252 exceeds valid range 0-63
  add rule ip t c ip dscp set ip dscp | 0x10
                              ^^^^^^^

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e7881543d2de..9d5fdaf0ef3e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -997,13 +997,9 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
  */
 static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr *unary = *expr, *arg;
+	struct expr *unary = *expr, *arg = unary->arg;
 	enum byteorder byteorder;
 
-	if (expr_evaluate(ctx, &unary->arg) < 0)
-		return -1;
-	arg = unary->arg;
-
 	assert(!expr_is_constant(arg));
 	assert(expr_basetype(arg)->type == TYPE_INTEGER);
 	assert(arg->etype != EXPR_UNARY);
-- 
2.24.1

