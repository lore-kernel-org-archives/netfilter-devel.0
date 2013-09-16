From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/4] netfilter: ipset: Skip really non-first fragments for IPv6 when getting port/protocol
Date: Mon, 16 Sep 2013 20:47:56 +0200
Message-ID: <1379357279-13361-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1379357279-13361-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:54684 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3IPSsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:48:00 -0400
In-Reply-To: <1379357279-13361-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_getport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 6fdf88a..dac156f 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -116,12 +116,12 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 {
 	int protoff;
 	u8 nexthdr;
-	__be16 frag_off;
+	__be16 frag_off = 0;
 
 	nexthdr = ipv6_hdr(skb)->nexthdr;
 	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
 				   &frag_off);
-	if (protoff < 0)
+	if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
 		return false;
 
 	return get_port(skb, nexthdr, protoff, src, port, proto);
-- 
1.7.0.4

