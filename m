From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] netfilter: af_info: add 'strict' parameter to limit lookup to .oif
Date: Mon, 21 Mar 2011 23:25:40 +0100
Message-ID: <1300746341-18011-2-git-send-email-fw@strlen.de>
References: <1300746341-18011-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44484 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab1CUWbp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:31:45 -0400
In-Reply-To: <1300746341-18011-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipv6 fib lookup can set RT6_LOOKUP_F_IFACE flag to restrict search
to an interface, but this flag cannot be set via struct flowi.

Also, it cannot be set via ip6_route_output: this function uses the
passed sock struct to determine if this flag is required
(by testing for nonzero sk_bound_dev_if).

Work around this by passing in an artificial struct sk in case
'strict' argument is true.

This is required to replace the rt6_lookup call in xt_addrtype.c with
nf_afinfo->route().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Patrick,

 the change in nf_ip6_route() is very ugly, but I found no
 other way to set RT6_LOOKUP_F_IFACE.

 rt6_lookup() can't be used instead of ip6_route_output
 since it does not take a flowi argument...

 include/linux/netfilter.h              |    2 +-
 net/ipv4/netfilter.c                   |    2 +-
 net/ipv6/netfilter.c                   |   14 ++++++++++++--
 net/netfilter/nf_conntrack_h323_main.c |    8 ++++----
 net/netfilter/xt_TCPMSS.c              |    2 +-
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 20ed452..7fa95df 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -271,7 +271,7 @@ struct nf_afinfo {
 					    unsigned int len,
 					    u_int8_t protocol);
 	int		(*route)(struct net *net, struct dst_entry **dst,
-				 struct flowi *fl);
+				 struct flowi *fl, bool strict);
 	void		(*saveroute)(const struct sk_buff *skb,
 				     struct nf_queue_entry *entry);
 	int		(*reroute)(struct sk_buff *skb,
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 138e106..87f20e8 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -218,7 +218,7 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 }
 
 static int nf_ip_route(struct net *net, struct dst_entry **dst,
-		       struct flowi *fl)
+		       struct flowi *fl, bool strict __always_unused)
 {
 	return ip_route_output_key(net, (struct rtable **)dst, fl);
 }
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 9e1b3e4..f237d58 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -90,9 +90,19 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 }
 
 static int nf_ip6_route(struct net *net, struct dst_entry **dst,
-			struct flowi *fl)
+			struct flowi *fl, bool strict)
 {
-	*dst = ip6_route_output(net, NULL, fl);
+	static const struct ipv6_pinfo fake_pinfo;
+	static const struct inet_sock fake_sk = {
+		/* makes ip6_route_output set RT6_LOOKUP_F_IFACE: */
+		.sk.sk_bound_dev_if = 1,
+		.pinet6 = (struct ipv6_pinfo *) &fake_pinfo,
+	};
+	struct sock *sk = NULL;
+
+	if (strict)
+		sk = (struct sock *) &fake_sk;
+	*dst = ip6_route_output(net, sk, fl);
 	return (*dst)->error;
 }
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 31c1430..1ef3ec9 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -732,9 +732,9 @@ static int callforward_do_filter(const union nf_inet_addr *src,
 		fl1.fl4_dst = src->ip;
 		fl2.fl4_dst = dst->ip;
 		if (!afinfo->route(&init_net, (struct dst_entry **)&rt1,
-							&fl1)) {
+							&fl1, false)) {
 			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
-							&fl2)) {
+							&fl2, false)) {
 				if (rt1->rt_gateway == rt2->rt_gateway &&
 				    rt1->dst.dev  == rt2->dst.dev)
 					ret = 1;
@@ -752,9 +752,9 @@ static int callforward_do_filter(const union nf_inet_addr *src,
 		memcpy(&fl1.fl6_dst, src, sizeof(fl1.fl6_dst));
 		memcpy(&fl2.fl6_dst, dst, sizeof(fl2.fl6_dst));
 		if (!afinfo->route(&init_net, (struct dst_entry **)&rt1,
-							&fl1)) {
+							&fl1, false)) {
 			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
-							&fl2)) {
+							&fl2, false)) {
 				if (!memcmp(&rt1->rt6i_gateway, &rt2->rt6i_gateway,
 					    sizeof(rt1->rt6i_gateway)) &&
 				    rt1->dst.dev == rt2->dst.dev)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 285d8bd..1a5d5ff 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -161,7 +161,7 @@ static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
 	rcu_read_lock();
 	ai = nf_get_afinfo(family);
 	if (ai != NULL)
-		ai->route(&init_net, (struct dst_entry **)&rt, &fl);
+		ai->route(&init_net, (struct dst_entry **)&rt, &fl, false);
 	rcu_read_unlock();
 
 	if (rt != NULL) {
-- 
1.7.3.4

