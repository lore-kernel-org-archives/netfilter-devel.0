Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1133C32792
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FCC9207FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="b2hp4HoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51204 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730787AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pFHlPWOruoSSFudH+Z886m2smWql7QxMrN/iWyy9oQg=; b=b2hp4HoPUyC248mPpaQwhZ71DH
        DysFNSKGDVY8CcKfYlo1MCA1gxQ8FfcL3/KQYwDLiUOv/UpIaSncAgSA5PyKfMWLm5DZGAOulWWTr
        LB0m+f7jNyZR4R3vQte5ZtdLhYcE2tQ9J08bIsZnfS0OPMRTBXjoJo/2PIwnrV9Ii4dhjHps7sqv9
        92oR4JotQWZFU/KawmcibZu1JsrbJYeahQpmVxCLgC347v26jtXiTXgx0R6q/iCTT+IriMDRYrlVW
        hH5yaPc46NZzr6ZPxObmQGs24hFr3OxMfgatNSOWnM9/9O3B2vRCsvrEMPsIRTtafCpr4RUFWWMwj
        oW/rJuqA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cq-0004KM-UZ; Thu, 03 Oct 2019 20:56:09 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 7/7] netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c.
Date:   Thu,  3 Oct 2019 20:56:07 +0100
Message-Id: <20191003195607.13180-8-jeremy@azazel.net>
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

ip_set_get_ip_port() is only used in ip_set_bitmap_port.c.  Move it
there and make it static.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../linux/netfilter/ipset/ip_set_getport.h    |  3 --
 net/netfilter/ipset/ip_set_bitmap_port.c      | 27 ++++++++++++++++++
 net/netfilter/ipset/ip_set_getport.c          | 28 -------------------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index d74cd112b88a..1ecaabd9a048 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -20,9 +20,6 @@ static inline bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 }
 #endif
 
-extern bool ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src,
-				__be16 *port);
-
 static inline bool ip_set_proto_with_ports(u8 proto)
 {
 	switch (proto) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 72fede25469d..23d6095cb196 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -96,6 +96,33 @@ bitmap_port_do_head(struct sk_buff *skb, const struct bitmap_port *map)
 	       nla_put_net16(skb, IPSET_ATTR_PORT_TO, htons(map->last_port));
 }
 
+static bool
+ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
+{
+	bool ret;
+	u8 proto;
+
+	switch (pf) {
+	case NFPROTO_IPV4:
+		ret = ip_set_get_ip4_port(skb, src, port, &proto);
+		break;
+	case NFPROTO_IPV6:
+		ret = ip_set_get_ip6_port(skb, src, port, &proto);
+		break;
+	default:
+		return false;
+	}
+	if (!ret)
+		return ret;
+	switch (proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int
 bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 		 const struct xt_action_param *par,
diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 2b8f959574b4..36615eb3eae1 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -148,31 +148,3 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
 #endif
-
-bool
-ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
-{
-	bool ret;
-	u8 proto;
-
-	switch (pf) {
-	case NFPROTO_IPV4:
-		ret = ip_set_get_ip4_port(skb, src, port, &proto);
-		break;
-	case NFPROTO_IPV6:
-		ret = ip_set_get_ip6_port(skb, src, port, &proto);
-		break;
-	default:
-		return false;
-	}
-	if (!ret)
-		return ret;
-	switch (proto) {
-	case IPPROTO_TCP:
-	case IPPROTO_UDP:
-		return true;
-	default:
-		return false;
-	}
-}
-EXPORT_SYMBOL_GPL(ip_set_get_ip_port);
-- 
2.23.0

