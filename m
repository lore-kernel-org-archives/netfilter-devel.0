From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/14]: Prepare {ipt,
	ip6t}_policy match for x_tables unification
Date: Fri,  3 Feb 2006 14:44:18 +0100 (MET)
Message-ID: <20060203134418.2141.67308.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Prepare {ipt,ip6t}_policy match for x_tables unification

The IPv4 and IPv6 version of the policy match are identical besides address
comparison and the data structure used for userspace communication. Unify
the data structures to break compatiblity now (before it is released), so
we can port it to x_tables in 2.6.17.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ea913eda85a9b7bf0247db91213a88b1ca2d12d8
tree c5b79a5a4a7e2a8764c2824ff7aa16d9ad6f2c20
parent 13518265c8c2fc265520844ada5dd15b10aa4653
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:34:25 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:34:25 +0100

 include/linux/netfilter_ipv4/ipt_policy.h  |   22 ++++++++++++++--------
 include/linux/netfilter_ipv6/ip6t_policy.h |   22 ++++++++++++++--------
 net/ipv4/netfilter/ipt_policy.c            |    9 ++++++---
 net/ipv6/netfilter/ip6t_policy.c           |    4 ++--
 4 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_policy.h b/include/linux/netfilter_ipv4/ipt_policy.h
index 7fd1bec..a3f6eff 100644
--- a/include/linux/netfilter_ipv4/ipt_policy.h
+++ b/include/linux/netfilter_ipv4/ipt_policy.h
@@ -27,16 +27,22 @@ struct ipt_policy_spec
 			reqid:1;
 };
 
+union ipt_policy_addr
+{
+	struct in_addr	a4;
+	struct in6_addr	a6;
+};
+
 struct ipt_policy_elem
 {
-	u_int32_t	saddr;
-	u_int32_t	smask;
-	u_int32_t	daddr;
-	u_int32_t	dmask;
-	u_int32_t	spi;
-	u_int32_t	reqid;
-	u_int8_t	proto;
-	u_int8_t	mode;
+	union ipt_policy_addr	saddr;
+	union ipt_policy_addr	smask;
+	union ipt_policy_addr	daddr;
+	union ipt_policy_addr	dmask;
+	u_int32_t		spi;
+	u_int32_t		reqid;
+	u_int8_t		proto;
+	u_int8_t		mode;
 
 	struct ipt_policy_spec	match;
 	struct ipt_policy_spec	invert;
diff --git a/include/linux/netfilter_ipv6/ip6t_policy.h b/include/linux/netfilter_ipv6/ip6t_policy.h
index 5a93afc..671bd81 100644
--- a/include/linux/netfilter_ipv6/ip6t_policy.h
+++ b/include/linux/netfilter_ipv6/ip6t_policy.h
@@ -27,16 +27,22 @@ struct ip6t_policy_spec
 			reqid:1;
 };
 
+union ip6t_policy_addr
+{
+	struct in_addr	a4;
+	struct in6_addr	a6;
+};
+
 struct ip6t_policy_elem
 {
-	struct in6_addr	saddr;
-	struct in6_addr	smask;
-	struct in6_addr	daddr;
-	struct in6_addr	dmask;
-	u_int32_t	spi;
-	u_int32_t	reqid;
-	u_int8_t	proto;
-	u_int8_t	mode;
+	union ip6t_policy_addr	saddr;
+	union ip6t_policy_addr	smask;
+	union ip6t_policy_addr	daddr;
+	union ip6t_policy_addr	dmask;
+	u_int32_t		spi;
+	u_int32_t		reqid;
+	u_int8_t		proto;
+	u_int8_t		mode;
 
 	struct ip6t_policy_spec	match;
 	struct ip6t_policy_spec	invert;
diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
index a48949a..5a7a265 100644
--- a/net/ipv4/netfilter/ipt_policy.c
+++ b/net/ipv4/netfilter/ipt_policy.c
@@ -26,10 +26,13 @@ MODULE_LICENSE("GPL");
 static inline int
 match_xfrm_state(struct xfrm_state *x, const struct ipt_policy_elem *e)
 {
-#define MATCH(x,y)	(!e->match.x || ((e->x == (y)) ^ e->invert.x))
+#define MATCH_ADDR(x,y,z)	(!e->match.x ||				     \
+		                 ((e->x.a4.s_addr == (e->y.a4.s_addr & (z))) \
+				  ^ e->invert.x))
+#define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 
-	return MATCH(saddr, x->props.saddr.a4 & e->smask) &&
-	       MATCH(daddr, x->id.daddr.a4 & e->dmask) &&
+	return MATCH_ADDR(saddr, smask, x->props.saddr.a4) &&
+	       MATCH_ADDR(daddr, dmask, x->id.daddr.a4) &&
 	       MATCH(proto, x->id.proto) &&
 	       MATCH(mode, x->props.mode) &&
 	       MATCH(spi, x->id.spi) &&
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index 1d0f482..3d39ec9 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -26,8 +26,8 @@ MODULE_LICENSE("GPL");
 static inline int
 match_xfrm_state(struct xfrm_state *x, const struct ip6t_policy_elem *e)
 {
-#define MATCH_ADDR(x,y,z)	(!e->match.x ||				 \
-				 ((!ip6_masked_addrcmp(&e->x, &e->y, z)) \
+#define MATCH_ADDR(x,y,z)	(!e->match.x ||				       \
+				 ((!ip6_masked_addrcmp(&e->x.a6, &e->y.a6, z)) \
 				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 	
