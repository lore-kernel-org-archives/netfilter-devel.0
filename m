Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0E3C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbiDDMbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbiDDMbu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:50 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EF925280
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kiX82OGZlHTbJIac9j0u7fgC6Qxrf20KBmHmHiNBjGU=; b=r7zdoqqtWZ71F/aWTAUAY+yu97
        UpsSiGwa9yn1kAEifEd3VY8Wkt5pGg4fxmv9/ybrIDkcBw1CCTnjScna7JF3q2pkBY5Cg+U2lrE5r
        GZXpFtF49w7arSfj8x7U6iITC76HuWRneTgl3IXkaegfZbJVVl/silto4bpDzxZc2PK7WXlsqk2S4
        OZkUmG56j8sUnZ6dHR5Qr9zGJxgS0eTWQ0xjc0t+poO3h6GqiRVHindXqgQ02RLQIoMBGLOEwDbJi
        WPxBfle03ru62y0u2bo/QiC+zFBN28zKI2vAHisV4ZQhA3ljwKFJKvg/Zn+AFho+CJAJz7MRCYU6u
        rqHavEHQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-MK; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 23/32] evaluate: set eval context to leftmost bitwise operand
Date:   Mon,  4 Apr 2022 13:14:01 +0100
Message-Id: <20220404121410.188509-24-jeremy@azazel.net>
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

A bitwise expression currently derives its type and size from its
left operand.  Thus:

  ct mark & 0xff

has type `mark` and size `32`.

However, currently, something like:

  ct mark | ip dscp | 0x200

will fail because, although evaluation is left-associative, and
therefore this expression will be evaluated as:

 (ct mark | ip dscp) | 0x200

after the evaluation of `ct mark | ip dscp`, the evaluation context
contains the size and data-type of the `ip dscp` expression and so
`0x200` is out of range.

Instead, reset the evaluation context to the values from the left-hand
operand once both operands have been evaluated.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 6b1e295d216a..02bfde2a2ded 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1153,6 +1153,8 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left;
 
+	expr_evaluate_primary(ctx, &left);
+
 	if (byteorder_conversion(ctx, &op->right, left->byteorder) < 0)
 		return -1;
 
-- 
2.35.1

