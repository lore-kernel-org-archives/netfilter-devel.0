From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/20]: nf_conntrack_expect: avoid useless list walking
Date: Fri, 29 Jun 2007 02:45:08 +0200 (MEST)
Message-ID: <20070629004406.25566.93872.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_expect: avoid useless list walking

Don't walk the list when unexpecting an expectation, we already
have a reference and the timer check is enough to guarantee
that it still is on the list.

This comment suggests that it was copied there by mistake from
expectation eviction:

/* choose the oldest expectation to evict */

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b7e3977052189e3400e250559b29d14431dc9964
tree 3b71639d175ba87e514eaf768caff7f1de1d4083
parent c0a3afa700989b3b3fb003cef94629194a4ccd0d
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:11:04 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:11:04 +0200

 net/netfilter/nf_conntrack_expect.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 83b5ad8..5c8cb0f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -165,17 +165,10 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 /* Generally a bad idea to call this: could have matched already. */
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
-	struct nf_conntrack_expect *i;
-
 	write_lock_bh(&nf_conntrack_lock);
-	/* choose the oldest expectation to evict */
-	list_for_each_entry_reverse(i, &nf_ct_expect_list, list) {
-		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			nf_ct_unlink_expect(i);
-			write_unlock_bh(&nf_conntrack_lock);
-			nf_ct_expect_put(i);
-			return;
-		}
+	if (del_timer(&exp->timeout)) {
+		nf_ct_unlink_expect(exp);
+		nf_ct_expect_put(exp);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
 }
