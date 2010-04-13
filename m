From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/8] netfilter: xtables: remove old comments about reentrancy
Date: Tue, 13 Apr 2010 14:37:45 +0200
Message-ID: <1271162268-28131-7-git-send-email-jengelh@medozas.de>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44357 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0DMMiA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:38:00 -0400
In-Reply-To: <1271162268-28131-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c   |    2 --
 net/ipv4/netfilter/ipt_REJECT.c  |    3 ---
 net/ipv6/netfilter/ip6_tables.c  |    2 --
 net/ipv6/netfilter/ip6t_REJECT.c |    3 ---
 4 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 70900ec..bb5e0d9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -434,8 +434,6 @@ ipt_do_table(struct sk_buff *skb,
 			continue;
 		}
 
-		/* Targets which reenter must return
-		   abs. verdicts */
 		tgpar.target   = t->u.kernel.target;
 		tgpar.targinfo = t->data;
 
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index b026014..038fa0b 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -139,9 +139,6 @@ reject_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct ipt_reject_info *reject = par->targinfo;
 
-	/* WARNING: This code causes reentry within iptables.
-	   This means that the iptables jump stack is now crap.  We
-	   must return an absolute verdict. --RR */
 	switch (reject->with) {
 	case IPT_ICMP_NET_UNREACHABLE:
 		send_unreach(skb, ICMP_NET_UNREACH);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2a2770b..7afa117 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -451,8 +451,6 @@ ip6t_do_table(struct sk_buff *skb,
 			continue;
 		}
 
-		/* Targets which reenter must return
-		   abs. verdicts */
 		tgpar.target   = t->u.kernel.target;
 		tgpar.targinfo = t->data;
 
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 55b9b2d..dad9762 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -179,9 +179,6 @@ reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
 
 	pr_debug("%s: medium point\n", __func__);
-	/* WARNING: This code causes reentry within ip6tables.
-	   This means that the ip6tables jump stack is now crap.  We
-	   must return an absolute verdict. --RR */
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
 		send_unreach(net, skb, ICMPV6_NOROUTE, par->hooknum);
-- 
1.7.0.4

