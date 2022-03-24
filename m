Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D4BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 14:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbiCXOFR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 10:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCXOFQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 10:05:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB46BDE1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2022 07:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9/k/Nyxtkx98NaLvj4jr/itIEqSzDzBr/p/3F476Fik=; b=NQeoVHitcA204wZbuq/hm5hf35
        gPlEngR9y6oaDLf7fc7kjxp4qAfkp7wTNHCfIlvMhhNjBFvHCJA8poHIzFq1Nh+yB630D2aN6+BOA
        lkVJw+KyiJtDDdidNnw8RvlOzR8AyyKVwB715btyFSAi7G9oeeWKO9SNUOgEgw+5xb67ck8bneqTQ
        KeXjOPkvMm1rJlWhAy9mAAFfN+Rhnp2vN6XPGK1RhMdTfn/E23/1cbXJWrsLCIqUf7r7AMolk9s4d
        zPFJfM5UtI8iD3qpMaSb1f/TNNxVMASjqMhxra2HoqT6/MpzS/bE31eue3i4chDsPWPJYGCdkBdoi
        LtvQ2q5Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXO3y-0002xy-VD; Thu, 24 Mar 2022 15:03:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/2] netfilter: nf_log_syslog: Merge MAC header dumpers
Date:   Thu, 24 Mar 2022 15:03:40 +0100
Message-Id: <20220324140341.24259-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The functions for IPv4 and IPv6 were almost identical apart from extra
SIT tunnel device handling in the latter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_log_syslog.c | 91 ++++++++++-------------------------
 1 file changed, 25 insertions(+), 66 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 13234641cdb34..d1dcf36545d79 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -766,9 +766,9 @@ dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 		nf_log_buf_add(m, "MARK=0x%x ", skb->mark);
 }
 
-static void dump_ipv4_mac_header(struct nf_log_buf *m,
-				 const struct nf_loginfo *info,
-				 const struct sk_buff *skb)
+static void dump_mac_header(struct nf_log_buf *m,
+			    const struct nf_loginfo *info,
+			    const struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	unsigned int logflags = 0;
@@ -798,9 +798,26 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-		nf_log_buf_add(m, "%02x", *p++);
-		for (i = 1; i < dev->hard_header_len; i++, p++)
-			nf_log_buf_add(m, ":%02x", *p);
+		if (dev->type == ARPHRD_SIT) {
+			p -= ETH_HLEN;
+
+			if (p < skb->head)
+				p = NULL;
+		}
+
+		if (p) {
+			nf_log_buf_add(m, "%02x", *p++);
+			for (i = 1; i < dev->hard_header_len; i++)
+				nf_log_buf_add(m, ":%02x", *p++);
+		}
+
+		if (dev->type == ARPHRD_SIT) {
+			const struct iphdr *iph =
+				(struct iphdr *)skb_mac_header(skb);
+
+			nf_log_buf_add(m, " TUNNEL=%pI4->%pI4", &iph->saddr,
+				       &iph->daddr);
+		}
 	}
 	nf_log_buf_add(m, " ");
 }
@@ -827,7 +844,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 				  out, loginfo, prefix);
 
 	if (in)
-		dump_ipv4_mac_header(m, loginfo, skb);
+		dump_mac_header(m, loginfo, skb);
 
 	dump_ipv4_packet(net, m, loginfo, skb, 0);
 
@@ -841,64 +858,6 @@ static struct nf_logger nf_ip_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static void dump_ipv6_mac_header(struct nf_log_buf *m,
-				 const struct nf_loginfo *info,
-				 const struct sk_buff *skb)
-{
-	struct net_device *dev = skb->dev;
-	unsigned int logflags = 0;
-
-	if (info->type == NF_LOG_TYPE_LOG)
-		logflags = info->u.log.logflags;
-
-	if (!(logflags & NF_LOG_MACDECODE))
-		goto fallback;
-
-	switch (dev->type) {
-	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
-			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
-		nf_log_dump_vlan(m, skb);
-		nf_log_buf_add(m, "MACPROTO=%04x ",
-			       ntohs(eth_hdr(skb)->h_proto));
-		return;
-	default:
-		break;
-	}
-
-fallback:
-	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len &&
-	    skb->mac_header != skb->network_header) {
-		const unsigned char *p = skb_mac_header(skb);
-		unsigned int len = dev->hard_header_len;
-		unsigned int i;
-
-		if (dev->type == ARPHRD_SIT) {
-			p -= ETH_HLEN;
-
-			if (p < skb->head)
-				p = NULL;
-		}
-
-		if (p) {
-			nf_log_buf_add(m, "%02x", *p++);
-			for (i = 1; i < len; i++)
-				nf_log_buf_add(m, ":%02x", *p++);
-		}
-		nf_log_buf_add(m, " ");
-
-		if (dev->type == ARPHRD_SIT) {
-			const struct iphdr *iph =
-				(struct iphdr *)skb_mac_header(skb);
-			nf_log_buf_add(m, "TUNNEL=%pI4->%pI4 ", &iph->saddr,
-				       &iph->daddr);
-		}
-	} else {
-		nf_log_buf_add(m, " ");
-	}
-}
-
 static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 			      unsigned int hooknum, const struct sk_buff *skb,
 			      const struct net_device *in,
@@ -921,7 +880,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 				  loginfo, prefix);
 
 	if (in)
-		dump_ipv6_mac_header(m, loginfo, skb);
+		dump_mac_header(m, loginfo, skb);
 
 	dump_ipv6_packet(net, m, loginfo, skb, skb_network_offset(skb), 1);
 
-- 
2.34.1

