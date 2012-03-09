From: Tony Zelenoff <antonz@parallels.com>
Subject: [PATCH v2] net/netfilter: refactor notifier registration
Date: Fri, 9 Mar 2012 13:35:39 +0400
Message-ID: <1331285739-487343-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <antonz@parallels.com>, <pablo@netfilter.org>,
	<eric.dumazet@gmail.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:32956 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2CIJfo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:35:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* ret variable initialization removed as useless
* similar code strings concatenated and functions code
  flow became more plain

Signed-off-by: Tony Zelenoff <antonz@parallels.com>
---
 net/netfilter/nf_conntrack_ecache.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5bd3047..3a3409f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 int nf_conntrack_register_notifier(struct net *net,
 				   struct nf_ct_event_notifier *new)
 {
-	int ret = 0;
+	int ret;
 	struct nf_ct_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
@@ -95,8 +95,7 @@ int nf_conntrack_register_notifier(struct net *net,
 		goto out_unlock;
 	}
 	rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
-	mutex_unlock(&nf_ct_ecache_mutex);
-	return ret;
+	ret = 0;
 
 out_unlock:
 	mutex_unlock(&nf_ct_ecache_mutex);
@@ -121,7 +120,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 int nf_ct_expect_register_notifier(struct net *net,
 				   struct nf_exp_event_notifier *new)
 {
-	int ret = 0;
+	int ret;
 	struct nf_exp_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
@@ -132,8 +131,7 @@ int nf_ct_expect_register_notifier(struct net *net,
 		goto out_unlock;
 	}
 	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
-	mutex_unlock(&nf_ct_ecache_mutex);
-	return ret;
+	ret = 0;
 
 out_unlock:
 	mutex_unlock(&nf_ct_ecache_mutex);
-- 
1.7.1

