From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/14]: Fix ip6t_policy address matching
Date: Fri,  3 Feb 2006 14:44:16 +0100 (MET)
Message-ID: <20060203134416.2141.15369.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix ip6t_policy address matching

Fix two bugs in ip6t_policy address matching:
- misorder arguments to ip6_masked_addrcmp, mask must be the second argument
- inversion incorrectly applied to the entire expression instead of just
  the address comparison

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 13518265c8c2fc265520844ada5dd15b10aa4653
tree d374d2abc2678f3ba4da1ab282f1f24a832a9cae
parent 0140ae42a6acc87e5c63ac8367473670dcffba8e
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:27:12 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:27:12 +0100

 net/ipv6/netfilter/ip6t_policy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index 9f38cd0..1d0f482 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -26,8 +26,9 @@ MODULE_LICENSE("GPL");
 static inline int
 match_xfrm_state(struct xfrm_state *x, const struct ip6t_policy_elem *e)
 {
-#define MATCH_ADDR(x,y,z)	(!e->match.x || \
-				 ((ip6_masked_addrcmp((z), &e->x, &e->y)) == 0) ^ e->invert.x)
+#define MATCH_ADDR(x,y,z)	(!e->match.x ||				 \
+				 ((!ip6_masked_addrcmp(&e->x, &e->y, z)) \
+				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 	
 	return MATCH_ADDR(saddr, smask, (struct in6_addr *)&x->props.saddr.a6) &&
