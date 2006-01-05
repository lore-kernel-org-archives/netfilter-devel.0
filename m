From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/18]: Export ip6_masked_addrcmp,
	don't pass IPv6 addresses on stack
Date: Thu,  5 Jan 2006 05:06:53 +0100 (MET)
Message-ID: <20060105040618.23512.52037.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Export ip6_masked_addrcmp, don't pass IPv6 addresses on stack

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 24cd0baad0ca24fbc94f1af8e731c17afdfcfd71
tree f2fa0bd1455fa4550d7eb917d48ee3c268acf175
parent 5ce8af1e153cd5a08089d6cb00a79f39773d67a4
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:32:01 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:32:01 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |    4 ++++
 net/ipv6/netfilter/ip6_tables.c           |   18 ++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index a291cb7..c163ba3 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -476,6 +476,10 @@ extern int ip6t_ext_hdr(u8 nexthdr);
 extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 			 int target, unsigned short *fragoff);
 
+extern int ip6_masked_addrcmp(const struct in6_addr *addr1,
+			      const struct in6_addr *mask,
+			      const struct in6_addr *addr2);
+
 #define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
 
 #endif /*__KERNEL__*/
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 13b1a52..925b42d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -119,13 +119,14 @@ static LIST_HEAD(ip6t_tables);
 #define up(x) do { printk("UP:%u:" #x "\n", __LINE__); up(x); } while(0)
 #endif
 
-static int ip6_masked_addrcmp(struct in6_addr addr1, struct in6_addr mask,
-			      struct in6_addr addr2)
+int
+ip6_masked_addrcmp(const struct in6_addr *addr1, const struct in6_addr *mask,
+                   const struct in6_addr *addr2)
 {
 	int i;
 	for( i = 0; i < 16; i++){
-		if((addr1.s6_addr[i] & mask.s6_addr[i]) != 
-		   (addr2.s6_addr[i] & mask.s6_addr[i]))
+		if((addr1->s6_addr[i] & mask->s6_addr[i]) != 
+		   (addr2->s6_addr[i] & mask->s6_addr[i]))
 			return 1;
 	}
 	return 0;
@@ -159,10 +160,10 @@ ip6_packet_match(const struct sk_buff *s
 
 #define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
 
-	if (FWINV(ip6_masked_addrcmp(ipv6->saddr,ip6info->smsk,ip6info->src),
-		  IP6T_INV_SRCIP)
-	    || FWINV(ip6_masked_addrcmp(ipv6->daddr,ip6info->dmsk,ip6info->dst),
-		     IP6T_INV_DSTIP)) {
+	if (FWINV(ip6_masked_addrcmp(&ipv6->saddr, &ip6info->smsk,
+	                             &ip6info->src), IP6T_INV_SRCIP)
+	    || FWINV(ip6_masked_addrcmp(&ipv6->daddr, &ip6info->dmsk,
+	                                &ip6info->dst), IP6T_INV_DSTIP)) {
 		dprintf("Source or dest mismatch.\n");
 /*
 		dprintf("SRC: %u. Mask: %u. Target: %u.%s\n", ip->saddr,
@@ -2131,6 +2132,7 @@ EXPORT_SYMBOL(ip6t_register_target);
 EXPORT_SYMBOL(ip6t_unregister_target);
 EXPORT_SYMBOL(ip6t_ext_hdr);
 EXPORT_SYMBOL(ipv6_find_hdr);
+EXPORT_SYMBOL(ip6_masked_addrcmp);
 
 module_init(init);
 module_exit(fini);
