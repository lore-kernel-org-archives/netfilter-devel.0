From: Sami Farin <safari-netfilter@safari.iki.fi>
Subject: xt_TARPIT update for 2.6.24
Date: Mon, 3 Mar 2008 13:21:05 +0200
Message-ID: <20080303112105.b6qnh5a2byk5lbq7@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:62400 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbYCCLVL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:21:11 -0500
Received: from safari.iki.fi (80.223.84.180) by pne-smtpout4-sn2.hy.skanova.net (7.3.129)
        id 478BE66300294886 for netfilter-devel@vger.kernel.org; Mon, 3 Mar 2008 12:21:09 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The version of xt_TARPIT which worked in 2.6.23, panics the kernel
with 2.6.24.  Fix below.

Current version of ipt_TARPIT.c in patch-o-matic-ng svn is dated
20070524.  I do not know of other places where TARPIT module could
be found.

diff --git a/net/netfilter/xt_TARPIT.c b/net/netfilter/xt_TARPIT.c
index 23574bd..927ff88 100644
--- a/net/netfilter/xt_TARPIT.c
+++ b/net/netfilter/xt_TARPIT.c
@@ -152,7 +152,7 @@ static inline void tarpit_tcp(struct sk_buff *oskb, unsigned int hook)
 #endif
 		addr_type = RTN_LOCAL;
 
-	if (ip_route_me_harder(&nskb, addr_type))
+	if (ip_route_me_harder(nskb, addr_type))
 		goto free_nskb;
 
 	/* Adjust IP TTL */
@@ -176,14 +176,13 @@ static inline void tarpit_tcp(struct sk_buff *oskb, unsigned int hook)
 	kfree_skb(nskb);
 }
 
-static unsigned int xt_tarpit_target(struct sk_buff **pskb,
+static unsigned int xt_tarpit_target(struct sk_buff *skb,
                                      const struct net_device *in,
                                      const struct net_device *out,
                                      unsigned int hooknum,
                                      const struct xt_target *target,
                                      const void *targinfo)
 {
-	struct sk_buff *skb       = *pskb;
 	const struct iphdr *iph   = ip_hdr(skb);
 	struct rtable *rt         = (void *)skb->dst;
 

-- 
Do what you love because life is too short for anything else.

