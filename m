From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 039/103] netfilter: xtables: dissolve do_match function
Date: Tue,  4 Aug 2009 09:25:23 +0200
Message-ID: <1249370787-17583-40-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbZHDH1P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:15 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |   22 +++++-----------------
 net/ipv6/netfilter/ip6_tables.c |   22 +++++-----------------
 2 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 55dd8ef..173b33b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -167,21 +167,6 @@ ipt_error(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-/* Performance critical - called for every packet */
-static inline bool
-do_match(const struct ipt_entry_match *m, const struct sk_buff *skb,
-	 struct xt_match_param *par)
-{
-	par->match     = m->u.kernel.match;
-	par->matchinfo = m->data;
-
-	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, par))
-		return true;
-	else
-		return false;
-}
-
 /* Performance critical */
 static inline struct ipt_entry *
 get_entry(const void *base, unsigned int offset)
@@ -373,9 +358,12 @@ ipt_do_table(struct sk_buff *skb,
 			continue;
 		}
 
-		xt_ematch_foreach(ematch, e)
-			if (do_match(ematch, skb, &mtpar) != 0)
+		xt_ematch_foreach(ematch, e) {
+			mtpar.match     = ematch->u.kernel.match;
+			mtpar.matchinfo = ematch->data;
+			if (!mtpar.match->match(skb, &mtpar))
 				goto no_match;
+		}
 
 		ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f7570cd..d9d5477 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -199,21 +199,6 @@ ip6t_error(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-/* Performance critical - called for every packet */
-static inline bool
-do_match(const struct ip6t_entry_match *m, const struct sk_buff *skb,
-	 struct xt_match_param *par)
-{
-	par->match     = m->u.kernel.match;
-	par->matchinfo = m->data;
-
-	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, par))
-		return true;
-	else
-		return false;
-}
-
 static inline struct ip6t_entry *
 get_entry(const void *base, unsigned int offset)
 {
@@ -396,9 +381,12 @@ ip6t_do_table(struct sk_buff *skb,
 			continue;
 		}
 
-		xt_ematch_foreach(ematch, e)
-			if (do_match(ematch, skb, &mtpar) != 0)
+		xt_ematch_foreach(ematch, e) {
+			mtpar.match     = ematch->u.kernel.match;
+			mtpar.matchinfo = ematch->data;
+			if (!mtpar.match->match(skb, &mtpar))
 				goto no_match;
+		}
 
 		ADD_COUNTER(e->counters,
 			    ntohs(ipv6_hdr(skb)->payload_len) +
-- 
1.6.3.3

