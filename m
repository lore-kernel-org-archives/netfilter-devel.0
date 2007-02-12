From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/22]: nf_nat: properly use RCU API for nf_nat_protos
	array
Date: Mon, 12 Feb 2007 11:36:35 +0100 (MET)
Message-ID: <20070212103635.661.33429.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: properly use RCU API for nf_nat_protos array

Replace preempt_{enable,disable} based RCU by proper use of the
RCU API and add missing rcu_read_lock/rcu_read_unlock calls in
paths used outside of packet processing context (nfnetlink_conntrack).

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8592a4e696c2d452053b005a7b8a84e29a7462af
tree c900a38cb8b11b3f4c78776f416cec8b7adbfd6c
parent 6930ac084caa4aff8d702716b80a2b59212efb78
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:44:58 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:44:58 +0100

 net/ipv4/netfilter/nf_nat_core.c |   59 ++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index cf10108..6d0061f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -53,7 +53,7 @@ static struct nf_nat_protocol *nf_nat_pr
 static inline struct nf_nat_protocol *
 __nf_nat_proto_find(u_int8_t protonum)
 {
-	return nf_nat_protos[protonum];
+	return rcu_dereference(nf_nat_protos[protonum]);
 }
 
 struct nf_nat_protocol *
@@ -61,13 +61,11 @@ nf_nat_proto_find_get(u_int8_t protonum)
 {
 	struct nf_nat_protocol *p;
 
-	/* we need to disable preemption to make sure 'p' doesn't get
-	 * removed until we've grabbed the reference */
-	preempt_disable();
+	rcu_read_lock();
 	p = __nf_nat_proto_find(protonum);
 	if (!try_module_get(p->me))
 		p = &nf_nat_unknown_protocol;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return p;
 }
@@ -126,8 +124,8 @@ in_range(const struct nf_conntrack_tuple
 	 const struct nf_nat_range *range)
 {
 	struct nf_nat_protocol *proto;
+	int ret = 0;
 
-	proto = __nf_nat_proto_find(tuple->dst.protonum);
 	/* If we are supposed to map IPs, then we must be in the
 	   range specified, otherwise let this drag us onto a new src IP. */
 	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
@@ -136,12 +134,15 @@ in_range(const struct nf_conntrack_tuple
 			return 0;
 	}
 
+	rcu_read_lock();
+	proto = __nf_nat_proto_find(tuple->dst.protonum);
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED) ||
 	    proto->in_range(tuple, IP_NAT_MANIP_SRC,
 			    &range->min, &range->max))
-		return 1;
+		ret = 1;
+	rcu_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 static inline int
@@ -268,27 +269,25 @@ get_unique_tuple(struct nf_conntrack_tup
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
 
-	proto = nf_nat_proto_find_get(orig_tuple->dst.protonum);
+	rcu_read_lock();
+	proto = __nf_nat_proto_find(orig_tuple->dst.protonum);
 
 	/* Change protocol info to have some randomization */
 	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
 		proto->unique_tuple(tuple, range, maniptype, ct);
-		nf_nat_proto_put(proto);
-		return;
+		goto out;
 	}
 
 	/* Only bother mapping if it's not already in range and unique */
 	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED) ||
 	     proto->in_range(tuple, maniptype, &range->min, &range->max)) &&
-	    !nf_nat_used_tuple(tuple, ct)) {
-		nf_nat_proto_put(proto);
-		return;
-	}
+	    !nf_nat_used_tuple(tuple, ct))
+		goto out;
 
 	/* Last change: get protocol to try to obtain unique tuple. */
 	proto->unique_tuple(tuple, range, maniptype, ct);
-
-	nf_nat_proto_put(proto);
+out:
+	rcu_read_unlock();
 }
 
 unsigned int
@@ -369,12 +368,11 @@ manip_pkt(u_int16_t proto,
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
-	p = nf_nat_proto_find_get(proto);
-	if (!p->manip_pkt(pskb, iphdroff, target, maniptype)) {
-		nf_nat_proto_put(p);
+
+	/* rcu_read_lock()ed by nf_hook_slow */
+	p = __nf_nat_proto_find(proto);
+	if (!p->manip_pkt(pskb, iphdroff, target, maniptype))
 		return 0;
-	}
-	nf_nat_proto_put(p);
 
 	iph = (void *)(*pskb)->data + iphdroff;
 
@@ -529,7 +527,7 @@ int nf_nat_protocol_register(struct nf_n
 		ret = -EBUSY;
 		goto out;
 	}
-	nf_nat_protos[proto->protonum] = proto;
+	rcu_assign_pointer(nf_nat_protos[proto->protonum], proto);
  out:
 	write_unlock_bh(&nf_nat_lock);
 	return ret;
@@ -540,11 +538,10 @@ EXPORT_SYMBOL(nf_nat_protocol_register);
 void nf_nat_protocol_unregister(struct nf_nat_protocol *proto)
 {
 	write_lock_bh(&nf_nat_lock);
-	nf_nat_protos[proto->protonum] = &nf_nat_unknown_protocol;
+	rcu_assign_pointer(nf_nat_protos[proto->protonum],
+			   &nf_nat_unknown_protocol);
 	write_unlock_bh(&nf_nat_lock);
-
-	/* Someone could be still looking at the proto in a bh. */
-	synchronize_net();
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_nat_protocol_unregister);
 
@@ -608,10 +605,10 @@ static int __init nf_nat_init(void)
 	/* Sew in builtin protocols. */
 	write_lock_bh(&nf_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
-		nf_nat_protos[i] = &nf_nat_unknown_protocol;
-	nf_nat_protos[IPPROTO_TCP] = &nf_nat_protocol_tcp;
-	nf_nat_protos[IPPROTO_UDP] = &nf_nat_protocol_udp;
-	nf_nat_protos[IPPROTO_ICMP] = &nf_nat_protocol_icmp;
+		rcu_assign_pointer(nf_nat_protos[i], &nf_nat_unknown_protocol);
+	rcu_assign_pointer(nf_nat_protos[IPPROTO_TCP], &nf_nat_protocol_tcp);
+	rcu_assign_pointer(nf_nat_protos[IPPROTO_UDP], &nf_nat_protocol_udp);
+	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
 	write_unlock_bh(&nf_nat_lock);
 
 	for (i = 0; i < nf_nat_htable_size; i++) {
