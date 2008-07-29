From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Tue, 29 Jul 2008 19:11:53 +0200
Message-ID: <488F4F59.1010003@netfilter.org>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org>	 <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>	 <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch>	 <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net>	 <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net>	 <48876725.8010404@gmx.ch>  <48876876.6010006@trash.net>	 <1216905683.31465.10.camel@pumper.lan.luxnet.ch>	 <48899DBE.5080005@netfilter.org> <4889B5BD.5070004@netfilter.org>	 <488E108B.4080505@netfilter.org> <1217286763.8495.2.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050106090403020700050208"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43960 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbYG2RMD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:12:03 -0400
In-Reply-To: <1217286763.8495.2.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050106090403020700050208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Fabian Hugelshofer wrote:
> On Mon, 2008-07-28 at 20:31 +0200, Pablo Neira Ayuso wrote:
>> Pablo Neira Ayuso wrote:
>>> Pablo Neira Ayuso wrote:
>>>> Or much simpler, just call read_rcu_unlock() before the first
>>>> nla_nest_start() so that this results in much smaller patch:
>>>>
>>>> nlmsg_failure:
>>>> nla_put_failure:
>>>>         read_rcu_unlock(); <---
>>>>         nlmsg_trim(skb, b);
>>>>         return -1;
>> Sorry, this is wrong. It should be:
>>
>> nla_put_failure:
>>          read_rcu_unlock();
>> nlmsg_failure:
>>          nlmsg_trim(skb, b);
>>          return -1;
> 
> Very true indeed. Thanks for noticing. The nlmsg_failure is kinda hidden
> in the macro and the jump targets were in the wrong order. You find the
> corrected version below.
> 
> nf_ctnetlink: Remove read locks from dump functions to increase
> performance in the event notification path

I have six patches for ctnetlink here, one of them is based on your
patch. I hope to post them tomorrow for review.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050106090403020700050208
Content-Type: text/x-diff;
 name="00.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="00.patch"

[PATCH] get rid of module refcounting in ctnetlink

This patch replaces the unnecessary module refcounting with
the read-side locks. With this patch, all the dump and fill_info
function are called under the RCU read lock.

Based on a patch from Fabien Hugelshofer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-29 14:24:39.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-29 14:24:41.000000000 +0200
@@ -103,16 +103,14 @@ ctnetlink_dump_tuples(struct sk_buff *sk
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
@@ -149,11 +147,9 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 	struct nlattr *nest_proto;
 	int ret;
 
-	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	if (!l4proto->to_nlattr) {
-		nf_ct_l4proto_put(l4proto);
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	if (!l4proto->to_nlattr)
 		return 0;
-	}
 
 	nest_proto = nla_nest_start(skb, CTA_PROTOINFO | NLA_F_NESTED);
 	if (!nest_proto)
@@ -161,14 +157,11 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 
 	ret = l4proto->to_nlattr(skb, nest_proto, ct);
 
-	nf_ct_l4proto_put(l4proto);
-
 	nla_nest_end(skb, nest_proto);
 
 	return ret;
 
 nla_put_failure:
-	nf_ct_l4proto_put(l4proto);
 	return -1;
 }
 
@@ -182,7 +175,6 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 	if (!help)
 		return 0;
 
-	rcu_read_lock();
 	helper = rcu_dereference(help->helper);
 	if (!helper)
 		goto out;
@@ -197,11 +189,9 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 
 	nla_nest_end(skb, nest_helper);
 out:
-	rcu_read_unlock();
 	return 0;
 
 nla_put_failure:
-	rcu_read_unlock();
 	return -1;
 }
 
@@ -458,6 +448,7 @@ static int ctnetlink_conntrack_event(str
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
+	rcu_read_lock();
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
@@ -519,13 +510,15 @@ static int ctnetlink_conntrack_event(str
 	    && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
+	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
 
-nlmsg_failure:
 nla_put_failure:
+	rcu_read_unlock();
+nlmsg_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -863,8 +856,10 @@ ctnetlink_get_conntrack(struct sock *ctn
 		return -ENOMEM;
 	}
 
+	rcu_read_lock();
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq,
 				  IPCTNL_MSG_CT_NEW, 1, ct);
+	rcu_read_unlock();
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
@@ -1316,16 +1311,14 @@ ctnetlink_exp_dump_mask(struct sk_buff *
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
+	l3proto = __nf_ct_l3proto_find(tuple->src.l3num);
 	ret = ctnetlink_dump_tuples_ip(skb, &m, l3proto);
-	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
 		goto nla_put_failure;
 
-	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
+	l4proto = __nf_ct_l4proto_find(tuple->src.l3num, tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, &m, l4proto);
-	nf_ct_l4proto_put(l4proto);
 	if (unlikely(ret < 0))
 		goto nla_put_failure;
 
@@ -1432,15 +1425,18 @@ static int ctnetlink_expect_event(struct
 	nfmsg->version	    = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
 
+	rcu_read_lock();
 	if (ctnetlink_exp_dump_expect(skb, exp) < 0)
 		goto nla_put_failure;
+	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, NFNLGRP_CONNTRACK_EXP_NEW, 0);
 	return NOTIFY_DONE;
 
-nlmsg_failure:
 nla_put_failure:
+	rcu_read_unlock();
+nlmsg_failure:
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -1543,9 +1539,11 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (!skb2)
 		goto out;
 
+	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).pid,
 				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      1, exp);
+	rcu_read_unlock();
 	if (err <= 0)
 		goto free;
 

--------------050106090403020700050208--
