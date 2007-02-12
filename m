From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/22]: ip_conntrack: properly use RCU API for
	ip_ct_protos array
Date: Mon, 12 Feb 2007 11:36:36 +0100 (MET)
Message-ID: <20070212103636.661.61566.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_conntrack: properly use RCU API for ip_ct_protos array

Replace preempt_{enable,disable} based RCU by proper use of the
RCU API and add missing rcu_read_lock/rcu_read_unlock calls in
all paths not obviously only used within packet process context
(nfnetlink_conntrack).

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f99ec74e0c460f0969f028c2853d2d31178ba3aa
tree 4a0534a350b1f4067cc2c4b1ef450dace12b9da7
parent 8592a4e696c2d452053b005a7b8a84e29a7462af
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:56:31 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:56:31 +0100

 net/ipv4/netfilter/ip_conntrack_core.c       |   26 ++++++++++++++++++--------
 net/ipv4/netfilter/ip_conntrack_standalone.c |    9 ++++-----
 net/ipv4/netfilter/ip_nat_core.c             |    6 ++++--
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 933b878..ed87812 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -318,9 +318,11 @@ destroy_conntrack(struct nf_conntrack *n
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
+	rcu_read_lock();
 	proto = __ip_conntrack_proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
 	if (proto && proto->destroy)
 		proto->destroy(ct);
+	rcu_read_unlock();
 
 	if (ip_conntrack_destroyed)
 		ip_conntrack_destroyed(ct);
@@ -595,13 +597,13 @@ ip_conntrack_proto_find_get(u_int8_t pro
 {
 	struct ip_conntrack_protocol *p;
 
-	preempt_disable();
+	rcu_read_lock();
 	p = __ip_conntrack_proto_find(protocol);
 	if (p) {
 		if (!try_module_get(p->me))
 			p = &ip_conntrack_generic_protocol;
 	}
-	preempt_enable();
+	rcu_read_unlock();
 
 	return p;
 }
@@ -831,6 +833,7 @@ #if 0
 	}
 #endif
 
+	/* rcu_read_lock()ed by nf_hook_slow */
 	proto = __ip_conntrack_proto_find((*pskb)->nh.iph->protocol);
 
 	/* It may be an special packet, error, unclean...
@@ -876,8 +879,15 @@ #endif
 int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 		   const struct ip_conntrack_tuple *orig)
 {
-	return ip_ct_invert_tuple(inverse, orig,
-				  __ip_conntrack_proto_find(orig->dst.protonum));
+	struct ip_conntrack_protocol *proto;
+	int ret;
+
+	rcu_read_lock();
+	proto = __ip_conntrack_proto_find(orig->dst.protonum);
+	ret = ip_ct_invert_tuple(inverse, orig, proto);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /* Would two expected things clash? */
@@ -1508,11 +1518,11 @@ int __init ip_conntrack_init(void)
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&ip_conntrack_lock);
 	for (i = 0; i < MAX_IP_CT_PROTO; i++)
-		ip_ct_protos[i] = &ip_conntrack_generic_protocol;
+		rcu_assign_pointer(ip_ct_protos[i], &ip_conntrack_generic_protocol);
 	/* Sew in builtin protocols. */
-	ip_ct_protos[IPPROTO_TCP] = &ip_conntrack_protocol_tcp;
-	ip_ct_protos[IPPROTO_UDP] = &ip_conntrack_protocol_udp;
-	ip_ct_protos[IPPROTO_ICMP] = &ip_conntrack_protocol_icmp;
+	rcu_assign_pointer(ip_ct_protos[IPPROTO_TCP], &ip_conntrack_protocol_tcp);
+	rcu_assign_pointer(ip_ct_protos[IPPROTO_UDP], &ip_conntrack_protocol_udp);
+	rcu_assign_pointer(ip_ct_protos[IPPROTO_ICMP], &ip_conntrack_protocol_icmp);
 	write_unlock_bh(&ip_conntrack_lock);
 
 	/* For use by ipt_REJECT */
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 5903588..d0045e4 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -796,7 +796,7 @@ int ip_conntrack_protocol_register(struc
 		ret = -EBUSY;
 		goto out;
 	}
-	ip_ct_protos[proto->proto] = proto;
+	rcu_assign_pointer(ip_ct_protos[proto->proto], proto);
  out:
 	write_unlock_bh(&ip_conntrack_lock);
 	return ret;
@@ -805,11 +805,10 @@ int ip_conntrack_protocol_register(struc
 void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto)
 {
 	write_lock_bh(&ip_conntrack_lock);
-	ip_ct_protos[proto->proto] = &ip_conntrack_generic_protocol;
+	rcu_assign_pointer(ip_ct_protos[proto->proto],
+			   &ip_conntrack_generic_protocol);
 	write_unlock_bh(&ip_conntrack_lock);
-
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
+	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
 	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 85ae0ca..18daabc 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -420,6 +420,7 @@ int ip_nat_icmp_reply_translation(struct
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} *inside;
+	struct ip_conntrack_protocol *proto;
 	struct ip_conntrack_tuple inner, target;
 	int hdrlen = (*pskb)->nh.iph->ihl * 4;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -455,10 +456,11 @@ int ip_nat_icmp_reply_translation(struct
 	DEBUGP("icmp_reply_translation: translating error %p manp %u dir %s\n",
 	       *pskb, manip, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
 
+	/* rcu_read_lock()ed by nf_hook_slow */
+	proto = __ip_conntrack_proto_find(inside->ip.protocol);
 	if (!ip_ct_get_tuple(&inside->ip, *pskb, (*pskb)->nh.iph->ihl*4 +
 			     sizeof(struct icmphdr) + inside->ip.ihl*4,
-			     &inner,
-			     __ip_conntrack_proto_find(inside->ip.protocol)))
+			     &inner, proto))
 		return 0;
 
 	/* Change inner back to look like incoming packet.  We do the
