Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B5DEE49AA
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjHUTnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjHUTnH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:07 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B57FA
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xepZXcBmAG+zA4wwNaJiFAO0f+rneMnWUY3TeepppPc=; b=CF6QY6VhTFscLDCwf4YvzBxWx1
        1Ydyg8VzymnmDgiHMBjQjj+kCWJ+7F3aGW4mptOrJTwlYMlT8Rtp2LsU1aIzfo7raGEb0s0LjHf3I
        Y+YZD0rlXj4ihGx25xYYh2PdDLP2s1z8mhnVmQlbVKBEUOnp8+3ygf61w+l9XSWau3e9HSA+HznrP
        7MDc8zhI6C5cWA5yPMdBvRSMUSJ78ubwk+ADde2iQHx7ZuiVM0mAGvKQGmNsglVNC26TcAJi1R7N5
        J6BE7BXPKtzOsfJbNafckQhGagSYd+T8Z8XQUGEg+4N/gZMLCcRTdQo/u/whD64vaN+tvxay+bA91
        U9TGa5/g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-27
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 05/11] ip2hbin: store ipv6 address as integer
Date:   Mon, 21 Aug 2023 20:42:31 +0100
Message-Id: <20230821194237.51139-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821194237.51139-1-jeremy@azazel.net>
References: <20230821194237.51139-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By using `okey_set_u128` we keep track of the address size and
downstream plug-ins can distinguish the address family.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2HBIN.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
index 2711f9c3e12a..081616edbc51 100644
--- a/filter/ulogd_filter_IP2HBIN.c
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -157,15 +157,14 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 		if (pp_is_valid(inp, i)) {
 			switch (convfamily) {
 			case AF_INET:
-				okey_set_u32(&ret[i-START_KEY],
-					ntohl(ikey_get_u32(&inp[i])));
+				okey_set_u32(&ret[i - START_KEY],
+					     ntohl(ikey_get_u32(&inp[i])));
 				break;
 			case AF_INET6:
-				okey_set_ptr(&ret[i-START_KEY],
-					(struct in6_addr *)ikey_get_u128(&inp[i]));
+				okey_set_u128(&ret[i - START_KEY],
+					      ikey_get_u128(&inp[i]));
 				break;
 			default:
-				;
 				break;
 			}
 		}
-- 
2.40.1

