From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] netfilter: nf_dup_ipv6: set again FLOWI_FLAG_KNOWN_NH at flowi6_flags
Date: Wed,  1 Jun 2016 14:03:22 +0200
Message-ID: <1464782604-19346-6-git-send-email-pablo@netfilter.org>
References: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52868 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736AbcFAMDk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 08:03:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 560E3129E145
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 44C2C2310AF
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC0E42310AA
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:33 +0200 (CEST)
In-Reply-To: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Paolo Abeni <pabeni@redhat.com>

With the commit 48e8aa6e3137 ("ipv6: Set FLOWI_FLAG_KNOWN_NH at
flowi6_flags") ip6_pol_route() callers were asked to to set the
FLOWI_FLAG_KNOWN_NH properly and xt_TEE was updated accordingly,
but with the later refactor in commit bbde9fc1824a ("netfilter:
factor out packet duplication for IPv4/IPv6") the flowi6_flags
update was lost.
This commit re-add it just before the routing decision.

Fixes: bbde9fc1824a ("netfilter: factor out packet duplication for IPv4/IPv6")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

