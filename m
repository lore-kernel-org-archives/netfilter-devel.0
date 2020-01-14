Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFFFC33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 374EE24656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WetfohzY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgANV3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:29:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55090 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgANV3V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hiaTWRqqmj3j+x2r8twgHR9v0Fvrvn19oiP1AW/TsoI=; b=WetfohzYWmhlMkogXmTRSnEzVL
        UnzB3bd9OGt8/spQ8znrReIj5QiQcrz7zELLQ4iGAwuJSnSZxL9tJsuXCBf0L1F2ym9tYz/OZLxLB
        VvqiCfw/P7js4NiPFHz6iWdTzmlQ2sZsB05OgGVyZNonDH0K9bZONVDJ/qi9nSE4MIHxuM0d5GmSM
        3uVWfWw+F18jKzE92vJ2VChpJgzbseZFEdNDuH94EECkngADj8Zjj8a9E6ulEAG0504kWArjyFA2k
        j+Qf7Cu7PvWUBlB1O5JYseHNz1VI8x1MCZsywGN4tczm2tc55KI38hstJ3NFKFjoaEHsJWrK87K1k
        0uFBpmPg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkV-0001Dh-Ue; Tue, 14 Jan 2020 21:29:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 08/10] netfilter: bitwise: only offload boolean operations.
Date:   Tue, 14 Jan 2020 21:29:16 +0000
Message-Id: <20200114212918.134062-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114212918.134062-1-jeremy@azazel.net>
References: <20200114212918.134062-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only boolean operations supports offloading, so check the type of the
operation and return an error for other types.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 40272a45deeb..1d9079ba2102 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -190,6 +190,9 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	    priv->sreg != priv->dreg || priv->len != reg->len)
 		return -EOPNOTSUPP;
 
+	if (priv->op != NFT_BITWISE_BOOL)
+		return -EOPNOTSUPP;
+
 	memcpy(&reg->mask, &priv->mask, sizeof(priv->mask));
 
 	return 0;
-- 
2.24.1

