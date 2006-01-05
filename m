From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/18]: make ipv6_find_hdr() find transport protocol
	header
Date: Thu,  5 Jan 2006 05:06:51 +0100 (MET)
Message-ID: <20060105040616.23512.35272.sendpatchset@localhost.localdomain>
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

[NETFILTER]: make ipv6_find_hdr() find transport protocol header

The original ipv6_find_hdr() finds the specified header in IPv6 packets.
This makes it possible to get transport header so that we can kill similar
loop in ip6_match_packet().

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5ce8af1e153cd5a08089d6cb00a79f39773d67a4
tree 1b79f16aadc82f49f147cc88a48b036be5286828
parent 08d7c2719c70f5819768203f17db35934236469b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 05 Jan 2006 03:30:49 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:30:49 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |    2 -
 net/ipv6/netfilter/ip6_tables.c           |  106 +++++++++++------------------
 net/ipv6/netfilter/ip6t_ah.c              |    2 -
 net/ipv6/netfilter/ip6t_dst.c             |    4 +
 net/ipv6/netfilter/ip6t_esp.c             |    2 -
 net/ipv6/netfilter/ip6t_frag.c            |    2 -
 net/ipv6/netfilter/ip6t_hbh.c             |    4 +
 net/ipv6/netfilter/ip6t_rt.c              |    2 -
 8 files changed, 49 insertions(+), 75 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 2efc046..a291cb7 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -474,7 +474,7 @@ extern unsigned int ip6t_do_table(struct
 extern int ip6t_ext_hdr(u8 nexthdr);
 /* find specified header and get offset to it */
 extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
-			 u8 target);
+			 int target, unsigned short *fragoff);
 
 #define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ea43ef1..13b1a52 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -205,69 +205,21 @@ ip6_packet_match(const struct sk_buff *s
 
 	/* look for the desired protocol header */
 	if((ip6info->flags & IP6T_F_PROTO)) {
-		u_int8_t currenthdr = ipv6->nexthdr;
-		struct ipv6_opt_hdr _hdr, *hp;
-		u_int16_t ptr;		/* Header offset in skb */
-		u_int16_t hdrlen;	/* Header */
-		u_int16_t _fragoff = 0, *fp = NULL;
-
-		ptr = IPV6_HDR_LEN;
-
-		while (ip6t_ext_hdr(currenthdr)) {
-	                /* Is there enough space for the next ext header? */
-	                if (skb->len - ptr < IPV6_OPTHDR_LEN)
-	                        return 0;
-
-			/* NONE or ESP: there isn't protocol part */
-			/* If we want to count these packets in '-p all',
-			 * we will change the return 0 to 1*/
-			if ((currenthdr == IPPROTO_NONE) || 
-				(currenthdr == IPPROTO_ESP))
-				break;
-
-			hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-			BUG_ON(hp == NULL);
+		int protohdr;
+		unsigned short _frag_off;
 
-			/* Size calculation */
-	                if (currenthdr == IPPROTO_FRAGMENT) {
-				fp = skb_header_pointer(skb,
-						   ptr+offsetof(struct frag_hdr,
-								frag_off),
-						   sizeof(_fragoff),
-						   &_fragoff);
-				if (fp == NULL)
-					return 0;
-
-				_fragoff = ntohs(*fp) & ~0x7;
-	                        hdrlen = 8;
-	                } else if (currenthdr == IPPROTO_AH)
-	                        hdrlen = (hp->hdrlen+2)<<2;
-	                else
-	                        hdrlen = ipv6_optlen(hp);
-
-			currenthdr = hp->nexthdr;
-	                ptr += hdrlen;
-			/* ptr is too large */
-	                if ( ptr > skb->len ) 
-				return 0;
-			if (_fragoff) {
-				if (ip6t_ext_hdr(currenthdr))
-					return 0;
-				break;
-			}
-		}
-
-		*protoff = ptr;
-		*fragoff = _fragoff;
+		protohdr = ipv6_find_hdr(skb, protoff, -1, &_frag_off);
+		if (protohdr < 0)
+			return 0;
 
-		/* currenthdr contains the protocol header */
+		*fragoff = _frag_off;
 
 		dprintf("Packet protocol %hi ?= %s%hi.\n",
-				currenthdr, 
+				protohdr, 
 				ip6info->invflags & IP6T_INV_PROTO ? "!":"",
 				ip6info->proto);
 
-		if (ip6info->proto == currenthdr) {
+		if (ip6info->proto == protohdr) {
 			if(ip6info->invflags & IP6T_INV_PROTO) {
 				return 0;
 			}
@@ -2098,26 +2050,39 @@ static void __exit fini(void)
 }
 
 /*
- * find specified header up to transport protocol header.
- * If found target header, the offset to the header is set to *offset
- * and return 0. otherwise, return -1.
+ * find the offset to specified header or the protocol number of last header
+ * if target < 0. "last header" is transport protocol header, ESP, or
+ * "No next header".
+ *
+ * If target header is found, its offset is set in *offset and return protocol
+ * number. Otherwise, return -1.
+ *
+ * Note that non-1st fragment is special case that "the protocol number
+ * of last header" is "next header" field in Fragment header. In this case,
+ * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
+ * isn't NULL.
  *
- * Notes: - non-1st Fragment Header isn't skipped.
- *	  - ESP header isn't skipped.
- *	  - The target header may be trancated.
  */
-int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset, u8 target)
+int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
+		  int target, unsigned short *fragoff)
 {
 	unsigned int start = (u8*)(skb->nh.ipv6h + 1) - skb->data;
 	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 	unsigned int len = skb->len - start;
 
+	if (fragoff)
+		*fragoff = 0;
+
 	while (nexthdr != target) {
 		struct ipv6_opt_hdr _hdr, *hp;
 		unsigned int hdrlen;
 
-		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE)
+		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE) {
+			if (target < 0)
+				break;
 			return -1;
+		}
+
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (hp == NULL)
 			return -1;
@@ -2131,8 +2096,17 @@ int ipv6_find_hdr(const struct sk_buff *
 			if (fp == NULL)
 				return -1;
 
-			if (ntohs(*fp) & ~0x7)
+			_frag_off = ntohs(*fp) & ~0x7;
+			if (_frag_off) {
+				if (target < 0 &&
+				    ((!ipv6_ext_hdr(hp->nexthdr)) ||
+				     nexthdr == NEXTHDR_NONE)) {
+					if (fragoff)
+						*fragoff = _frag_off;
+					return hp->nexthdr;
+				}
 				return -1;
+			}
 			hdrlen = 8;
 		} else if (nexthdr == NEXTHDR_AUTH)
 			hdrlen = (hp->hdrlen + 2) << 2; 
@@ -2145,7 +2119,7 @@ int ipv6_find_hdr(const struct sk_buff *
 	}
 
 	*offset = start;
-	return 0;
+	return nexthdr;
 }
 
 EXPORT_SYMBOL(ip6t_register_table);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 268918d..f5c1a7f 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -54,7 +54,7 @@ match(const struct sk_buff *skb,
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL) < 0)
 		return 0;
 
 	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index c450a63..48cf5f9 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -71,9 +71,9 @@ match(const struct sk_buff *skb,
        unsigned int optlen;
        
 #if HOPBYHOP
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP, NULL) < 0)
 #else
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST, NULL) < 0)
 #endif
 		return 0;
 
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
index 65937de..e1828f6 100644
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ b/net/ipv6/netfilter/ip6t_esp.c
@@ -56,7 +56,7 @@ match(const struct sk_buff *skb,
 	/* Make sure this isn't an evil packet */
 	/*DEBUGP("ipv6_esp entered \n");*/
 
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ESP) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ESP, NULL) < 0)
 		return 0;
 
 	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 085d5f8..d1549b2 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -52,7 +52,7 @@ match(const struct sk_buff *skb,
        const struct ip6t_frag *fraginfo = matchinfo;
        unsigned int ptr;
 
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL) < 0)
 		return 0;
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 1d09485..e3bc8e2 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -71,9 +71,9 @@ match(const struct sk_buff *skb,
        unsigned int optlen;
        
 #if HOPBYHOP
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP, NULL) < 0)
 #else
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST, NULL) < 0)
 #endif
 		return 0;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index beb2fd5..c1e770e 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -58,7 +58,7 @@ match(const struct sk_buff *skb,
        unsigned int ret = 0;
        struct in6_addr *ap, _addr;
 
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING) < 0)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL) < 0)
 		return 0;
 
        rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
