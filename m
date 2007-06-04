From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 2/4] Switch xt_match->match to bool
Date: Mon, 4 Jun 2007 17:10:45 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041710220.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
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


Switch the return type of match functions to boolean

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/x_tables.h   |   16 ++++++-------
 net/ipv4/netfilter/ip_tables.c       |   26 ++++++++++-----------
 net/ipv4/netfilter/ipt_addrtype.c    |   12 +++++-----
 net/ipv4/netfilter/ipt_ah.c          |   10 ++++----
 net/ipv4/netfilter/ipt_ecn.c         |   38 +++++++++++++++----------------
 net/ipv4/netfilter/ipt_iprange.c     |    8 +++---
 net/ipv4/netfilter/ipt_owner.c       |   10 ++++----
 net/ipv4/netfilter/ipt_recent.c      |   12 +++++-----
 net/ipv4/netfilter/ipt_tos.c         |    2 -
 net/ipv4/netfilter/ipt_ttl.c         |   12 +++++-----
 net/ipv6/netfilter/ip6_tables.c      |   42 +++++++++++++++++------------------
 net/ipv6/netfilter/ip6t_ah.c         |   12 +++++-----
 net/ipv6/netfilter/ip6t_eui64.c      |    8 +++---
 net/ipv6/netfilter/ip6t_frag.c       |   12 +++++-----
 net/ipv6/netfilter/ip6t_hbh.c        |   18 +++++++--------
 net/ipv6/netfilter/ip6t_hl.c         |   12 +++++-----
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 ++---
 net/ipv6/netfilter/ip6t_mh.c         |   17 +++++---------
 net/ipv6/netfilter/ip6t_owner.c      |   10 ++++----
 net/ipv6/netfilter/ip6t_rt.c         |   26 ++++++++++-----------
 net/netfilter/xt_comment.c           |    4 +--
 net/netfilter/xt_connbytes.c         |    4 +--
 net/netfilter/xt_connmark.c          |    4 +--
 net/netfilter/xt_conntrack.c         |   24 ++++++++++----------
 net/netfilter/xt_dccp.c              |   22 +++++++++---------
 net/netfilter/xt_dscp.c              |   32 +++++++++++++-------------
 net/netfilter/xt_esp.c               |   12 +++++-----
 net/netfilter/xt_hashlimit.c         |   17 +++++++-------
 net/netfilter/xt_helper.c            |    6 ++---
 net/netfilter/xt_length.c            |    4 +--
 net/netfilter/xt_limit.c             |    6 ++---
 net/netfilter/xt_mac.c               |    2 -
 net/netfilter/xt_mark.c              |    2 -
 net/netfilter/xt_multiport.c         |   34 ++++++++++++++--------------
 net/netfilter/xt_physdev.c           |   28 ++++++++++-------------
 net/netfilter/xt_pkttype.c           |    2 -
 net/netfilter/xt_policy.c            |   26 ++++++++++-----------
 net/netfilter/xt_quota.c             |    6 ++---
 net/netfilter/xt_realm.c             |    2 -
 net/netfilter/xt_sctp.c              |   26 ++++++++++-----------
 net/netfilter/xt_state.c             |    2 -
 net/netfilter/xt_statistic.c         |    8 +++---
 net/netfilter/xt_string.c            |   16 ++++++-------
 net/netfilter/xt_tcpmss.c            |    4 +--
 net/netfilter/xt_tcpudp.c            |   39 +++++++++++++++-----------------
 45 files changed, 317 insertions(+), 324 deletions(-)

Index: linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
===================================================================
--- linux-2.6.22-rc3-git6.orig/include/linux/netfilter/x_tables.h
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
@@ -141,14 +141,14 @@ struct xt_match
 	/* Arguments changed since 2.6.9, as this must now handle
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
-	int (*match)(const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const struct xt_match *match,
-		     const void *matchinfo,
-		     int offset,
-		     unsigned int protoff,
-		     bool *hotdrop);
+	bool (*match)(const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const struct xt_match *match,
+		      const void *matchinfo,
+		      int offset,
+		      unsigned int protoff,
+		      bool *hotdrop);
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ip_tables.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ip_tables.c
@@ -183,19 +183,19 @@ ipt_error(struct sk_buff **pskb,
 }
 
 static inline
-int do_match(struct ipt_entry_match *m,
-	     const struct sk_buff *skb,
-	     const struct net_device *in,
-	     const struct net_device *out,
-	     int offset,
-	     bool *hotdrop)
+bool do_match(struct ipt_entry_match *m,
+	      const struct sk_buff *skb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      int offset,
+	      bool *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
 				      offset, ip_hdrlen(skb), hotdrop))
-		return 1;
+		return true;
 	else
-		return 0;
+		return false;
 }
 
 static inline struct ipt_entry *
@@ -2060,16 +2060,16 @@ void ipt_unregister_table(struct xt_tabl
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline int
+static inline bool
 icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		     u_int8_t type, u_int8_t code,
-		     int invert)
+		     bool invert)
 {
 	return ((test_type == 0xFF) || (type == test_type && code >= min_code && code <= max_code))
 		^ invert;
 }
 
-static int
+static bool
 icmp_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
@@ -2084,7 +2084,7 @@ icmp_match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	ic = skb_header_pointer(skb, protoff, sizeof(_icmph), &_icmph);
 	if (ic == NULL) {
@@ -2093,7 +2093,7 @@ icmp_match(const struct sk_buff *skb,
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return icmp_type_code_match(icmpinfo->type,
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_addrtype.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_addrtype.c
@@ -22,19 +22,19 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
 
-static inline int match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(__be32 addr, u_int16_t mask)
 {
 	return !!(mask & (1 << inet_addr_type(addr)));
 }
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in, const struct net_device *out,
-		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  const struct xt_match *match, const void *matchinfo,
+		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
-	int ret = 1;
+	bool ret = true;
 
 	if (info->source)
 		ret &= match_type(iph->saddr, info->source)^info->invert_source;
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ah.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ah.c
@@ -25,10 +25,10 @@ MODULE_DESCRIPTION("iptables AH SPI matc
 #endif
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
-static inline int
-spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+static inline bool
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	int r=0;
+	bool r;
 	duprintf("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
 		min,spi,max);
 	r=(spi >= min && spi <= max) ^ invert;
@@ -36,7 +36,7 @@ spi_match(u_int32_t min, u_int32_t max, 
 	return r;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -51,7 +51,7 @@ match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	ah = skb_header_pointer(skb, protoff,
 				sizeof(_ahdr), &_ahdr);
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ecn.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ecn.c
@@ -22,15 +22,15 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("iptables ECN matching module");
 MODULE_LICENSE("GPL");
 
-static inline int match_ip(const struct sk_buff *skb,
-			   const struct ipt_ecn_info *einfo)
+static inline bool match_ip(const struct sk_buff *skb,
+			    const struct ipt_ecn_info *einfo)
 {
 	return (ip_hdr(skb)->tos & IPT_ECN_IP_MASK) == einfo->ip_ect;
 }
 
-static inline int match_tcp(const struct sk_buff *skb,
-			    const struct ipt_ecn_info *einfo,
-			    bool *hotdrop)
+static inline bool match_tcp(const struct sk_buff *skb,
+			     const struct ipt_ecn_info *einfo,
+			     bool *hotdrop)
 {
 	struct tcphdr _tcph, *th;
 
@@ -40,51 +40,51 @@ static inline int match_tcp(const struct
 	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_tcph), &_tcph);
 	if (th == NULL) {
 		*hotdrop = false;
-		return 0;
+		return false;
 	}
 
 	if (einfo->operation & IPT_ECN_OP_MATCH_ECE) {
 		if (einfo->invert & IPT_ECN_OP_MATCH_ECE) {
 			if (th->ece == 1)
-				return 0;
+				return false;
 		} else {
 			if (th->ece == 0)
-				return 0;
+				return false;
 		}
 	}
 
 	if (einfo->operation & IPT_ECN_OP_MATCH_CWR) {
 		if (einfo->invert & IPT_ECN_OP_MATCH_CWR) {
 			if (th->cwr == 1)
-				return 0;
+				return false;
 		} else {
 			if (th->cwr == 0)
-				return 0;
+				return false;
 		}
 	}
 
-	return 1;
+	return true;
 }
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in, const struct net_device *out,
-		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  const struct xt_match *match, const void *matchinfo,
+		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 
 	if (info->operation & IPT_ECN_OP_MATCH_IP)
 		if (!match_ip(skb, info))
-			return 0;
+			return false;
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
 		if (ip_hdr(skb)->protocol != IPPROTO_TCP)
-			return 0;
+			return false;
 		if (!match_tcp(skb, info, hotdrop))
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int checkentry(const char *tablename, const void *ip_void,
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_iprange.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_iprange.c
@@ -23,7 +23,7 @@ MODULE_DESCRIPTION("iptables arbitrary I
 #define DEBUGP(format, args...)
 #endif
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -44,7 +44,7 @@ match(const struct sk_buff *skb,
 				info->flags & IPRANGE_SRC_INV ? "(INV) " : "",
 				NIPQUAD(info->src.min_ip),
 				NIPQUAD(info->src.max_ip));
-			return 0;
+			return false;
 		}
 	}
 	if (info->flags & IPRANGE_DST) {
@@ -57,10 +57,10 @@ match(const struct sk_buff *skb,
 				info->flags & IPRANGE_DST_INV ? "(INV) " : "",
 				NIPQUAD(info->dst.min_ip),
 				NIPQUAD(info->dst.max_ip));
-			return 0;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match iprange_match = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_owner.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_owner.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables owner match");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -34,21 +34,21 @@ match(const struct sk_buff *skb,
 	const struct ipt_owner_info *info = matchinfo;
 
 	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
-		return 0;
+		return false;
 
 	if(info->match & IPT_OWNER_UID) {
 		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
 		    !!(info->invert & IPT_OWNER_UID))
-			return 0;
+			return false;
 	}
 
 	if(info->match & IPT_OWNER_GID) {
 		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
 		    !!(info->invert & IPT_OWNER_GID))
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_recent.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_recent.c
@@ -169,7 +169,7 @@ static void recent_table_flush(struct re
 	}
 }
 
-static int
+static bool
 ipt_recent_match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
@@ -180,7 +180,7 @@ ipt_recent_match(const struct sk_buff *s
 	struct recent_entry *e;
 	__be32 addr;
 	u_int8_t ttl;
-	int ret = info->invert;
+	bool ret = info->invert;
 
 	if (info->side == IPT_RECENT_DEST)
 		addr = ip_hdr(skb)->daddr;
@@ -202,15 +202,15 @@ ipt_recent_match(const struct sk_buff *s
 		e = recent_entry_init(t, addr, ttl);
 		if (e == NULL)
 			*hotdrop = true;
-		ret ^= 1;
+		ret = !ret;
 		goto out;
 	}
 
 	if (info->check_set & IPT_RECENT_SET)
-		ret ^= 1;
+		ret = !ret;
 	else if (info->check_set & IPT_RECENT_REMOVE) {
 		recent_entry_remove(t, e);
-		ret ^= 1;
+		ret = !ret;
 	} else if (info->check_set & (IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) {
 		unsigned long t = jiffies - info->seconds * HZ;
 		unsigned int i, hits = 0;
@@ -219,7 +219,7 @@ ipt_recent_match(const struct sk_buff *s
 			if (info->seconds && time_after(t, e->stamps[i]))
 				continue;
 			if (++hits >= info->hit_count) {
-				ret ^= 1;
+				ret = !ret;
 				break;
 			}
 		}
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_tos.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_tos.c
@@ -18,7 +18,7 @@
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("iptables TOS match module");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ttl.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ttl.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ttl.c
@@ -18,10 +18,10 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("IP tables TTL matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in, const struct net_device *out,
-		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  const struct xt_match *match, const void *matchinfo,
+		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_ttl_info *info = matchinfo;
 	const u8 ttl = ip_hdr(skb)->ttl;
@@ -42,10 +42,10 @@ static int match(const struct sk_buff *s
 		default:
 			printk(KERN_WARNING "ipt_ttl: unknown mode %d\n",
 				info->mode);
-			return 0;
+			return false;
 	}
 
-	return 0;
+	return false;
 }
 
 static struct xt_match ttl_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6_tables.c
@@ -96,7 +96,7 @@ ip6t_ext_hdr(u8 nexthdr)
 }
 
 /* Returns whether matches rule or not. */
-static inline int
+static inline bool
 ip6_packet_match(const struct sk_buff *skb,
 		 const char *indev,
 		 const char *outdev,
@@ -122,7 +122,7 @@ ip6_packet_match(const struct sk_buff *s
 		dprintf("DST: %u. Mask: %u. Target: %u.%s\n", ip->daddr,
 			ipinfo->dmsk.s_addr, ipinfo->dst.s_addr,
 			ipinfo->invflags & IP6T_INV_DSTIP ? " (INV)" : "");*/
-		return 0;
+		return false;
 	}
 
 	/* Look for ifname matches; this should unroll nicely. */
@@ -136,7 +136,7 @@ ip6_packet_match(const struct sk_buff *s
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
 			indev, ip6info->iniface,
 			ip6info->invflags&IP6T_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
@@ -149,7 +149,7 @@ ip6_packet_match(const struct sk_buff *s
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
 			outdev, ip6info->outiface,
 			ip6info->invflags&IP6T_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 /* ... might want to do something with class and flowlabel here ... */
@@ -163,7 +163,7 @@ ip6_packet_match(const struct sk_buff *s
 		if (protohdr < 0) {
 			if (_frag_off == 0)
 				*hotdrop = true;
-			return 0;
+			return false;
 		}
 		*fragoff = _frag_off;
 
@@ -174,17 +174,17 @@ ip6_packet_match(const struct sk_buff *s
 
 		if (ip6info->proto == protohdr) {
 			if(ip6info->invflags & IP6T_INV_PROTO) {
-				return 0;
+				return false;
 			}
-			return 1;
+			return true;
 		}
 
 		/* We need match for the '-p all', too! */
 		if ((ip6info->proto != 0) &&
 			!(ip6info->invflags & IP6T_INV_PROTO))
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 /* should be ip6 safe */
@@ -219,20 +219,20 @@ ip6t_error(struct sk_buff **pskb,
 }
 
 static inline
-int do_match(struct ip6t_entry_match *m,
-	     const struct sk_buff *skb,
-	     const struct net_device *in,
-	     const struct net_device *out,
-	     int offset,
-	     unsigned int protoff,
-	     bool *hotdrop)
+bool do_match(struct ip6t_entry_match *m,
+	      const struct sk_buff *skb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      int offset,
+	      unsigned int protoff,
+	      bool *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
 				      offset, protoff, hotdrop))
-		return 1;
+		return true;
 	else
-		return 0;
+		return false;
 }
 
 static inline struct ip6t_entry *
@@ -1291,7 +1291,7 @@ icmp6_type_code_match(u_int8_t test_type
 		^ invert;
 }
 
-static int
+static bool
 icmp6_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
@@ -1306,7 +1306,7 @@ icmp6_match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	ic = skb_header_pointer(skb, protoff, sizeof(_icmp), &_icmp);
 	if (ic == NULL) {
@@ -1314,7 +1314,7 @@ icmp6_match(const struct sk_buff *skb,
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil ICMP tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return icmp6_type_code_match(icmpinfo->type,
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ah.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_ah.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ah.c
@@ -30,10 +30,10 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #endif
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
-static inline int
-spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+static inline bool
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	int r=0;
+	bool r;
 	DEBUGP("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
 	       min,spi,max);
 	r = (spi >= min && spi <= max) ^ invert;
@@ -41,7 +41,7 @@ spi_match(u_int32_t min, u_int32_t max, 
 	return r;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -61,13 +61,13 @@ match(const struct sk_buff *skb,
 	if (err < 0) {
 		if (err != -ENOENT)
 			*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
 	if (ah == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	hdrlen = (ah->hdrlen + 2) << 2;
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_eui64.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_eui64.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_eui64.c
@@ -19,7 +19,7 @@ MODULE_DESCRIPTION("IPv6 EUI64 address c
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -36,7 +36,7 @@ match(const struct sk_buff *skb,
 	      (skb_mac_header(skb) + ETH_HLEN) <= skb->data) &&
 	    offset != 0) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	memset(eui64, 0, sizeof(eui64));
@@ -55,11 +55,11 @@ match(const struct sk_buff *skb,
 				i++;
 
 			if (i == 8)
-				return 1;
+				return true;
 		}
 	}
 
-	return 0;
+	return false;
 }
 
 static struct xt_match eui64_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_frag.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_frag.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_frag.c
@@ -29,10 +29,10 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #endif
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
-static inline int
-id_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
+static inline bool
+id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	int r = 0;
+	bool r;
 	DEBUGP("frag id_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
 	       min, id, max);
 	r = (id >= min && id <= max) ^ invert;
@@ -40,7 +40,7 @@ id_match(u_int32_t min, u_int32_t max, u
 	return r;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -59,13 +59,13 @@ match(const struct sk_buff *skb,
 	if (err < 0) {
 		if (err != -ENOENT)
 			*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
 	if (fh == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	DEBUGP("INFO %04X ", fh->frag_off);
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hbh.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_hbh.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hbh.c
@@ -47,7 +47,7 @@ MODULE_ALIAS("ip6t_dst");
  *	5	-> RTALERT 2 x x
  */
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -62,7 +62,7 @@ match(const struct sk_buff *skb,
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
-	unsigned int ret = 0;
+	bool ret = false;
 	u8 _opttype, *tp = NULL;
 	u8 _optlen, *lp = NULL;
 	unsigned int optlen;
@@ -72,19 +72,19 @@ match(const struct sk_buff *skb,
 	if (err < 0) {
 		if (err != -ENOENT)
 			*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
 	if (oh == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	hdrlen = ipv6_optlen(oh);
 	if (skb->len - ptr < hdrlen) {
 		/* Packet smaller than it's length field */
-		return 0;
+		return false;
 	}
 
 	DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
@@ -123,7 +123,7 @@ match(const struct sk_buff *skb,
 				DEBUGP("Tbad %02X %02X\n",
 				       *tp,
 				       (optinfo->opts[temp] & 0xFF00) >> 8);
-				return 0;
+				return false;
 			} else {
 				DEBUGP("Tok ");
 			}
@@ -144,7 +144,7 @@ match(const struct sk_buff *skb,
 				if (spec_len != 0x00FF && spec_len != *lp) {
 					DEBUGP("Lbad %02X %04X\n", *lp,
 					       spec_len);
-					return 0;
+					return false;
 				}
 				DEBUGP("Lok ");
 				optlen = *lp + 2;
@@ -167,10 +167,10 @@ match(const struct sk_buff *skb,
 		if (temp == optinfo->optsnr)
 			return ret;
 		else
-			return 0;
+			return false;
 	}
 
-	return 0;
+	return false;
 }
 
 /* Called when user tries to insert an entry of this type. */
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hl.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_hl.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hl.c
@@ -19,10 +19,10 @@ MODULE_AUTHOR("Maciej Soltysiak <solt@dn
 MODULE_DESCRIPTION("IP tables Hop Limit matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in, const struct net_device *out,
-		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  const struct xt_match *match, const void *matchinfo,
+		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ip6t_hl_info *info = matchinfo;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
@@ -43,10 +43,10 @@ static int match(const struct sk_buff *s
 		default:
 			printk(KERN_WARNING "ip6t_hl: unknown mode %d\n",
 				info->mode);
-			return 0;
+			return false;
 	}
 
-	return 0;
+	return false;
 }
 
 static struct xt_match hl_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ipv6header.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_ipv6header.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -26,7 +26,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IPv6 headers match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-static int
+static bool
 ipv6header_match(const struct sk_buff *skb,
 		 const struct net_device *in,
 		 const struct net_device *out,
@@ -58,7 +58,7 @@ ipv6header_match(const struct sk_buff *s
 
 		/* Is there enough space for the next ext header? */
 		if (len < (int)sizeof(struct ipv6_opt_hdr))
-			return 0;
+			return false;
 		/* No more exthdr -> evaluate */
 		if (nexthdr == NEXTHDR_NONE) {
 			temp |= MASK_NONE;
@@ -99,7 +99,7 @@ ipv6header_match(const struct sk_buff *s
 			temp |= MASK_DSTOPTS;
 			break;
 		default:
-			return 0;
+			return false;
 			break;
 		}
 
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_mh.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_mh.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_mh.c
@@ -31,16 +31,13 @@ MODULE_LICENSE("GPL");
 #endif
 
 /* Returns 1 if the type is matched by the range, 0 otherwise */
-static inline int
-type_match(u_int8_t min, u_int8_t max, u_int8_t type, int invert)
+static inline bool
+type_match(u_int8_t min, u_int8_t max, u_int8_t type, bool invert)
 {
-	int ret;
-
-	ret = (type >= min && type <= max) ^ invert;
-	return ret;
+	return (type >= min && type <= max) ^ invert;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
@@ -55,7 +52,7 @@ match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	mh = skb_header_pointer(skb, protoff, sizeof(_mh), &_mh);
 	if (mh == NULL) {
@@ -63,14 +60,14 @@ match(const struct sk_buff *skb,
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil MH tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
 		duprintf("Dropping invalid MH Payload Proto: %u\n",
 			 mh->ip6mh_proto);
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return type_match(mhinfo->types[0], mhinfo->types[1], mh->ip6mh_type,
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_owner.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_owner.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_owner.c
@@ -23,7 +23,7 @@ MODULE_DESCRIPTION("IP6 tables owner mat
 MODULE_LICENSE("GPL");
 
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -36,21 +36,21 @@ match(const struct sk_buff *skb,
 	const struct ip6t_owner_info *info = matchinfo;
 
 	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
-		return 0;
+		return false;
 
 	if (info->match & IP6T_OWNER_UID) {
 		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
 		    !!(info->invert & IP6T_OWNER_UID))
-			return 0;
+			return false;
 	}
 
 	if (info->match & IP6T_OWNER_GID) {
 		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
 		    !!(info->invert & IP6T_OWNER_GID))
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_rt.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_rt.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_rt.c
@@ -31,10 +31,10 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #endif
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
-static inline int
-segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
+static inline bool
+segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	int r = 0;
+	bool r;
 	DEBUGP("rt segsleft_match:%c 0x%x <= 0x%x <= 0x%x",
 	       invert ? '!' : ' ', min, id, max);
 	r = (id >= min && id <= max) ^ invert;
@@ -42,7 +42,7 @@ segsleft_match(u_int32_t min, u_int32_t 
 	return r;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -57,7 +57,7 @@ match(const struct sk_buff *skb,
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
-	unsigned int ret = 0;
+	bool ret = false;
 	struct in6_addr *ap, _addr;
 	int err;
 
@@ -65,19 +65,19 @@ match(const struct sk_buff *skb,
 	if (err < 0) {
 		if (err != -ENOENT)
 			*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
 	if (rh == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	hdrlen = ipv6_optlen(rh);
 	if (skb->len - ptr < hdrlen) {
 		/* Pcket smaller than its length field */
-		return 0;
+		return false;
 	}
 
 	DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
@@ -136,7 +136,7 @@ match(const struct sk_buff *skb,
 		DEBUGP("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
 			DEBUGP("There isn't enough space\n");
-			return 0;
+			return false;
 		} else {
 			unsigned int i = 0;
 
@@ -164,13 +164,13 @@ match(const struct sk_buff *skb,
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
-				return 0;
+				return false;
 		}
 	} else {
 		DEBUGP("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
 			DEBUGP("There isn't enough space\n");
-			return 0;
+			return false;
 		} else {
 			DEBUGP("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
@@ -190,11 +190,11 @@ match(const struct sk_buff *skb,
 			    (temp == (unsigned int)((hdrlen - 8) / 16)))
 				return ret;
 			else
-				return 0;
+				return false;
 		}
 	}
 
-	return 0;
+	return false;
 }
 
 /* Called when user tries to insert an entry of this type. */
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_comment.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_comment.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_comment.c
@@ -15,7 +15,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -26,7 +26,7 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	/* We always match */
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_comment_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_connbytes.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_connbytes.c
@@ -15,7 +15,7 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("iptables match for matching number of pkts/bytes per connection");
 MODULE_ALIAS("ipt_connbytes");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -35,7 +35,7 @@ match(const struct sk_buff *skb,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
-		return 0;
+		return false;
 	counters = ct->counters;
 
 	switch (sinfo->what) {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_connmark.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_connmark.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_connmark.c
@@ -30,7 +30,7 @@ MODULE_DESCRIPTION("IP tables connmark m
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -46,7 +46,7 @@ match(const struct sk_buff *skb,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
-		return 0;
+		return false;
 
 	return (((ct->mark) & info->mask) == info->mark) ^ info->invert;
 }
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_conntrack.c
@@ -19,7 +19,7 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.c
 MODULE_DESCRIPTION("iptables connection tracking match module");
 MODULE_ALIAS("ipt_conntrack");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -54,53 +54,53 @@ match(const struct sk_buff *skb,
 		}
 		if (FWINV((statebit & sinfo->statemask) == 0,
 			  XT_CONNTRACK_STATE))
-			return 0;
+			return false;
 	}
 
 	if (ct == NULL) {
 		if (sinfo->flags & ~XT_CONNTRACK_STATE)
-			return 0;
-		return 1;
+			return false;
+		return true;
 	}
 
 	if (sinfo->flags & XT_CONNTRACK_PROTO &&
 	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
 		  XT_CONNTRACK_PROTO))
-		return 0;
+		return false;
 
 	if (sinfo->flags & XT_CONNTRACK_ORIGSRC &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip &
 		   sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
 		  XT_CONNTRACK_ORIGSRC))
-		return 0;
+		return false;
 
 	if (sinfo->flags & XT_CONNTRACK_ORIGDST &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip &
 		   sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
 		  XT_CONNTRACK_ORIGDST))
-		return 0;
+		return false;
 
 	if (sinfo->flags & XT_CONNTRACK_REPLSRC &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip &
 		   sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
 		  XT_CONNTRACK_REPLSRC))
-		return 0;
+		return false;
 
 	if (sinfo->flags & XT_CONNTRACK_REPLDST &&
 	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip &
 		   sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) !=
 		  sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
 		  XT_CONNTRACK_REPLDST))
-		return 0;
+		return false;
 
 	if (sinfo->flags & XT_CONNTRACK_STATUS &&
 	    FWINV((ct->status & sinfo->statusmask) == 0,
 		  XT_CONNTRACK_STATUS))
-		return 0;
+		return false;
 
 	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
 		unsigned long expires = timer_pending(&ct->timeout) ?
@@ -109,9 +109,9 @@ match(const struct sk_buff *skb,
 		if (FWINV(!(expires >= sinfo->expires_min &&
 			    expires <= sinfo->expires_max),
 			  XT_CONNTRACK_EXPIRES))
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 static int
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_dccp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_dccp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_dccp.c
@@ -31,7 +31,7 @@ MODULE_ALIAS("ipt_dccp");
 static unsigned char *dccp_optbuf;
 static DEFINE_SPINLOCK(dccp_buflock);
 
-static inline int
+static inline bool
 dccp_find_option(u_int8_t option,
 		 const struct sk_buff *skb,
 		 unsigned int protoff,
@@ -46,11 +46,11 @@ dccp_find_option(u_int8_t option,
 
 	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh)) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	if (!optlen)
-		return 0;
+		return false;
 
 	spin_lock_bh(&dccp_buflock);
 	op = skb_header_pointer(skb, protoff + optoff, optlen, dccp_optbuf);
@@ -58,13 +58,13 @@ dccp_find_option(u_int8_t option,
 		/* If we don't have the whole header, drop packet. */
 		spin_unlock_bh(&dccp_buflock);
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	for (i = 0; i < optlen; ) {
 		if (op[i] == option) {
 			spin_unlock_bh(&dccp_buflock);
-			return 1;
+			return true;
 		}
 
 		if (op[i] < 2)
@@ -74,24 +74,24 @@ dccp_find_option(u_int8_t option,
 	}
 
 	spin_unlock_bh(&dccp_buflock);
-	return 0;
+	return false;
 }
 
 
-static inline int
+static inline bool
 match_types(const struct dccp_hdr *dh, u_int16_t typemask)
 {
 	return (typemask & (1 << dh->dccph_type));
 }
 
-static inline int
+static inline bool
 match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
 	     const struct dccp_hdr *dh, bool *hotdrop)
 {
 	return dccp_find_option(option, skb, protoff, dh, hotdrop);
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -105,12 +105,12 @@ match(const struct sk_buff *skb,
 	struct dccp_hdr _dh, *dh;
 
 	if (offset)
-		return 0;
+		return false;
 
 	dh = skb_header_pointer(skb, protoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return  DCCHECK(((ntohs(dh->dccph_sport) >= info->spts[0])
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_dscp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_dscp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_dscp.c
@@ -22,22 +22,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in,
-		 const struct net_device *out,
-		 const struct xt_match *match,
-		 const void *matchinfo,
-		 int offset,
-		 unsigned int protoff,
-		 bool *hotdrop)
-{
-	const struct xt_dscp_info *info = matchinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	return (dscp == info->dscp) ^ !!info->invert;
-}
-
-static int match6(const struct sk_buff *skb,
+static bool match(const struct sk_buff *skb,
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  const struct xt_match *match,
@@ -47,6 +32,21 @@ static int match6(const struct sk_buff *
 		  bool *hotdrop)
 {
 	const struct xt_dscp_info *info = matchinfo;
+	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	return (dscp == info->dscp) ^ !!info->invert;
+}
+
+static bool match6(const struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   const struct xt_match *match,
+		   const void *matchinfo,
+		   int offset,
+		   unsigned int protoff,
+		   bool *hotdrop)
+{
+	const struct xt_dscp_info *info = matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_esp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_esp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_esp.c
@@ -31,10 +31,10 @@ MODULE_ALIAS("ip6t_esp");
 #endif
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
-static inline int
-spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+static inline bool
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
-	int r = 0;
+	bool r;
 	duprintf("esp spi_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
 		 min, spi, max);
 	r = (spi >= min && spi <= max) ^ invert;
@@ -42,7 +42,7 @@ spi_match(u_int32_t min, u_int32_t max, 
 	return r;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -57,7 +57,7 @@ match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	eh = skb_header_pointer(skb, protoff, sizeof(_esp), &_esp);
 	if (eh == NULL) {
@@ -66,7 +66,7 @@ match(const struct sk_buff *skb,
 		 */
 		duprintf("Dropping evil ESP tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return spi_match(espinfo->spis[0], espinfo->spis[1], ntohl(eh->spi),
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_hashlimit.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_hashlimit.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_hashlimit.c
@@ -94,7 +94,8 @@ static DEFINE_MUTEX(hlimit_mutex);	/* ad
 static HLIST_HEAD(hashlimit_htables);
 static struct kmem_cache *hashlimit_cachep __read_mostly;
 
-static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_dst *b)
+static inline bool dst_cmp(const struct dsthash_ent *ent,
+			   struct dsthash_dst *b)
 {
 	return !memcmp(&ent->dst, b, sizeof(ent->dst));
 }
@@ -227,18 +228,18 @@ static int htable_create(struct xt_hashl
 	return 0;
 }
 
-static int select_all(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
+static bool select_all(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
 {
 	return 1;
 }
 
-static int select_gc(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
+static bool select_gc(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
 {
 	return (jiffies >= he->expires);
 }
 
 static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-				int (*select)(struct xt_hashlimit_htable *ht,
+				bool (*select)(struct xt_hashlimit_htable *ht,
 					      struct dsthash_ent *he))
 {
 	unsigned int i;
@@ -432,7 +433,7 @@ hashlimit_init_dst(struct xt_hashlimit_h
 	return 0;
 }
 
-static int
+static bool
 hashlimit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
@@ -478,17 +479,17 @@ hashlimit_match(const struct sk_buff *sk
 		/* We're underlimit. */
 		dh->rateinfo.credit -= dh->rateinfo.cost;
 		spin_unlock_bh(&hinfo->lock);
-		return 1;
+		return true;
 	}
 
 	spin_unlock_bh(&hinfo->lock);
 
 	/* default case: we're overlimit, thus don't match */
-	return 0;
+	return false;
 
 hotdrop:
 	*hotdrop = true;
-	return 0;
+	return false;
 }
 
 static int
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_helper.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_helper.c
@@ -28,7 +28,7 @@ MODULE_ALIAS("ip6t_helper");
 #define DEBUGP(format, args...)
 #endif
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -42,7 +42,7 @@ match(const struct sk_buff *skb,
 	struct nf_conn *ct;
 	struct nf_conn_help *master_help;
 	enum ip_conntrack_info ctinfo;
-	int ret = info->invert;
+	bool ret = info->invert;
 
 	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct) {
@@ -67,7 +67,7 @@ match(const struct sk_buff *skb,
 		ct->master->helper->name, info->name);
 
 	if (info->name[0] == '\0')
-		ret ^= 1;
+		ret = !ret;
 	else
 		ret ^= !strncmp(master_help->helper->name, info->name,
 				strlen(master_help->helper->name));
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_length.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_length.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_length.c
@@ -20,7 +20,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -36,7 +36,7 @@ match(const struct sk_buff *skb,
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
-static int
+static bool
 match6(const struct sk_buff *skb,
        const struct net_device *in,
        const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_limit.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_limit.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_limit.c
@@ -57,7 +57,7 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static int
+static bool
 ipt_limit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
@@ -79,11 +79,11 @@ ipt_limit_match(const struct sk_buff *sk
 		/* We're not limited. */
 		r->credit -= r->cost;
 		spin_unlock_bh(&limit_lock);
-		return 1;
+		return true;
 	}
 
 	spin_unlock_bh(&limit_lock);
-	return 0;
+	return false;
 }
 
 /* Precision saver. */
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_mac.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_mac.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_mac.c
@@ -24,7 +24,7 @@ MODULE_DESCRIPTION("iptables mac matchin
 MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_mark.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_mark.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_mark.c
@@ -19,7 +19,7 @@ MODULE_DESCRIPTION("iptables mark matchi
 MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_multiport.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_multiport.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_multiport.c
@@ -33,24 +33,24 @@ MODULE_ALIAS("ip6t_multiport");
 #endif
 
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline int
+static inline bool
 ports_match(const u_int16_t *portlist, enum xt_multiport_flags flags,
 	    u_int8_t count, u_int16_t src, u_int16_t dst)
 {
 	unsigned int i;
 	for (i = 0; i < count; i++) {
 		if (flags != XT_MULTIPORT_DESTINATION && portlist[i] == src)
-			return 1;
+			return true;
 
 		if (flags != XT_MULTIPORT_SOURCE && portlist[i] == dst)
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
-static inline int
+static inline bool
 ports_match_v1(const struct xt_multiport_v1 *minfo,
 	       u_int16_t src, u_int16_t dst)
 {
@@ -67,34 +67,34 @@ ports_match_v1(const struct xt_multiport
 
 			if (minfo->flags == XT_MULTIPORT_SOURCE
 			    && src >= s && src <= e)
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 			if (minfo->flags == XT_MULTIPORT_DESTINATION
 			    && dst >= s && dst <= e)
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 			if (minfo->flags == XT_MULTIPORT_EITHER
 			    && ((dst >= s && dst <= e)
 				|| (src >= s && src <= e)))
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 		} else {
 			/* exact port matching */
 			duprintf("src or dst matches with %d?\n", s);
 
 			if (minfo->flags == XT_MULTIPORT_SOURCE
 			    && src == s)
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 			if (minfo->flags == XT_MULTIPORT_DESTINATION
 			    && dst == s)
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 			if (minfo->flags == XT_MULTIPORT_EITHER
 			    && (src == s || dst == s))
-				return 1 ^ minfo->invert;
+				return true ^ minfo->invert;
 		}
 	}
 
 	return minfo->invert;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -108,7 +108,7 @@ match(const struct sk_buff *skb,
 	const struct xt_multiport *multiinfo = matchinfo;
 
 	if (offset)
-		return 0;
+		return false;
 
 	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
 	if (pptr == NULL) {
@@ -117,7 +117,7 @@ match(const struct sk_buff *skb,
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return ports_match(multiinfo->ports,
@@ -125,7 +125,7 @@ match(const struct sk_buff *skb,
 			   ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
-static int
+static bool
 match_v1(const struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
@@ -139,7 +139,7 @@ match_v1(const struct sk_buff *skb,
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
 
 	if (offset)
-		return 0;
+		return false;
 
 	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
 	if (pptr == NULL) {
@@ -148,7 +148,7 @@ match_v1(const struct sk_buff *skb,
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_physdev.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
@@ -14,8 +14,6 @@
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge.h>
-#define MATCH   1
-#define NOMATCH 0
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
@@ -23,7 +21,7 @@ MODULE_DESCRIPTION("iptables bridge phys
 MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -36,7 +34,7 @@ match(const struct sk_buff *skb,
 	int i;
 	static const char nulldevname[IFNAMSIZ];
 	const struct xt_physdev_info *info = matchinfo;
-	unsigned int ret;
+	bool ret;
 	const char *indev, *outdev;
 	struct nf_bridge_info *nf_bridge;
 
@@ -47,33 +45,33 @@ match(const struct sk_buff *skb,
 		/* Return MATCH if the invert flags of the used options are on */
 		if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
 		    !(info->invert & XT_PHYSDEV_OP_BRIDGED))
-			return NOMATCH;
+			return false;
 		if ((info->bitmask & XT_PHYSDEV_OP_ISIN) &&
 		    !(info->invert & XT_PHYSDEV_OP_ISIN))
-			return NOMATCH;
+			return false;
 		if ((info->bitmask & XT_PHYSDEV_OP_ISOUT) &&
 		    !(info->invert & XT_PHYSDEV_OP_ISOUT))
-			return NOMATCH;
+			return false;
 		if ((info->bitmask & XT_PHYSDEV_OP_IN) &&
 		    !(info->invert & XT_PHYSDEV_OP_IN))
-			return NOMATCH;
+			return false;
 		if ((info->bitmask & XT_PHYSDEV_OP_OUT) &&
 		    !(info->invert & XT_PHYSDEV_OP_OUT))
-			return NOMATCH;
-		return MATCH;
+			return false;
+		return true;
 	}
 
 	/* This only makes sense in the FORWARD and POSTROUTING chains */
 	if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
 	    (!!(nf_bridge->mask & BRNF_BRIDGED) ^
 	    !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
-		return NOMATCH;
+		return false;
 
 	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
 	    (!nf_bridge->physindev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN))) ||
 	    (info->bitmask & XT_PHYSDEV_OP_ISOUT &&
 	    (!nf_bridge->physoutdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT))))
-		return NOMATCH;
+		return false;
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
 		goto match_outdev;
@@ -85,11 +83,11 @@ match(const struct sk_buff *skb,
 	}
 
 	if ((ret == 0) ^ !(info->invert & XT_PHYSDEV_OP_IN))
-		return NOMATCH;
+		return false;
 
 match_outdev:
 	if (!(info->bitmask & XT_PHYSDEV_OP_OUT))
-		return MATCH;
+		return true;
 	outdev = nf_bridge->physoutdev ?
 		 nf_bridge->physoutdev->name : nulldevname;
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
@@ -98,7 +96,7 @@ match_outdev:
 			& ((const unsigned int *)info->out_mask)[i];
 	}
 
-	return (ret != 0) ^ !(info->invert & XT_PHYSDEV_OP_OUT);
+	return ret ^ !(info->invert & XT_PHYSDEV_OP_OUT);
 }
 
 static int
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_pkttype.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_pkttype.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_pkttype.c
@@ -21,7 +21,7 @@ MODULE_DESCRIPTION("IP tables match to m
 MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
-static int match(const struct sk_buff *skb,
+static bool match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_policy.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_policy.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_policy.c
@@ -20,7 +20,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@tr
 MODULE_DESCRIPTION("Xtables IPsec policy matching module");
 MODULE_LICENSE("GPL");
 
-static inline int
+static inline bool
 xt_addr_cmp(const union xt_policy_addr *a1, const union xt_policy_addr *m,
 	    const union xt_policy_addr *a2, unsigned short family)
 {
@@ -30,10 +30,10 @@ xt_addr_cmp(const union xt_policy_addr *
 	case AF_INET6:
 		return !ipv6_masked_addr_cmp(&a1->a6, &m->a6, &a2->a6);
 	}
-	return 0;
+	return false;
 }
 
-static inline int
+static inline bool
 match_xfrm_state(struct xfrm_state *x, const struct xt_policy_elem *e,
 		 unsigned short family)
 {
@@ -108,14 +108,14 @@ match_policy_out(const struct sk_buff *s
 	return strict ? i == info->len : 0;
 }
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in,
-		 const struct net_device *out,
-		 const struct xt_match *match,
-		 const void *matchinfo,
-		 int offset,
-		 unsigned int protoff,
-		 bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const struct xt_match *match,
+		  const void *matchinfo,
+		  int offset,
+		  unsigned int protoff,
+		  bool *hotdrop)
 {
 	const struct xt_policy_info *info = matchinfo;
 	int ret;
@@ -126,9 +126,9 @@ static int match(const struct sk_buff *s
 		ret = match_policy_out(skb, info, match->family);
 
 	if (ret < 0)
-		ret = info->flags & XT_POLICY_MATCH_NONE ? 1 : 0;
+		ret = info->flags & XT_POLICY_MATCH_NONE ? true : false;
 	else if (info->flags & XT_POLICY_MATCH_NONE)
-		ret = 0;
+		ret = false;
 
 	return ret;
 }
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_quota.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_quota.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_quota.c
@@ -16,19 +16,19 @@ MODULE_ALIAS("ip6t_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
       int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct xt_quota_info *q = ((struct xt_quota_info *)matchinfo)->master;
-	int ret = q->flags & XT_QUOTA_INVERT ? 1 : 0;
+	bool ret = q->flags & XT_QUOTA_INVERT;
 
 	spin_lock_bh(&quota_lock);
 	if (q->quota >= skb->len) {
 		q->quota -= skb->len;
-		ret ^= 1;
+		ret = !ret;
 	} else {
 		/* we do not allow even small packets from now on */
 		q->quota = 0;
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_realm.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_realm.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_realm.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("X_tables realm match");
 MODULE_ALIAS("ipt_realm");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_sctp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_sctp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_sctp.c
@@ -23,7 +23,7 @@ MODULE_ALIAS("ipt_sctp");
 #define SCCHECK(cond, option, flag, invflag) (!((flag) & (option)) \
 					      || (!!((invflag) & (option)) ^ (cond)))
 
-static int
+static bool
 match_flags(const struct xt_sctp_flag_info *flag_info,
 	    const int flag_count,
 	    u_int8_t chunktype,
@@ -37,10 +37,10 @@ match_flags(const struct xt_sctp_flag_in
 		}
 	}
 
-	return 1;
+	return true;
 }
 
-static inline int
+static inline bool
 match_packet(const struct sk_buff *skb,
 	     unsigned int offset,
 	     const u_int32_t *chunkmap,
@@ -65,7 +65,7 @@ match_packet(const struct sk_buff *skb,
 		if (sch == NULL || sch->length == 0) {
 			duprintf("Dropping invalid SCTP packet.\n");
 			*hotdrop = true;
-			return 0;
+			return false;
 		}
 
 		duprintf("Chunk num: %d\toffset: %d\ttype: %d\tlength: %d\tflags: %x\n",
@@ -80,7 +80,7 @@ match_packet(const struct sk_buff *skb,
 			case SCTP_CHUNK_MATCH_ANY:
 				if (match_flags(flag_info, flag_count,
 					sch->type, sch->flags)) {
-					return 1;
+					return true;
 				}
 				break;
 
@@ -94,14 +94,14 @@ match_packet(const struct sk_buff *skb,
 			case SCTP_CHUNK_MATCH_ONLY:
 				if (!match_flags(flag_info, flag_count,
 					sch->type, sch->flags)) {
-					return 0;
+					return false;
 				}
 				break;
 			}
 		} else {
 			switch (chunk_match_type) {
 			case SCTP_CHUNK_MATCH_ONLY:
-				return 0;
+				return false;
 			}
 		}
 	} while (offset < skb->len);
@@ -110,16 +110,16 @@ match_packet(const struct sk_buff *skb,
 	case SCTP_CHUNK_MATCH_ALL:
 		return SCTP_CHUNKMAP_IS_CLEAR(chunkmap);
 	case SCTP_CHUNK_MATCH_ANY:
-		return 0;
+		return false;
 	case SCTP_CHUNK_MATCH_ONLY:
-		return 1;
+		return true;
 	}
 
 	/* This will never be reached, but required to stop compiler whine */
-	return 0;
+	return false;
 }
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -134,14 +134,14 @@ match(const struct sk_buff *skb,
 
 	if (offset) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
-		return 0;
+		return false;
 	}
 
 	sh = skb_header_pointer(skb, protoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_state.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_state.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_state.c
@@ -20,7 +20,7 @@ MODULE_DESCRIPTION("ip[6]_tables connect
 MODULE_ALIAS("ipt_state");
 MODULE_ALIAS("ip6t_state");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_statistic.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_statistic.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_statistic.c
@@ -24,26 +24,26 @@ MODULE_ALIAS("ip6t_statistic");
 
 static DEFINE_SPINLOCK(nth_lock);
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
       int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
-	int ret = info->flags & XT_STATISTIC_INVERT ? 1 : 0;
+	bool ret = info->flags & XT_STATISTIC_INVERT;
 
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
 		if ((net_random() & 0x7FFFFFFF) < info->u.random.probability)
-			ret ^= 1;
+			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
 		info = info->master;
 		spin_lock_bh(&nth_lock);
 		if (info->u.nth.count++ == info->u.nth.every) {
 			info->u.nth.count = 0;
-			ret ^= 1;
+			ret = !ret;
 		}
 		spin_unlock_bh(&nth_lock);
 		break;
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_string.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_string.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_string.c
@@ -21,14 +21,14 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
 
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in,
-		 const struct net_device *out,
-		 const struct xt_match *match,
-		 const void *matchinfo,
-		 int offset,
-		 unsigned int protoff,
-		 bool *hotdrop)
+static bool match(const struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const struct xt_match *match,
+		  const void *matchinfo,
+		  int offset,
+		  unsigned int protoff,
+		  bool *hotdrop)
 {
 	const struct xt_string_info *conf = matchinfo;
 	struct ts_state state;
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_tcpmss.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_tcpmss.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_tcpmss.c
@@ -23,7 +23,7 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.c
 MODULE_DESCRIPTION("iptables TCP MSS match module");
 MODULE_ALIAS("ipt_tcpmss");
 
-static int
+static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -78,7 +78,7 @@ out:
 
 dropit:
 	*hotdrop = true;
-	return 0;
+	return false;
 }
 
 static struct xt_match xt_tcpmss_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_tcpudp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_tcpudp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_tcpudp.c
@@ -27,21 +27,18 @@ MODULE_ALIAS("ip6t_tcp");
 
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */
-static inline int
-port_match(u_int16_t min, u_int16_t max, u_int16_t port, int invert)
+static inline bool
+port_match(u_int16_t min, u_int16_t max, u_int16_t port, bool invert)
 {
-	int ret;
-
-	ret = (port >= min && port <= max) ^ invert;
-	return ret;
+	return (port >= min && port <= max) ^ invert;
 }
 
-static int
+static bool
 tcp_find_option(u_int8_t option,
 		const struct sk_buff *skb,
 		unsigned int protoff,
 		unsigned int optlen,
-		int invert,
+		bool invert,
 		bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
@@ -58,7 +55,7 @@ tcp_find_option(u_int8_t option,
 				optlen, _opt);
 	if (op == NULL) {
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	for (i = 0; i < optlen; ) {
@@ -70,7 +67,7 @@ tcp_find_option(u_int8_t option,
 	return invert;
 }
 
-static int
+static bool
 tcp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
@@ -95,7 +92,7 @@ tcp_match(const struct sk_buff *skb,
 			*hotdrop = true;
 		}
 		/* Must not be a fragment. */
-		return 0;
+		return false;
 	}
 
 #define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
@@ -106,33 +103,33 @@ tcp_match(const struct sk_buff *skb,
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	if (!port_match(tcpinfo->spts[0], tcpinfo->spts[1],
 			ntohs(th->source),
 			!!(tcpinfo->invflags & XT_TCP_INV_SRCPT)))
-		return 0;
+		return false;
 	if (!port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
 			ntohs(th->dest),
 			!!(tcpinfo->invflags & XT_TCP_INV_DSTPT)))
-		return 0;
+		return false;
 	if (!FWINVTCP((((unsigned char *)th)[13] & tcpinfo->flg_mask)
 		      == tcpinfo->flg_cmp,
 		      XT_TCP_INV_FLAGS))
-		return 0;
+		return false;
 	if (tcpinfo->option) {
 		if (th->doff * 4 < sizeof(_tcph)) {
 			*hotdrop = true;
-			return 0;
+			return false;
 		}
 		if (!tcp_find_option(tcpinfo->option, skb, protoff,
 				     th->doff*4 - sizeof(_tcph),
 				     tcpinfo->invflags & XT_TCP_INV_OPTION,
 				     hotdrop))
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -149,7 +146,7 @@ tcp_checkentry(const char *tablename,
 	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
 }
 
-static int
+static bool
 udp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
@@ -164,7 +161,7 @@ udp_match(const struct sk_buff *skb,
 
 	/* Must not be a fragment. */
 	if (offset)
-		return 0;
+		return false;
 
 	uh = skb_header_pointer(skb, protoff, sizeof(_udph), &_udph);
 	if (uh == NULL) {
@@ -172,7 +169,7 @@ udp_match(const struct sk_buff *skb,
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
 		*hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return port_match(udpinfo->spts[0], udpinfo->spts[1],
