From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/04]: conntrack: fix refcount leak when finding
	expectation
Date: Mon, 27 Nov 2006 19:20:58 +0100 (MET)
Message-ID: <20061127182058.17688.64661.sendpatchset@localhost.localdomain>
References: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: fix refcount leak when finding expectation

All users of __{ip,nf}_conntrack_expect_find() don't expect that
it increments the reference count of expectation.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a9c71b046b2ba5ced529e0cf53a061c02b2bbf4b
tree f0d31367b29c1ebccdd3aaa35771a2f5adfcae11
parent 7d79b94fc3d91498b8f2ff655839ad84d3390b13
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 27 Nov 2006 18:56:27 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 27 Nov 2006 19:10:45 +0100

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
