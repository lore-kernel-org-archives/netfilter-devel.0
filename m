From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2]: nf_conntrack: fix the race on assign helper to new
 conntrack
Date: Fri, 24 Nov 2006 02:18:20 +0900 (JST)
Message-ID: <200611231718.kANHIMVl027610@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, kadlec@blackhole.kfki.hu, pablo@netfilter.org
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


The found helper cannot be assigned to conntrack after unlocking
nf_conntrack_lock. This tries to find helper to assign again.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 1d301309e433ca67a74569a536078861a767c425
tree 0ea96fbc55e313e1182ca9dbf0b77ab69b0d56fc
parent b34563e3485e5fdd3c386130fec8189837dff34d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 01:47:24 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 01:47:24 +0900

 net/netfilter/nf_conntrack_core.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 836541e..0f58307 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -893,12 +893,6 @@ __nf_conntrack_alloc(const struct nf_con
 
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
-	if (helper) {
-		struct nf_conn_help *help = nfct_help(conntrack);
-		NF_CT_ASSERT(help);
-		help->helper = helper;
-	}
-
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
@@ -982,8 +976,13 @@ init_conntrack(const struct nf_conntrack
 #endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
-	} else
+	} else {
+		struct nf_conn_help *help = nfct_help(conntrack);
+
+		if (help)
+			help->helper = __nf_ct_helper_find(&repl_tuple);
 		NF_CT_STAT_INC(new);
+	}
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
