Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E2EC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3F42469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="lc76hcOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgB2LoY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:24 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49460 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgB2LoY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zk2N9w2BDQeiCgNqbkHj06Jl9c+xbE9zj+LfO6V+Ur4=; b=lc76hcOZnf/he/yXOFVcwtYmMp
        4zs9ucVLrwLE1ab39B+5k4Z68JKBfuUZyCAWolxiWdxOFQw1Dw0GNUVLI40WjJjX9Dq23Ku805SOs
        0P/WwPecgNoiUALDNDIzZdFvzAWRSMuJC8sJgIzeIjQP0+SFllzR/Z1WS1/J0Fmu8x/CSrlyXDDzJ
        61sFADtnBzt6W6qlD+7E7ixGXO3iXqNutmk/VNw2tx1/BImeKIsJFCBEmQbZCpzpPPG4IXClQdx9v
        iIQeYO3ilcvSswxmNkXuZMgS8G5c73P+nzPuK6JrjfALCaG4uP5AAF+H1d8M8PTLd5R6fh0AnTM6x
        63gL84ig==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HN-0003Wm-AT; Sat, 29 Feb 2020 11:27:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 11/18] netlink_linearize: round binop bitmask length up.
Date:   Sat, 29 Feb 2020 11:27:24 +0000
Message-Id: <20200229112731.796417-12-jeremy@azazel.net>
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
`(ip dscp & 0xfc) >> 2`.  When this AND expression is evaluated, its
length is set to 6, the length of `ip dscp`.  When the bitwise netlink
expression is generated, the length of the AND is used to generate the
mask, 0x3f, used in combining the binop's.  The upshot of this is that
the original mask gets mangled to 0x3c.  We can fix this by rounding the
length of the mask to the nearest byte.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_linearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b2987efbc49f..2e7ee5ae4de7 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -597,7 +597,7 @@ static void netlink_gen_bitwise_constant(struct netlink_linearize_ctx *ctx,
 
 	netlink_gen_expr(ctx, binops[n--], dreg);
 
-	mpz_bitmask(mask, expr->len);
+	mpz_bitmask(mask, round_up(expr->len, BITS_PER_BYTE));
 	mpz_set_ui(xor, 0);
 	for (; n >= 0; n--) {
 		i = binops[n];
-- 
2.25.0

