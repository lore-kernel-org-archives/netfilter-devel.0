From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2]: conntrack: fix refcount leak when finding expectation
Date: Fri, 24 Nov 2006 08:15:30 +0900 (JST)
Message-ID: <200611232315.kANNFVib006772@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, pablo@netfilter.org
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


# Sorry, I forgot netfilter-devel, so resend.

All users of __{ip,nf}_conntrack_expect_find() don't expect that
it increments the reference count of expectation.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 139a3c05b435f47cfd26eba62c0e04b35bb5d9d3
tree 1aa652bd008fceeb66ea52d21c58deac031353f1
parent 1d301309e433ca67a74569a536078861a767c425
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 07:09:46 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 07:09:46 +0900

 net/ipv4/netfilter/ip_conntrack_core.c |    6 +++---
 net/netfilter/nf_conntrack_core.c      |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 143c466..8b848aa 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -225,10 +225,8 @@ __ip_conntrack_expect_find(const struct
 	struct ip_conntrack_expect *i;
 	
 	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
-		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
-			atomic_inc(&i->use);
+		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
 			return i;
-		}
 	}
 	return NULL;
 }
@@ -241,6 +239,8 @@ ip_conntrack_expect_find(const struct ip
 	
 	read_lock_bh(&ip_conntrack_lock);
 	i = __ip_conntrack_expect_find(tuple);
+	if (i)
+		atomic_inc(&i->use);
 	read_unlock_bh(&ip_conntrack_lock);
 
 	return i;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0f58307..de0567b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -469,10 +469,8 @@ __nf_conntrack_expect_find(const struct
 	struct nf_conntrack_expect *i;
 	
 	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
-		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
-			atomic_inc(&i->use);
+		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
 			return i;
-		}
 	}
 	return NULL;
 }
@@ -485,6 +483,8 @@ nf_conntrack_expect_find(const struct nf
 	
 	read_lock_bh(&nf_conntrack_lock);
 	i = __nf_conntrack_expect_find(tuple);
+	if (i)
+		atomic_inc(&i->use);
 	read_unlock_bh(&nf_conntrack_lock);
 
 	return i;
