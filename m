From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/09]: Fix xt_policy address matching
Date: Tue, 21 Mar 2006 02:55:59 +0100 (MET)
Message-ID: <20060321015559.11977.82507.sendpatchset@localhost.localdomain>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
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
commit d64ab19c8c265eb3defd20d3fa993df52542ad00
tree 2724b6ba5c06a490a1fdfa8fef7b55f05a9240d1
parent 9f037d96029cc5aad5c61969eeb52ebcb71957d5
author Patrick McHardy <kaber@trash.net> Mon, 20 Mar 2006 14:06:22 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 20 Mar 2006 14:06:22 +0100

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
