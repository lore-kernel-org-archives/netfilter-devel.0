From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.6.14] return ENOMEM if failed to allocate conntrack.
Date: Mon, 08 Aug 2005 17:47:00 +0900 (JST)
Message-ID: <200508080847.j788l1Yg004416@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Aug__8_17_47_00_2005_240)--"
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

----Next_Part(Mon_Aug__8_17_47_00_2005_240)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

This patch fixes the bug which doesn't return ERR_PTR(-ENOMEM) if it failed
to allocate memory space from slab cache.

Please consider applying this to netfilter-2.6.14 tree.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_Aug__8_17_47_00_2005_240)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-nomem.patch"

[NETFILTER] return ENOMEM if failed to allocate conntrack.

This patch fixes the bug which doesn't return ERR_PTR(-ENOMEM) if it failed
to allocate memory space from slab cache.

---
commit b4cfffe82a33f72621196cdc7a79d6b0fb0085df
tree 7401f6dfad283fac89e95397a3050ce7584664a7
parent cb61a01e73b145368630f82298951e77a9ff8ee4
author <kozakai@alprut.(none)> Mon, 08 Aug 2005 01:51:33 +0900
committer <kozakai@alprut.(none)> Mon, 08 Aug 2005 01:51:33 +0900

 net/ipv4/netfilter/ip_conntrack_core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -655,7 +655,7 @@ struct ip_conntrack *ip_conntrack_alloc(
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	memset(conntrack, 0, sizeof(*conntrack));
@@ -696,8 +696,9 @@ init_conntrack(struct ip_conntrack_tuple
 		return NULL;
 	}
 
-	if (!(conntrack = ip_conntrack_alloc(tuple, &repl_tuple)))
-		return NULL;
+	conntrack = ip_conntrack_alloc(tuple, &repl_tuple);
+	if (conntrack == NULL || IS_ERR(conntrack))
+		return (struct ip_conntrack_tuple_hash *)conntrack;
 
 	if (!protocol->new(conntrack, skb)) {
 		ip_conntrack_free(conntrack);

----Next_Part(Mon_Aug__8_17_47_00_2005_240)----
