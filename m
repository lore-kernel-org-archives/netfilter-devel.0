From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: nf_reject: remove unused variable
Date: Tue,  7 Mar 2017 22:02:50 +0900
Message-ID: <20170307130250.16693-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36172 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdCGOGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 09:06:02 -0500
Received: by mail-pf0-f195.google.com with SMTP id j5so248779pfb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2017 06:05:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

variable oiph is not used.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 146d861..7cd8d0d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -104,7 +104,6 @@ EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
-	const struct iphdr *oiph;
 	struct iphdr *niph;
 	const struct tcphdr *oth;
 	struct tcphdr _oth;
@@ -116,8 +115,6 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
-	oiph = ip_hdr(oldskb);
-
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
 			 LL_MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
-- 
2.9.3

