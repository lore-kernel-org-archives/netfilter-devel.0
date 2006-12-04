From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_conntrack: Don't try to find clashed
	expectation
Date: Mon,  4 Dec 2006 11:56:02 +0100 (MET)
Message-ID: <20061204105911.6456.18151.sendpatchset@localhost.localdomain>
References: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061204105906.6456.62345.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Don't try to find clashed expectation

The original code continues loop to find expectation in list if the master
conntrack of the found expectation is unconfirmed. But it never success
in that case, because nf_conntrack_expect_related() never insert
clashed expectation to the list.

This stops loop in that case.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b7c3fd1079bf21b37b3135466418a2576d7d5fa1
tree 20a30d94395b7015450663f73c1b58f85ed5814c
parent b8ef637f630bc2206673170e07800a8e537f95d8
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 04 Dec 2006 11:39:42 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 04 Dec 2006 11:39:42 +0100

 net/netfilter/nf_conntrack_expect.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 588d379..7df8f9a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -91,25 +91,28 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_fi
 struct nf_conntrack_expect *
 find_expectation(const struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_expect *i;
+	struct nf_conntrack_expect *exp;
+
+	exp = __nf_conntrack_expect_find(tuple);
+	if (!exp)
+		return NULL;
 
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
 	/* If master is not in hash table yet (ie. packet hasn't left
 	   this machine yet), how can other end know about expected?
 	   Hence these are not the droids you are looking for (if
 	   master ct never got confirmed, we'd hold a reference to it
 	   and weird things would happen to future packets). */
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
-		    && nf_ct_is_confirmed(i->master)) {
-			if (i->flags & NF_CT_EXPECT_PERMANENT) {
-				atomic_inc(&i->use);
-				return i;
-			} else if (del_timer(&i->timeout)) {
-				nf_ct_unlink_expect(i);
-				return i;
-			}
-		}
+	if (!nf_ct_is_confirmed(exp->master))
+		return NULL;
+
+	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
+		atomic_inc(&exp->use);
+		return exp;
+	} else if (del_timer(&exp->timeout)) {
+		nf_ct_unlink_expect(exp);
+		return exp;
 	}
+
 	return NULL;
 }
 
