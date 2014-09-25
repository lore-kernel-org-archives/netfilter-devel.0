From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: disable generic protocol tracking
Date: Thu, 25 Sep 2014 13:32:37 +0200
Message-ID: <20140925113237.GC25548@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dborkman@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51641 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbaIYLcj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:32:39 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Given following iptables ruleset:
-P FORWARD DROP
-A FORWARD -m sctp --dport 9 -j ACCEPT
-A FORWARD -p tcp --dport 80 -j ACCEPT
-A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT

One would assume that this allows SCTP on port 9 and TCP on port 80.
Unfortunately, if the SCTP conntrack module is not loaded, this allows
*all* SCTP communication to pass through, i.e. -p sctp -j ACCEPT,
which we think is a security issue.

This is because on the first SCTP packet on port 9, we create a dummy
"generic l4" conntrack entry without any port information (since
conntrack doesn't know how to extract this information).

All subsequent packets that are unknown will then be in established
state since they fallback to proto_generic and the tuple lookup will
match the 'generic' entry.

Unfortunately, the only reasonable fix seems to be to completely
disable generic protocol tracking, i.e. force all packets to be in
invalid state.

Joint work with Daniel Borkmann.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/netfilter/nf_conntrack_proto_generic.c | 68 +++---------------------------
 1 file changed, 5 insertions(+), 63 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index d25f293..eac3a31 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
+static unsigned int nf_ct_generic_timeout __read_mostly;
 
 static inline struct nf_generic_net *generic_pernet(struct net *net)
 {
@@ -23,19 +23,13 @@ static bool generic_pkt_to_tuple(const struct sk_buff *skb,
 				 unsigned int dataoff,
 				 struct nf_conntrack_tuple *tuple)
 {
-	tuple->src.u.all = 0;
-	tuple->dst.u.all = 0;
-
-	return true;
+	return false;
 }
 
 static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
 				 const struct nf_conntrack_tuple *orig)
 {
-	tuple->src.u.all = 0;
-	tuple->dst.u.all = 0;
-
-	return true;
+	return false;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -59,59 +53,16 @@ static int generic_packet(struct nf_conn *ct,
 			  unsigned int hooknum,
 			  unsigned int *timeout)
 {
-	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
-	return NF_ACCEPT;
+	return NF_DROP;
 }
 
 /* Called when a new connection for this protocol found. */
 static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
 			unsigned int dataoff, unsigned int *timeouts)
 {
-	return true;
-}
-
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nfnetlink_cttimeout.h>
-
-static int generic_timeout_nlattr_to_obj(struct nlattr *tb[],
-					 struct net *net, void *data)
-{
-	unsigned int *timeout = data;
-	struct nf_generic_net *gn = generic_pernet(net);
-
-	if (tb[CTA_TIMEOUT_GENERIC_TIMEOUT])
-		*timeout =
-		    ntohl(nla_get_be32(tb[CTA_TIMEOUT_GENERIC_TIMEOUT])) * HZ;
-	else {
-		/* Set default generic timeout. */
-		*timeout = gn->timeout;
-	}
-
-	return 0;
+	return false;
 }
 
-static int
-generic_timeout_obj_to_nlattr(struct sk_buff *skb, const void *data)
-{
-	const unsigned int *timeout = data;
-
-	if (nla_put_be32(skb, CTA_TIMEOUT_GENERIC_TIMEOUT, htonl(*timeout / HZ)))
-		goto nla_put_failure;
-
-	return 0;
-
-nla_put_failure:
-        return -ENOSPC;
-}
-
-static const struct nla_policy
-generic_timeout_nla_policy[CTA_TIMEOUT_GENERIC_MAX+1] = {
-	[CTA_TIMEOUT_GENERIC_TIMEOUT]	= { .type = NLA_U32 },
-};
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
-
 #ifdef CONFIG_SYSCTL
 static struct ctl_table generic_sysctl_table[] = {
 	{
@@ -202,15 +153,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_mostly =
 	.packet			= generic_packet,
 	.get_timeouts		= generic_get_timeouts,
 	.new			= generic_new,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= generic_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_GENERIC_MAX,
-		.obj_size	= sizeof(unsigned int),
-		.nla_policy	= generic_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
 	.init_net		= generic_init_net,
 	.get_net_proto		= generic_get_net_proto,
 };
-- 
1.8.3.1

