From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/4] netfilter: add and use nf_ct_unconfirmed_destroy
Date: Wed, 26 Jul 2017 00:02:32 +0200
Message-ID: <20170725220234.29354-3-fw@strlen.de>
References: <20170725220234.29354-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56174 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751690AbdGYWCY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 18:02:24 -0400
In-Reply-To: <20170725220234.29354-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This also removes __nf_ct_unconfirmed_destroy() call from
nf_ct_iterate_cleanup_net, so that function can be used only
when missing conntracks from unconfirmed list isn't a problem.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since v1
 include/net/netfilter/nf_conntrack.h |  3 +++
 net/netfilter/nf_conntrack_core.c    | 15 +++++++++++----
 net/netfilter/nfnetlink_cttimeout.c  |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 48407569585d..6e6f678aaac7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -224,6 +224,9 @@ extern s32 (*nf_ct_nat_offset)(const struct nf_conn *ct,
 			       enum ip_conntrack_dir dir,
 			       u32 seq);
 
+/* Set all unconfirmed conntrack as dying */
+void nf_ct_unconfirmed_destroy(struct net *);
+
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9979f46c81dc..c8b87eaa17a2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1689,6 +1689,17 @@ __nf_ct_unconfirmed_destroy(struct net *net)
 	}
 }
 
+void nf_ct_unconfirmed_destroy(struct net *net)
+{
+	might_sleep();
+
+	if (atomic_read(&net->ct.count) > 0) {
+		__nf_ct_unconfirmed_destroy(net);
+		synchronize_net();
+	}
+}
+EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_destroy);
+
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
@@ -1700,14 +1711,10 @@ void nf_ct_iterate_cleanup_net(struct net *net,
 	if (atomic_read(&net->ct.count) == 0)
 		return;
 
-	__nf_ct_unconfirmed_destroy(net);
-
 	d.iter = iter;
 	d.data = data;
 	d.net = net;
 
-	synchronize_net();
-
 	nf_ct_iterate_cleanup(iter_net_only, &d, portid, report);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 400e9ae97153..83c8da48df59 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -572,6 +572,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 {
 	struct ctnl_timeout *cur, *tmp;
 
+	nf_ct_unconfirmed_destroy(net);
 	ctnl_untimeout(net, NULL);
 
 	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
-- 
2.13.0

