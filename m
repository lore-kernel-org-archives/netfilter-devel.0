From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable-3.8.y 6/9] netfilter: nf_ct_helper: don't discard helper if it is actually the same
Date: Tue,  7 May 2013 01:05:25 +0200
Message-ID: <1367881528-15524-6-git-send-email-pablo@netfilter.org>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52119 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759784Ab3EFXFw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 19:05:52 -0400
In-Reply-To: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

commit (32f5376 netfilter: nf_ct_helper: disable automatic helper
re-assignment of different type) broke transparent proxy scenarios.

For example, initial helper lookup might yield "ftp" (dport 21),
while re-lookup after REDIRECT yields "ftp-2121".

This causes the autoassign code to toss the ftp helper, even
though these are just different instances of the same helper.

Change the test to check for the helper function address instead
of the helper address, as suggested by Pablo.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>

[ git cherry-pick 6e2f0aa ]
---
 net/netfilter/nf_conntrack_helper.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 884f2b3..91527d5 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -236,7 +236,9 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 		/* We only allow helper re-assignment of the same sort since
 		 * we cannot reallocate the helper extension area.
 		 */
-		if (help->helper != helper) {
+		struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
+
+		if (tmp && tmp->help != helper->help) {
 			RCU_INIT_POINTER(help->helper, NULL);
 			goto out;
 		}
-- 
1.7.10.4

