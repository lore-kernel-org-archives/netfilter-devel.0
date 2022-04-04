Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F2BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345946AbiDDMcO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345545AbiDDMcH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:32:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B92529A
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X7VFGzEnD9iwwwaDqr35k2+4YnaFV8FsKZDiG6pM5Y0=; b=eP5nL+FAPyXROvTov/VI6TKug8
        Plqaz6AFB5whET36s6vSbMXNURTW1TBqhf7W00NCJNw9niCZNXU3IIOol5L/TZeirbsvX4i4xhbJ3
        7QC+Dr+97UxhQUPB+Iu6mZWHx3/IEakxogIn+cQ0rHe6vABWv3h6mUda7MS111mMYB9mrAEdVxO9l
        8sZZyB/ldDnEkGfPG+0EZAfhOkSRJkOkaMAu9aTYGw93WmN7d/uFPYNZKMqRkL1a2gU2UbRUdtcjX
        8ntkSWWnVxqr4HA29UTEsFbhKyhCVB9C2hdBzjbOqupcHn1Z2CzBzW1AN6B824nQ++FrcqOU+DQKJ
        zAq9ifnA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-BT; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 19/32] evaluate: don't eval unary arguments
Date:   Mon,  4 Apr 2022 13:13:57 +0100
Message-Id: <20220404121410.188509-20-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When a unary expression is inserted to implement a byte-order
conversion, the expression being converted has already been evaluated
and so `expr_evaluate_unary` doesn't need to do so.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f975dd197de3..1b252076e124 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1025,13 +1025,9 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
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
2.35.1

