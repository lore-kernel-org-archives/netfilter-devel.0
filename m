From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] net: sched: Use dev_net() instead of the direct access to ->nd_net
Date: Fri, 18 Oct 2013 11:41:56 +0200
Message-ID: <1382089317-24311-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37427 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3JRJmA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:42:00 -0400
In-Reply-To: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to use dev_net() instead of the direct access to ->nd_net,
otherwise compilation fails if NET_NS is not enabled. Reported by
the kbuild test robot.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/sched/em_ipset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/em_ipset.c b/net/sched/em_ipset.c
index 1ac41d3..527aeb7 100644
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -24,7 +24,7 @@ static int em_ipset_change(struct tcf_proto *tp, void *data, int data_len,
 {
 	struct xt_set_info *set = data;
 	ip_set_id_t index;
-	struct net *net = qdisc_dev(tp->q)->nd_net;
+	struct net *net = dev_net(qdisc_dev(tp->q));
 
 	if (data_len != sizeof(*set))
 		return -EINVAL;
@@ -46,7 +46,7 @@ static void em_ipset_destroy(struct tcf_proto *p, struct tcf_ematch *em)
 {
 	const struct xt_set_info *set = (const void *) em->data;
 	if (set) {
-		ip_set_nfnl_put(qdisc_dev(p->q)->nd_net, set->index);
+		ip_set_nfnl_put(dev_net(qdisc_dev(p->q)), set->index);
 		kfree((void *) em->data);
 	}
 }
-- 
1.7.10.4

