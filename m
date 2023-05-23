Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FFDC7EE26
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 May 2023 17:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbjEWR3l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 May 2023 13:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbjEWR3h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2023 13:29:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DECE90
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2023 10:29:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q1VpD-0004LP-AU
        for netfilter-devel@vger.kernel.org; Tue, 23 May 2023 19:29:31 +0200
Date:   Tue, 23 May 2023 19:29:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: nftables; key update with symbolic values/immediates
Message-ID: <20230523172931.GB17561@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

Consider following example:

table ip t {
	set s {
		type ipv4_addr . ipv4_addr . inet_service
		size 65535
		flags dynamic, timeout
		timeout 3h
	}

	chain c1 {
		update @s { ip saddr . 10.180.0.4 . 80 }
	}

	chain c2 {
		ip saddr . 1.2.3.4 . 80 @s goto c1
	}
}

This doesn't work:
:13:14-20: Error: Can't parse symbolic invalid expressions
ip saddr . 1.2.3.4 . 80 @s goto c1

Problem is that expr_evaluate_relational() first evaluates
the lhs, so by the time concat evaluation encounters '1.2.3.4'
symbol there is nothing that would hint at what datatype that is.

For this specific case, its possible to first evaluate the rhs, i.e.:

--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2336,8 +2336,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
        struct expr *range;
        int ret;
 
+       right = rel->right;
+       if (right->etype == EXPR_SYMBOL &&
+           right->symtype == SYMBOL_SET &&
+           expr_evaluate(ctx, &rel->right) < 0)
+               return -1;
+

This populates ectx->key and thus allows to infer the symbolic data
type:

1485                 if (key) {
1486                         tmp = key->dtype;
1487                         dsize = key->len;
1488                         bo = key->byteorder;
1489                         off--;
1490                 } else if (dtype == NULL || off == 0) {
1491                         tmp = datatype_lookup(TYPE_INVALID);

line 1486ff.  With unmodified nft, this hits the 'dtype == NULL' path
and decoding "1.2.3.4" fails.

What do you think?  If you think this is fine I can work on this,
above patch makes nft parse the example above, it needs more work on
delinarization path.
