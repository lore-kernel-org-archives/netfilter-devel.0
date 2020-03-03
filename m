Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FFCC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DB65214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aYYMvUy2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgCCKOh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 05:14:37 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41974 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbgCCKOg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0RdP4924XGG3BJ8Qkthw8QlieG/3V3rD6+tsXlB5G6k=; b=aYYMvUy29rvmrSe5Q/aHh8JnF3
        AiIOyHdRVe0df03RKAUe9OnmeZ41OxoeYZ0pNT6HgGl1V5y2kN/EniVYWnwZwIqv+ylvFS26iXkMp
        9od/PP5fuPsi+TR0KlJjSTIG8d+pqHuoJcwYnokstL9s2jzbAt+cdgoRSGlROXAMQdXfpyClWxmq+
        4BNfMm2xsnQM7KdfZ05Gn4CcrOHX6P7Q5P/8TyUTlBizu5PUc1lqSNXdGUl0vaQBRHvKkUwBHs4OC
        opGbzi6zeMxgW+ISw2FXUovGtOrYFAnK10rW8ztQs4Tv8j7e6fvaVIpHRsMRGL9KCNsApVvf4gMNJ
        7U+RxFhA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AQ-00081M-Hb; Tue, 03 Mar 2020 09:48:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 11/18] evaluate: don't clobber binop bitmask lengths.
Date:   Tue,  3 Mar 2020 09:48:37 +0000
Message-Id: <20200303094844.26694-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In this example:

nft --debug=netlink add rule ip t c ip dscp set ip dscp
ip t c
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
  [ payload load 1b @ network header + 1 => reg 2 ]
  [ bitwise reg 2 = (reg=2 & 0x0000003c ) ^ 0x00000000 ]
  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]

The mask at line 4 should be 0xfc, not 0x3c.

Evaluation of the payload expression munges it from `ip dscp` to
`(ip dscp & 0xfc) >> 2`, because although `ip dscp` is only 6 bits long,
those 6 bits are the top bits in a byte, and to make the arithmetic
simpler when we perform comparisons and assignments, we mask and shift
the field.  When the AND expression is allocated, its length is
correctly set to 8.  However, when a binop is evaluated, it is assumed
that the length has not been set and is length is always set to the
length of the left operand, incorrectly to 6 in this case.  When the
bitwise netlink expression is generated, the length of the AND is used
to generate the mask, 0x3f, used in combining the binop's.  The upshot
of this is that the original mask gets mangled to 0x3c.

We can fix this by changing the evaluation of binops only to set the
op's length if it is not already set.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1db175007c2d..ff168434cd8f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1133,7 +1133,7 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 
 	op->dtype     = left->dtype;
 	op->byteorder = left->byteorder;
-	op->len	      = left->len;
+	op->len	      = op->len ? op->len : left->len;
 
 	if (expr_is_constant(left) && expr_is_constant(op->right))
 		return constant_binop_simplify(ctx, expr);
-- 
2.25.1

