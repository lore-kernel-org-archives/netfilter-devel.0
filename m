From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: conntrack: netns fix re reliable conntrack
	event delivery
Date: Thu, 27 Aug 2009 02:24:25 +0400
Message-ID: <20090826222425.GA7523@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:7700 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZHZWY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:24:26 -0400
Received: by ey-out-2122.google.com with SMTP id 25so137560eya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2009 15:24:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Conntracks in netns other than init_net dying list were never killed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_conntrack_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1089,14 +1089,14 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
-static void nf_ct_release_dying_list(void)
+static void nf_ct_release_dying_list(struct net *net)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 	struct hlist_nulls_node *n;
 
 	spin_lock_bh(&nf_conntrack_lock);
-	hlist_nulls_for_each_entry(h, n, &init_net.ct.dying, hnnode) {
+	hlist_nulls_for_each_entry(h, n, &net->ct.dying, hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		/* never fails to remove them, no listeners at this point */
 		nf_ct_kill(ct);
@@ -1115,7 +1115,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
-	nf_ct_release_dying_list();
+	nf_ct_release_dying_list(net);
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
