From: Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH nf] netfilter: set again FLOWI_FLAG_KNOWN_NH at flowi6_flags
Date: Thu, 26 May 2016 19:08:10 +0200
Message-ID: <57f1193ae2ca44c7a901cab0b0f53d603afdca04.1464262477.git.pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbcEZRIX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2016 13:08:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the commit 48e8aa6e3137 ("ipv6: Set FLOWI_FLAG_KNOWN_NH at
flowi6_flags") ip6_pol_route() callers were asked to to set the
FLOWI_FLAG_KNOWN_NH properly and xt_TEE was updated accordingly,
but with the later refactor in commit bbde9fc1824a ("netfilter:
factor out packet duplication for IPv4/IPv6") the flowi6_flags
update was lost.
This commit re-add it just before the routing decision.

Fixes: bbde9fc1824a ("netfilter: factor out packet duplication for IPv4/IPv6")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv6/netfilter/nf_dup_ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6989c70..4a84b5a 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -33,6 +33,7 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 	fl6.daddr = *gw;
 	fl6.flowlabel = (__force __be32)(((iph->flow_lbl[0] & 0xF) << 16) |
 			(iph->flow_lbl[1] << 8) | iph->flow_lbl[2]);
+	fl6.flowi6_flags = FLOWI_FLAG_KNOWN_NH;
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst->error) {
 		dst_release(dst);
-- 
1.8.3.1

