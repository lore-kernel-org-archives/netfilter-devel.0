From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/50]: x_tables: switch hotdrop to bool
Date: Sat,  7 Jul 2007 14:23:04 +0200 (MEST)
Message-ID: <20070707122219.1589.5284.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: switch hotdrop to bool

Switch the "hotdrop" variables to boolean

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9585b488575e0b72aa54636e019ee4d711982ac8
tree 44fb6014d478fe6cf06663787af7773c40be2a22
parent 758639bdab77d422ed21343f206644a73d568787
author Jan Engelhardt <jengelh@gmx.de> Sat, 07 Jul 2007 12:15:07 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:07 +0200

 include/linux/netfilter/x_tables.h   |    2 +-
 net/ipv4/netfilter/arp_tables.c      |    2 +-
 net/ipv4/netfilter/ip_tables.c       |    8 ++++----
 net/ipv4/netfilter/ipt_addrtype.c    |    2 +-
 net/ipv4/netfilter/ipt_ah.c          |    4 ++--
 net/ipv4/netfilter/ipt_ecn.c         |    6 +++---
 net/ipv4/netfilter/ipt_iprange.c     |    2 +-
 net/ipv4/netfilter/ipt_owner.c       |    2 +-
 net/ipv4/netfilter/ipt_recent.c      |    4 ++--
 net/ipv4/netfilter/ipt_tos.c         |    2 +-
 net/ipv4/netfilter/ipt_ttl.c         |    2 +-
 net/ipv6/netfilter/ip6_tables.c      |   12 ++++++------
 net/ipv6/netfilter/ip6t_ah.c         |    6 +++---
 net/ipv6/netfilter/ip6t_eui64.c      |    4 ++--
 net/ipv6/netfilter/ip6t_frag.c       |    6 +++---
 net/ipv6/netfilter/ip6t_hbh.c        |    6 +++---
 net/ipv6/netfilter/ip6t_hl.c         |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    6 +++---
 net/ipv6/netfilter/ip6t_owner.c      |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    6 +++---
 net/netfilter/xt_comment.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_conntrack.c         |    2 +-
 net/netfilter/xt_dccp.c              |   12 ++++++------
 net/netfilter/xt_dscp.c              |    4 ++--
 net/netfilter/xt_esp.c               |    4 ++--
 net/netfilter/xt_hashlimit.c         |    4 ++--
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_length.c            |    4 ++--
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_mac.c               |    2 +-
 net/netfilter/xt_mark.c              |    2 +-
 net/netfilter/xt_multiport.c         |    8 ++++----
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_pkttype.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_sctp.c              |    8 ++++----
 net/netfilter/xt_state.c             |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpmss.c            |    4 ++--
 net/netfilter/xt_tcpudp.c            |   16 ++++++++--------
 46 files changed, 92 insertions(+), 92 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7e733a6..b8577d1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -148,7 +148,7 @@ struct xt_match
 		     const void *matchinfo,
 		     int offset,
 		     unsigned int protoff,
-		     int *hotdrop);
+		     bool *hotdrop);
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index cae4121..1d75a5c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -224,7 +224,7 @@ unsigned int arpt_do_table(struct sk_buff **pskb,
 	static const char nulldevname[IFNAMSIZ];
 	unsigned int verdict = NF_DROP;
 	struct arphdr *arp;
-	int hotdrop = 0;
+	bool hotdrop = false;
 	struct arpt_entry *e, *back;
 	const char *indev, *outdev;
 	void *table_base;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 9bacf1a..e2a8938 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -188,7 +188,7 @@ int do_match(struct ipt_entry_match *m,
 	     const struct net_device *in,
 	     const struct net_device *out,
 	     int offset,
-	     int *hotdrop)
+	     bool *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
@@ -216,7 +216,7 @@ ipt_do_table(struct sk_buff **pskb,
 	u_int16_t offset;
 	struct iphdr *ip;
 	u_int16_t datalen;
-	int hotdrop = 0;
+	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
 	const char *indev, *outdev;
@@ -2122,7 +2122,7 @@ icmp_match(const struct sk_buff *skb,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   bool *hotdrop)
 {
 	struct icmphdr _icmph, *ic;
 	const struct ipt_icmp *icmpinfo = matchinfo;
@@ -2137,7 +2137,7 @@ icmp_match(const struct sk_buff *skb,
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index a652a14..a9a9b75 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,7 +30,7 @@ static inline int match_type(__be32 addr, u_int16_t mask)
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 18a1678..9a244e4 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -44,7 +44,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct ip_auth_hdr _ahdr, *ah;
 	const struct ipt_ah *ahinfo = matchinfo;
@@ -60,7 +60,7 @@ match(const struct sk_buff *skb,
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil AH tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 2621812..a47f374 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -30,7 +30,7 @@ static inline int match_ip(const struct sk_buff *skb,
 
 static inline int match_tcp(const struct sk_buff *skb,
 			    const struct ipt_ecn_info *einfo,
-			    int *hotdrop)
+			    bool *hotdrop)
 {
 	struct tcphdr _tcph, *th;
 
@@ -39,7 +39,7 @@ static inline int match_tcp(const struct sk_buff *skb,
 	 */
 	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_tcph), &_tcph);
 	if (th == NULL) {
-		*hotdrop = 0;
+		*hotdrop = false;
 		return 0;
 	}
 
@@ -69,7 +69,7 @@ static inline int match_tcp(const struct sk_buff *skb,
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 33af9e9..86f225c 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -29,7 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
-      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_iprange_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 7fae9aa..92be562 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -29,7 +29,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct ipt_owner_info *info = matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 15a9e8b..81f1a01 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -173,7 +173,7 @@ static int
 ipt_recent_match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_table *t;
@@ -201,7 +201,7 @@ ipt_recent_match(const struct sk_buff *skb,
 			goto out;
 		e = recent_entry_init(t, addr, ttl);
 		if (e == NULL)
-			*hotdrop = 1;
+			*hotdrop = true;
 		ret ^= 1;
 		goto out;
 	}
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index d314844..803ed4c 100644
--- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -26,7 +26,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct ipt_tos_info *info = matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index ab02d9e..e7316b2 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("GPL");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_ttl_info *info = matchinfo;
 	const u8 ttl = ip_hdr(skb)->ttl;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9aa6240..13c66a7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -102,7 +102,7 @@ ip6_packet_match(const struct sk_buff *skb,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
 		 unsigned int *protoff,
-		 int *fragoff, int *hotdrop)
+		 int *fragoff, bool *hotdrop)
 {
 	size_t i;
 	unsigned long ret;
@@ -162,7 +162,7 @@ ip6_packet_match(const struct sk_buff *skb,
 		protohdr = ipv6_find_hdr(skb, protoff, -1, &_frag_off);
 		if (protohdr < 0) {
 			if (_frag_off == 0)
-				*hotdrop = 1;
+				*hotdrop = true;
 			return 0;
 		}
 		*fragoff = _frag_off;
@@ -225,7 +225,7 @@ int do_match(struct ip6t_entry_match *m,
 	     const struct net_device *out,
 	     int offset,
 	     unsigned int protoff,
-	     int *hotdrop)
+	     bool *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
@@ -252,7 +252,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	int offset = 0;
 	unsigned int protoff = 0;
-	int hotdrop = 0;
+	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
 	const char *indev, *outdev;
@@ -1299,7 +1299,7 @@ icmp6_match(const struct sk_buff *skb,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   bool *hotdrop)
 {
 	struct icmp6hdr _icmp, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
@@ -1313,7 +1313,7 @@ icmp6_match(const struct sk_buff *skb,
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index d3c1543..27b7bd2 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -49,7 +49,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct ip_auth_hdr *ah, _ah;
 	const struct ip6t_ah *ahinfo = matchinfo;
@@ -60,13 +60,13 @@ match(const struct sk_buff *skb,
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = 1;
+			*hotdrop = true;
 		return 0;
 	}
 
 	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
 	if (ah == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 0f3dd93..69e79e1 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -27,7 +27,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	unsigned char eui64[8];
 	int i = 0;
@@ -35,7 +35,7 @@ match(const struct sk_buff *skb,
 	if (!(skb_mac_header(skb) >= skb->head &&
 	      (skb_mac_header(skb) + ETH_HLEN) <= skb->data) &&
 	    offset != 0) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 5a5da71..740fdca 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct frag_hdr _frag, *fh;
 	const struct ip6t_frag *fraginfo = matchinfo;
@@ -58,13 +58,13 @@ match(const struct sk_buff *skb,
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = 1;
+			*hotdrop = true;
 		return 0;
 	}
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
 	if (fh == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index d2373c7..5633de1 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -55,7 +55,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct ipv6_opt_hdr _optsh, *oh;
 	const struct ip6t_opts *optinfo = matchinfo;
@@ -71,13 +71,13 @@ match(const struct sk_buff *skb,
 	err = ipv6_find_hdr(skb, &ptr, match->data, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = 1;
+			*hotdrop = true;
 		return 0;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
 	if (oh == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index d606c0e..cbf49cf 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -22,7 +22,7 @@ MODULE_LICENSE("GPL");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ip6t_hl_info *info = matchinfo;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index fd6a086..469dec2 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -34,7 +34,7 @@ ipv6header_match(const struct sk_buff *skb,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 bool *hotdrop)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
 	unsigned int temp;
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index c2a9098..c27647b 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
 	 const void *matchinfo,
 	 int offset,
 	 unsigned int protoff,
-	 int *hotdrop)
+	 bool *hotdrop)
 {
 	struct ip6_mh _mh, *mh;
 	const struct ip6t_mh *mhinfo = matchinfo;
@@ -62,14 +62,14 @@ match(const struct sk_buff *skb,
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil MH tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
 		duprintf("Dropping invalid MH Payload Proto: %u\n",
 			 mh->ip6mh_proto);
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 43738bb..f90f7c3 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -31,7 +31,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 81ab00d..2bb8821 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -50,7 +50,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct ipv6_rt_hdr _route, *rh;
 	const struct ip6t_rt *rtinfo = matchinfo;
@@ -64,13 +64,13 @@ match(const struct sk_buff *skb,
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = 1;
+			*hotdrop = true;
 		return 0;
 	}
 
 	rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
 	if (rh == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 7db492d..20690ea 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -23,7 +23,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protooff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	/* We always match */
 	return 1;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 804afe5..8fe5775 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -23,7 +23,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 	struct nf_conn *ct;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index e180325..8a6d58a 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -38,7 +38,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_connmark_info *info = matchinfo;
 	struct nf_conn *ct;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 189ded5..915c730 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -27,7 +27,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
 	struct nf_conn *ct;
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 2c9c0de..3172e73 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -36,7 +36,7 @@ dccp_find_option(u_int8_t option,
 		 const struct sk_buff *skb,
 		 unsigned int protoff,
 		 const struct dccp_hdr *dh,
-		 int *hotdrop)
+		 bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
 	unsigned char *op;
@@ -45,7 +45,7 @@ dccp_find_option(u_int8_t option,
 	unsigned int i;
 
 	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh)) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
@@ -57,7 +57,7 @@ dccp_find_option(u_int8_t option,
 	if (op == NULL) {
 		/* If we don't have the whole header, drop packet. */
 		spin_unlock_bh(&dccp_buflock);
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
@@ -86,7 +86,7 @@ match_types(const struct dccp_hdr *dh, u_int16_t typemask)
 
 static inline int
 match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
-	     const struct dccp_hdr *dh, int *hotdrop)
+	     const struct dccp_hdr *dh, bool *hotdrop)
 {
 	return dccp_find_option(option, skb, protoff, dh, hotdrop);
 }
@@ -99,7 +99,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_dccp_info *info = matchinfo;
 	struct dccp_hdr _dh, *dh;
@@ -109,7 +109,7 @@ match(const struct sk_buff *skb,
 
 	dh = skb_header_pointer(skb, protoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 56b247e..c106d73 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -29,7 +29,7 @@ static int match(const struct sk_buff *skb,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 bool *hotdrop)
 {
 	const struct xt_dscp_info *info = matchinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -44,7 +44,7 @@ static int match6(const struct sk_buff *skb,
 		  const void *matchinfo,
 		  int offset,
 		  unsigned int protoff,
-		  int *hotdrop)
+		  bool *hotdrop)
 {
 	const struct xt_dscp_info *info = matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 7c95f14..5d3421b 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -50,7 +50,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	struct ip_esp_hdr _esp, *eh;
 	const struct xt_esp *espinfo = matchinfo;
@@ -65,7 +65,7 @@ match(const struct sk_buff *skb,
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ESP tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d3043fa..cd5cba6 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -440,7 +440,7 @@ hashlimit_match(const struct sk_buff *skb,
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
-		int *hotdrop)
+		bool *hotdrop)
 {
 	struct xt_hashlimit_info *r =
 		((struct xt_hashlimit_info *)matchinfo)->u.master;
@@ -487,7 +487,7 @@ hashlimit_match(const struct sk_buff *skb,
 	return 0;
 
 hotdrop:
-	*hotdrop = 1;
+	*hotdrop = true;
 	return 0;
 }
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index c139b2f..0aa0907 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -36,7 +36,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_helper_info *info = matchinfo;
 	struct nf_conn *ct;
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 77288c5..621c9ee 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -28,7 +28,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_length_info *info = matchinfo;
 	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
@@ -44,7 +44,7 @@ match6(const struct sk_buff *skb,
        const void *matchinfo,
        int offset,
        unsigned int protoff,
-       int *hotdrop)
+       bool *hotdrop)
 {
 	const struct xt_length_info *info = matchinfo;
 	const u_int16_t pktlen = (ntohs(ipv6_hdr(skb)->payload_len) +
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 571a72a..1133b4c 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -65,7 +65,7 @@ ipt_limit_match(const struct sk_buff *skb,
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
-		int *hotdrop)
+		bool *hotdrop)
 {
 	struct xt_rateinfo *r = ((struct xt_rateinfo *)matchinfo)->master;
 	unsigned long now = jiffies;
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 1d3a1d9..0e6a286 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -32,7 +32,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
     const struct xt_mac_info *info = matchinfo;
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 39911dd..944d1ea 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -27,7 +27,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_mark_info *info = matchinfo;
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 4dce2a8..1dc53de 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -102,7 +102,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	__be16 _ports[2], *pptr;
 	const struct xt_multiport *multiinfo = matchinfo;
@@ -116,7 +116,7 @@ match(const struct sk_buff *skb,
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
@@ -133,7 +133,7 @@ match_v1(const struct sk_buff *skb,
 	 const void *matchinfo,
 	 int offset,
 	 unsigned int protoff,
-	 int *hotdrop)
+	 bool *hotdrop)
 {
 	__be16 _ports[2], *pptr;
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
@@ -147,7 +147,7 @@ match_v1(const struct sk_buff *skb,
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 35a0fe2..a6de512 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -31,7 +31,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index e1409fc..692581f 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -28,7 +28,7 @@ static int match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	u_int8_t type;
 	const struct xt_pkttype_info *info = matchinfo;
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 15b45a9..6878482 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -115,7 +115,7 @@ static int match(const struct sk_buff *skb,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 bool *hotdrop)
 {
 	const struct xt_policy_info *info = matchinfo;
 	int ret;
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index bfdde06..53c71ac 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -20,7 +20,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
-      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct xt_quota_info *q = ((struct xt_quota_info *)matchinfo)->master;
 	int ret = q->flags & XT_QUOTA_INVERT ? 1 : 0;
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index c2017f8..41451f5 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -29,7 +29,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_realm_info *info = matchinfo;
 	struct dst_entry *dst = skb->dst;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index f86d8d7..e581afe 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -47,7 +47,7 @@ match_packet(const struct sk_buff *skb,
 	     int chunk_match_type,
 	     const struct xt_sctp_flag_info *flag_info,
 	     const int flag_count,
-	     int *hotdrop)
+	     bool *hotdrop)
 {
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
 	sctp_chunkhdr_t _sch, *sch;
@@ -64,7 +64,7 @@ match_packet(const struct sk_buff *skb,
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
 		if (sch == NULL || sch->length == 0) {
 			duprintf("Dropping invalid SCTP packet.\n");
-			*hotdrop = 1;
+			*hotdrop = true;
 			return 0;
 		}
 
@@ -127,7 +127,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_sctp_info *info = matchinfo;
 	sctp_sctphdr_t _sh, *sh;
@@ -140,7 +140,7 @@ match(const struct sk_buff *skb,
 	sh = skb_header_pointer(skb, protoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 149294f..74fe069 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -28,7 +28,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_state_info *sinfo = matchinfo;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 091a9f8..4e5ed81 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -28,7 +28,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
-      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
 	int ret = info->flags & XT_STATISTIC_INVERT ? 1 : 0;
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 999a005..7552d89 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -28,7 +28,7 @@ static int match(const struct sk_buff *skb,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
-		 int *hotdrop)
+		 bool *hotdrop)
 {
 	const struct xt_string_info *conf = matchinfo;
 	struct ts_state state;
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 80571d0..0db4f53 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -31,7 +31,7 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
-      int *hotdrop)
+      bool *hotdrop)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
 	struct tcphdr _tcph, *th;
@@ -77,7 +77,7 @@ out:
 	return info->invert;
 
 dropit:
-	*hotdrop = 1;
+	*hotdrop = true;
 	return 0;
 }
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 46414b5..ca9ccdd 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -42,7 +42,7 @@ tcp_find_option(u_int8_t option,
 		unsigned int protoff,
 		unsigned int optlen,
 		int invert,
-		int *hotdrop)
+		bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
 	u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
@@ -57,7 +57,7 @@ tcp_find_option(u_int8_t option,
 	op = skb_header_pointer(skb, protoff + sizeof(struct tcphdr),
 				optlen, _opt);
 	if (op == NULL) {
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
@@ -78,7 +78,7 @@ tcp_match(const struct sk_buff *skb,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
-	  int *hotdrop)
+	  bool *hotdrop)
 {
 	struct tcphdr _tcph, *th;
 	const struct xt_tcp *tcpinfo = matchinfo;
@@ -92,7 +92,7 @@ tcp_match(const struct sk_buff *skb,
 		*/
 		if (offset == 1) {
 			duprintf("Dropping evil TCP offset=1 frag.\n");
-			*hotdrop = 1;
+			*hotdrop = true;
 		}
 		/* Must not be a fragment. */
 		return 0;
@@ -105,7 +105,7 @@ tcp_match(const struct sk_buff *skb,
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
@@ -123,7 +123,7 @@ tcp_match(const struct sk_buff *skb,
 		return 0;
 	if (tcpinfo->option) {
 		if (th->doff * 4 < sizeof(_tcph)) {
-			*hotdrop = 1;
+			*hotdrop = true;
 			return 0;
 		}
 		if (!tcp_find_option(tcpinfo->option, skb, protoff,
@@ -157,7 +157,7 @@ udp_match(const struct sk_buff *skb,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
-	  int *hotdrop)
+	  bool *hotdrop)
 {
 	struct udphdr _udph, *uh;
 	const struct xt_udp *udpinfo = matchinfo;
@@ -171,7 +171,7 @@ udp_match(const struct sk_buff *skb,
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
-		*hotdrop = 1;
+		*hotdrop = true;
 		return 0;
 	}
 
