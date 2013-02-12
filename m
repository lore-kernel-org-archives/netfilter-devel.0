From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: nf_ct_helper: don't discard helper if it is actually the same
Date: Tue, 12 Feb 2013 16:59:53 +0100
Message-ID: <1360684793-32109-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40156 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758579Ab3BLP5s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:57:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 32f5376003920a8bc1bd97c6cddcf42df0b6a833
(netfilter: nf_ct_helper: disable automatic helper re-assignment of different type)
breaks transparent proxy scenarios.

For example, initial helper lookup might yield "ftp" (dport 21),
while re-lookup after REDIRECT yields "ftp-2121".

This causes the autoassign code to toss the ftp helper, even
though these are just different instances of the same.

Change the test to check for the helper function address instead
of the helper address, as suggested by Pablo.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_helper.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 884f2b3..6357441 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -236,7 +236,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 		/* We only allow helper re-assignment of the same sort since
 		 * we cannot reallocate the helper extension area.
 		 */
-		if (help->helper != helper) {
+		struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
+		if (tmp && tmp->help != helper->help) {
 			RCU_INIT_POINTER(help->helper, NULL);
 			goto out;
 		}
-- 
1.7.8.6

