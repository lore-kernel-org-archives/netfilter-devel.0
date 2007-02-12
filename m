From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/22]: ip_nat: properly use RCU API for ip_nat_protos
	array
Date: Mon, 12 Feb 2007 11:36:34 +0100 (MET)
Message-ID: <20070212103633.661.25123.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_nat: properly use RCU API for ip_nat_protos array

Replace preempt_{enable,disable} based RCU by proper use of the
RCU API and add missing rcu_read_lock/rcu_read_unlock calls in
paths used outside of packet processing context (nfnetlink_conntrack).

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6930ac084caa4aff8d702716b80a2b59212efb78
tree 527cf137f820f9aeecacc7fbfe6621bef49a333f
parent 5187c6343d6eac0b2fc995bfb607f817565ec258
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:43:27 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:43:27 +0100

 net/ipv4/netfilter/ip_nat_core.c |   61 ++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 275a4d3..85ae0ca 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -50,7 +50,7 @@ static struct ip_nat_protocol *ip_nat_pr
 static inline struct ip_nat_protocol *
 __ip_nat_proto_find(u_int8_t protonum)
 {
-	return ip_nat_protos[protonum];
+	return rcu_dereference(ip_nat_protos[protonum]);
 }
 
 struct ip_nat_protocol *
@@ -58,13 +58,11 @@ ip_nat_proto_find_get(u_int8_t protonum)
 {
 	struct ip_nat_protocol *p;
 
-	/* we need to disable preemption to make sure 'p' doesn't get
-	 * removed until we've grabbed the reference */
-	preempt_disable();
+	rcu_read_lock();
 	p = __ip_nat_proto_find(protonum);
 	if (!try_module_get(p->me))
 		p = &ip_nat_unknown_protocol;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return p;
 }
@@ -120,8 +118,8 @@ static int
 in_range(const struct ip_conntrack_tuple *tuple,
 	 const struct ip_nat_range *range)
 {
-	struct ip_nat_protocol *proto =
-				__ip_nat_proto_find(tuple->dst.protonum);
+	struct ip_nat_protocol *proto;
+	int ret = 0;
 
 	/* If we are supposed to map IPs, then we must be in the
 	   range specified, otherwise let this drag us onto a new src IP. */
@@ -131,12 +129,15 @@ in_range(const struct ip_conntrack_tuple
 			return 0;
 	}
 
+	rcu_read_lock();
+	proto = __ip_nat_proto_find(tuple->dst.protonum);
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
 	    || proto->in_range(tuple, IP_NAT_MANIP_SRC,
 			       &range->min, &range->max))
-		return 1;
+		ret = 1;
+	rcu_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 static inline int
@@ -260,27 +261,25 @@ get_unique_tuple(struct ip_conntrack_tup
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
 
-	proto = ip_nat_proto_find_get(orig_tuple->dst.protonum);
+	rcu_read_lock();
+	proto = __ip_nat_proto_find(orig_tuple->dst.protonum);
 
 	/* Change protocol info to have some randomization */
 	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
 		proto->unique_tuple(tuple, range, maniptype, conntrack);
-		ip_nat_proto_put(proto);
-		return;
+		goto out;
 	}
 
 	/* Only bother mapping if it's not already in range and unique */
 	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
 	     || proto->in_range(tuple, maniptype, &range->min, &range->max))
-	    && !ip_nat_used_tuple(tuple, conntrack)) {
-		ip_nat_proto_put(proto);
-		return;
-	}
+	    && !ip_nat_used_tuple(tuple, conntrack))
+		goto out;
 
 	/* Last change: get protocol to try to obtain unique tuple. */
 	proto->unique_tuple(tuple, range, maniptype, conntrack);
-
-	ip_nat_proto_put(proto);
+out:
+	rcu_read_unlock();
 }
 
 unsigned int
@@ -360,12 +359,11 @@ manip_pkt(u_int16_t proto,
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
-	p = ip_nat_proto_find_get(proto);
-	if (!p->manip_pkt(pskb, iphdroff, target, maniptype)) {
-		ip_nat_proto_put(p);
+
+	/* rcu_read_lock()ed by nf_hook_slow */
+	p = __ip_nat_proto_find(proto);
+	if (!p->manip_pkt(pskb, iphdroff, target, maniptype))
 		return 0;
-	}
-	ip_nat_proto_put(p);
 
 	iph = (void *)(*pskb)->data + iphdroff;
 
@@ -515,7 +513,7 @@ int ip_nat_protocol_register(struct ip_n
 		ret = -EBUSY;
 		goto out;
 	}
-	ip_nat_protos[proto->protonum] = proto;
+	rcu_assign_pointer(ip_nat_protos[proto->protonum], proto);
  out:
 	write_unlock_bh(&ip_nat_lock);
 	return ret;
@@ -526,11 +524,10 @@ EXPORT_SYMBOL(ip_nat_protocol_register);
 void ip_nat_protocol_unregister(struct ip_nat_protocol *proto)
 {
 	write_lock_bh(&ip_nat_lock);
-	ip_nat_protos[proto->protonum] = &ip_nat_unknown_protocol;
+	rcu_assign_pointer(ip_nat_protos[proto->protonum],
+			   &ip_nat_unknown_protocol);
 	write_unlock_bh(&ip_nat_lock);
-
-	/* Someone could be still looking at the proto in a bh. */
-	synchronize_net();
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(ip_nat_protocol_unregister);
 
@@ -594,10 +591,10 @@ static int __init ip_nat_init(void)
 	/* Sew in builtin protocols. */
 	write_lock_bh(&ip_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
-		ip_nat_protos[i] = &ip_nat_unknown_protocol;
-	ip_nat_protos[IPPROTO_TCP] = &ip_nat_protocol_tcp;
-	ip_nat_protos[IPPROTO_UDP] = &ip_nat_protocol_udp;
-	ip_nat_protos[IPPROTO_ICMP] = &ip_nat_protocol_icmp;
+		rcu_assign_pointer(ip_nat_protos[i], &ip_nat_unknown_protocol);
+	rcu_assign_pointer(ip_nat_protos[IPPROTO_TCP], &ip_nat_protocol_tcp);
+	rcu_assign_pointer(ip_nat_protos[IPPROTO_UDP], &ip_nat_protocol_udp);
+	rcu_assign_pointer(ip_nat_protos[IPPROTO_ICMP], &ip_nat_protocol_icmp);
 	write_unlock_bh(&ip_nat_lock);
 
 	for (i = 0; i < ip_nat_htable_size; i++) {
