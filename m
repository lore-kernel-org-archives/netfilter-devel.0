From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: nat: work around shared nfct struct in bridge case
Date: Tue, 30 Aug 2011 15:28:58 +0200
Message-ID: <1314710938-25342-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50828 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab1H3N1N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:27:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When calling iptables code using bridge netfilter, the assumption
that a non-confirmed skb->nfct is never shared does no longer hold,
as bridge code clones skbs when e.g. forwarding packets to multiple
bridge ports.

When NFQUEUE is used, we can BUG because nf_nat_setup_info can be
invoked simultaneously for the same conntrack:

[ 3196.798768] kernel BUG at net/ipv4/netfilter/nf_nat_core.c:300!
[..]
[ 3196.798768]  [<ffffffff8120d73e>] ? nf_hook_slow+0x21a/0x282
[ 3196.798768]  [<ffffffffa03207e4>] ? br_handle_frame_finish+0x0/0x13b [bridge]
[ 3196.798768]  [<ffffffffa02a61a5>] ? alloc_null_binding+0x47/0x4c [iptable_nat]
[ 3196.798768]  [<ffffffffa02a64eb>] ? nf_nat_fn+0x193/0x1fb [iptable_nat]
[ 3196.798768]  [<ffffffff8120d4c5>] ? nf_iterate+0x40/0x9f
[ 3196.798768]  [<ffffffff8120d73e>] ? nf_hook_slow+0x21a/0x282
[ 3196.798768]  [<ffffffff81213c94>] ? ip_local_deliver_finish+0x0/0x1f1
[ 3196.798768]  [<ffffffff81213c94>] ? ip_local_deliver_finish+0x0/0x1f1
[ 3196.798768]  [<ffffffff8120d73e>] ? nf_hook_slow+0x21a/0x282
[ 3196.798768]  [<ffffffff8121369c>] ? ip_rcv_finish+0x0/0x340
[ 3196.798768]  [<ffffffff81213ed7>] ? ip_local_deliver+0x52/0x6c
[ 3196.798768]  [<ffffffff812139c2>] ? ip_rcv_finish+0x326/0x340
[ 3196.798768]  [<ffffffff81213c4f>] ? ip_rcv+0x273/0x2b8
[ 3196.798768]  [<ffffffff811f1384>] ? process_backlog+0x8d/0xc6
[ 3196.798768]  [<ffffffff811f2f85>] ? net_rx_action+0xa2/0x1cf
[ 3196.798768]  [<ffffffff8103d3c2>] ? __do_softirq+0x8b/0x10b
[ 3196.798768]  [<ffffffff8100c9dc>] ? call_softirq+0x1c/0x28
[ 3196.798768]  [<ffffffff8100dd15>] ? do_softirq+0x31/0x66
[ 3196.798768]  [<ffffffff8103d267>] ? irq_exit+0x36/0x78
[ 3196.798768]  [<ffffffff8100d41a>] ? do_IRQ+0xa0/0xb6
[ 3196.798768]  [<ffffffff8100c253>] ? ret_from_intr+0x0/0xa
[..]
[ 3196.798768] Code: be 2b 01 00 00 48 c7 c7 e8 cd 29 a0 e8 e8 d7 d9 e0 45 85 ff 49 8b 45 78 75 06 48 c1 e8 07 eb 04 48 c1 e8 08 83 e0 01 85 c0 74 04 <0f> 0b eb fe 49 8d 75 50 48 8d bc 24 80 00 00 00 e8 83 38 f7 ff
[ 3196.798768] RIP  [<ffffffffa029b68f>] nf_nat_setup_info+0x8a/0x564 [nf_nat]
[ 3196.798768]  RSP <ffff880001603bf0>

Work around this by forcing serialization via ct->lock and
accepting the packet silently.

Signed-off-by: Florian Westphal <fw@strlen.de>

---
 net/ipv4/netfilter/nf_nat_core.c |   39 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 2 deletions(-)

 Alternate patch to the 'make nfct of cloned skbs untracked' solution (which
 introduced unwanted module dependeny...)

 Main problem is that we can still end up confirming an
 already-confirmed conntrack, but this should be harmless.

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 9c71b27..bd89744 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -265,6 +265,35 @@ out:
 	rcu_read_unlock();
 }
 
+/* bridge netfilter uses cloned skbs when forwarding to multiple bridge ports.
+ * when userspace queueing is involved, we might try to set up NAT bindings
+ * on the same conntrack simultaneoulsy.  Can happen e.g. when broadcast has
+ * to be forwarded by the bridge but is also passed up the stack.
+ *
+ * Thus, when bridge netfilter is enabled, we need to serialize and silently
+ * accept the packet in the collision case.
+ */
+static inline bool nf_nat_bridge_lock(struct nf_conn *ct, enum nf_nat_manip_type maniptype)
+{
+#ifdef CONFIG_BRIDGE_NETFILTER
+	spin_lock_bh(&ct->lock);
+
+	if (unlikely(nf_nat_initialized(ct, maniptype))) {
+		pr_debug("race with cloned skb? Not adding NAT extension\n");
+		spin_unlock_bh(&ct->lock);
+		return false;
+	}
+#endif
+	return true;
+}
+
+static inline void nf_nat_bridge_unlock(struct nf_conn *ct)
+{
+#ifdef CONFIG_BRIDGE_NETFILTER
+	spin_unlock_bh(&ct->lock);
+#endif
+}
+
 unsigned int
 nf_nat_setup_info(struct nf_conn *ct,
 		  const struct nf_nat_range *range,
@@ -274,18 +303,23 @@ nf_nat_setup_info(struct nf_conn *ct,
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
 	struct nf_conn_nat *nat;
 
+	NF_CT_ASSERT(maniptype == IP_NAT_MANIP_SRC ||
+		     maniptype == IP_NAT_MANIP_DST);
+
+	if (!nf_nat_bridge_lock(ct, maniptype))
+		return NF_ACCEPT;
+
 	/* nat helper or nfctnetlink also setup binding */
 	nat = nfct_nat(ct);
 	if (!nat) {
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
+			nf_nat_bridge_unlock(ct);
 			pr_debug("failed to add NAT extension\n");
 			return NF_ACCEPT;
 		}
 	}
 
-	NF_CT_ASSERT(maniptype == IP_NAT_MANIP_SRC ||
-		     maniptype == IP_NAT_MANIP_DST);
 	BUG_ON(nf_nat_initialized(ct, maniptype));
 
 	/* What we've got will look like inverse of reply. Normally
@@ -332,6 +366,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 	else
 		ct->status |= IPS_SRC_NAT_DONE;
 
+	nf_nat_bridge_unlock(ct);
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL(nf_nat_setup_info);
-- 
1.7.3.4

