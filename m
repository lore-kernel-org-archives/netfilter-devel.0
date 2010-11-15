From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:21:28 +0100
Message-ID: <1289841688.2607.102.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52208 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0KORVd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:21:33 -0500
Received: by wwa36 with SMTP id 36so262631wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 09:21:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use helpers to reduce number of sparse warnings
(CONFIG_SPARSE_RCU_POINTER=y)

remove one variable in amanda, hiding a previous one.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |   17 ++++++----
 net/ipv4/netfilter/nf_nat_amanda.c                    |    2 -
 net/ipv4/netfilter/nf_nat_core.c                      |    5 ++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 37f8adb..ab9c05c 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -20,6 +20,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <linux/rculist_nulls.h>
 
 struct ct_iter_state {
 	struct seq_net_private p;
@@ -35,7 +36,8 @@ static struct hlist_nulls_node *ct_get_first(struct seq_file *seq)
 	for (st->bucket = 0;
 	     st->bucket < net->ct.htable_size;
 	     st->bucket++) {
-		n = rcu_dereference(net->ct.hash[st->bucket].first);
+		n = rcu_dereference(
+			hlist_nulls_first_rcu(&net->ct.hash[st->bucket]));
 		if (!is_a_nulls(n))
 			return n;
 	}
@@ -48,13 +50,14 @@ static struct hlist_nulls_node *ct_get_next(struct seq_file *seq,
 	struct net *net = seq_file_net(seq);
 	struct ct_iter_state *st = seq->private;
 
-	head = rcu_dereference(head->next);
+	head = rcu_dereference(hlist_nulls_next_rcu(head));
 	while (is_a_nulls(head)) {
 		if (likely(get_nulls_value(head) == st->bucket)) {
 			if (++st->bucket >= net->ct.htable_size)
 				return NULL;
 		}
-		head = rcu_dereference(net->ct.hash[st->bucket].first);
+		head = rcu_dereference(
+			hlist_nulls_first_rcu(&net->ct.hash[st->bucket]));
 	}
 	return head;
 }
@@ -217,7 +220,8 @@ static struct hlist_node *ct_expect_get_first(struct seq_file *seq)
 	struct hlist_node *n;
 
 	for (st->bucket = 0; st->bucket < nf_ct_expect_hsize; st->bucket++) {
-		n = rcu_dereference(net->ct.expect_hash[st->bucket].first);
+		n = rcu_dereference(
+			hlist_first_rcu(&net->ct.expect_hash[st->bucket]));
 		if (n)
 			return n;
 	}
@@ -230,11 +234,12 @@ static struct hlist_node *ct_expect_get_next(struct seq_file *seq,
 	struct net *net = seq_file_net(seq);
 	struct ct_expect_iter_state *st = seq->private;
 
-	head = rcu_dereference(head->next);
+	head = rcu_dereference(hlist_next_rcu(head));
 	while (head == NULL) {
 		if (++st->bucket >= nf_ct_expect_hsize)
 			return NULL;
-		head = rcu_dereference(net->ct.expect_hash[st->bucket].first);
+		head = rcu_dereference(
+			hlist_first_rcu(&net->ct.expect_hash[st->bucket]));
 	}
 	return head;
 }
diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf_nat_amanda.c
index 0f23b3f..3d1ac1d 100644
--- a/net/ipv4/netfilter/nf_nat_amanda.c
+++ b/net/ipv4/netfilter/nf_nat_amanda.c
@@ -44,8 +44,6 @@ static unsigned int help(struct sk_buff *skb,
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int ret;
-
 		exp->tuple.dst.u.tcp.port = htons(port);
 		ret = nf_ct_expect_related(exp);
 		if (ret == 0)
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index ab877ac..eb55835 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -502,7 +502,10 @@ int nf_nat_protocol_register(const struct nf_nat_protocol *proto)
 	int ret = 0;
 
 	spin_lock_bh(&nf_nat_lock);
-	if (nf_nat_protos[proto->protonum] != &nf_nat_unknown_protocol) {
+	if (rcu_dereference_protected(
+			nf_nat_protos[proto->protonum],
+			lockdep_is_held(&nf_nat_lock)
+			) != &nf_nat_unknown_protocol) {
 		ret = -EBUSY;
 		goto out;
 	}


