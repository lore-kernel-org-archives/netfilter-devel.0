Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05338C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCGXXP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCGXXO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:23:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7039BB8
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j9BlUKRZPFBvSu4D9TZFLP92BqcxK9utnkUFZhO9TzE=; b=kkUyGimYJ6HtPWCGMQPhcPIsU5
        NDyDXwjJHHttZbwj8y8YWkRGakGyU1XTat2nq+6EUDF/anIGEIiybZKYaoKkVpg1BUCHtSX9OW49B
        N6CeXjezBWG++W25Q+PDgkNLjIDnSZzRgZBMlNQtsl2Za3ciUBwbd55IJGPbrCD3kYJlc7UJLscl9
        4CkYbtNB1Iz5khNWn8BWo+X/qRbA1WYFnFM6M6gCvZkP9nHRFop2odzHbKFRlipp+o9GN7wUOQCZm
        NJI9+U3tFI2HP4TCN1brwcjkxtCOFt56XrNLqyYxMHa1DuCSTNR/nLbsRqmrfVtGlOrDSe7ItOKAJ
        1AL4cUow==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgeA-00H2Fp-03
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:23:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf 3/4] netfilter: nft_redir: correct length for loading protocol registers
Date:   Tue,  7 Mar 2023 23:22:58 +0000
Message-Id: <20230307232259.2681135-4-jeremy@azazel.net>
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

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5f7739987559..dbc642f5d32a 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
-- 
2.39.2

