Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C00FC74A4B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCGXXS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCGXXP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:23:15 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CE23B670
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gxQJBiJSCP1Mw3mZ8P/rp2jypDJVUKWEsmOuVBRilZM=; b=XqiGiXRXKUi3w8fh6Y2QbxpiN+
        4pAN7wgVDIsHEQcwhROFycbMw7tpdTjeWdlad1toOFLg89cABD199RYx3oUsWUSLLFPViEwzxy8Yj
        wglHG35Tney3XbOTPH3U/vEcoL/4A6vuDpoxwVud8RbmH14FMNiSCzUOVACLijgiCbGUOrChEQvKr
        2pbhr6N7dc3QP4D3IvHzzzJVbuy4m7VdepmDRReVi/90EccuMllnNsmVOkduFHui91Wx81/+XCaoX
        vAD5zU8P6h+T19xWRYU7UYcYmya66WwXZmA08fFyfiV0hEz/ebpxwEmbxji528vMxKpipc535PG6/
        Wim9EK3w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZge9-00H2Fp-Tt
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:23:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf 2/4] netfilter: nft_masq: correct length for loading protocol registers
Date:   Tue,  7 Mar 2023 23:22:57 +0000
Message-Id: <20230307232259.2681135-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307232259.2681135-1-jeremy@azazel.net>
References: <20230307232259.2681135-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The values in the protocol registers are two bytes wide.  However, when
parsing the register loads, the code currently uses the larger 16-byte
size of a `union nf_inet_addr`.  Change it to use the (correct) size of
a `union nf_conntrack_man_proto` instead.

Fixes: 8a6bf5da1aef ("netfilter: nft_masq: support port range")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_masq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index e55e455275c4..9544c2f16998 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -43,7 +43,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	u32 plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
-- 
2.39.2

