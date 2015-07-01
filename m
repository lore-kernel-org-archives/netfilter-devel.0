From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf] netfilter: nf_conntrack: fix endless loop on netns deletion
Date: Wed,  1 Jul 2015 18:24:41 +0200
Message-ID: <b41741db7ecfaabe74fbcacac9a628375217ee35.1435765328.git.daniel@iogearbox.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:51159 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbGAQYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2015 12:24:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When adding connection tracking template rules to a netns, f.e. to
configure netfilter zones, the kernel will endlessly busy-loop as soon
as we try to delete the given netns in case there's at least one
template present. Minimal example:

  ip netns add foo
  ip netns exec foo iptables -t raw -A PREROUTING -d 1.2.3.4 -j CT --zone 1
  ip netns del foo

What happens is that when nf_ct_iterate_cleanup() is being called from
nf_conntrack_cleanup_net_list() for a provided netns, we always end up
with a net->ct.count > 0 and thus jump back to i_see_dead_people. We
don't get a soft-lockup as we still have a schedule() point, but the
serving CPU spins on 100% from that point onwards.

Since templates are normally allocated with nf_conntrack_alloc(), we
also bump net->ct.count, but they are never freed via nf_ct_put(). Thus,
when we delete a netns, we also need to check and free them from the
pcpu template list, so that the refcount can actually drop to 0 and
eventually move on with destroying the netns.

Therefore, we add a nf_ct_tmpls_cleanup() function, that is similar to
nf_ct_iterate_cleanup(), but which handles templates that got onto the
list via nf_conntrack_tmpl_insert(). Note that nf_ct_put() needs to be
done outside of the lock protecting the pcpu lists.

Fixes: 252b3e8c1bc0 ("netfilter: xt_CT: fix crash while destroy ct templates")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 (I believe this should be the case since 252b3e8c1bc0.)

 net/netfilter/nf_conntrack_core.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..dec0b3a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1409,6 +1409,35 @@ void nf_ct_iterate_cleanup(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
+static struct nf_conn *get_next_tmpl(struct ct_pcpu *pcpu)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	struct nf_conn *ct = NULL;
+
+	spin_lock_bh(&pcpu->lock);
+	hlist_nulls_for_each_entry(h, n, &pcpu->tmpl, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		break;
+	}
+	spin_unlock_bh(&pcpu->lock);
+
+	return ct;
+}
+
+static void nf_ct_tmpls_cleanup(struct net *net)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+		struct nf_conn *ct;
+
+		while ((ct = get_next_tmpl(pcpu)) != NULL)
+			nf_ct_put(ct);
+	}
+}
+
 static int kill_all(struct nf_conn *i, void *data)
 {
 	return 1;
@@ -1488,6 +1517,8 @@ i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_ct_iterate_cleanup(net, kill_all, NULL, 0, 0);
+		nf_ct_tmpls_cleanup(net);
+
 		if (atomic_read(&net->ct.count) != 0)
 			busy = 1;
 	}
-- 
1.9.3

