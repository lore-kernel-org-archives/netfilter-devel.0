Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258EDECE595
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A1F207FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MeTOte+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51200 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732353AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aN+O3kKZELULojA7fH218brBujoNjSOV2qsZR4V+mmM=; b=MeTOte+0Gf1YKx1PVkHsptoUbr
        F2RgjjVa3D7i5Z5MlJPLe3mDpKhS2Zg7/P0oa8U739RlOR3hisvqiMNxNbsj7PexGK4W74ayKrndk
        +VHjj3ZZP7jfuYco+l4e/elLB7JmPl6WbvFYpVivcv//uWousq2a3LdqJpl8ArVVlFOHOcQjioR+s
        0revj4nd3INhuUx9EiU7wqJOgD2hvfTJCZAEpAbLu4jmzqKATUNFA2dzKRO9ijZOZ19/w/9eX5SIq
        AHMuIi4FhYjQq+cO90xIOp0vRMjSp2uZYG42jyDZgUkdI6ZV/3ERXa8TU/oeWz6nrpAOoDFggIvCW
        qGrFG1lw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cq-0004KM-PO; Thu, 03 Oct 2019 20:56:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 6/7] netfilter: ipset: move function to ip_set_bitmap_ip.c.
Date:   Thu,  3 Oct 2019 20:56:06 +0100
Message-Id: <20191003195607.13180-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003195607.13180-1-jeremy@azazel.net>
References: <20191003195607.13180-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One inline function in ip_set_bitmap.h is only called in
ip_set_bitmap_ip.c: move it and remove inline function specifier.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set_bitmap.h | 14 --------------
 net/netfilter/ipset/ip_set_bitmap_ip.c        | 12 ++++++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_bitmap.h b/include/linux/netfilter/ipset/ip_set_bitmap.h
index 2dddbc6dcac7..fcc4d214a788 100644
--- a/include/linux/netfilter/ipset/ip_set_bitmap.h
+++ b/include/linux/netfilter/ipset/ip_set_bitmap.h
@@ -12,18 +12,4 @@ enum {
 	IPSET_ADD_START_STORED_TIMEOUT,
 };
 
-/* Common functions */
-
-static inline u32
-range_to_mask(u32 from, u32 to, u8 *bits)
-{
-	u32 mask = 0xFFFFFFFE;
-
-	*bits = 32;
-	while (--(*bits) > 0 && mask && (to & mask) != from)
-		mask <<= 1;
-
-	return mask;
-}
-
 #endif /* __IP_SET_BITMAP_H */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index c06172d5b017..abe8f77d7d23 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -237,6 +237,18 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	return true;
 }
 
+static u32
+range_to_mask(u32 from, u32 to, u8 *bits)
+{
+	u32 mask = 0xFFFFFFFE;
+
+	*bits = 32;
+	while (--(*bits) > 0 && mask && (to & mask) != from)
+		mask <<= 1;
+
+	return mask;
+}
+
 static int
 bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		 u32 flags)
-- 
2.23.0

