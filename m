From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH] ipv6: Preserve link scope traffic original oif
Date: Wed,  1 Mar 2017 14:47:23 +0100
Message-ID: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33581 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdCAOSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 09:18:51 -0500
Received: by mail-qk0-f194.google.com with SMTP id n186so10844377qkb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Mar 2017 06:18:13 -0800 (PST)
Received: from cplx250.edegem.eu.thmulti.com (14.125.146.82.ipv4.evonet.be. [82.146.125.14])
        by smtp.gmail.com with ESMTPSA id a69sm3158290qkj.60.2017.03.01.05.47.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2017 05:47:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Link-local and multicast packets must keep their original oif after
ip6_route_me_harder is called.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 net/ipv6/netfilter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 39970e2..02811c5 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,7 +24,8 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	struct flowi6 fl6 = {
-		.flowi6_oif = skb->sk ? skb->sk->sk_bound_dev_if : 0,
+		.flowi6_oif = skb->sk ? skb->sk->sk_bound_dev_if :
+			rt6_need_strict(&iph->daddr) ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, skb->sk),
 		.daddr = iph->daddr,
-- 
1.7.12.4

