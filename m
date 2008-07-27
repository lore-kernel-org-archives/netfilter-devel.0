From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Sun, 27 Jul 2008 18:23:48 +0100
Message-ID: <1217179428.11538.6.camel@pumper.lan.luxnet.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>
	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>
	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>
	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>
	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net>
	 <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
	 <48899DBE.5080005@netfilter.org>  <4889B5BD.5070004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60164 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750790AbYG0RX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 13:23:57 -0400
In-Reply-To: <4889B5BD.5070004@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
> > Or much simpler, just call read_rcu_unlock() before the first
> > nla_nest_start() so that this results in much smaller patch:
> > 
> > nlmsg_failure:
> > nla_put_failure:
> >         read_rcu_unlock(); <---
> >         nlmsg_trim(skb, b);
> >         return -1;
> 
> As said, if you do this in ctnetlink_conntrack_event, I think that you
> can also remove the rcu_read_lock in ctnetlink_dump_helpinfo, as then
> all dump functions will be invoked under rcu_read_lock.

I modified the patch with your suggestions. Read locks have been removed
from all dump functions.

> In ctnetlink_get_conntrack, I think that ctnetlink_fill_info needs to be
> protected with rcu_read_lock.

ctnetlink_get_conntrack now contains a read lock to protect the dump
functions. Protecting it outside is therefore not necessary.


nf_ctnetlink: Remove read locks from dump functions to increase
performance in the event notification path

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 95a7967..696649e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -104,16 +104,14 @@ ctnetlink_dump_tuples(struct sk_buff *skb,
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
 
-	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
 	ret = ctnetlink_dump_tuples_ip(skb, tuple, l3proto);
-	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
 		return ret;
 
-	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	l4proto = __nf_ct_l4proto_find(tuple->src.l3num, tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, tuple, l4proto);
-	nf_ct_l4proto_put(l4proto);
 
 	return ret;
 }
@@ -150,9 +148,8 @@ ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_proto;
 	int ret;
 
-	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (!l4proto->to_nlattr) {
-		nf_ct_l4proto_put(l4proto);
 		return 0;
 	}
 
@@ -162,14 +159,11 @@ ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = l4proto->to_nlattr(skb, nest_proto, ct);
 
-	nf_ct_l4proto_put(l4proto);
-
 	nla_nest_end(skb, nest_proto);
 
 	return ret;
 
 nla_put_failure:
-	nf_ct_l4proto_put(l4proto);
 	return -1;
 }
 
@@ -183,7 +177,6 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	if (!help)
 		return 0;
 
-	rcu_read_lock();
 	helper = rcu_dereference(help->helper);
 	if (!helper)
 		goto out;
@@ -198,11 +191,9 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 
 	nla_nest_end(skb, nest_helper);
 out:
-	rcu_read_unlock();
 	return 0;
 
 nla_put_failure:
-	rcu_read_unlock();
 	return -1;
 }
 
@@ -374,6 +365,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
 
+	rcu_read_lock();
+
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
@@ -402,11 +395,14 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
+	rcu_read_unlock();
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;
 
 nlmsg_failure:
 nla_put_failure:
+	rcu_read_unlock();
 	nlmsg_trim(skb, b);
 	return -1;
 }
@@ -1285,16 +1281,19 @@ ctnetlink_exp_dump_tuple(struct sk_buff *skb,
 {
 	struct nlattr *nest_parms;
 
+	rcu_read_lock();
 	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
 	if (ctnetlink_dump_tuples(skb, tuple) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
+	rcu_read_unlock();
 
 	return 0;
 
 nla_put_failure:
+	rcu_read_unlock();
 	return -1;
 }
 


