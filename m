Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A28C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344900AbiDDMb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344971AbiDDMb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:56 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDAE25280
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GVghsi+gNpZBXcGueEUJn7tkCrxKGtUX3ww9Ns1WA+c=; b=Au1TdiRDiJAYhkdzDI8JL0s+K1
        YyaYcFV4DUJ0N1Ur1F94JyzbxmBHkY/M5/SaH0uR6Yyl6xUfro/YmDeHXk1aRxYNWTR3mLkRVt8Yt
        tdT3MYFQmsZWm4JUlZdK17gfaXAMHz1JXDFO8zp1aaJmYA30iCcavxnTpqV3OI9+FNMmuQl6WOM3z
        66J0tSHex8Yp1f/C9sJ8kIwvK3YpJ6Wr9paMlqM7YXJI4VvRnGuHStbapwNCZe7tfWS8YSScFLac8
        XqztaPoVOlxGH5gsKX+nhs3e+GDdw8bTqRjn6kBurD+ChcTtnDABNmNBDBacU9a/Q35yqbWtcK52b
        k+rhl4OA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-J5; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 22/32] evaluate: insert byte-order conversions for expressions between 9 and 15 bits
Date:   Mon,  4 Apr 2022 13:14:00 +0100
Message-Id: <20220404121410.188509-23-jeremy@azazel.net>
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

Round up expression lengths when determining whether to insert a
byte-order conversion.  For example, if one is masking a network header
which spans a byte boundary, the mask will span two bytes and so it will
need to be in NBO.

Fixes: bb03cbcd18a1 ("evaluate: no need to swap byte-order for values of fewer than 16 bits.")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c              | 2 +-
 tests/py/ip6/ct.t.payload   | 2 ++
 tests/py/ip6/meta.t.payload | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e19f6300fe2c..6b1e295d216a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -158,7 +158,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
-	if (expr_is_constant(*expr) || (*expr)->len / BITS_PER_BYTE < 2)
+	if (expr_is_constant(*expr) || div_round_up((*expr)->len, BITS_PER_BYTE) < 2)
 		(*expr)->byteorder = byteorder;
 	else {
 		op = byteorder_conversion_op(*expr, byteorder);
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 580c8d8d5712..a0565d14e15e 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -3,6 +3,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
@@ -12,6 +13,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index 49d7b42b0179..3cb0a587a5e7 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -66,6 +66,7 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
@@ -75,6 +76,7 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
-- 
2.35.1

