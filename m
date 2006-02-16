From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/13]: Move ip6_masked_addrcmp to include/net/ipv6.h
Date: Thu, 16 Feb 2006 22:32:24 +0100 (MET)
Message-ID: <20060216213224.6933.16631.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Move ip6_masked_addrcmp to include/net/ipv6.h

Replace netfilter's ip6_masked_addrcmp by a more efficient version
in include/net/ipv6.h to make it usable without module dependencies.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 27e960bc61180f1028acd05990c8bcba688fc87f
tree 92352857c92597419b23ef1621a6d8349e37a920
parent 58b6f4b041f8400857ac02cc5a5ddd9f442c05c7
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:56 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:56 +0100

 include/net/ipv6.h               |   12 ++++++++++++
 net/ipv6/netfilter/ip6_tables.c  |   22 ++++------------------
 net/ipv6/netfilter/ip6t_policy.c |    3 ++-
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3b1d963..c893a1c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -282,6 +282,18 @@ static inline int ipv6_addr_cmp(const st
 	return memcmp((const void *) a1, (const void *) a2, sizeof(struct in6_addr));
 }
 
+static inline int
+ipv6_masked_addr_cmp(const struct in6_addr *a1, const struct in6_addr *m,
+		     const struct in6_addr *a2)
+{
+	unsigned int i;
+
+	for (i = 0; i < 4; i++)
+		if ((a1->s6_addr32[i] ^ a2->s6_addr32[i]) & m->s6_addr32[i])
+			return 1;
+	return 0;
+}
+
 static inline void ipv6_addr_copy(struct in6_addr *a1, const struct in6_addr *a2)
 {
 	memcpy((void *) a1, (const void *) a2, sizeof(struct in6_addr));
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bb04852..0d6fe15 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -94,19 +94,6 @@ do {								\
 #define up(x) do { printk("UP:%u:" #x "\n", __LINE__); up(x); } while(0)
 #endif
 
-int
-ip6_masked_addrcmp(const struct in6_addr *addr1, const struct in6_addr *mask,
-                   const struct in6_addr *addr2)
-{
-	int i;
-	for( i = 0; i < 16; i++){
-		if((addr1->s6_addr[i] & mask->s6_addr[i]) != 
-		   (addr2->s6_addr[i] & mask->s6_addr[i]))
-			return 1;
-	}
-	return 0;
-}
-
 /* Check for an extension */
 int 
 ip6t_ext_hdr(u8 nexthdr)
@@ -135,10 +122,10 @@ ip6_packet_match(const struct sk_buff *s
 
 #define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
 
-	if (FWINV(ip6_masked_addrcmp(&ipv6->saddr, &ip6info->smsk,
-	                             &ip6info->src), IP6T_INV_SRCIP)
-	    || FWINV(ip6_masked_addrcmp(&ipv6->daddr, &ip6info->dmsk,
-	                                &ip6info->dst), IP6T_INV_DSTIP)) {
+	if (FWINV(ipv6_masked_addr_cmp(&ipv6->saddr, &ip6info->smsk,
+	                               &ip6info->src), IP6T_INV_SRCIP)
+	    || FWINV(ipv6_masked_addr_cmp(&ipv6->daddr, &ip6info->dmsk,
+	                                  &ip6info->dst), IP6T_INV_DSTIP)) {
 		dprintf("Source or dest mismatch.\n");
 /*
 		dprintf("SRC: %u. Mask: %u. Target: %u.%s\n", ip->saddr,
@@ -1526,7 +1513,6 @@ EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_do_table);
 EXPORT_SYMBOL(ip6t_ext_hdr);
 EXPORT_SYMBOL(ipv6_find_hdr);
-EXPORT_SYMBOL(ip6_masked_addrcmp);
 
 module_init(init);
 module_exit(fini);
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index b2f3007..f2a5997 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -27,7 +27,8 @@ static inline int
 match_xfrm_state(struct xfrm_state *x, const struct ip6t_policy_elem *e)
 {
 #define MATCH_ADDR(x,y,z)	(!e->match.x ||				       \
-				 ((!ip6_masked_addrcmp(&e->x.a6, &e->y.a6, z)) \
+				 ((!ipv6_masked_addr_cmp(&e->x.a6, &e->y.a6,   \
+							 z))                   \
 				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 	
