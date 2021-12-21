Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17605C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241819AbhLUThR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbhLUThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAFBC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WG4WsYl8nNhsc5zxfqtm1aU1NsWVe1ViKhMBywAOVTU=; b=CQ+/PBJNEFh/WvRSxF/gzEw40o
        pdFhYndkJQ+F2u0eleerngyY80kVLu9I5thViaLLCJfjXeLVilosEjFvZdvIueCa6jAHMQefZe+RU
        pDYgdvpl7dnMukcDntQTVh3a0kSGCAw9epIDCvqvrCuhyb+r9dESNkT2L9gYZP+icD1twJ9adlBrJ
        KR5AthxkrN7EPBfrCnqks9N3OoEwelQguqqx5k9VeKnpnBVKUVtFTkmPRRz0ougpPCyn+KYURMPgi
        7dRus0FTbUaf7yKqg5fr9YwXADvCoOMZjztJP4qKfba7j+60rVGJV+yu7wB7jfqTKTSZMpjmZiBYr
        UuRYXhUg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-S1
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 04/11] netlink_delinearize: fix typo
Date:   Tue, 21 Dec 2021 19:36:50 +0000
Message-Id: <20211221193657.430866-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221193657.430866-1-jeremy@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Correct spelling in comment.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 323e9150cdf6..83be2fec441d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2057,7 +2057,7 @@ static bool __meta_dependency_may_kill(const struct expr *dep, uint8_t *nfproto)
 }
 
 /* We have seen a protocol key expression that restricts matching at the network
- * base, leave it in place since this is meaninful in bridge, inet and netdev
+ * base, leave it in place since this is meaningful in bridge, inet and netdev
  * families. Exceptions are ICMP and ICMPv6 where this code assumes that can
  * only happen with IPv4 and IPv6.
  */
-- 
2.34.1

