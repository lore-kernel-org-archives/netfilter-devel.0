From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/36] netfilter: conntrack: don't attempt to iterate over empty table
Date: Mon,  9 May 2016 20:46:35 +0200
Message-ID: <1462819614-5402-18-git-send-email-pablo@netfilter.org>
References: <1462819614-5402-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45735 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbcEISrX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 14:47:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2C14CE8E8C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 20:47:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C85D134727
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 20:47:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7831D134714
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 20:47:19 +0200 (CEST)
In-Reply-To: <1462819614-5402-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Once we place all conntracks into same table iteration becomes more
costly because the table contains conntracks that we are not interested
in (belonging to other netns).

So don't bother scanning if the current namespace has no entries.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 29fa08b..f2e75a5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1428,6 +1428,9 @@ void nf_ct_iterate_cleanup(struct net *net,
 
 	might_sleep();
 
+	if (atomic_read(&net->ct.count) == 0)
+		return;
+
 	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
-- 
2.1.4

