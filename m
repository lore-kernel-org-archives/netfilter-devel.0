From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/22]: nf_conntrack: properly use RCU API for
	nf_ct_protos/nf_ct_l3protos arrays
Date: Mon, 12 Feb 2007 11:36:38 +0100 (MET)
Message-ID: <20070212103637.661.87027.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: properly use RCU API for nf_ct_protos/nf_ct_l3protos arrays

Replace preempt_{enable,disable} based RCU by proper use of the
RCU API and add missing rcu_read_lock/rcu_read_unlock calls in
all paths not obviously only used within packet process context
(nfnetlink_conntrack).
  
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f34e7966f36432f6915ab7eee85116439a3944e
tree 829a240f1c040ef8a712d7e159adb473934320f7
parent f99ec74e0c460f0969f028c2853d2d31178ba3aa
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:01:11 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:01:11 +0100

 include/net/netfilter/nf_conntrack_l3proto.h   |    2 +
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +
 net/ipv4/netfilter/nf_nat_core.c               |    9 ++++---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 +
 net/netfilter/nf_conntrack_core.c              |   27 +++++++++++++++-----
 net/netfilter/nf_conntrack_proto.c             |   33 ++++++++++--------------
 6 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 664ddcf..ba760fe 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -106,7 +106,7 @@ __nf_ct_l3proto_find(u_int16_t l3proto)
 {
 	if (unlikely(l3proto >= AF_MAX))
 		return &nf_conntrack_l3proto_generic;
-	return nf_ct_l3protos[l3proto];
+	return rcu_dereference(nf_ct_l3protos[l3proto]);
 }
 
 #endif /*_NF_CONNTRACK_L3PROTO_H*/
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 677b6c8..e5aa4d8 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -170,7 +170,9 @@ icmp_error_message(struct sk_buff *skb,
 		return -NF_ACCEPT;
 	}
 
+	/* rcu_read_lock()ed by nf_hook_slow */
 	innerproto = __nf_ct_l4proto_find(PF_INET, inside->ip.protocol);
+
 	dataoff = skb->nh.iph->ihl*4 + sizeof(inside->icmp);
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, dataoff, dataoff + inside->ip.ihl*4, PF_INET,
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 6d0061f..5156d5d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -429,6 +429,7 @@ int nf_nat_icmp_reply_translation(struct
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} *inside;
+	struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple inner, target;
 	int hdrlen = (*pskb)->nh.iph->ihl * 4;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -464,16 +465,16 @@ int nf_nat_icmp_reply_translation(struct
 	DEBUGP("icmp_reply_translation: translating error %p manp %u dir %s\n",
 	       *pskb, manip, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
 
+	/* rcu_read_lock()ed by nf_hook_slow */
+	l4proto = __nf_ct_l4proto_find(PF_INET, inside->ip.protocol);
+
 	if (!nf_ct_get_tuple(*pskb,
 			     (*pskb)->nh.iph->ihl*4 + sizeof(struct icmphdr),
 			     (*pskb)->nh.iph->ihl*4 +
 			     sizeof(struct icmphdr) + inside->ip.ihl*4,
 			     (u_int16_t)AF_INET,
 			     inside->ip.protocol,
-			     &inner,
-			     l3proto,
-			     __nf_ct_l4proto_find((u_int16_t)PF_INET,
-						  inside->ip.protocol)))
+			     &inner, l3proto, l4proto))
 		return 0;
 
 	/* Change inner back to look like incoming packet.  We do the
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index b08622c..19bdb7c 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -182,6 +182,7 @@ icmpv6_error_message(struct sk_buff *skb
 		return -NF_ACCEPT;
 	}
 
+	/* rcu_read_lock()ed by nf_hook_slow */
 	inproto = __nf_ct_l4proto_find(PF_INET6, inprotonum);
 
 	/* Are they talking about one of our connections? */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 59bcab1..3deeb90 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -332,13 +332,16 @@ destroy_conntrack(struct nf_conntrack *n
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
+	rcu_read_lock();
 	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num);
 	if (l3proto && l3proto->destroy)
 		l3proto->destroy(ct);
 
-	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
+	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num,
+				       ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
+	rcu_read_unlock();
 
 	if (nf_conntrack_destroyed)
 		nf_conntrack_destroyed(ct);
@@ -647,9 +650,14 @@ struct nf_conn *nf_conntrack_alloc(const
 				   const struct nf_conntrack_tuple *repl)
 {
 	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conn *ct;
 
+	rcu_read_lock();
 	l3proto = __nf_ct_l3proto_find(orig->src.l3num);
-	return __nf_conntrack_alloc(orig, repl, l3proto, 0);
+	ct = __nf_conntrack_alloc(orig, repl, l3proto, 0);
+	rcu_read_unlock();
+
+	return ct;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
@@ -817,7 +825,9 @@ nf_conntrack_in(int pf, unsigned int hoo
 		return NF_ACCEPT;
 	}
 
+	/* rcu_read_lock()ed by nf_hook_slow */
 	l3proto = __nf_ct_l3proto_find((u_int16_t)pf);
+
 	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
 		DEBUGP("not prepared to track yet or error occured\n");
 		return -ret;
@@ -872,10 +882,15 @@ EXPORT_SYMBOL_GPL(nf_conntrack_in);
 int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 			 const struct nf_conntrack_tuple *orig)
 {
-	return nf_ct_invert_tuple(inverse, orig,
-				  __nf_ct_l3proto_find(orig->src.l3num),
-				  __nf_ct_l4proto_find(orig->src.l3num,
-						     orig->dst.protonum));
+	int ret;
+
+	rcu_read_lock();
+	ret = nf_ct_invert_tuple(inverse, orig,
+				 __nf_ct_l3proto_find(orig->src.l3num),
+				 __nf_ct_l4proto_find(orig->src.l3num,
+						      orig->dst.protonum));
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_invert_tuplepr);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 1a61b72..4dab3fa 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -66,7 +66,7 @@ __nf_ct_l4proto_find(u_int16_t l3proto, 
 	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
 		return &nf_conntrack_l4proto_generic;
 
-	return nf_ct_protos[l3proto][l4proto];
+	return rcu_dereference(nf_ct_protos[l3proto][l4proto]);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_l4proto_find);
 
@@ -77,11 +77,11 @@ nf_ct_l4proto_find_get(u_int16_t l3proto
 {
 	struct nf_conntrack_l4proto *p;
 
-	preempt_disable();
+	rcu_read_lock();
 	p = __nf_ct_l4proto_find(l3proto, l4proto);
 	if (!try_module_get(p->me))
 		p = &nf_conntrack_l4proto_generic;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return p;
 }
@@ -98,11 +98,11 @@ nf_ct_l3proto_find_get(u_int16_t l3proto
 {
 	struct nf_conntrack_l3proto *p;
 
-	preempt_disable();
+	rcu_read_lock();
 	p = __nf_ct_l3proto_find(l3proto);
 	if (!try_module_get(p->me))
 		p = &nf_conntrack_l3proto_generic;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return p;
 }
@@ -137,10 +137,8 @@ void nf_ct_l3proto_module_put(unsigned s
 {
 	struct nf_conntrack_l3proto *p;
 
-	preempt_disable();
+	/* rcu_read_lock not necessary since the caller holds a reference */
 	p = __nf_ct_l3proto_find(l3proto);
-	preempt_enable();
-
 	module_put(p->me);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l3proto_module_put);
@@ -202,7 +200,7 @@ int nf_conntrack_l3proto_register(struct
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	nf_ct_l3protos[proto->l3proto] = proto;
+	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
 	write_unlock_bh(&nf_conntrack_lock);
 
 	ret = nf_ct_l3proto_register_sysctl(proto);
@@ -233,14 +231,13 @@ int nf_conntrack_l3proto_unregister(stru
 		goto out;
 	}
 
-	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_l3proto_generic;
+	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
+			   &nf_conntrack_l3proto_generic);
 	write_unlock_bh(&nf_conntrack_lock);
+	synchronize_rcu();
 
 	nf_ct_l3proto_unregister_sysctl(proto);
 
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
-
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l3proto, proto);
 
@@ -356,7 +353,7 @@ retry:
 		goto retry;
 	}
 
-	nf_ct_protos[l4proto->l3proto][l4proto->l4proto] = l4proto;
+	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto], l4proto);
 	write_unlock_bh(&nf_conntrack_lock);
 
 	ret = nf_ct_l4proto_register_sysctl(l4proto);
@@ -392,15 +389,13 @@ int nf_conntrack_l4proto_unregister(stru
 		ret = -EBUSY;
 		goto out;
 	}
-	nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
-		= &nf_conntrack_l4proto_generic;
+	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+			   &nf_conntrack_l4proto_generic);
 	write_unlock_bh(&nf_conntrack_lock);
+	synchronize_rcu();
 
 	nf_ct_l4proto_unregister_sysctl(l4proto);
 
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
-
 	/* Remove all contrack entries for this protocol */
 	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
 
