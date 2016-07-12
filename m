From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/2] netfilter: conntrack: protect early_drop by rcu read lock
Date: Tue, 12 Jul 2016 19:45:00 +0800
Message-ID: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Florian Westphal <fw@strlen.de>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:33107 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcGLLqE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 07:46:04 -0400
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
2.5.5


