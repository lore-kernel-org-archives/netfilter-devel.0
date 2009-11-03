From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] netfilter: iptables: remove unused function arguments
Date: Tue,  3 Nov 2009 19:04:37 +0100
Message-ID: <1257271483-26772-2-git-send-email-jengelh@medozas.de>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43224 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbZKCSEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:04:40 -0500
In-Reply-To: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/iptable_mangle.c  |   10 +++-------
 net/ipv6/netfilter/ip6table_mangle.c |   10 +++-------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 4708d8f..2f79301 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -36,11 +36,7 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ipt_local_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *in,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+ipt_mangle_out(struct sk_buff *skb, const struct net_device *out)
 {
 	unsigned int ret;
 	const struct iphdr *iph;
@@ -60,7 +56,7 @@ ipt_local_hook(unsigned int hook,
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, hook, in, out,
+	ret = ipt_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
 			   dev_net(out)->ipv4.iptable_mangle);
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
@@ -86,7 +82,7 @@ iptable_mangle_hook(unsigned int hook,
 		     int (*okfn)(struct sk_buff *))
 {
 	if (hook == NF_INET_LOCAL_OUT)
-		return ipt_local_hook(hook, skb, in, out, okfn);
+		return ipt_mangle_out(skb, out);
 
 	/* PREROUTING/INPUT/FORWARD: */
 	return ipt_do_table(skb, hook, in, out,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index c86c838..cc6845e 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -30,12 +30,8 @@ static const struct xt_table packet_mangler = {
 };
 
 static unsigned int
-ip6t_local_out_hook(unsigned int hook,
-		   struct sk_buff *skb,
-		   const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+ip6t_mangle_out(struct sk_buff *skb, const struct net_device *out)
 {
-
 	unsigned int ret;
 	struct in6_addr saddr, daddr;
 	u_int8_t hop_limit;
@@ -60,7 +56,7 @@ ip6t_local_out_hook(unsigned int hook,
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, hook, NULL, out,
+	ret = ip6t_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
 			    dev_net(out)->ipv6.ip6table_mangle);
 
 	if (ret != NF_DROP && ret != NF_STOLEN
@@ -82,7 +78,7 @@ ip6table_mangle_hook(unsigned int hook,
 	 int (*okfn)(struct sk_buff *))
 {
 	if (hook == NF_INET_LOCAL_OUT)
-		return ip6t_local_out_hook(hook, skb, out, okfn);
+		return ip6t_mangle_out(skb, out);
 
 	/* INPUT/FORWARD */
 	return ip6t_do_table(skb, hook, in, out,
-- 
1.6.5.2

