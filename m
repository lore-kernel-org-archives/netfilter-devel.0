From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/41]: nf_nat: kill helper and seq_adjust hooks
Date: Mon, 14 Apr 2008 12:16:59 +0200 (MEST)
Message-ID: <20080414101656.32717.44196.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36331 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYDNKRB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:01 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: kill helper and seq_adjust hooks

Connection tracking helpers (specifically FTP) need to be called
before NAT sequence numbers adjustments are performed to be able
to compare them against previously seen ones. We've introduced
two new hooks around 2.6.11 to maintain this ordering when NAT
modules were changed to get called from conntrack helpers directly.

The cost of netfilter hooks is quite high and sequence number
adjustments are only rarely needed however. Add a RCU-protected
sequence number adjustment function pointer and call it from
IPv4 conntrack after calling the helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5c5f11539fad5dacee3edb96279dda0785252b66
tree 424e2843bd28de0568ef68e50d62db35460fb3fb
parent b2a3c0b71517472b86ecb38cbf30fbdd1b27eb95
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200

 include/linux/netfilter_ipv4.h                 |    2 -
 include/net/netfilter/nf_nat_helper.h          |    3 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   56 ++++++++++++------------
 net/ipv4/netfilter/nf_nat_core.c               |    5 ++
 net/ipv4/netfilter/nf_nat_helper.c             |    1 
 net/ipv4/netfilter/nf_nat_standalone.c         |   35 ---------------
 6 files changed, 35 insertions(+), 67 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 9a10092..650318b 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -62,8 +62,6 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_FILTER = 0,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
-	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
-	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
 	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
 	NF_IP_PRI_LAST = INT_MAX,
 };
diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index 58dd226..237a961 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -24,6 +24,9 @@ extern int nf_nat_mangle_udp_packet(struct sk_buff *skb,
 extern int nf_nat_seq_adjust(struct sk_buff *skb,
 			     struct nf_conn *ct,
 			     enum ip_conntrack_info ctinfo);
+extern int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
+				     struct nf_conn *ct,
+				     enum ip_conntrack_info ctinfo);
 
 /* Setup NAT on this expected conntrack so it follows master, but goes
  * to port ct->master->saved_proto. */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index a65b845..41e7961 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -23,6 +23,12 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/nf_nat_helper.h>
+
+int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
+			      struct nf_conn *ct,
+			      enum ip_conntrack_info ctinfo);
+EXPORT_SYMBOL_GPL(nf_nat_seq_adjust_hook);
 
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
@@ -101,35 +107,41 @@ static unsigned int ipv4_confirm(unsigned int hooknum,
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
-}
-
-static unsigned int ipv4_conntrack_help(unsigned int hooknum,
-				      struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
-{
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn_help *help;
 	const struct nf_conntrack_helper *helper;
+	unsigned int ret;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY)
-		return NF_ACCEPT;
+		goto out;
 
 	help = nfct_help(ct);
 	if (!help)
-		return NF_ACCEPT;
+		goto out;
+
 	/* rcu_read_lock()ed by nf_hook_slow */
 	helper = rcu_dereference(help->helper);
 	if (!helper)
-		return NF_ACCEPT;
-	return helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
-			    ct, ctinfo);
+		goto out;
+
+	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
+			   ct, ctinfo);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
+		typeof(nf_nat_seq_adjust_hook) seq_adjust;
+
+		seq_adjust = rcu_dereference(nf_nat_seq_adjust_hook);
+		if (!seq_adjust || !seq_adjust(skb, ct, ctinfo))
+			return NF_DROP;
+	}
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
 }
 
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
@@ -211,20 +223,6 @@ static struct nf_hook_ops ipv4_conntrack_ops[] __read_mostly = {
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
 	{
-		.hook		= ipv4_conntrack_help,
-		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
-		.hook		= ipv4_conntrack_help,
-		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
 		.hook		= ipv4_confirm,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET,
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 105bf61..9d4b1fe 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -620,6 +620,9 @@ static int __init nf_nat_init(void)
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
+
+	BUG_ON(nf_nat_seq_adjust_hook != NULL);
+	rcu_assign_pointer(nf_nat_seq_adjust_hook, nf_nat_seq_adjust);
 	return 0;
 
  cleanup_extend:
@@ -646,6 +649,8 @@ static void __exit nf_nat_cleanup(void)
 	nf_ct_free_hashtable(bysource, nf_nat_vmalloced, nf_nat_htable_size);
 	nf_ct_l3proto_put(l3proto);
 	nf_ct_extend_unregister(&nat_extend);
+	rcu_assign_pointer(nf_nat_seq_adjust_hook, NULL);
+	synchronize_net();
 }
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 2fca727..11976ea 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -416,7 +416,6 @@ nf_nat_seq_adjust(struct sk_buff *skb,
 
 	return 1;
 }
-EXPORT_SYMBOL(nf_nat_seq_adjust);
 
 /* Setup NAT on this expected conntrack so it follows master. */
 /* If we fail to get a free NAT slot, we'll get dropped on confirm */
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index a366b58..b7dd695 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -245,25 +245,6 @@ nf_nat_local_fn(unsigned int hooknum,
 	return ret;
 }
 
-static unsigned int
-nf_nat_adjust(unsigned int hooknum,
-	      struct sk_buff *skb,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      int (*okfn)(struct sk_buff *))
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
-		pr_debug("nf_nat_standalone: adjusting sequence number\n");
-		if (!nf_nat_seq_adjust(skb, ct, ctinfo))
-			return NF_DROP;
-	}
-	return NF_ACCEPT;
-}
-
 /* We must be after connection tracking and before packet filtering. */
 
 static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
@@ -283,14 +264,6 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
-	/* After conntrack, adjust sequence number */
-	{
-		.hook		= nf_nat_adjust,
-		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
-	},
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_local_fn,
@@ -307,14 +280,6 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
-	/* After conntrack, adjust sequence number */
-	{
-		.hook		= nf_nat_adjust,
-		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
-	},
 };
 
 static int __init nf_nat_standalone_init(void)
