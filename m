Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7D1C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C2A207FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="LF3k2SCS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733145AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51196 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732906AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=25pxK9X5je3VtsrDflnLj9EVj9+9E0tmpimVSJWZrZ0=; b=LF3k2SCSGLSh1VjfsXX+59kuAX
        VdTgOH1dqAUSMxCM4Vw0JweNtBhDrvypUctLMkRbEryQwLx6UUhAZRX0+xNBElFZFlClwqQU93/hm
        IaUfdZ2B5qbs64hNenltwOMpbnuIxQvkZuqshCFVJm339lx/XKfvvX+UjtKF0hz4dufR4lhVCXSrN
        V086jXDjpVB16XmWyXoz1ui0+kyXwruOJdysKJElxpImHQr3YkPcD0Q4flSCeWG05AqVl7YK2z9+k
        qLBKyedsZ5a0/D19axVW1MJvuvJSj5SOephk6OvWMk88SU14H20LXlHhHtGABWHKq7SJYTBoUwtSt
        LtIK/M5w==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cq-0004KM-Jf; Thu, 03 Oct 2019 20:56:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 5/7] netfilter: ipset: make ip_set_put_flags extern.
Date:   Thu,  3 Oct 2019 20:56:05 +0100
Message-Id: <20191003195607.13180-6-jeremy@azazel.net>
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

ip_set_put_flags is rather large for a static inline function in a
header-file.  Move it to ip_set_core.c and export it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h | 23 +----------------------
 net/netfilter/ipset/ip_set_core.c      | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 44f6de8a1733..4d8b1eaf7708 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -276,28 +276,7 @@ ip_set_ext_destroy(struct ip_set *set, void *data)
 	}
 }
 
-static inline int
-ip_set_put_flags(struct sk_buff *skb, struct ip_set *set)
-{
-	u32 cadt_flags = 0;
-
-	if (SET_WITH_TIMEOUT(set))
-		if (unlikely(nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
-					   htonl(set->timeout))))
-			return -EMSGSIZE;
-	if (SET_WITH_COUNTER(set))
-		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
-	if (SET_WITH_COMMENT(set))
-		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
-	if (SET_WITH_SKBINFO(set))
-		cadt_flags |= IPSET_FLAG_WITH_SKBINFO;
-	if (SET_WITH_FORCEADD(set))
-		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
-
-	if (!cadt_flags)
-		return 0;
-	return nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(cadt_flags));
-}
+int ip_set_put_flags(struct sk_buff *skb, struct ip_set *set);
 
 /* Netlink CB args */
 enum {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 30bc7df2f4cf..35cf59e4004b 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1418,6 +1418,30 @@ static int ip_set_swap(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 #define DUMP_TYPE(arg)		(((u32)(arg)) & 0x0000FFFF)
 #define DUMP_FLAGS(arg)		(((u32)(arg)) >> 16)
 
+int
+ip_set_put_flags(struct sk_buff *skb, struct ip_set *set)
+{
+	u32 cadt_flags = 0;
+
+	if (SET_WITH_TIMEOUT(set))
+		if (unlikely(nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
+					   htonl(set->timeout))))
+			return -EMSGSIZE;
+	if (SET_WITH_COUNTER(set))
+		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
+	if (SET_WITH_COMMENT(set))
+		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
+	if (SET_WITH_SKBINFO(set))
+		cadt_flags |= IPSET_FLAG_WITH_SKBINFO;
+	if (SET_WITH_FORCEADD(set))
+		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
+
+	if (!cadt_flags)
+		return 0;
+	return nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(cadt_flags));
+}
+EXPORT_SYMBOL_GPL(ip_set_put_flags);
+
 static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
-- 
2.23.0

