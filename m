From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/11] netfilter: xtables: remove some goto
Date: Fri,  8 May 2009 11:26:38 +0200
Message-ID: <1241774801-2315-9-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53363 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZEHJ0o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:44 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Combining two ifs, and goto is easily gone.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |    7 ++-----
 net/ipv6/netfilter/ip6_tables.c |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 82888bc..cfcb7af 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -359,15 +359,12 @@ ipt_do_table(struct sk_buff *skb,
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		if (!ip_packet_match(ip, indev, outdev,
-		    &e->ip, mtpar.fragoff)) {
- no_match:
+		    &e->ip, mtpar.fragoff) ||
+		    IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0) {
 			e = ipt_next_entry(e);
 			continue;
 		}
 
-		if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
-			goto no_match;
-
 		ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
 
 		t = ipt_get_target(e);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a6c2213..d01b8a3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -386,15 +386,12 @@ ip6t_do_table(struct sk_buff *skb,
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
-		    &mtpar.thoff, &mtpar.fragoff, &hotdrop)) {
- no_match:
+		    &mtpar.thoff, &mtpar.fragoff, &hotdrop) ||
+		    IP6T_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0) {
 			e = ip6t_next_entry(e);
 			continue;
 		}
 
-		if (IP6T_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
-			goto no_match;
-
 		ADD_COUNTER(e->counters,
 			    ntohs(ipv6_hdr(skb)->payload_len) +
 			    sizeof(struct ipv6hdr), 1);
-- 
1.6.2.2

