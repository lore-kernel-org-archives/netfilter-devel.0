Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6702C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 22:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjFEWMH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjFEWMG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 18:12:06 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A48106
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 15:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XjSDGU0dNvNgrpOyj9KMOfSJNjPJWWrKPtA8Rq2DxKY=; b=ZTCWdFc+VAUnt7IN9YW7pX56jb
        DykMOx6xjUnv/MyM1SO3MsWtSV3nZ/sC/f5XuHhM4ZN/DBA919Jl5kiMS0W3p4h+NePd6LcqxCBUj
        njOq2SCoj2JjTFf0J/kOM14lWECDyxtEFEf+dBVRY1N5DljUW6O5OGWx3GvtH72x35QdywSkbP4+K
        +fHd9b4KMLfXLXbeS8wPCGkHHM4ZeHKdMc+3FIq38QqBjreL4or4CmOsycSEDQBkhxdi8z5kDsrB3
        mmImbHJsLVaqzwC/hTqi7x3SP+Ci3B7N8uaD7E7/IBobBoTQTuvrkjq8gXZAWf1sqzem+RjWnUT64
        fXuWTksA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6IQl-00H5Wa-JP
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 23:12:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 2/7] xt_ipp2p: change byte-orer conversion
Date:   Mon,  5 Jun 2023 23:10:39 +0100
Message-Id: <20230605221044.140855-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605221044.140855-1-jeremy@azazel.net>
References: <20230605221044.140855-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of converting the packet bytes before comparing it to a constant,
convert the constant.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 5bdb7eec40d2..d2e29706998a 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -210,8 +210,8 @@ udp_search_bit(const unsigned char *haystack, const unsigned int packet_len)
 	switch (packet_len) {
 	case 16:
 		/* ^ 00 00 04 17 27 10 19 80 */
-		if (ntohl(get_u32(haystack, 0)) == 0x00000417 &&
-		    ntohl(get_u32(haystack, 4)) == 0x27101980)
+		if (get_u32(haystack, 0) == __constant_htonl(0x00000417) &&
+		    get_u32(haystack, 4) == __constant_htonl(0x27101980))
 			return IPP2P_BIT * 100 + 50;
 		break;
 	case 36:
-- 
2.39.2

