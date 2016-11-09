From: David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH] netfilter: Update ip_route_me_harder to consider L3 domain
Date: Wed,  9 Nov 2016 10:24:40 -0800
Message-ID: <1478715880-18952-1-git-send-email-dsa@cumulusnetworks.com>
Cc: netfilter-devel@vger.kernel.org,
        David Ahern <dsa@cumulusnetworks.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36681 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbcKISYv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 13:24:51 -0500
Received: by mail-pf0-f173.google.com with SMTP id 189so130866332pfz.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 10:24:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip_route_me_harder is not considering the L3 domain and sending lookups
to the wrong table. For example consider the following output rule:

iptables -I OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset

using perf to analyze lookups via the fib_table_lookup tracepoint shows:

vrf-test  1187 [001] 46887.295927: fib:fib_table_lookup: table 255 oif 0 iif 0 src 0.0.0.0 dst 10.100.1.254 tos 0 scope 0 flags 0
        ffffffff8143922c perf_trace_fib_table_lookup ([kernel.kallsyms])
        ffffffff81493aac fib_table_lookup ([kernel.kallsyms])
        ffffffff8148dda3 __inet_dev_addr_type ([kernel.kallsyms])
        ffffffff8148ddf6 inet_addr_type ([kernel.kallsyms])
        ffffffff8149e344 ip_route_me_harder ([kernel.kallsyms])

and

vrf-test  1187 [001] 46887.295933: fib:fib_table_lookup: table 255 oif 0 iif 1 src 10.100.1.254 dst 10.100.1.2 tos 0 scope 0 flags
        ffffffff8143922c perf_trace_fib_table_lookup ([kernel.kallsyms])
        ffffffff81493aac fib_table_lookup ([kernel.kallsyms])
        ffffffff814998ff fib4_rule_action ([kernel.kallsyms])
        ffffffff81437f35 fib_rules_lookup ([kernel.kallsyms])
        ffffffff81499758 __fib_lookup ([kernel.kallsyms])
        ffffffff8144f010 fib_lookup.constprop.34 ([kernel.kallsyms])
        ffffffff8144f759 __ip_route_output_key_hash ([kernel.kallsyms])
        ffffffff8144fc6a ip_route_output_flow ([kernel.kallsyms])
        ffffffff8149e39b ip_route_me_harder ([kernel.kallsyms])

In both cases the lookups are directed to table 255 rather than the
table associated with the device via the L3 domain. Update both
lookups to pull the L3 domain from the dst currently attached to the
skb.

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
---
 net/ipv4/netfilter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index c3776ff6749f..b3cc1335adbc 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -24,10 +24,11 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
 	struct flowi4 fl4 = {};
 	__be32 saddr = iph->saddr;
 	__u8 flags = skb->sk ? inet_sk_flowi_flags(skb->sk) : 0;
+	struct net_device *dev = skb_dst(skb)->dev;
 	unsigned int hh_len;
 
 	if (addr_type == RTN_UNSPEC)
-		addr_type = inet_addr_type(net, saddr);
+		addr_type = inet_addr_type_dev_table(net, dev, saddr);
 	if (addr_type == RTN_LOCAL || addr_type == RTN_UNICAST)
 		flags |= FLOWI_FLAG_ANYSRC;
 	else
@@ -40,6 +41,8 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
 	fl4.saddr = saddr;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_oif = skb->sk ? skb->sk->sk_bound_dev_if : 0;
+	if (!fl4.flowi4_oif)
+		fl4.flowi4_oif = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
 	fl4.flowi4_flags = flags;
 	rt = ip_route_output_key(net, &fl4);
-- 
2.1.4

