From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] netfilter: af_info: add network namespace parameter to route hook
Date: Mon, 21 Mar 2011 23:25:39 +0100
Message-ID: <1300746341-18011-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44483 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab1CUWbn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:31:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is required to eventually replace the rt6_lookup call in xt_addrtype.c
with nf_afinfo->route().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h              |    3 ++-
 net/ipv4/netfilter.c                   |    5 +++--
 net/ipv6/netfilter.c                   |    5 +++--
 net/netfilter/nf_conntrack_h323_main.c |   12 ++++++++----
 net/netfilter/xt_TCPMSS.c              |    2 +-
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index eeec00a..20ed452 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -270,7 +270,8 @@ struct nf_afinfo {
 					    unsigned int dataoff,
 					    unsigned int len,
 					    u_int8_t protocol);
-	int		(*route)(struct dst_entry **dst, struct flowi *fl);
+	int		(*route)(struct net *net, struct dst_entry **dst,
+				 struct flowi *fl);
 	void		(*saveroute)(const struct sk_buff *skb,
 				     struct nf_queue_entry *entry);
 	int		(*reroute)(struct sk_buff *skb,
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 994a1f2..138e106 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -217,9 +217,10 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	return csum;
 }
 
-static int nf_ip_route(struct dst_entry **dst, struct flowi *fl)
+static int nf_ip_route(struct net *net, struct dst_entry **dst,
+		       struct flowi *fl)
 {
-	return ip_route_output_key(&init_net, (struct rtable **)dst, fl);
+	return ip_route_output_key(net, (struct rtable **)dst, fl);
 }
 
 static const struct nf_afinfo nf_ip_afinfo = {
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 35915e8..9e1b3e4 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -89,9 +89,10 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_ip6_route(struct dst_entry **dst, struct flowi *fl)
+static int nf_ip6_route(struct net *net, struct dst_entry **dst,
+			struct flowi *fl)
 {
-	*dst = ip6_route_output(&init_net, NULL, fl);
+	*dst = ip6_route_output(net, NULL, fl);
 	return (*dst)->error;
 }
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b969025..31c1430 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -731,8 +731,10 @@ static int callforward_do_filter(const union nf_inet_addr *src,
 
 		fl1.fl4_dst = src->ip;
 		fl2.fl4_dst = dst->ip;
-		if (!afinfo->route((struct dst_entry **)&rt1, &fl1)) {
-			if (!afinfo->route((struct dst_entry **)&rt2, &fl2)) {
+		if (!afinfo->route(&init_net, (struct dst_entry **)&rt1,
+							&fl1)) {
+			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
+							&fl2)) {
 				if (rt1->rt_gateway == rt2->rt_gateway &&
 				    rt1->dst.dev  == rt2->dst.dev)
 					ret = 1;
@@ -749,8 +751,10 @@ static int callforward_do_filter(const union nf_inet_addr *src,
 
 		memcpy(&fl1.fl6_dst, src, sizeof(fl1.fl6_dst));
 		memcpy(&fl2.fl6_dst, dst, sizeof(fl2.fl6_dst));
-		if (!afinfo->route((struct dst_entry **)&rt1, &fl1)) {
-			if (!afinfo->route((struct dst_entry **)&rt2, &fl2)) {
+		if (!afinfo->route(&init_net, (struct dst_entry **)&rt1,
+							&fl1)) {
+			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
+							&fl2)) {
 				if (!memcmp(&rt1->rt6i_gateway, &rt2->rt6i_gateway,
 					    sizeof(rt1->rt6i_gateway)) &&
 				    rt1->dst.dev == rt2->dst.dev)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index eb81c38..285d8bd 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -161,7 +161,7 @@ static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
 	rcu_read_lock();
 	ai = nf_get_afinfo(family);
 	if (ai != NULL)
-		ai->route((struct dst_entry **)&rt, &fl);
+		ai->route(&init_net, (struct dst_entry **)&rt, &fl);
 	rcu_read_unlock();
 
 	if (rt != NULL) {
-- 
1.7.3.4

