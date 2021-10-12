Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79084C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E03E60F23
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 17:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhJLRca (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhJLRc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 13:32:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C38CC061570;
        Tue, 12 Oct 2021 10:30:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maLbb-0008Tz-2b; Tue, 12 Oct 2021 19:30:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     lvs-devel@vger.kernel.org, ja@ssi.bg, horms@verge.net.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 4/4] netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers
Date:   Tue, 12 Oct 2021 19:29:59 +0200
Message-Id: <20211012172959.745-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012172959.745-1-fw@strlen.de>
References: <20211012172959.745-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to earlier patches: allow ipv4 and ipv6 to use the
same handler.  ipv4 and ipv6 specific actions can be done by
checking state->pf.

v2: split the pf == NFPROTO_IPV4 check (Julian Anastasov)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_core.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ad5f5e50547f..e93c937a8bf0 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2106,40 +2106,31 @@ static unsigned int
 ip_vs_forward_icmp(void *priv, struct sk_buff *skb,
 		   const struct nf_hook_state *state)
 {
-	int r;
 	struct netns_ipvs *ipvs = net_ipvs(state->net);
-
-	if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
-		return NF_ACCEPT;
+	int r;
 
 	/* ipvs enabled in this netns ? */
 	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
 		return NF_ACCEPT;
 
-	return ip_vs_in_icmp(ipvs, skb, &r, state->hook);
-}
-
+	if (state->pf == NFPROTO_IPV4) {
+		if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
+			return NF_ACCEPT;
 #ifdef CONFIG_IP_VS_IPV6
-static unsigned int
-ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	int r;
-	struct netns_ipvs *ipvs = net_ipvs(state->net);
-	struct ip_vs_iphdr iphdr;
+	} else {
+		struct ip_vs_iphdr iphdr;
 
-	ip_vs_fill_iph_skb(AF_INET6, skb, false, &iphdr);
-	if (iphdr.protocol != IPPROTO_ICMPV6)
-		return NF_ACCEPT;
+		ip_vs_fill_iph_skb(AF_INET6, skb, false, &iphdr);
 
-	/* ipvs enabled in this netns ? */
-	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
-		return NF_ACCEPT;
+		if (iphdr.protocol != IPPROTO_ICMPV6)
+			return NF_ACCEPT;
 
-	return ip_vs_in_icmp_v6(ipvs, skb, &r, state->hook, &iphdr);
-}
+		return ip_vs_in_icmp_v6(ipvs, skb, &r, state->hook, &iphdr);
 #endif
+	}
 
+	return ip_vs_in_icmp(ipvs, skb, &r, state->hook);
+}
 
 static const struct nf_hook_ops ip_vs_ops4[] = {
 	/* After packet filtering, change source only for VS/NAT */
@@ -2224,7 +2215,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	/* After packet filtering (but before ip_vs_out_icmp), catch icmp
 	 * destined for 0.0.0.0/0, which is for incoming IPVS connections */
 	{
-		.hook		= ip_vs_forward_icmp_v6,
+		.hook		= ip_vs_forward_icmp,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 99,
-- 
2.32.0

