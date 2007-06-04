From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 3/4] Switch xt_match->checkentry to bool
Date: Mon, 4 Jun 2007 17:11:00 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041710470.20829@yvahk01.tjqt.qr>
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
 include/linux/netfilter/x_tables.h   |   10 +++++-----
 net/ipv4/netfilter/ip_tables.c       |   10 +++++-----
 net/ipv4/netfilter/ipt_ah.c          |    6 +++---
 net/ipv4/netfilter/ipt_ecn.c         |   14 +++++++-------
 net/ipv4/netfilter/ipt_owner.c       |    6 +++---
 net/ipv4/netfilter/ipt_recent.c      |   14 +++++++-------
 net/ipv6/netfilter/ip6_tables.c      |   14 +++++++-------
 net/ipv6/netfilter/ip6t_ah.c         |    6 +++---
 net/ipv6/netfilter/ip6t_frag.c       |    6 +++---
 net/ipv6/netfilter/ip6t_hbh.c        |    6 +++---
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 +++---
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_owner.c      |    6 +++---
 net/ipv6/netfilter/ip6t_rt.c         |    8 ++++----
 net/netfilter/xt_connbytes.c         |   18 +++++++++---------
 net/netfilter/xt_connmark.c          |    8 ++++----
 net/netfilter/xt_conntrack.c         |    6 +++---
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |   14 +++++++-------
 net/netfilter/xt_esp.c               |    6 +++---
 net/netfilter/xt_hashlimit.c         |   16 ++++++++--------
 net/netfilter/xt_helper.c            |   14 +++++++-------
 net/netfilter/xt_limit.c             |    6 +++---
 net/netfilter/xt_mark.c              |    6 +++---
 net/netfilter/xt_multiport.c         |   10 +++++-----
 net/netfilter/xt_physdev.c           |    8 ++++----
 net/netfilter/xt_policy.c            |   16 ++++++++--------
 net/netfilter/xt_quota.c             |    6 +++---
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_state.c             |   14 +++++++-------
 net/netfilter/xt_statistic.c         |    6 +++---
 net/netfilter/xt_string.c            |   20 ++++++++++----------
 net/netfilter/xt_tcpudp.c            |    4 ++--
 33 files changed, 148 insertions(+), 148 deletions(-)

Index: linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
===================================================================
--- linux-2.6.22-rc3-git6.orig/include/linux/netfilter/x_tables.h
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
@@ -152,11 +152,11 @@ struct xt_match
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const void *ip,
-			  const struct xt_match *match,
-			  void *matchinfo,
-			  unsigned int hook_mask);
+	bool (*checkentry)(const char *tablename,
+			   const void *ip,
+			   const struct xt_match *match,
+			   void *matchinfo,
+			   unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_match *match, void *matchinfo);
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ip_tables.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ip_tables.c
@@ -152,20 +152,20 @@ ip_packet_match(const struct iphdr *ip,
 	return 1;
 }
 
-static inline int
+static inline bool
 ip_checkentry(const struct ipt_ip *ip)
 {
 	if (ip->flags & ~IPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ip->flags & ~IPT_F_MASK);
-		return 0;
+		return false;
 	}
 	if (ip->invflags & ~IPT_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 ip->invflags & ~IPT_INV_MASK);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static unsigned int
@@ -2104,7 +2104,7 @@ icmp_match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 icmp_checkentry(const char *tablename,
 	   const void *info,
 	   const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ah.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ah.c
@@ -70,7 +70,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip_void,
 	   const struct xt_match *match,
@@ -82,9 +82,9 @@ checkentry(const char *tablename,
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
 		duprintf("ipt_ah: unknown flags %X\n", ahinfo->invflags);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match ah_match = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ecn.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ecn.c
@@ -87,27 +87,27 @@ static bool match(const struct sk_buff *
 	return true;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
-		      const struct xt_match *match,
-		      void *matchinfo, unsigned int hook_mask)
+static bool checkentry(const char *tablename, const void *ip_void,
+		       const struct xt_match *match,
+		       void *matchinfo, unsigned int hook_mask)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
 
 	if (info->operation & IPT_ECN_OP_MATCH_MASK)
-		return 0;
+		return false;
 
 	if (info->invert & IPT_ECN_OP_MATCH_MASK)
-		return 0;
+		return false;
 
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)
 	    && ip->proto != IPPROTO_TCP) {
 		printk(KERN_WARNING "ipt_ecn: can't match TCP bits in rule for"
 		       " non-tcp packets\n");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static struct xt_match ecn_match = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_owner.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_owner.c
@@ -51,7 +51,7 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
@@ -63,9 +63,9 @@ checkentry(const char *tablename,
 	if (info->match & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
 		printk("ipt_owner: pid, sid and command matching "
 		       "not supported anymore\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match owner_match = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_recent.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_recent.c
@@ -235,7 +235,7 @@ out:
 	return ret;
 }
 
-static int
+static bool
 ipt_recent_checkentry(const char *tablename, const void *ip,
 		      const struct xt_match *match, void *matchinfo,
 		      unsigned int hook_mask)
@@ -243,24 +243,24 @@ ipt_recent_checkentry(const char *tablen
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_table *t;
 	unsigned i;
-	int ret = 0;
+	bool ret = false;
 
 	if (hweight8(info->check_set &
 		     (IPT_RECENT_SET | IPT_RECENT_REMOVE |
 		      IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) != 1)
-		return 0;
+		return false;
 	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
-		return 0;
+		return false;
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
-		return 0;
+		return false;
 
 	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(info->name);
 	if (t != NULL) {
 		t->refcnt++;
-		ret = 1;
+		ret = true;
 		goto out;
 	}
 
@@ -287,7 +287,7 @@ ipt_recent_checkentry(const char *tablen
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);
 	spin_unlock_bh(&recent_lock);
-	ret = 1;
+	ret = true;
 out:
 	mutex_unlock(&recent_mutex);
 	return ret;
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6_tables.c
@@ -188,20 +188,20 @@ ip6_packet_match(const struct sk_buff *s
 }
 
 /* should be ip6 safe */
-static inline int
+static inline bool
 ip6_checkentry(const struct ip6t_ip6 *ipv6)
 {
 	if (ipv6->flags & ~IP6T_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ipv6->flags & ~IP6T_F_MASK);
-		return 0;
+		return false;
 	}
 	if (ipv6->invflags & ~IP6T_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 ipv6->invflags & ~IP6T_INV_MASK);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static unsigned int
@@ -1282,10 +1282,10 @@ void ip6t_unregister_table(struct xt_tab
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline int
+static inline bool
 icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		     u_int8_t type, u_int8_t code,
-		     int invert)
+		     bool invert)
 {
 	return (type == test_type && code >= min_code && code <= max_code)
 		^ invert;
@@ -1325,7 +1325,7 @@ icmp6_match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 icmp6_checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ah.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_ah.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ah.c
@@ -103,7 +103,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	  const void *entry,
 	  const struct xt_match *match,
@@ -114,9 +114,9 @@ checkentry(const char *tablename,
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
 		DEBUGP("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match ah_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_frag.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_frag.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_frag.c
@@ -120,7 +120,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
@@ -131,9 +131,9 @@ checkentry(const char *tablename,
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
 		DEBUGP("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match frag_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hbh.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_hbh.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_hbh.c
@@ -174,7 +174,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
@@ -185,9 +185,9 @@ checkentry(const char *tablename,
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match opts_match[] = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ipv6header.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_ipv6header.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -124,7 +124,7 @@ ipv6header_match(const struct sk_buff *s
 	}
 }
 
-static int
+static bool
 ipv6header_checkentry(const char *tablename,
 		      const void *ip,
 		      const struct xt_match *match,
@@ -136,9 +136,9 @@ ipv6header_checkentry(const char *tablen
 	/* invflags is 0 or 0xff in hard mode */
 	if ((!info->modeflag) && info->invflags != 0x00 &&
 	    info->invflags != 0xFF)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 static struct xt_match ip6t_ipv6header_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_mh.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_mh.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_mh.c
@@ -75,7 +75,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 mh_checkentry(const char *tablename,
 	      const void *entry,
 	      const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_owner.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_owner.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_owner.c
@@ -53,7 +53,7 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
@@ -65,9 +65,9 @@ checkentry(const char *tablename,
 	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
 		printk("ipt_owner: pid and sid matching "
 		       "not supported anymore\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match owner_match = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_rt.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_rt.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_rt.c
@@ -198,7 +198,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
@@ -209,17 +209,17 @@ checkentry(const char *tablename,
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
 		DEBUGP("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
-		return 0;
+		return false;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
 		DEBUGP("`--rt-type 0' required before `--rt-0-*'");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static struct xt_match rt_match = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_connbytes.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_connbytes.c
@@ -95,31 +95,31 @@ match(const struct sk_buff *skb,
 		return (what >= sinfo->count.from);
 }
 
-static int check(const char *tablename,
-		 const void *ip,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int hook_mask)
+static bool check(const char *tablename,
+		  const void *ip,
+		  const struct xt_match *match,
+		  void *matchinfo,
+		  unsigned int hook_mask)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
 	    sinfo->what != XT_CONNBYTES_AVGPKT)
-		return 0;
+		return false;
 
 	if (sinfo->direction != XT_CONNBYTES_DIR_ORIGINAL &&
 	    sinfo->direction != XT_CONNBYTES_DIR_REPLY &&
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
-		return 0;
+		return false;
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_connmark.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_connmark.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_connmark.c
@@ -51,7 +51,7 @@ match(const struct sk_buff *skb,
 	return (((ct->mark) & info->mask) == info->mark) ^ info->invert;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
@@ -62,14 +62,14 @@ checkentry(const char *tablename,
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
-		return 0;
+		return false;
 	}
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_conntrack.c
@@ -114,7 +114,7 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
@@ -124,9 +124,9 @@ checkentry(const char *tablename,
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void destroy(const struct xt_match *match, void *matchinfo)
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_dccp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_dccp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_dccp.c
@@ -126,7 +126,7 @@ match(const struct sk_buff *skb,
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *inf,
 	   const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_dscp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_dscp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_dscp.c
@@ -52,20 +52,20 @@ static bool match6(const struct sk_buff 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static int checkentry(const char *tablename,
-		      const void *info,
-		      const struct xt_match *match,
-		      void *matchinfo,
-		      unsigned int hook_mask)
+static bool checkentry(const char *tablename,
+		       const void *info,
+		       const struct xt_match *match,
+		       void *matchinfo,
+		       unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_dscp_info *)matchinfo)->dscp;
 
 	if (dscp > XT_DSCP_MAX) {
 		printk(KERN_ERR "xt_dscp: dscp %x out of range\n", dscp);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_dscp_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_esp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_esp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_esp.c
@@ -74,7 +74,7 @@ match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *ip_void,
 	   const struct xt_match *match,
@@ -85,10 +85,10 @@ checkentry(const char *tablename,
 
 	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
 		duprintf("xt_esp: unknown flags %X\n", espinfo->invflags);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_esp_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_hashlimit.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_hashlimit.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_hashlimit.c
@@ -492,7 +492,7 @@ hotdrop:
 	return false;
 }
 
-static int
+static bool
 hashlimit_checkentry(const char *tablename,
 		     const void *inf,
 		     const struct xt_match *match,
@@ -506,20 +506,20 @@ hashlimit_checkentry(const char *tablena
 	    user2credits(r->cfg.avg * r->cfg.burst) < user2credits(r->cfg.avg)) {
 		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
 		       r->cfg.avg, r->cfg.burst);
-		return 0;
+		return false;
 	}
 	if (r->cfg.mode == 0 ||
 	    r->cfg.mode > (XT_HASHLIMIT_HASH_DPT |
 			   XT_HASHLIMIT_HASH_DIP |
 			   XT_HASHLIMIT_HASH_SIP |
 			   XT_HASHLIMIT_HASH_SPT))
-		return 0;
+		return false;
 	if (!r->cfg.gc_interval)
-		return 0;
+		return false;
 	if (!r->cfg.expire)
-		return 0;
+		return false;
 	if (r->name[sizeof(r->name) - 1] != '\0')
-		return 0;
+		return false;
 
 	/* This is the best we've got: We cannot release and re-grab lock,
 	 * since checkentry() is called before x_tables.c grabs xt_mutex.
@@ -531,13 +531,13 @@ hashlimit_checkentry(const char *tablena
 	r->hinfo = htable_find_get(r->name, match->family);
 	if (!r->hinfo && htable_create(r, match->family) != 0) {
 		mutex_unlock(&hlimit_mutex);
-		return 0;
+		return false;
 	}
 	mutex_unlock(&hlimit_mutex);
 
 	/* Ugly hack: For SMP, we only want to use one set */
 	r->u.master = r;
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_helper.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_helper.c
@@ -76,21 +76,21 @@ out_unlock:
 	return ret;
 }
 
-static int check(const char *tablename,
-		 const void *inf,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int hook_mask)
+static bool check(const char *tablename,
+		  const void *inf,
+		  const struct xt_match *match,
+		  void *matchinfo,
+		  unsigned int hook_mask)
 {
 	struct xt_helper_info *info = matchinfo;
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
-		return 0;
+		return false;
 	}
 	info->name[29] = '\0';
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_limit.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_limit.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_limit.c
@@ -98,7 +98,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_LIMIT_SCALE;
 }
 
-static int
+static bool
 ipt_limit_checkentry(const char *tablename,
 		     const void *inf,
 		     const struct xt_match *match,
@@ -112,7 +112,7 @@ ipt_limit_checkentry(const char *tablena
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
 		printk("Overflow in xt_limit, try lower: %u/%u\n",
 		       r->avg, r->burst);
-		return 0;
+		return false;
 	}
 
 	/* For SMP, we only want to use one set of counters. */
@@ -125,7 +125,7 @@ ipt_limit_checkentry(const char *tablena
 		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_COMPAT
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_mark.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_mark.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_mark.c
@@ -34,7 +34,7 @@ match(const struct sk_buff *skb,
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
@@ -45,9 +45,9 @@ checkentry(const char *tablename,
 
 	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "mark: only supports 32bit mark\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_COMPAT
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_multiport.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_multiport.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_multiport.c
@@ -154,7 +154,7 @@ match_v1(const struct sk_buff *skb,
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
-static inline int
+static inline bool
 check(u_int16_t proto,
       u_int8_t ip_invflags,
       u_int8_t match_flags,
@@ -172,7 +172,7 @@ check(u_int16_t proto,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *info,
 	   const struct xt_match *match,
@@ -186,7 +186,7 @@ checkentry(const char *tablename,
 		     multiinfo->count);
 }
 
-static int
+static bool
 checkentry_v1(const char *tablename,
 	      const void *info,
 	      const struct xt_match *match,
@@ -200,7 +200,7 @@ checkentry_v1(const char *tablename,
 		     multiinfo->count);
 }
 
-static int
+static bool
 checkentry6(const char *tablename,
 	    const void *info,
 	    const struct xt_match *match,
@@ -214,7 +214,7 @@ checkentry6(const char *tablename,
 		     multiinfo->count);
 }
 
-static int
+static bool
 checkentry6_v1(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_physdev.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
@@ -99,7 +99,7 @@ match_outdev:
 	return ret ^ !(info->invert & XT_PHYSDEV_OP_OUT);
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 		       const void *ip,
 		       const struct xt_match *match,
@@ -110,7 +110,7 @@ checkentry(const char *tablename,
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
-		return 0;
+		return false;
 	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
@@ -120,9 +120,9 @@ checkentry(const char *tablename,
 		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
 		       "traffic is not supported anymore.\n");
 		if (hook_mask & (1 << NF_IP_LOCAL_OUT))
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_physdev_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_policy.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_policy.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_policy.c
@@ -133,35 +133,35 @@ static bool match(const struct sk_buff *
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
-		      const struct xt_match *match,
-		      void *matchinfo, unsigned int hook_mask)
+static bool checkentry(const char *tablename, const void *ip_void,
+		       const struct xt_match *match,
+		       void *matchinfo, unsigned int hook_mask)
 {
 	struct xt_policy_info *info = matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "xt_policy: neither incoming nor "
 				"outgoing policy selected\n");
-		return 0;
+		return false;
 	}
 	/* hook values are equal for IPv4 and IPv6 */
 	if (hook_mask & (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_LOCAL_IN)
 	    && info->flags & XT_POLICY_MATCH_OUT) {
 		printk(KERN_ERR "xt_policy: output policy not valid in "
 				"PRE_ROUTING and INPUT\n");
-		return 0;
+		return false;
 	}
 	if (hook_mask & (1 << NF_IP_POST_ROUTING | 1 << NF_IP_LOCAL_OUT)
 	    && info->flags & XT_POLICY_MATCH_IN) {
 		printk(KERN_ERR "xt_policy: input policy not valid in "
 				"POST_ROUTING and OUTPUT\n");
-		return 0;
+		return false;
 	}
 	if (info->len > XT_POLICY_MAX_ELEM) {
 		printk(KERN_ERR "xt_policy: too many policy elements\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_policy_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_quota.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_quota.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_quota.c
@@ -38,7 +38,7 @@ match(const struct sk_buff *skb,
 	return ret;
 }
 
-static int
+static bool
 checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
 	   unsigned int hook_mask)
@@ -46,10 +46,10 @@ checkentry(const char *tablename, const 
 	struct xt_quota_info *q = (struct xt_quota_info *)matchinfo;
 
 	if (q->flags & ~XT_QUOTA_MASK)
-		return 0;
+		return false;
 	/* For SMP, we only want to use one set of counters. */
 	q->master = q;
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_quota_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_sctp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_sctp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_sctp.c
@@ -158,7 +158,7 @@ match(const struct sk_buff *skb,
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *inf,
 	   const struct xt_match *match,
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_state.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_state.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_state.c
@@ -44,18 +44,18 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
 
-static int check(const char *tablename,
-		 const void *inf,
-		 const struct xt_match *match,
-		 void *matchinfo,
-		 unsigned int hook_mask)
+static bool check(const char *tablename,
+		  const void *inf,
+		  const struct xt_match *match,
+		  void *matchinfo,
+		  unsigned int hook_mask)
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_statistic.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_statistic.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_statistic.c
@@ -52,7 +52,7 @@ match(const struct sk_buff *skb,
 	return ret;
 }
 
-static int
+static bool
 checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
 	   unsigned int hook_mask)
@@ -61,9 +61,9 @@ checkentry(const char *tablename, const 
 
 	if (info->mode > XT_STATISTIC_MODE_MAX ||
 	    info->flags & ~XT_STATISTIC_MASK)
-		return 0;
+		return false;
 	info->master = info;
-	return 1;
+	return true;
 }
 
 static struct xt_match xt_statistic_match[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_string.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_string.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_string.c
@@ -42,30 +42,30 @@ static bool match(const struct sk_buff *
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
 
-static int checkentry(const char *tablename,
-		      const void *ip,
-		      const struct xt_match *match,
-		      void *matchinfo,
-		      unsigned int hook_mask)
+static bool checkentry(const char *tablename,
+		       const void *ip,
+		       const struct xt_match *match,
+		       void *matchinfo,
+		       unsigned int hook_mask)
 {
 	struct xt_string_info *conf = matchinfo;
 	struct ts_config *ts_conf;
 
 	/* Damn, can't handle this case properly with iptables... */
 	if (conf->from_offset > conf->to_offset)
-		return 0;
+		return false;
 	if (conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] != '\0')
-		return 0;
+		return false;
 	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
-		return 0;
+		return false;
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
-		return 0;
+		return false;
 
 	conf->config = ts_conf;
 
-	return 1;
+	return true;
 }
 
 static void destroy(const struct xt_match *match, void *matchinfo)
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_tcpudp.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_tcpudp.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_tcpudp.c
@@ -133,7 +133,7 @@ tcp_match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 tcp_checkentry(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
@@ -181,7 +181,7 @@ udp_match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static int
+static bool
 udp_checkentry(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
