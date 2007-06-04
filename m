From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 4/4] Switch xt_target->checkentry to bool
Date: Mon, 4 Jun 2007 17:11:19 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041711020.20829@yvahk01.tjqt.qr>
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


Switch the return type of target functions to boolean.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/x_tables.h  |   10 +++++-----
 net/ipv4/netfilter/arpt_mangle.c    |    8 ++++----
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   28 ++++++++++++++--------------
 net/ipv4/netfilter/ipt_ECN.c        |   30 +++++++++++++++---------------
 net/ipv4/netfilter/ipt_LOG.c        |   16 ++++++++--------
 net/ipv4/netfilter/ipt_MASQUERADE.c |    8 ++++----
 net/ipv4/netfilter/ipt_NETMAP.c     |    8 ++++----
 net/ipv4/netfilter/ipt_REDIRECT.c   |    8 ++++----
 net/ipv4/netfilter/ipt_REJECT.c     |   16 ++++++++--------
 net/ipv4/netfilter/ipt_SAME.c       |   14 +++++++-------
 net/ipv4/netfilter/ipt_TOS.c        |    6 +++---
 net/ipv4/netfilter/ipt_TTL.c        |    8 ++++----
 net/ipv4/netfilter/ipt_ULOG.c       |   16 ++++++++--------
 net/ipv4/netfilter/nf_nat_rule.c    |   28 ++++++++++++++--------------
 net/ipv6/netfilter/ip6t_HL.c        |    8 ++++----
 net/ipv6/netfilter/ip6t_LOG.c       |   16 ++++++++--------
 net/ipv6/netfilter/ip6t_REJECT.c    |   16 ++++++++--------
 net/netfilter/xt_CONNMARK.c         |   10 +++++-----
 net/netfilter/xt_CONNSECMARK.c      |   12 ++++++------
 net/netfilter/xt_DSCP.c             |   14 +++++++-------
 net/netfilter/xt_MARK.c             |   14 +++++++-------
 net/netfilter/xt_NFLOG.c            |    8 ++++----
 net/netfilter/xt_SECMARK.c          |   24 ++++++++++++------------
 net/netfilter/xt_TCPMSS.c           |   22 +++++++++++-----------
 24 files changed, 174 insertions(+), 174 deletions(-)

Index: linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
===================================================================
--- linux-2.6.22-rc3-git6.orig/include/linux/netfilter/x_tables.h
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/x_tables.h
@@ -202,11 +202,11 @@ struct xt_target
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const void *entry,
-			  const struct xt_target *target,
-			  void *targinfo,
-			  unsigned int hook_mask);
+	bool (*checkentry)(const char *tablename,
+			   const void *entry,
+			   const struct xt_target *target,
+			   void *targinfo,
+			   unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_target *target, void *targinfo);
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/arpt_mangle.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/arpt_mangle.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/arpt_mangle.c
@@ -65,7 +65,7 @@ target(struct sk_buff **pskb,
 	return mangle->target;
 }
 
-static int
+static bool
 checkentry(const char *tablename, const void *e, const struct xt_target *target,
 	   void *targinfo, unsigned int hook_mask)
 {
@@ -73,12 +73,12 @@ checkentry(const char *tablename, const 
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
-		return 0;
+		return false;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
 	   mangle->target != ARPT_CONTINUE)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static struct arpt_target arpt_mangle_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -220,17 +220,17 @@ clusterip_add_node(struct clusterip_conf
 	return 0;
 }
 
-static int
+static bool
 clusterip_del_node(struct clusterip_config *c, u_int16_t nodenum)
 {
 	if (nodenum == 0 ||
 	    nodenum > c->num_total_nodes)
-		return 1;
+		return true;
 
 	if (test_and_clear_bit(nodenum - 1, &c->local_nodes))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 #endif
 
@@ -370,7 +370,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
@@ -387,13 +387,13 @@ checkentry(const char *tablename,
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
 		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
 			cipinfo->hash_mode);
-		return 0;
+		return false;
 
 	}
 	if (e->ip.dmsk.s_addr != htonl(0xffffffff)
 	    || e->ip.dst.s_addr == 0) {
 		printk(KERN_ERR "CLUSTERIP: Please specify destination IP\n");
-		return 0;
+		return false;
 	}
 
 	/* FIXME: further sanity checks */
@@ -407,7 +407,7 @@ checkentry(const char *tablename,
 			if (cipinfo->config != config) {
 				printk(KERN_ERR "CLUSTERIP: Reloaded entry "
 				       "has invalid config pointer!\n");
-				return 0;
+				return false;
 			}
 		} else {
 			/* Case B: This is a new rule referring to an existing
@@ -418,19 +418,19 @@ checkentry(const char *tablename,
 		/* Case C: This is a completely new clusterip config */
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			printk(KERN_WARNING "CLUSTERIP: no config found for %u.%u.%u.%u, need 'new'\n", NIPQUAD(e->ip.dst.s_addr));
-			return 0;
+			return false;
 		} else {
 			struct net_device *dev;
 
 			if (e->ip.iniface[0] == '\0') {
 				printk(KERN_WARNING "CLUSTERIP: Please specify an interface name\n");
-				return 0;
+				return false;
 			}
 
 			dev = dev_get_by_name(e->ip.iniface);
 			if (!dev) {
 				printk(KERN_WARNING "CLUSTERIP: no such interface %s\n", e->ip.iniface);
-				return 0;
+				return false;
 			}
 
 			config = clusterip_config_init(cipinfo,
@@ -438,7 +438,7 @@ checkentry(const char *tablename,
 			if (!config) {
 				printk(KERN_WARNING "CLUSTERIP: cannot allocate config\n");
 				dev_put(dev);
-				return 0;
+				return false;
 			}
 			dev_mc_add(config->dev,config->clustermac, ETH_ALEN, 0);
 		}
@@ -448,10 +448,10 @@ checkentry(const char *tablename,
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", target->family);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 /* drop reference count of cluster config when rule is deleted */
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ECN.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ECN.c
@@ -24,8 +24,8 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("iptables ECN modification module");
 
 /* set ECT codepoint from IP header.
- * 	return 0 if there was an error. */
-static inline int
+ * 	return false if there was an error. */
+static inline bool
 set_ect_ip(struct sk_buff **pskb, const struct ipt_ECN_info *einfo)
 {
 	struct iphdr *iph = ip_hdr(*pskb);
@@ -33,18 +33,18 @@ set_ect_ip(struct sk_buff **pskb, const 
 	if ((iph->tos & IPT_ECN_IP_MASK) != (einfo->ip_ect & IPT_ECN_IP_MASK)) {
 		__u8 oldtos;
 		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
-			return 0;
+			return false;
 		iph = ip_hdr(*pskb);
 		oldtos = iph->tos;
 		iph->tos &= ~IPT_ECN_IP_MASK;
 		iph->tos |= (einfo->ip_ect & IPT_ECN_IP_MASK);
 		nf_csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
 	}
-	return 1;
+	return true;
 }
 
-/* Return 0 if there was an error. */
-static inline int
+/* Return false if there was an error. */
+static inline bool
 set_ect_tcp(struct sk_buff **pskb, const struct ipt_ECN_info *einfo)
 {
 	struct tcphdr _tcph, *tcph;
@@ -54,16 +54,16 @@ set_ect_tcp(struct sk_buff **pskb, const
 	tcph = skb_header_pointer(*pskb, ip_hdrlen(*pskb),
 				  sizeof(_tcph), &_tcph);
 	if (!tcph)
-		return 0;
+		return false;
 
 	if ((!(einfo->operation & IPT_ECN_OP_SET_ECE) ||
 	     tcph->ece == einfo->proto.tcp.ece) &&
 	    ((!(einfo->operation & IPT_ECN_OP_SET_CWR) ||
 	     tcph->cwr == einfo->proto.tcp.cwr)))
-		return 1;
+		return true;
 
 	if (!skb_make_writable(pskb, ip_hdrlen(*pskb) + sizeof(*tcph)))
-		return 0;
+		return false;
 	tcph = (void *)ip_hdr(*pskb) + ip_hdrlen(*pskb);
 
 	oldval = ((__be16 *)tcph)[6];
@@ -74,7 +74,7 @@ set_ect_tcp(struct sk_buff **pskb, const
 
 	nf_proto_csum_replace2(&tcph->check, *pskb,
 				oldval, ((__be16 *)tcph)[6], 0);
-	return 1;
+	return true;
 }
 
 static unsigned int
@@ -99,7 +99,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
@@ -112,20 +112,20 @@ checkentry(const char *tablename,
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
 			einfo->operation);
-		return 0;
+		return false;
 	}
 	if (einfo->ip_ect & ~IPT_ECN_IP_MASK) {
 		printk(KERN_WARNING "ECN: new ECT codepoint %x out of mask\n",
 			einfo->ip_ect);
-		return 0;
+		return false;
 	}
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR))
 	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
 		printk(KERN_WARNING "ECN: cannot use TCP operations on a "
 		       "non-tcp rule\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ipt_ecn_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_LOG.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_LOG.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_LOG.c
@@ -435,24 +435,24 @@ ipt_log_target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int ipt_log_checkentry(const char *tablename,
-			      const void *e,
-			      const struct xt_target *target,
-			      void *targinfo,
-			      unsigned int hook_mask)
+static bool ipt_log_checkentry(const char *tablename,
+			       const void *e,
+			       const struct xt_target *target,
+			       void *targinfo,
+			       unsigned int hook_mask)
 {
 	const struct ipt_log_info *loginfo = targinfo;
 
 	if (loginfo->level >= 8) {
 		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
-		return 0;
+		return false;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		DEBUGP("LOG: prefix term %i\n",
 		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ipt_log_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -37,7 +37,7 @@ MODULE_DESCRIPTION("iptables MASQUERADE 
 static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
-static int
+static bool
 masquerade_check(const char *tablename,
 		 const void *e,
 		 const struct xt_target *target,
@@ -48,13 +48,13 @@ masquerade_check(const char *tablename,
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		DEBUGP("masquerade_check: bad MAP_IPS.\n");
-		return 0;
+		return false;
 	}
 	if (mr->rangesize != 1) {
 		DEBUGP("masquerade_check: bad rangesize %u.\n", mr->rangesize);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static unsigned int
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_NETMAP.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_NETMAP.c
@@ -29,7 +29,7 @@ MODULE_DESCRIPTION("iptables 1:1 NAT map
 #define DEBUGP(format, args...)
 #endif
 
-static int
+static bool
 check(const char *tablename,
       const void *e,
       const struct xt_target *target,
@@ -40,13 +40,13 @@ check(const char *tablename,
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		DEBUGP(MODULENAME":check: bad MAP_IPS.\n");
-		return 0;
+		return false;
 	}
 	if (mr->rangesize != 1) {
 		DEBUGP(MODULENAME":check: bad rangesize %u.\n", mr->rangesize);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static unsigned int
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_REDIRECT.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_REDIRECT.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -32,7 +32,7 @@ MODULE_DESCRIPTION("iptables REDIRECT ta
 #endif
 
 /* FIXME: Take multiple ranges --RR */
-static int
+static bool
 redirect_check(const char *tablename,
 	       const void *e,
 	       const struct xt_target *target,
@@ -43,13 +43,13 @@ redirect_check(const char *tablename,
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		DEBUGP("redirect_check: bad MAP_IPS.\n");
-		return 0;
+		return false;
 	}
 	if (mr->rangesize != 1) {
 		DEBUGP("redirect_check: bad rangesize %u.\n", mr->rangesize);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static unsigned int
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_REJECT.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_REJECT.c
@@ -217,27 +217,27 @@ static unsigned int reject(struct sk_buf
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
-		 const void *e_void,
-		 const struct xt_target *target,
-		 void *targinfo,
-		 unsigned int hook_mask)
+static bool check(const char *tablename,
+		  const void *e_void,
+		  const struct xt_target *target,
+		  void *targinfo,
+		  unsigned int hook_mask)
 {
 	const struct ipt_reject_info *rejinfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		printk("REJECT: ECHOREPLY no longer supported.\n");
-		return 0;
+		return false;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP
 		    || (e->ip.invflags & XT_INV_PROTO)) {
 			DEBUGP("REJECT: TCP_RESET invalid for non-tcp\n");
-			return 0;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ipt_reject_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_SAME.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_SAME.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_SAME.c
@@ -33,7 +33,7 @@ MODULE_DESCRIPTION("iptables special SNA
 #define DEBUGP(format, args...)
 #endif
 
-static int
+static bool
 same_check(const char *tablename,
 	      const void *e,
 	      const struct xt_target *target,
@@ -47,13 +47,13 @@ same_check(const char *tablename,
 
 	if (mr->rangesize < 1) {
 		DEBUGP("same_check: need at least one dest range.\n");
-		return 0;
+		return false;
 	}
 	if (mr->rangesize > IPT_SAME_MAX_RANGE) {
 		DEBUGP("same_check: too many ranges specified, maximum "
 				"is %u ranges\n",
 				IPT_SAME_MAX_RANGE);
-		return 0;
+		return false;
 	}
 	for (count = 0; count < mr->rangesize; count++) {
 		if (ntohl(mr->range[count].min_ip) >
@@ -62,11 +62,11 @@ same_check(const char *tablename,
 				"range `%u.%u.%u.%u-%u.%u.%u.%u'.\n",
 				NIPQUAD(mr->range[count].min_ip),
 				NIPQUAD(mr->range[count].max_ip));
-			return 0;
+			return false;
 		}
 		if (!(mr->range[count].flags & IP_NAT_RANGE_MAP_IPS)) {
 			DEBUGP("same_check: bad MAP_IPS.\n");
-			return 0;
+			return false;
 		}
 		rangeip = (ntohl(mr->range[count].max_ip) -
 					ntohl(mr->range[count].min_ip) + 1);
@@ -81,7 +81,7 @@ same_check(const char *tablename,
 		DEBUGP("same_check: Couldn't allocate %u bytes "
 			"for %u ipaddresses!\n",
 			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
-		return 0;
+		return false;
 	}
 	DEBUGP("same_check: Allocated %u bytes for %u ipaddresses.\n",
 			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
@@ -97,7 +97,7 @@ same_check(const char *tablename,
 			index++;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_TOS.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_TOS.c
@@ -43,7 +43,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
@@ -58,9 +58,9 @@ checkentry(const char *tablename,
 	    && tos != IPTOS_MINCOST
 	    && tos != IPTOS_NORMALSVC) {
 		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ipt_tos_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_TTL.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_TTL.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_TTL.c
@@ -62,7 +62,7 @@ ipt_ttl_target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int ipt_ttl_checkentry(const char *tablename,
+static bool ipt_ttl_checkentry(const char *tablename,
 		const void *e,
 		const struct xt_target *target,
 		void *targinfo,
@@ -73,11 +73,11 @@ static int ipt_ttl_checkentry(const char
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
 			info->mode);
-		return 0;
+		return false;
 	}
 	if ((info->mode != IPT_TTL_SET) && (info->ttl == 0))
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static struct xt_target ipt_TTL = {
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_ULOG.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_ULOG.c
@@ -328,25 +328,25 @@ static void ipt_logfn(unsigned int pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static int ipt_ulog_checkentry(const char *tablename,
-			       const void *e,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int hookmask)
+static bool ipt_ulog_checkentry(const char *tablename,
+				const void *e,
+				const struct xt_target *target,
+				void *targinfo,
+				unsigned int hookmask)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		DEBUGP("ipt_ULOG: prefix term %i\n",
 		       loginfo->prefix[sizeof(loginfo->prefix) - 1]);
-		return 0;
+		return false;
 	}
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
 		DEBUGP("ipt_ULOG: queue threshold %i > MAX_QLEN\n",
 			loginfo->qthreshold);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_COMPAT
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_nat_rule.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/nf_nat_rule.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_nat_rule.c
@@ -140,36 +140,36 @@ static unsigned int ipt_dnat_target(stru
 	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
 }
 
-static int ipt_snat_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int hook_mask)
+static bool ipt_snat_checkentry(const char *tablename,
+				const void *entry,
+				const struct xt_target *target,
+				void *targinfo,
+				unsigned int hook_mask)
 {
 	struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
 		printk("SNAT: multiple ranges no longer supported\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
-static int ipt_dnat_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int hook_mask)
+static bool ipt_dnat_checkentry(const char *tablename,
+				const void *entry,
+				const struct xt_target *target,
+				void *targinfo,
+				unsigned int hook_mask)
 {
 	struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
 		printk("DNAT: multiple ranges no longer supported\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 inline unsigned int
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_HL.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_HL.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_HL.c
@@ -58,7 +58,7 @@ static unsigned int ip6t_hl_target(struc
 	return XT_CONTINUE;
 }
 
-static int ip6t_hl_checkentry(const char *tablename,
+static bool ip6t_hl_checkentry(const char *tablename,
 		const void *entry,
 		const struct xt_target *target,
 		void *targinfo,
@@ -69,14 +69,14 @@ static int ip6t_hl_checkentry(const char
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
 			info->mode);
-		return 0;
+		return false;
 	}
 	if ((info->mode != IP6T_HL_SET) && (info->hop_limit == 0)) {
 		printk(KERN_WARNING "ip6t_HL: increment/decrement doesn't "
 			"make sense with value 0\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ip6t_HL = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_LOG.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_LOG.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_LOG.c
@@ -448,24 +448,24 @@ ip6t_log_target(struct sk_buff **pskb,
 }
 
 
-static int ip6t_log_checkentry(const char *tablename,
-			       const void *entry,
-			       const struct xt_target *target,
-			       void *targinfo,
-			       unsigned int hook_mask)
+static bool ip6t_log_checkentry(const char *tablename,
+				const void *entry,
+				const struct xt_target *target,
+				void *targinfo,
+				unsigned int hook_mask)
 {
 	const struct ip6t_log_info *loginfo = targinfo;
 
 	if (loginfo->level >= 8) {
 		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
-		return 0;
+		return false;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		DEBUGP("LOG: prefix term %i\n",
 		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ip6t_log_reg = {
Index: linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_REJECT.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/ipv6/netfilter/ip6t_REJECT.c
+++ linux-2.6.22-rc3-git6/net/ipv6/netfilter/ip6t_REJECT.c
@@ -221,27 +221,27 @@ static unsigned int reject6_target(struc
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
-		 const void *entry,
-		 const struct xt_target *target,
-		 void *targinfo,
-		 unsigned int hook_mask)
+static bool check(const char *tablename,
+		  const void *entry,
+		  const struct xt_target *target,
+		  void *targinfo,
+		  unsigned int hook_mask)
 {
 	const struct ip6t_reject_info *rejinfo = targinfo;
 	const struct ip6t_entry *e = entry;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
-		return 0;
+		return false;
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ipv6.proto != IPPROTO_TCP
 		    || (e->ipv6.invflags & XT_INV_PROTO)) {
 			DEBUGP("ip6t_REJECT: TCP_RESET illegal for non-tcp\n");
-			return 0;
+			return false;
 		}
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target ip6t_reject_reg = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_CONNMARK.c
@@ -76,7 +76,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
+static bool
 checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_target *target,
@@ -88,21 +88,21 @@ checkentry(const char *tablename,
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", target->family);
-		return 0;
+		return false;
 	}
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 		if (strcmp(tablename, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
 			       "called from \"mangle\" table, not \"%s\"\n",
 			       tablename);
-			return 0;
+			return false;
 		}
 	}
 	if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_CONNSECMARK.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_CONNSECMARK.c
@@ -85,16 +85,16 @@ static unsigned int target(struct sk_buf
 	return XT_CONTINUE;
 }
 
-static int checkentry(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *targinfo,
-		      unsigned int hook_mask)
+static bool checkentry(const char *tablename, const void *entry,
+		       const struct xt_target *target, void *targinfo,
+		       unsigned int hook_mask)
 {
 	struct xt_connsecmark_target_info *info = targinfo;
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", target->family);
-		return 0;
+		return false;
 	}
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
@@ -103,10 +103,10 @@ static int checkentry(const char *tablen
 
 	default:
 		printk(KERN_INFO PFX "invalid mode: %hu\n", info->mode);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static void
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_DSCP.c
@@ -66,19 +66,19 @@ static unsigned int target6(struct sk_bu
 	return XT_CONTINUE;
 }
 
-static int checkentry(const char *tablename,
-		      const void *e_void,
-		      const struct xt_target *target,
-		      void *targinfo,
-		      unsigned int hook_mask)
+static bool checkentry(const char *tablename,
+		       const void *e_void,
+		       const struct xt_target *target,
+		       void *targinfo,
+		       unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
 
 	if ((dscp > XT_DSCP_MAX)) {
 		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static struct xt_target xt_dscp_target[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_MARK.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_MARK.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_MARK.c
@@ -65,7 +65,7 @@ target_v1(struct sk_buff **pskb,
 }
 
 
-static int
+static bool
 checkentry_v0(const char *tablename,
 	      const void *entry,
 	      const struct xt_target *target,
@@ -76,12 +76,12 @@ checkentry_v0(const char *tablename,
 
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
-static int
+static bool
 checkentry_v1(const char *tablename,
 	      const void *entry,
 	      const struct xt_target *target,
@@ -95,13 +95,13 @@ checkentry_v1(const char *tablename,
 	    && markinfo->mode != XT_MARK_OR) {
 		printk(KERN_WARNING "MARK: unknown mode %u\n",
 		       markinfo->mode);
-		return 0;
+		return false;
 	}
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_COMPAT
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_NFLOG.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_NFLOG.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_NFLOG.c
@@ -38,7 +38,7 @@ nflog_target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
+static bool
 nflog_checkentry(const char *tablename, const void *entry,
 		 const struct xt_target *target, void *targetinfo,
 		 unsigned int hookmask)
@@ -46,10 +46,10 @@ nflog_checkentry(const char *tablename, 
 	struct xt_nflog_info *info = targetinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
-		return 0;
+		return false;
 	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static struct xt_target xt_nflog_target[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_SECMARK.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_SECMARK.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_SECMARK.c
@@ -51,7 +51,7 @@ static unsigned int target(struct sk_buf
 	return XT_CONTINUE;
 }
 
-static int checkentry_selinux(struct xt_secmark_target_info *info)
+static bool checkentry_selinux(struct xt_secmark_target_info *info)
 {
 	int err;
 	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
@@ -63,50 +63,50 @@ static int checkentry_selinux(struct xt_
 		if (err == -EINVAL)
 			printk(KERN_INFO PFX "invalid SELinux context \'%s\'\n",
 			       sel->selctx);
-		return 0;
+		return false;
 	}
 
 	if (!sel->selsid) {
 		printk(KERN_INFO PFX "unable to map SELinux context \'%s\'\n",
 		       sel->selctx);
-		return 0;
+		return false;
 	}
 
 	err = selinux_relabel_packet_permission(sel->selsid);
 	if (err) {
 		printk(KERN_INFO PFX "unable to obtain relabeling permission\n");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
-static int checkentry(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *targinfo,
-		      unsigned int hook_mask)
+static bool checkentry(const char *tablename, const void *entry,
+		       const struct xt_target *target, void *targinfo,
+		       unsigned int hook_mask)
 {
 	struct xt_secmark_target_info *info = targinfo;
 
 	if (mode && mode != info->mode) {
 		printk(KERN_INFO PFX "mode already set to %hu cannot mix with "
 		       "rules for mode %hu\n", mode, info->mode);
-		return 0;
+		return false;
 	}
 
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
 		if (!checkentry_selinux(info))
-			return 0;
+			return false;
 		break;
 
 	default:
 		printk(KERN_INFO PFX "invalid mode: %hu\n", info->mode);
-		return 0;
+		return false;
 	}
 
 	if (!mode)
 		mode = info->mode;
-	return 1;
+	return true;
 }
 
 static struct xt_target xt_secmark_target[] = {
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_TCPMSS.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_TCPMSS.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_TCPMSS.c
@@ -197,19 +197,19 @@ xt_tcpmss_target6(struct sk_buff **pskb,
 #define TH_SYN 0x02
 
 /* Must specify -p tcp --syn */
-static inline int find_syn_match(const struct xt_entry_match *m)
+static inline bool find_syn_match(const struct xt_entry_match *m)
 {
 	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
 
 	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
 	    tcpinfo->flg_cmp & TH_SYN &&
 	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
-static int
+static bool
 xt_tcpmss_checkentry4(const char *tablename,
 		      const void *entry,
 		      const struct xt_target *target,
@@ -225,16 +225,16 @@ xt_tcpmss_checkentry4(const char *tablen
 			   (1 << NF_IP_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
 		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return 0;
+		return false;
 	}
 	if (IPT_MATCH_ITERATE(e, find_syn_match))
-		return 1;
+		return true;
 	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
-	return 0;
+	return false;
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static int
+static bool
 xt_tcpmss_checkentry6(const char *tablename,
 		      const void *entry,
 		      const struct xt_target *target,
@@ -250,12 +250,12 @@ xt_tcpmss_checkentry6(const char *tablen
 			   (1 << NF_IP6_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
 		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return 0;
+		return false;
 	}
 	if (IP6T_MATCH_ITERATE(e, find_syn_match))
-		return 1;
+		return true;
 	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
-	return 0;
+	return false;
 }
 #endif
 
