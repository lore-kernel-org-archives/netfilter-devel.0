From: David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH] netfilter: Update nf_send_reset6 to consider L3 domain
Date: Wed,  9 Nov 2016 10:25:05 -0800
Message-ID: <1478715905-19005-1-git-send-email-dsa@cumulusnetworks.com>
Cc: netfilter-devel@vger.kernel.org,
        David Ahern <dsa@cumulusnetworks.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36789 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbcKISZM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 13:25:12 -0500
Received: by mail-pf0-f173.google.com with SMTP id 189so130871468pfz.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2016 10:25:11 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_send_reset6 is not considering the L3 domain and lookups are sent
to the wrong table. For example consider the following output rule:

ip6tables -A OUTPUT -p tcp --dport 12345 -j REJECT --reject-with tcp-reset

using perf to analyze lookups via the fib6_table_lookup tracepoint shows:

swapper     0 [001]   248.787816: fib6:fib6_table_lookup: table 255 oif 0 iif 1 src 2100:1::3 dst 2100:1:
        ffffffff81439cdc perf_trace_fib6_table_lookup ([kernel.kallsyms])
        ffffffff814c1ce3 trace_fib6_table_lookup ([kernel.kallsyms])
        ffffffff814c3e89 ip6_pol_route ([kernel.kallsyms])
        ffffffff814c40d5 ip6_pol_route_output ([kernel.kallsyms])
        ffffffff814e7b6f fib6_rule_action ([kernel.kallsyms])
        ffffffff81437f60 fib_rules_lookup ([kernel.kallsyms])
        ffffffff814e7c79 fib6_rule_lookup ([kernel.kallsyms])
        ffffffff814c2541 ip6_route_output_flags ([kernel.kallsyms])
                     528 nf_send_reset6 ([nf_reject_ipv6])

The lookup is directed to table 255 rather than the table associated with
the device via the L3 domain. Update nf_send_reset6 to pull the L3 domain
from the dst currently attached to the skb.

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index a5400223fd74..10090400c72f 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -156,6 +156,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.daddr = oip6h->saddr;
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
+	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst->error) {
-- 
2.1.4

