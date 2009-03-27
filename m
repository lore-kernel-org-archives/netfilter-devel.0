From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] netfilter: conntrack: don't report events on module
	removal
Date: Fri, 27 Mar 2009 10:39:47 +0100
Message-ID: <20090327093947.8259.19826.stgit@Decadence>
References: <20090327093822.8259.50902.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42547 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754852AbZC0Jjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:39:55 -0400
In-Reply-To: <20090327093822.8259.50902.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During the module removal there are no possible event listeners
since ctnetlink must be removed before to allow removing
nf_conntrack. This patch removes the event reporting for the
module removal case which is not of any use in the existing code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h |    2 +-
 net/netfilter/nf_conntrack_core.c    |   15 ++++++++++-----
 net/netfilter/nf_conntrack_netlink.c |    6 +++---
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2e0c536..4e6a4d3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -199,7 +199,7 @@ __nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple);
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
-extern void nf_conntrack_flush(struct net *net, u32 pid, int report);
+extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
 extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
 			      unsigned int nhoff, u_int16_t l3num,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 188090f..94bccae 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -974,7 +974,7 @@ struct __nf_ct_flush_report {
 	int report;
 };
 
-static int kill_all(struct nf_conn *i, void *data)
+static int kill_report(struct nf_conn *i, void *data)
 {
 	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
 
@@ -986,6 +986,11 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
+static int kill_all(struct nf_conn *i, void *data)
+{
+	return 1;
+}
+
 void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced, unsigned int size)
 {
 	if (vmalloced)
@@ -996,15 +1001,15 @@ void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced, unsigned int s
 }
 EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
-void nf_conntrack_flush(struct net *net, u32 pid, int report)
+void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 {
 	struct __nf_ct_flush_report fr = {
 		.pid 	= pid,
 		.report = report,
 	};
-	nf_ct_iterate_cleanup(net, kill_all, &fr);
+	nf_ct_iterate_cleanup(net, kill_report, &fr);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_flush);
+EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
 static void nf_conntrack_cleanup_init_net(void)
 {
@@ -1018,7 +1023,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 	nf_ct_event_cache_flush(net);
 	nf_conntrack_ecache_fini(net);
  i_see_dead_people:
-	nf_conntrack_flush(net, 0, 0);
+	nf_ct_iterate_cleanup(net, kill_all, NULL);
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3c49d62..d399b04 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -724,9 +724,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
 		/* Flush the whole table */
-		nf_conntrack_flush(&init_net, 
-				   NETLINK_CB(skb).pid, 
-				   nlmsg_report(nlh));
+		nf_conntrack_flush_report(&init_net,
+					 NETLINK_CB(skb).pid,
+					 nlmsg_report(nlh));
 		return 0;
 	}
 

