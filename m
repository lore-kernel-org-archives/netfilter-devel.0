From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH] netfilter: nf_nat: support user-specified SNAT rules
 in LOCAL_IN
Date: Wed, 16 Jun 2010 17:09:03 +0200
Message-ID: <4C18E90F.30802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090004070503090300050304"
Cc: Netfilter Core Team <coreteam@netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab0FPPJF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:09:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090004070503090300050304
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch adds support for user-specified SNAT
rules in nat/LOCAL_IN. One possible use case is explained
in the changelog.

The downside is a small performance penalty: NAT already
registers a hook for LOCAL_IN, with this patch we invoke
nf_nat_rule_find() for each new connection going through
LOCAL_IN. It would be possible quite easily to make this
behaviour controllable through a module parameter, but I'd
prefer to keep those to the necessary minimum.

Any opinions or objections to this patch? Otherwise I'll
queue it up in my nf-next tree.



--------------090004070503090300050304
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit a9d252f5dbee323808b4356e9edcf41e2ea2d225
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Jun 16 16:55:44 2010 +0200

    netfilter: nf_nat: support user-specified SNAT rules in LOCAL_IN
    
    2.6.34 introduced 'conntrack zones' to deal with cases where packets
    from multiple identical networks are handled by conntrack/NAT. Packets
    are looped through veth devices, during which they are NATed to private
    addresses, after which they can continue normally through the stack
    and possibly have NAT rules applied a second time.
    
    This works well, but is needlessly complicated for cases where only
    a single SNAT/DNAT mapping needs to be applied to these packets. In that
    case, all that needs to be done is to assign each network to a seperate
    zone and perform NAT as usual. However this doesn't work for packets
    destined for the machine performing NAT itself since its corrently not
    possible to configure SNAT mappings for the LOCAL_IN chain.
    
    This patch adds a new INPUT chain to the NAT table and changes the
    targets performing SNAT to be usable in that chain.
    
    Example usage with two identical networks (192.168.0.0/24) on eth0/eth1:
    
    # assign packets from each interface to a seperate zone and mark them for NAT
    
    iptables -t raw -A PREROUTING -i eth0 -j CT --zone 1
    iptables -t raw -A PREROUTING -i eth0 -j MARK --set-mark 1
    iptables -t raw -A PREROUTING -i eth1 -j CT --zone 2
    iptabels -t raw -A PREROUTING -i eth1 -j MARK --set-mark 2
    
    # SNAT packets to private networks: eth0 -> 10.0.0.0/24, eth1 -> 10.0.1.0/24
    
    iptables -t nat -A INPUT       -m mark --mark 1 -j NETMAP --to 10.0.0.0/24
    iptables -t nat -A POSTROUTING -m mark --mark 1 -j NETMAP --to 10.0.0.0/24
    iptables -t nat -A INPUT       -m mark --mark 2 -j NETMAP --to 10.0.1.0/24
    iptables -t nat -A POSTROUTING -m mark --mark 2 -j NETMAP --to 10.0.1.0/24
    
    # assign packets in the reverse direction to proper zone
    
    iptables -t raw -A PREROUTING -d 10.0.0.0/24 -j CT --zone 1
    iptables -t raw -A OUTPUT     -d 10.0.0.0/24 -j CT --zone 1
    iptables -t raw -A PREROUTING -d 10.0.1.0/24 -j CT --zone 2
    iptables -t raw -A OUTPUT     -d 10.0.1.0/24 -j CT --zone 2
    
    # Optional: DNAT new connections in the reverse direction to the correct addresses.
    
    iptables -t nat -A PREROUTING -d 10.0.0.0/24 -j NETMAP --to 192.168.0.0/24
    iptables -t nat -A OUTPUT     -d 10.0.0.0/24 -j NETMAP --to 192.168.0.0/24
    iptables -t nat -A PREROUTING -d 10.0.1.0/24 -j NETMAP --to 192.168.0.0/24
    iptables -t nat -A OUTPUT     -d 10.0.1.0/24 -j NETMAP --to 192.168.0.0/24
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_nat_rule.h b/include/net/netfilter/nf_nat_rule.h
index e4a18ae..2890bdc 100644
--- a/include/net/netfilter/nf_nat_rule.h
+++ b/include/net/netfilter/nf_nat_rule.h
@@ -12,6 +12,4 @@ extern int nf_nat_rule_find(struct sk_buff *skb,
 			    const struct net_device *out,
 			    struct nf_conn *ct);
 
-extern unsigned int
-alloc_null_binding(struct nf_conn *ct, unsigned int hooknum);
 #endif /* _NF_NAT_RULE_H */
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 7c29582..25acd0c 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -48,7 +48,8 @@ netmap_tg(struct sk_buff *skb, const struct xt_target_param *par)
 
 	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
 		     par->hooknum == NF_INET_POST_ROUTING ||
-		     par->hooknum == NF_INET_LOCAL_OUT);
+		     par->hooknum == NF_INET_LOCAL_OUT ||
+		     par->hooknum == NF_INET_LOCAL_IN);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
@@ -77,7 +78,8 @@ static struct xt_target netmap_tg_reg __read_mostly = {
 	.table		= "nat",
 	.hooks		= (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING) |
-			  (1 << NF_INET_LOCAL_OUT),
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_LOCAL_IN),
 	.checkentry 	= netmap_tg_check,
 	.me 		= THIS_MODULE
 };
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 26de2c1..bba3687 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -27,7 +27,8 @@
 
 #define NAT_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | \
 			 (1 << NF_INET_POST_ROUTING) | \
-			 (1 << NF_INET_LOCAL_OUT))
+			 (1 << NF_INET_LOCAL_OUT) | \
+			 (1 << NF_INET_LOCAL_IN))
 
 static const struct xt_table nat_table = {
 	.name		= "nat",
@@ -44,7 +45,8 @@ ipt_snat_target(struct sk_buff *skb, const struct xt_target_param *par)
 	enum ip_conntrack_info ctinfo;
 	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
-	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING);
+	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_IN);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
@@ -98,7 +100,7 @@ static bool ipt_dnat_checkentry(const struct xt_tgchk_param *par)
 	return true;
 }
 
-unsigned int
+static unsigned int
 alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 {
 	/* Force range to this IP; let proto decide mapping for
@@ -140,7 +142,7 @@ static struct xt_target ipt_snat_reg __read_mostly = {
 	.target		= ipt_snat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
 	.table		= "nat",
-	.hooks		= 1 << NF_INET_POST_ROUTING,
+	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_LOCAL_IN),
 	.checkentry	= ipt_snat_checkentry,
 	.family		= AF_INET,
 };
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index c39c9cf..5d5d9a7 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -131,13 +131,7 @@ nf_nat_fn(unsigned int hooknum,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			if (hooknum == NF_INET_LOCAL_IN)
-				/* LOCAL_IN hook doesn't have a chain!  */
-				ret = alloc_null_binding(ct, hooknum);
-			else
-				ret = nf_nat_rule_find(skb, hooknum, in, out,
-						       ct);
-
+			ret = nf_nat_rule_find(skb, hooknum, in, out, ct);
 			if (ret != NF_ACCEPT) {
 				return ret;
 			}

--------------090004070503090300050304--
