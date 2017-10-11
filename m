From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: x_tables: ensure readers see new ->private value
Date: Wed, 11 Oct 2017 20:03:24 +0200
Message-ID: <20171011180324.15638-1-fw@strlen.de>
Cc: edumazet@google.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42248 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757852AbdJKSDH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 14:03:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
 But it seems we need an extra smp_wmb() after
      smp_wmb();
      table->private = newinfo;

Otherwise we have no guarantee other cpus actually see the new
->private value.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d8571f414208..64cf669ecd6c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1182,6 +1182,9 @@ xt_replace_table(struct xt_table *table,
 	smp_wmb();
 	table->private = newinfo;
 
+	/* Ensure other cpus see the new ->private value. */
+	smp_wmb();
+
 	/*
 	 * Even though table entries have now been swapped, other CPU's
 	 * may still be using the old entries. This is okay, because
-- 
2.13.6

