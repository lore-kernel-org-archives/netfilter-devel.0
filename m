Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587BAC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbiDDMQf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbiDDMQb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF54213DC1
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YVmbkuqi1rc0xTLDE/DAbxz4qh95O7ki9swpcRbb7N4=; b=JNpBlXPcN5xfGHEi86aYz41iRA
        Hk0Zh99Lsp5dQRFhl46sJoE7U34ivGQdOAgRhOXgx6onCLphg3rEasYancKcHUCKlySnf2GLsQwpA
        O/92oHNAeMz/YFOqlxpCQfBYlsnH7j3vCivRzPUjSgOGi07tQEBYC+BPX9xns/wlQNQVdBNLtuauu
        z8WBBD36tCZ3IlZwdPNZpELe3noQS+lB7/Sq/ytgbKUfGhVINgxyU3VrjBhKlUPxltsmnT6Dv1SF8
        IREuYAQuWEPPGQLuaVkG3KAPhlxH5OPPM9of2HaDXchU+hOxBhYQRD9P++6WygOkpwELixCZpHmCb
        5N2yPmxQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-4q; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 08/32] netlink: send bit-length of bitwise binops to kernel
Date:   Mon,  4 Apr 2022 13:13:46 +0100
Message-Id: <20220404121410.188509-9-jeremy@azazel.net>
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

Some bitwise operations are generated when munging paylod expressions.
During delinearization, we attempt to eliminate these operations.
However, this is done before deducing the byte-order or the correct
length in bits of the operands, which means that we don't always handle
multi-byte host-endian operations correctly.  Therefore, pass the
bit-length of these expressions to the kernel in order to have it
available during delinearization.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 14 ++++++++++++--
 src/netlink_linearize.c   |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a1b00dee209a..733977bc526d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -451,20 +451,28 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 					       const struct nftnl_expr *nle,
 					       enum nft_registers sreg,
 					       struct expr *left)
-
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *mask, *xor, *or;
+	unsigned int nbits;
 	mpz_t m, x, o;
 
 	expr = left;
 
+	nbits = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_NBITS);
+	if (nbits > 0)
+		expr->len = nbits;
+
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_MASK, &nld.len);
 	mask = netlink_alloc_value(loc, &nld);
+	if (nbits > 0)
+		mpz_switch_byteorder(mask->value, div_round_up(nbits, BITS_PER_BYTE));
 	mpz_init_set(m, mask->value);
 
 	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_XOR, &nld.len);
-	xor  = netlink_alloc_value(loc, &nld);
+	xor = netlink_alloc_value(loc, &nld);
+	if (nbits > 0)
+		mpz_switch_byteorder(xor->value, div_round_up(nbits, BITS_PER_BYTE));
 	mpz_init_set(x, xor->value);
 
 	mpz_init_set_ui(o, 0);
@@ -500,6 +508,8 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 
 		or = netlink_alloc_value(loc, &nld);
 		mpz_set(or->value, o);
+		if (nbits > 0)
+			mpz_switch_byteorder(or->value, div_round_up(nbits, BITS_PER_BYTE));
 		expr = binop_expr_alloc(loc, OP_OR, expr, or);
 		expr->len = left->len;
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c8bbcb7452b0..4793f3853bee 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -677,6 +677,8 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_NBITS, expr->len);
 
 	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
-- 
2.35.1

