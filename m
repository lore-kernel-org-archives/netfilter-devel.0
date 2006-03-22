From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/10]: Fix xt_policy address matching
Date: Wed, 22 Mar 2006 19:47:55 +0100 (MET)
Message-ID: <20060322184755.5655.37050.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix xt_policy address matching

Fix missing inversion in address matching, it was broken during the
conversion to x_tables.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4dea04e970d17675cb21717b7cb02cce02ce155b
tree fdebfbc2ff20d6722d8d951297756b48a2deba47
parent 7eda410688c8365a37c036d9a6d7f6f5a90fa4a9
author Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:25 +0100

 net/netfilter/xt_policy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index d57a611..1099cb0 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -27,9 +27,9 @@ xt_addr_cmp(const union xt_policy_addr *
 {
 	switch (family) {
 	case AF_INET:
-		return (a1->a4.s_addr ^ a2->a4.s_addr) & m->a4.s_addr;
+		return !((a1->a4.s_addr ^ a2->a4.s_addr) & m->a4.s_addr);
 	case AF_INET6:
-		return ipv6_masked_addr_cmp(&a1->a6, &m->a6, &a2->a6);
+		return !ipv6_masked_addr_cmp(&a1->a6, &m->a6, &a2->a6);
 	}
 	return 0;
 }
@@ -44,7 +44,7 @@ match_xfrm_state(struct xfrm_state *x, c
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 
 	return MATCH_ADDR(saddr, smask, (union xt_policy_addr *)&x->props.saddr) &&
-	       MATCH_ADDR(daddr, dmask, (union xt_policy_addr *)&x->id.daddr.a4) &&
+	       MATCH_ADDR(daddr, dmask, (union xt_policy_addr *)&x->id.daddr) &&
 	       MATCH(proto, x->id.proto) &&
 	       MATCH(mode, x->props.mode) &&
 	       MATCH(spi, x->id.spi) &&
