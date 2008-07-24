From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Thu, 24 Jul 2008 14:21:23 +0100
Message-ID: <1216905683.31465.10.camel@pumper.lan.luxnet.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>
	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>
	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>
	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>
	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>
	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751243AbYGXNVc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:21:32 -0400
In-Reply-To: <48876876.6010006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Fabian Hugelshofer wrote:
> > Patrick McHardy wrote:
> >> The module reference stuff (module_put/nf_ct_*_find_get etc)
> >> is clearly superfluous, this runs in packet processing context
> >> and shouldn't use module references but RCU.
> > 
> > This goes too deep, that I could help you on this.
> 
> Its not really hard, all the nf_ct_*_find_get functions on the event
> sending path should be replaced by the corresponding __nf_ct_*_find
> functions and the _put functions removed. In case dumping functions
> are used by both the event handler and userspace triggered dumps,
> the userspace path needs to call rcu_read_lock/rcu_read_unlock.

Ok, I did what you said. You find the patch below. Is this what you
mean? If yes, I'll give it a try...

I only touched the parts from the event notification chain. Should I
leave the other find_gets as they are?

Is it ok to call rcu_read_lock() multiple times in a row? In
ctnetlink_fill_info e.g. I lock and then ctnetlink_dump_helpinfo locks
again. Should I move the second lock out of dump_helpinfo?

Generally I have the impression, that moving the locks out of some dump
functions makes the whole thing less uniform. Is this acceptable?


diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 95a7967..b8650e5 100644
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
 
@@ -384,8 +378,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
+	rcu_read_lock();
+	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0) {
+		rcu_read_unlock();
 		goto nla_put_failure;
+	}
 	nla_nest_end(skb, nest_parms);
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
@@ -399,8 +396,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
-	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
+	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0) {
+		rcu_read_unlock();
 		goto nla_put_failure;
+	}
+	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;
@@ -1288,8 +1288,12 @@ ctnetlink_exp_dump_tuple(struct sk_buff *skb,
 	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple) < 0)
+	rcu_read_lock();
+	if (ctnetlink_dump_tuples(skb, tuple) < 0) {
+		rcu_read_unlock();
 		goto nla_put_failure;
+	}
+	rcu_read_unlock();
 	nla_nest_end(skb, nest_parms);
 
 	return 0;


