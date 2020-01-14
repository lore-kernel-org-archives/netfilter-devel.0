Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B55C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F31B524656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aduL6p4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgANV3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:29:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55066 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgANV3U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:29:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K0XVHq73UHlhQ/D84IiwnlA9Y6baVDh3zj2vjhXE6yI=; b=aduL6p4DVWlVkNgasYaqOUMsKR
        daU+k49jYTWx7lEnvSisaX7Qvo+QkmhwC+IWCzBKcxrFjERo1BbYwXOLWwVjiCONVfHXHu6L8yyFu
        TSRkEsDG6phgfmglulkTsqKlZL9AiUQhaIa4kaxH8bedyGoQTw0HPPH+uqfs/KmVUEib7KWlg8iO3
        qzDtRK9o1BvMkvnCFACwepRi2D2bYk8xd8pT2fWjYkvS/9xWyyD5AZzpmR4AU+EHwTuvEl3m3lbxA
        PVfEj+bxSEPL+KSevfAF3/p6m5gJwjW3dvN+x6HpiTPkgwg8kGR8HQ+zq5n8cp7MfIF1WfvRqEQtb
        quLjivfA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTkU-0001Dh-Rj; Tue, 14 Jan 2020 21:29:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 02/10] netfilter: bitwise: remove NULL comparisons from attribute checks.
Date:   Tue, 14 Jan 2020 21:29:10 +0000
Message-Id: <20200114212918.134062-3-jeremy@azazel.net>
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

In later patches, we will be adding more checks.  In order to be
consistent and prevent complaints from checkpatch.pl, replace the
existing comparisons with NULL with logical NOT operators.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index e8ca1ec105f8..85605fb1e360 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -52,11 +52,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	u32 len;
 	int err;
 
-	if (tb[NFTA_BITWISE_SREG] == NULL ||
-	    tb[NFTA_BITWISE_DREG] == NULL ||
-	    tb[NFTA_BITWISE_LEN] == NULL ||
-	    tb[NFTA_BITWISE_MASK] == NULL ||
-	    tb[NFTA_BITWISE_XOR] == NULL)
+	if (!tb[NFTA_BITWISE_SREG] ||
+	    !tb[NFTA_BITWISE_DREG] ||
+	    !tb[NFTA_BITWISE_LEN]  ||
+	    !tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
-- 
2.24.1

