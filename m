From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/25] netfilter: conntrack: protect early_drop by rcu read lock
Date: Sat, 23 Jul 2016 13:02:13 +0200
Message-ID: <1469271745-14523-14-git-send-email-pablo@netfilter.org>
References: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35297 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbcGWLDP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:03:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F060AE7DAA
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DBA27FAB53
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C3FEFFAB56
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:11 +0200 (CEST)
In-Reply-To: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

User can add ct entry via nfnetlink(IPCTNL_MSG_CT_NEW), and if the total
number reach the nf_conntrack_max, we will try to drop some ct entries.

But in this case(the main function call path is ctnetlink_create_conntrack
-> nf_conntrack_alloc -> early_drop), rcu_read_lock is not held, so race
with hash resize will happen.

Fixes: 242922a02717 ("netfilter: conntrack: simplify early_drop")
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0e9c9a..2d46225 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -880,6 +880,7 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 		struct hlist_nulls_head *ct_hash;
 		unsigned hash, sequence, drops;
 
+		rcu_read_lock();
 		do {
 			sequence = read_seqcount_begin(&nf_conntrack_generation);
 			hash = scale_hash(_hash++);
@@ -887,6 +888,8 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 		} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
 
 		drops = early_drop_list(net, &ct_hash[hash]);
+		rcu_read_unlock();
+
 		if (drops) {
 			NF_CT_STAT_ADD_ATOMIC(net, early_drop, drops);
 			return true;
-- 
2.1.4

