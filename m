From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/25] netfilter: conntrack: protect early_drop by rcu read lock
Date: Sat, 23 Jul 2016 13:08:27 +0200
Message-ID: <1469272119-29942-14-git-send-email-pablo@netfilter.org>
References: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
