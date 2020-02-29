Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14902C3F2D8
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0EB5246AE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TF2Ff8YY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgB2L1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:27:35 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48666 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgB2L1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fLTVl9m6PJ/tQZqMAwRhogcxA98+0BrWyzJ9R6Y0Egk=; b=TF2Ff8YYdgxIrAV9484h7OOc0q
        2/M5i2j7V9seRzhBlayXaUjKEGtYUlNdX5LiaT+1q25bXl1l4XWdXbuj4/tWUba1QykHXLYm91yQw
        7mPcCokk3okGSG6Wm0rqoYgQwPQdFzxV1r0laMhcEWqu+v65HlAHT3bU+CHWU5Pd7rAvj+q+86CFM
        Q/wizgqkMwiKBJdMLdezPYfZOtclRAC0IqD2IBOW/ALEYT33fovTClp2IXddNFMXEh/Wvk1pbG5ZV
        ynrXFzJtZBWvRYkYFZw3Jj9d58D3N9k4IIIBDVurg/+EzajBPZRqqnyf/FwxB7gdIrO4oOAHw8gVw
        0DVRCPPw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HM-0003Wm-AV; Sat, 29 Feb 2020 11:27:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 05/18] evaluate: no need to swap byte-order for values of fewer than 16 bits.
Date:   Sat, 29 Feb 2020 11:27:18 +0000
Message-Id: <20200229112731.796417-6-jeremy@azazel.net>
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

Endianness is not meaningful for objects smaller than 2 bytes and the
byte-order conversions are no-ops in the kernel, so don't bother
inserting them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c              | 2 +-
 tests/py/any/meta.t.payload | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9b1a04f26f44..d5cc386d9792 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -149,7 +149,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 
 	if (expr_is_constant(*expr))
 		(*expr)->byteorder = byteorder;
-	else {
+	else if ((*expr)->len / BITS_PER_BYTE > 1) {
 		op = byteorder_conversion_op(*expr, byteorder);
 		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
 		if (expr_evaluate(ctx, expr) < 0)
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 486d7aa566ea..2af244a9e246 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -99,14 +99,12 @@ ip test-ip4 input
 # meta l4proto 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ cmp gte reg 1 0x00000021 ]
   [ cmp lte reg 1 0x0000002d ]
 
 # meta l4proto != 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ range neq reg 1 0x00000021 0x0000002d ]
 
 # meta l4proto { 33, 55, 67, 88}
@@ -865,7 +863,6 @@ __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ lookup reg 1 set __set%d ]
 
 # meta l4proto != { 33-55, 66-88}
@@ -874,7 +871,6 @@ __set%d test-ip4 0
 	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # meta skuid { 2001-2005, 3001-3005} accept
-- 
2.25.0

