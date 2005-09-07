From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/3] don't increase master refcount on
 expectation
Date: Wed, 07 Sep 2005 11:08:53 +0900 (JST)
Message-ID: <200509070208.j8728shP020308@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Sep__7_11_08_53_2005_516)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Wed_Sep__7_11_08_53_2005_516)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows recent change for ip_conntrack. Because expectations
are always destroyed before its masters, it isn't necessary to increase
the master refcount for non-fulfilled expectations,

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Wed_Sep__7_11_08_53_2005_516)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-master-refcount.patch"

[NETFILTER] don't increase master refcount on expectations in nf_conntrack

This patch follows recent change for ip_conntrack. Because expectations
are always destroyed before its masters, it isn't necessary to increase
the master refcount for non-fulfilled expectations,

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 58d33a593b1a6baf0ae6ce34ec4ac8c6a867143d
tree 25fcc7eec5a2e29eed1f23985b930412a1321f0a
parent bb499fcb241df2c6dc2f0b6244ba664ed6b1bf87
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:21:58 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 07 Sep 2005 09:21:58 +0900

 net/netfilter/nf_conntrack_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1059,6 +1059,9 @@ void nf_conntrack_unexpect_related(struc
 	write_unlock_bh(&nf_conntrack_lock);
 }
 
+/* We don't increase the master conntrack refcount for non-fulfilled
+ * conntracks. During the conntrack destruction, the expectations are
+ * always killed before the conntrack itself */
 struct nf_conntrack_expect *nf_conntrack_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
@@ -1069,17 +1072,14 @@ struct nf_conntrack_expect *nf_conntrack
 		return NULL;
 	}
 	new->master = me;
-	atomic_inc(&new->master->ct_general.use);
 	atomic_set(&new->use, 1);
 	return new;
 }
 
 void nf_conntrack_expect_put(struct nf_conntrack_expect *exp)
 {
-	if (atomic_dec_and_test(&exp->use)) {
-		nf_ct_put(exp->master);
+	if (atomic_dec_and_test(&exp->use))
 		kmem_cache_free(nf_conntrack_expect_cachep, exp);
-	}
 }
 
 static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)

----Next_Part(Wed_Sep__7_11_08_53_2005_516)----
