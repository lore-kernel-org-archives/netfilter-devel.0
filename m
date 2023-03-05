Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B183C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCEMeS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCEMeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96247EC55
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4J4XZ6sStYUVlf1GlQIUc9Im3N/yhzaIMeHurArerB8=; b=gUMF1xHaMNh7SuR6z/ukvdo2tv
        m3g1GabKIMFee/tmjRRkRIM3vfzCv32zA1885z1nPuzXLHQho8uJOas4QB7hZJkpl405RqmcvS7lg
        YmhUbvkp7pT6E1MLg0rTZ10+HNeJkpu8ckA74JtvFKSf1ZIEQ50u6EO/S3jVeX25l8MWJOuGULa3Q
        4OkYI7gJL3IDALJDbXll7ExFP6FLp/Y7tVnlZXcjCzK+huBrMqd7H06mepPUFCeEmXe39nuG79P3+
        kL+f7oHCHhWV8WxcplZp1dn9MEmbfLPQjfkH7rmIO6N2JfHAXVXysxvdVndaR4KxewNuFje5a68E2
        PGCTVhPw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ6-00E3og-Ne
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 04/13] netfilter: nft_nat: correct length for loading protocol registers
Date:   Sun,  5 Mar 2023 12:18:08 +0000
Message-Id: <20230305121817.2234734-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305121817.2234734-1-jeremy@azazel.net>
References: <20230305121817.2234734-1-jeremy@azazel.net>
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

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 047999150390..5c29915ab028 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -226,7 +226,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
-- 
2.39.2

