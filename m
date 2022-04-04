Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA6DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbiDDMQf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242407AbiDDMQb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2BD13D43
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P2f+wC1M2JRL8r3nyGaLcYjmx+gCj7V+d9tdnWG9i0Y=; b=AD5qelBLgZDuD+iADj7uDwHTRc
        YnCWfZ9olaHBMT2K/xkZmBDlEK8wEojQCmHsGV9MRKWcAq/iH19ikyCgRDIzXpfsOtxgDYFwyTL23
        V+DJ095msrvzLPSUhYGVTjSB7Ie2KUypA4DHoxkbn6RxxbBWZKz0B3IMao9elOz7p3fSPm3ZEb24m
        JGwkYtUXD0bOj0lVOOe/wzUSkXEqjTKaS+JV8W4hsdc7hNiFHYwLYWQ8FvoocLM/v6lmX83jvvdS4
        d6mbbIF5sFUhFL/B1vGSxqN4Y5DlPlecrOW8xVG4bv1Ns6U+9YMcYMSit7KJtFtcr29KqiIV9+lx+
        bzC1IV9w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-QH; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 04/32] datatype: support `NULL` symbol-tables when printing constants
Date:   Mon,  4 Apr 2022 13:13:42 +0100
Message-Id: <20220404121410.188509-5-jeremy@azazel.net>
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

If the symbol-table passed to `symbol_constant_print` is `NULL`, fall
back to printing the expression's base-type.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/datatype.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index b2e667cef2c6..668823b6c7b1 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -185,7 +185,7 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 			     struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
-	const struct symbolic_constant *s;
+	const struct symbolic_constant *s = NULL;
 	uint64_t val = 0;
 
 	/* Export the data in the correct byteorder for comparison */
@@ -193,12 +193,14 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
 			expr->byteorder, len);
 
-	for (s = tbl->symbols; s->identifier != NULL; s++) {
-		if (val == s->value)
-			break;
-	}
+	if (tbl != NULL)
+		for (s = tbl->symbols; s->identifier != NULL; s++) {
+			if (val == s->value)
+				break;
+		}
 
-	if (s->identifier == NULL || nft_output_numeric_symbol(octx))
+	if (s == NULL || s->identifier == NULL ||
+	    nft_output_numeric_symbol(octx))
 		return expr_basetype(expr)->print(expr, octx);
 
 	nft_print(octx, quotes ? "\"%s\"" : "%s", s->identifier);
-- 
2.35.1

