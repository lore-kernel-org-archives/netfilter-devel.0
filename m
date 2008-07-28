From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Tue, 29 Jul 2008 00:12:43 +0100
Message-ID: <1217286763.8495.2.camel@pumper.lan.luxnet.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>
	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>
	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>
	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>
	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net>
	 <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
	 <48899DBE.5080005@netfilter.org> <4889B5BD.5070004@netfilter.org>
	 <488E108B.4080505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751158AbYG1XMy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:12:54 -0400
In-Reply-To: <488E108B.4080505@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2008-07-28 at 20:31 +0200, Pablo Neira Ayuso wrote:
> Pablo Neira Ayuso wrote:
> > Pablo Neira Ayuso wrote:
> >> Or much simpler, just call read_rcu_unlock() before the first
> >> nla_nest_start() so that this results in much smaller patch:
> >>
> >> nlmsg_failure:
> >> nla_put_failure:
> >>         read_rcu_unlock(); <---
> >>         nlmsg_trim(skb, b);
> >>         return -1;
> 
> Sorry, this is wrong. It should be:
> 
> nla_put_failure:
>          read_rcu_unlock();
> nlmsg_failure:
>          nlmsg_trim(skb, b);
>          return -1;

Very true indeed. Thanks for noticing. The nlmsg_failure is kinda hidden
in the macro and the jump targets were in the wrong order. You find the
corrected version below.

nf_ctnetlink: Remove read locks from dump functions to increase
performance in the event notification path

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 95a7967..06f69a2 100644
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
 
-nlmsg_failure:
 nla_put_failure:
+	rcu_read_unlock();
+nlmsg_failure:
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
 


