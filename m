Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C40EEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 19:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjFSTIW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 15:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjFSTIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 15:08:21 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABE5E68
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HzPUxAzqHLAG4hAhWPiwcJe9Z0y256FlkONLwGFCP7k=; b=f1H4/xy23BGl9mqku4xF1NETvZ
        xzVaHM47tlXZGxsr3C9w78EubVf3++2k2gA8CkqmeL1dHwPHqTGL/fKS/kLlgW8jeOXBy1e8Or96E
        FkdadlnJmImSVf0Tr5h8CQcX944fylOTlj6Ea7CGM+Nre/Ow+l0BfioCnKI5JN1Xhl/n/6JvQwX09
        rrBXEzUnX1csEsQG1H5ZjCUGOU8bLQmjkovbq0HcEDQGd5HB0NOoiiZNZ6gwe37XZaa9RWluFKFAb
        fC6Vg+QSx5rCEAyxV8EQu08QE+EnKOy7WBpXV50auneTab4Y72B9aGdLxRHPOKy7eoxByMq6SvFkc
        ZuP7gvyQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBKEZ-008EPd-0I
        for netfilter-devel@vger.kernel.org;
        Mon, 19 Jun 2023 20:08:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf v2] lib/ts_bm: reset initial match offset for every block of text
Date:   Mon, 19 Jun 2023 20:06:57 +0100
Message-Id: <20230619190657.1905910-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `shift` variable which indicates the offset in the string at which
to start matching the pattern is initialized to `bm->patlen - 1`, but it
is not reset when a new block is retrieved.  This means the implemen-
tation may start looking at later and later positions in each successive
block and miss occurrences of the pattern at the beginning.  E.g.,
consider a HTTP packet held in a non-linear skb, where the HTTP request
line occurs in the second block:

  [... 52 bytes of packet headers ...]
  GET /bmtest HTTP/1.1\r\nHost: www.example.com\r\n\r\n

and the pattern is "GET /bmtest".

Once the first block comprising the packet headers has been examined,
`shift` will be pointing to somewhere near the end of the block, and so
when the second block is examined the request line at the beginning will
be missed.

Reinitialize the variable for each new block.

Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infrastructure strike #2")
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1390
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
Changes since v1

 The indentation and white-space fixes have been moved into a separate patch.

 lib/ts_bm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 1f2234221dd1..c8ecbf74ef29 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -60,10 +60,12 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 	struct ts_bm *bm = ts_config_priv(conf);
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
-	int shift = bm->patlen - 1, bs;
+	int bs;
 	const u8 icase = conf->flags & TS_IGNORECASE;
 
 	for (;;) {
+		int shift = bm->patlen - 1;
+
 		text_len = conf->get_next_block(consumed, &text, conf, state);
 
 		if (unlikely(text_len == 0))
-- 
2.39.2

