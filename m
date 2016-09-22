From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: evict stale entries when user reads /proc/net/nf_conntrack
Date: Thu, 22 Sep 2016 23:49:17 +0200
Message-ID: <1474580957-26032-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46400 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1034404AbcIVVtG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 17:49:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian reports a possible conntrack memory leak (could not reproduce so
far), however, one minor issue can be easily resolved:

> cat /proc/net/nf_conntrack | wc -l = 5
> 4 minutes required to clean up the table.

We should not report those timed-out entries to the user in first place.
And instead of just skipping those timed-out entries while iterating over
the table we can also zap them (we already do this during ctnetlink
walks, but I forgot about the /proc interface).

Fixes: f330a7fdbe16 ("netfilter: conntrack: get rid of conntrack timer")
Reported-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 7d52f8401afd..5f446cd9f3fd 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -212,6 +212,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
+	if (nf_ct_should_gc(ct)) {
+		nf_ct_kill(ct);
+		goto release;
+	}
+
 	/* we only want to print DIR_ORIGINAL */
 	if (NF_CT_DIRECTION(hash))
 		goto release;
-- 
2.7.3

