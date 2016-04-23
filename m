From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: init all_locks to avoid debug warning
Date: Sun, 24 Apr 2016 01:17:14 +0200
Message-ID: <1461453434-4271-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58651 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbcDWXQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 19:16:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Else we get 'BUG: spinlock bad magic on CPU#' on resize when
spin lock debugging is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index afde5f5..2bbb962 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1659,6 +1659,8 @@ int nf_conntrack_init_start(void)
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
+	spin_lock_init(&nf_conntrack_locks_all_lock);
+
 	if (!nf_conntrack_htable_size) {
 		/* Idea from tcp.c: use 1/16384 of memory.
 		 * On i386: 32MB machine has 512 buckets.
-- 
2.7.3

