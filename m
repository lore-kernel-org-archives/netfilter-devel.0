Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A270BEE49A6
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjHUTnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjHUTnH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:07 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11478EE
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AfVoxLeiyqUAFr4JmQ4D1StDNUFS+N5QekB3T4nz7Lo=; b=OuXEeSS8MU4T/zfd4G4W8dexFx
        ogHj14idTt1T1k1ZE61dxxdX6Bu15/vbglhXmSJOIsg9gqIAl0MrNeSH7dUVmBW4dgfWM0KfkgZTD
        tYMydPvjyUSZRSeJxr2329q2aS2hkFwBYLJkFmBWicwSbYV85X5RbGMskxOof0Y3B68ktMgVD2Ri1
        3K1h/T4ptq1/+ofuXKHKU2NV3MNUQ3qI6QBK2AIAeQ9b3zUlDu2amFRVHxoXR1phRSYAxJkQkENQG
        qHhJ8UFA+jUtqiznZ8bQ8hK3zRogxpG5x9XptHRsTndMYENaY2S8iXhw/lEN5wJjnD94kJAc7wHrO
        yoFqEnWg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-1f
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 02/11] printpkt: fix statement punctuator
Date:   Mon, 21 Aug 2023 20:42:28 +0100
Message-Id: <20230821194237.51139-3-jeremy@azazel.net>
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

Replace comma with semicolon.

Fixes: d4cf078cb71a ("add ukey_* function for key assignation")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/printpkt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/printpkt.c b/util/printpkt.c
index b9b47b2f63a0..11126b3c9af7 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -264,7 +264,7 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 					   ikey_get_u32(&res[KEY_ICMP_GATEWAY]) >> 24);
 			break;
 		case ICMP_REDIRECT:
-			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]),
+			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]);
 			buf_cur += sprintf(buf_cur, "GATEWAY=%s ",
 					   inet_ntop(AF_INET,
 						     &paddr,
-- 
2.40.1

