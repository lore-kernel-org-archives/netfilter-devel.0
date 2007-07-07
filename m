From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 47/50]: Convert DEBUGP to pr_debug
Date: Sat,  7 Jul 2007 14:24:06 +0200 (MEST)
Message-ID: <20070707122321.1589.65968.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert DEBUGP to pr_debug

Convert DEBUGP to pr_debug and fix lots of non-compiling debug statements.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6786c212c4a32dccc19cae256b36e80c26640b14
tree e3001575c3ba610137e3eb051617ce118cc15449
parent a427f588c5a2a74926656e0586717479869ff01c
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:08 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:08 +0200

 include/linux/netfilter/nf_conntrack_pptp.h        |    2 
 include/net/netfilter/nf_conntrack_tuple.h         |   10 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   27 +--
 net/ipv4/netfilter/ipt_LOG.c                       |   12 -
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   10 -
 net/ipv4/netfilter/ipt_NETMAP.c                    |   13 --
 net/ipv4/netfilter/ipt_REDIRECT.c                  |   10 -
 net/ipv4/netfilter/ipt_REJECT.c                    |   10 -
 net/ipv4/netfilter/ipt_SAME.c                      |   53 +++----
 net/ipv4/netfilter/ipt_ULOG.c                      |   35 ++--
 net/ipv4/netfilter/ipt_iprange.c                   |   30 +---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   22 +--
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    6 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   22 +--
 net/ipv4/netfilter/nf_nat_core.c                   |   15 +-
 net/ipv4/netfilter/nf_nat_ftp.c                    |   14 --
 net/ipv4/netfilter/nf_nat_h323.c                   |   95 ++++++------
 net/ipv4/netfilter/nf_nat_helper.c                 |   40 ++---
 net/ipv4/netfilter/nf_nat_irc.c                    |   13 --
 net/ipv4/netfilter/nf_nat_pptp.c                   |   37 ++---
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   17 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   14 --
 net/ipv4/netfilter/nf_nat_sip.c                    |    8 -
 net/ipv4/netfilter/nf_nat_standalone.c             |   16 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |   12 -
 net/ipv6/netfilter/ip6t_REJECT.c                   |   23 +--
 net/ipv6/netfilter/ip6t_ah.c                       |   47 +++---
 net/ipv6/netfilter/ip6t_frag.c                     |   76 ++++-----
 net/ipv6/netfilter/ip6t_hbh.c                      |   45 ++----
 net/ipv6/netfilter/ip6t_rt.c                       |   82 +++++-----
 net/ipv6/netfilter/ip6table_mangle.c               |    6 -
 net/ipv6/netfilter/ip6table_raw.c                  |    6 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   10 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   24 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   52 +++---
 net/netfilter/nf_conntrack_core.c                  |   41 ++---
 net/netfilter/nf_conntrack_ftp.c                   |   94 ++++++------
 net/netfilter/nf_conntrack_h323_main.c             |  161 ++++++++++----------
 net/netfilter/nf_conntrack_irc.c                   |   24 +--
 net/netfilter/nf_conntrack_l3proto_generic.c       |    6 -
 net/netfilter/nf_conntrack_pptp.c                  |   71 ++++-----
 net/netfilter/nf_conntrack_proto_gre.c             |   28 +--
 net/netfilter/nf_conntrack_proto_sctp.c            |   92 ++++-------
 net/netfilter/nf_conntrack_proto_tcp.c             |  129 +++++++---------
 net/netfilter/nf_conntrack_sane.c                  |   27 +--
 net/netfilter/nf_conntrack_sip.c                   |   22 +--
 net/netfilter/nf_conntrack_standalone.c            |    6 -
 net/netfilter/nf_conntrack_tftp.c                  |   17 --
 48 files changed, 662 insertions(+), 970 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 9d8144a..c93061f 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -4,6 +4,8 @@
 
 #include <linux/netfilter/nf_conntrack_common.h>
 
+extern const char *pptp_msg_name[];
+
 /* state of the control session */
 enum pptp_ctrlsess_state {
 	PPTP_SESSION_NONE,			/* no session present */
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 99934ab..040dae5 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -120,11 +120,11 @@ struct nf_conntrack_tuple_mask
 
 #ifdef __KERNEL__
 
-#define NF_CT_DUMP_TUPLE(tp)						    \
-DEBUGP("tuple %p: %u %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",	    \
-	(tp), (tp)->src.l3num, (tp)->dst.protonum,			    \
-	NIP6(*(struct in6_addr *)(tp)->src.u3.all), ntohs((tp)->src.u.all), \
-	NIP6(*(struct in6_addr *)(tp)->dst.u3.all), ntohs((tp)->dst.u.all))
+#define NF_CT_DUMP_TUPLE(tp)						     \
+pr_debug("tuple %p: %u %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",	     \
+	 (tp), (tp)->src.l3num, (tp)->dst.protonum,			     \
+	 NIP6(*(struct in6_addr *)(tp)->src.u3.all), ntohs((tp)->src.u.all), \
+	 NIP6(*(struct in6_addr *)(tp)->dst.u3.all), ntohs((tp)->dst.u.all))
 
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1981ace..8bacda3 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -30,14 +30,6 @@
 
 #define CLUSTERIP_VERSION "0.8"
 
-#define DEBUG_CLUSTERIP
-
-#ifdef DEBUG_CLUSTERIP
-#define DEBUGP	printk
-#else
-#define DEBUGP
-#endif
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables target for CLUSTERIP");
@@ -351,15 +343,15 @@ target(struct sk_buff **pskb,
 			break;
 	}
 
-#ifdef DEBUG_CLUSTERP
+#ifdef DEBUG
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	DEBUGP("hash=%u ct_hash=%u ", hash, ct->mark);
+	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
-		DEBUGP("not responsible\n");
+		pr_debug("not responsible\n");
 		return NF_DROP;
 	}
-	DEBUGP("responsible\n");
+	pr_debug("responsible\n");
 
 	/* despite being received via linklayer multicast, this is
 	 * actually a unicast IP packet. TCP doesn't like PACKET_MULTICAST */
@@ -490,7 +482,7 @@ struct arp_payload {
 	__be32 dst_ip;
 } __attribute__ ((packed));
 
-#ifdef CLUSTERIP_DEBUG
+#ifdef DEBUG
 static void arp_print(struct arp_payload *payload)
 {
 #define HBUFFERLEN 30
@@ -546,8 +538,9 @@ arp_mangle(unsigned int hook,
 	 * this wouldn't work, since we didn't subscribe the mcast group on
 	 * other interfaces */
 	if (c->dev != out) {
-		DEBUGP("CLUSTERIP: not mangling arp reply on different "
-		       "interface: cip'%s'-skb'%s'\n", c->dev->name, out->name);
+		pr_debug("CLUSTERIP: not mangling arp reply on different "
+			 "interface: cip'%s'-skb'%s'\n",
+			 c->dev->name, out->name);
 		clusterip_config_put(c);
 		return NF_ACCEPT;
 	}
@@ -555,8 +548,8 @@ arp_mangle(unsigned int hook,
 	/* mangle reply hardware address */
 	memcpy(payload->src_hw, c->clustermac, arp->ar_hln);
 
-#ifdef CLUSTERIP_DEBUG
-	DEBUGP(KERN_DEBUG "CLUSTERIP mangled arp reply: ");
+#ifdef DEBUG
+	pr_debug(KERN_DEBUG "CLUSTERIP mangled arp reply: ");
 	arp_print(payload);
 #endif
 
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 9bfce61..5937ad1 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -27,12 +27,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("iptables syslog logging module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Use lock to serialize, so printks don't overlap */
 static DEFINE_SPINLOCK(log_lock);
 
@@ -452,12 +446,12 @@ static bool ipt_log_checkentry(const char *tablename,
 	const struct ipt_log_info *loginfo = targinfo;
 
 	if (loginfo->level >= 8) {
-		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
+		pr_debug("LOG: level %u >= 8\n", loginfo->level);
 		return false;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
-		DEBUGP("LOG: prefix term %i\n",
-		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
+		pr_debug("LOG: prefix term %i\n",
+			 loginfo->prefix[sizeof(loginfo->prefix)-1]);
 		return false;
 	}
 	return true;
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index bc033e0..7c4e4be 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -27,12 +27,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("iptables MASQUERADE target module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Lock protects masq region inside conntrack */
 static DEFINE_RWLOCK(masq_lock);
 
@@ -47,11 +41,11 @@ masquerade_check(const char *tablename,
 	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
-		DEBUGP("masquerade_check: bad MAP_IPS.\n");
+		pr_debug("masquerade_check: bad MAP_IPS.\n");
 		return false;
 	}
 	if (mr->rangesize != 1) {
-		DEBUGP("masquerade_check: bad rangesize %u.\n", mr->rangesize);
+		pr_debug("masquerade_check: bad rangesize %u\n", mr->rangesize);
 		return false;
 	}
 	return true;
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 0a7ce15..41a011d 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -18,17 +18,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat_rule.h>
 
-#define MODULENAME "NETMAP"
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("iptables 1:1 NAT mapping of IP networks target");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static bool
 check(const char *tablename,
       const void *e,
@@ -39,11 +32,11 @@ check(const char *tablename,
 	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
-		DEBUGP(MODULENAME":check: bad MAP_IPS.\n");
+		pr_debug("NETMAP:check: bad MAP_IPS.\n");
 		return false;
 	}
 	if (mr->rangesize != 1) {
-		DEBUGP(MODULENAME":check: bad rangesize %u.\n", mr->rangesize);
+		pr_debug("NETMAP:check: bad rangesize %u.\n", mr->rangesize);
 		return false;
 	}
 	return true;
@@ -86,7 +79,7 @@ target(struct sk_buff **pskb,
 }
 
 static struct xt_target target_module __read_mostly = {
-	.name 		= MODULENAME,
+	.name 		= "NETMAP",
 	.family		= AF_INET,
 	.target 	= target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 61e1e47..6ac7a23 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -25,12 +25,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("iptables REDIRECT target module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* FIXME: Take multiple ranges --RR */
 static bool
 redirect_check(const char *tablename,
@@ -42,11 +36,11 @@ redirect_check(const char *tablename,
 	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
-		DEBUGP("redirect_check: bad MAP_IPS.\n");
+		pr_debug("redirect_check: bad MAP_IPS.\n");
 		return false;
 	}
 	if (mr->rangesize != 1) {
-		DEBUGP("redirect_check: bad rangesize %u.\n", mr->rangesize);
+		pr_debug("redirect_check: bad rangesize %u.\n", mr->rangesize);
 		return false;
 	}
 	return true;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index dd5432c..cb038c8 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -31,12 +31,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("iptables REJECT target module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
@@ -227,13 +221,13 @@ static bool check(const char *tablename,
 	const struct ipt_entry *e = e_void;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
-		printk("REJECT: ECHOREPLY no longer supported.\n");
+		printk("ipt_REJECT: ECHOREPLY no longer supported.\n");
 		return false;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP
 		    || (e->ip.invflags & XT_INV_PROTO)) {
-			DEBUGP("REJECT: TCP_RESET invalid for non-tcp\n");
+			printk("ipt_REJECT: TCP_RESET invalid for non-tcp\n");
 			return false;
 		}
 	}
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index 3a0d7da..97641f1 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -27,12 +27,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Josefsson <gandalf@wlug.westbo.se>");
 MODULE_DESCRIPTION("iptables special SNAT module for consistent sourceip");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static bool
 same_check(const char *tablename,
 	      const void *e,
@@ -46,54 +40,52 @@ same_check(const char *tablename,
 	mr->ipnum = 0;
 
 	if (mr->rangesize < 1) {
-		DEBUGP("same_check: need at least one dest range.\n");
+		pr_debug("same_check: need at least one dest range.\n");
 		return false;
 	}
 	if (mr->rangesize > IPT_SAME_MAX_RANGE) {
-		DEBUGP("same_check: too many ranges specified, maximum "
-				"is %u ranges\n",
-				IPT_SAME_MAX_RANGE);
+		pr_debug("same_check: too many ranges specified, maximum "
+			 "is %u ranges\n", IPT_SAME_MAX_RANGE);
 		return false;
 	}
 	for (count = 0; count < mr->rangesize; count++) {
 		if (ntohl(mr->range[count].min_ip) >
 				ntohl(mr->range[count].max_ip)) {
-			DEBUGP("same_check: min_ip is larger than max_ip in "
-				"range `%u.%u.%u.%u-%u.%u.%u.%u'.\n",
-				NIPQUAD(mr->range[count].min_ip),
-				NIPQUAD(mr->range[count].max_ip));
+			pr_debug("same_check: min_ip is larger than max_ip in "
+				 "range `%u.%u.%u.%u-%u.%u.%u.%u'.\n",
+				 NIPQUAD(mr->range[count].min_ip),
+				 NIPQUAD(mr->range[count].max_ip));
 			return false;
 		}
 		if (!(mr->range[count].flags & IP_NAT_RANGE_MAP_IPS)) {
-			DEBUGP("same_check: bad MAP_IPS.\n");
+			pr_debug("same_check: bad MAP_IPS.\n");
 			return false;
 		}
 		rangeip = (ntohl(mr->range[count].max_ip) -
 					ntohl(mr->range[count].min_ip) + 1);
 		mr->ipnum += rangeip;
 
-		DEBUGP("same_check: range %u, ipnum = %u\n", count, rangeip);
+		pr_debug("same_check: range %u, ipnum = %u\n", count, rangeip);
 	}
-	DEBUGP("same_check: total ipaddresses = %u\n", mr->ipnum);
+	pr_debug("same_check: total ipaddresses = %u\n", mr->ipnum);
 
 	mr->iparray = kmalloc((sizeof(u_int32_t) * mr->ipnum), GFP_KERNEL);
 	if (!mr->iparray) {
-		DEBUGP("same_check: Couldn't allocate %u bytes "
-			"for %u ipaddresses!\n",
-			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+		pr_debug("same_check: Couldn't allocate %Zu bytes "
+			 "for %u ipaddresses!\n",
+			 (sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
 		return false;
 	}
-	DEBUGP("same_check: Allocated %u bytes for %u ipaddresses.\n",
-			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+	pr_debug("same_check: Allocated %Zu bytes for %u ipaddresses.\n",
+		 (sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
 
 	for (count = 0; count < mr->rangesize; count++) {
 		for (countess = ntohl(mr->range[count].min_ip);
 				countess <= ntohl(mr->range[count].max_ip);
 					countess++) {
 			mr->iparray[index] = countess;
-			DEBUGP("same_check: Added ipaddress `%u.%u.%u.%u' "
-				"in index %u.\n",
-				HIPQUAD(countess), index);
+			pr_debug("same_check: Added ipaddress `%u.%u.%u.%u' "
+				 "in index %u.\n", HIPQUAD(countess), index);
 			index++;
 		}
 	}
@@ -107,8 +99,8 @@ same_destroy(const struct xt_target *target, void *targinfo)
 
 	kfree(mr->iparray);
 
-	DEBUGP("same_destroy: Deallocated %u bytes for %u ipaddresses.\n",
-			(sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
+	pr_debug("same_destroy: Deallocated %Zu bytes for %u ipaddresses.\n",
+		 (sizeof(u_int32_t) * mr->ipnum), mr->ipnum);
 }
 
 static unsigned int
@@ -146,10 +138,9 @@ same_target(struct sk_buff **pskb,
 
 	new_ip = htonl(same->iparray[aindex]);
 
-	DEBUGP("ipt_SAME: src=%u.%u.%u.%u dst=%u.%u.%u.%u, "
-			"new src=%u.%u.%u.%u\n",
-			NIPQUAD(t->src.ip), NIPQUAD(t->dst.ip),
-			NIPQUAD(new_ip));
+	pr_debug("ipt_SAME: src=%u.%u.%u.%u dst=%u.%u.%u.%u, "
+		 "new src=%u.%u.%u.%u\n",
+		 NIPQUAD(t->src.u3.ip), NIPQUAD(t->dst.u3.ip), NIPQUAD(new_ip));
 
 	/* Transfer from original range. */
 	newrange = ((struct nf_nat_range)
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 226750d..6ca43e4 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -55,13 +55,6 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NFLOG);
 #define ULOG_NL_EVENT		111		/* Harald's favorite number */
 #define ULOG_MAXNLGROUPS	32		/* numer of nlgroups */
 
-#if 0
-#define DEBUGP(format, args...) printk("%s:%s:" format, \
-				       __FILE__, __FUNCTION__ , ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 #define PRINTR(format, args...) do { if (net_ratelimit()) printk(format , ## args); } while (0)
 
 static unsigned int nlbufsiz = NLMSG_GOODSIZE;
@@ -96,12 +89,12 @@ static void ulog_send(unsigned int nlgroupnum)
 	ulog_buff_t *ub = &ulog_buffers[nlgroupnum];
 
 	if (timer_pending(&ub->timer)) {
-		DEBUGP("ipt_ULOG: ulog_send: timer was pending, deleting\n");
+		pr_debug("ipt_ULOG: ulog_send: timer was pending, deleting\n");
 		del_timer(&ub->timer);
 	}
 
 	if (!ub->skb) {
-		DEBUGP("ipt_ULOG: ulog_send: nothing to send\n");
+		pr_debug("ipt_ULOG: ulog_send: nothing to send\n");
 		return;
 	}
 
@@ -110,8 +103,8 @@ static void ulog_send(unsigned int nlgroupnum)
 		ub->lastnlh->nlmsg_type = NLMSG_DONE;
 
 	NETLINK_CB(ub->skb).dst_group = nlgroupnum + 1;
-	DEBUGP("ipt_ULOG: throwing %d packets to netlink group %u\n",
-		ub->qlen, nlgroupnum + 1);
+	pr_debug("ipt_ULOG: throwing %d packets to netlink group %u\n",
+		 ub->qlen, nlgroupnum + 1);
 	netlink_broadcast(nflognl, ub->skb, 0, nlgroupnum + 1, GFP_ATOMIC);
 
 	ub->qlen = 0;
@@ -123,7 +116,7 @@ static void ulog_send(unsigned int nlgroupnum)
 /* timer function to flush queue in flushtimeout time */
 static void ulog_timer(unsigned long data)
 {
-	DEBUGP("ipt_ULOG: timer function called, calling ulog_send\n");
+	pr_debug("ipt_ULOG: timer function called, calling ulog_send\n");
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
@@ -204,8 +197,8 @@ static void ipt_ulog_packet(unsigned int hooknum,
 			goto alloc_failure;
 	}
 
-	DEBUGP("ipt_ULOG: qlen %d, qthreshold %d\n", ub->qlen,
-		loginfo->qthreshold);
+	pr_debug("ipt_ULOG: qlen %d, qthreshold %Zu\n", ub->qlen,
+		 loginfo->qthreshold);
 
 	/* NLMSG_PUT contains a hidden goto nlmsg_failure !!! */
 	nlh = NLMSG_PUT(ub->skb, 0, ub->qlen, ULOG_NL_EVENT,
@@ -334,13 +327,13 @@ static bool ipt_ulog_checkentry(const char *tablename,
 	const struct ipt_ulog_info *loginfo = targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
-		DEBUGP("ipt_ULOG: prefix term %i\n",
-		       loginfo->prefix[sizeof(loginfo->prefix) - 1]);
+		pr_debug("ipt_ULOG: prefix term %i\n",
+			 loginfo->prefix[sizeof(loginfo->prefix) - 1]);
 		return false;
 	}
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
-		DEBUGP("ipt_ULOG: queue threshold %i > MAX_QLEN\n",
-			loginfo->qthreshold);
+		pr_debug("ipt_ULOG: queue threshold %Zu > MAX_QLEN\n",
+			 loginfo->qthreshold);
 		return false;
 	}
 	return true;
@@ -405,7 +398,7 @@ static int __init ipt_ulog_init(void)
 {
 	int ret, i;
 
-	DEBUGP("ipt_ULOG: init module\n");
+	pr_debug("ipt_ULOG: init module\n");
 
 	if (nlbufsiz > 128*1024) {
 		printk("Netlink buffer has to be <= 128kB\n");
@@ -437,7 +430,7 @@ static void __exit ipt_ulog_fini(void)
 	ulog_buff_t *ub;
 	int i;
 
-	DEBUGP("ipt_ULOG: cleanup_module\n");
+	pr_debug("ipt_ULOG: cleanup_module\n");
 
 	if (nflog)
 		nf_log_unregister(&ipt_ulog_logger);
@@ -448,7 +441,7 @@ static void __exit ipt_ulog_fini(void)
 	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
 		if (timer_pending(&ub->timer)) {
-			DEBUGP("timer was pending, deleting\n");
+			pr_debug("timer was pending, deleting\n");
 			del_timer(&ub->timer);
 		}
 
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 6a3a033..0106dc9 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -17,12 +17,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
 MODULE_DESCRIPTION("iptables arbitrary IP range match module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static bool
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -38,12 +32,12 @@ match(const struct sk_buff *skb,
 		if ((ntohl(iph->saddr) < ntohl(info->src.min_ip)
 			  || ntohl(iph->saddr) > ntohl(info->src.max_ip))
 			 ^ !!(info->flags & IPRANGE_SRC_INV)) {
-			DEBUGP("src IP %u.%u.%u.%u NOT in range %s"
-			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
-				NIPQUAD(iph->saddr),
-				info->flags & IPRANGE_SRC_INV ? "(INV) " : "",
-				NIPQUAD(info->src.min_ip),
-				NIPQUAD(info->src.max_ip));
+			pr_debug("src IP %u.%u.%u.%u NOT in range %s"
+				 "%u.%u.%u.%u-%u.%u.%u.%u\n",
+				 NIPQUAD(iph->saddr),
+				 info->flags & IPRANGE_SRC_INV ? "(INV) " : "",
+				 NIPQUAD(info->src.min_ip),
+				 NIPQUAD(info->src.max_ip));
 			return false;
 		}
 	}
@@ -51,12 +45,12 @@ match(const struct sk_buff *skb,
 		if ((ntohl(iph->daddr) < ntohl(info->dst.min_ip)
 			  || ntohl(iph->daddr) > ntohl(info->dst.max_ip))
 			 ^ !!(info->flags & IPRANGE_DST_INV)) {
-			DEBUGP("dst IP %u.%u.%u.%u NOT in range %s"
-			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
-				NIPQUAD(iph->daddr),
-				info->flags & IPRANGE_DST_INV ? "(INV) " : "",
-				NIPQUAD(info->dst.min_ip),
-				NIPQUAD(info->dst.max_ip));
+			pr_debug("dst IP %u.%u.%u.%u NOT in range %s"
+				 "%u.%u.%u.%u-%u.%u.%u.%u\n",
+				 NIPQUAD(iph->daddr),
+				 info->flags & IPRANGE_DST_INV ? "(INV) " : "",
+				 NIPQUAD(info->dst.min_ip),
+				 NIPQUAD(info->dst.max_ip));
 			return false;
 		}
 	}
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index a103f59..3c56299 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -24,12 +24,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -324,13 +318,13 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 
 	/* We only do TCP at the moment: is there a better way? */
 	if (strcmp(sk->sk_prot->name, "TCP")) {
-		DEBUGP("SO_ORIGINAL_DST: Not a TCP socket\n");
+		pr_debug("SO_ORIGINAL_DST: Not a TCP socket\n");
 		return -ENOPROTOOPT;
 	}
 
 	if ((unsigned int) *len < sizeof(struct sockaddr_in)) {
-		DEBUGP("SO_ORIGINAL_DST: len %u not %u\n",
-		       *len, sizeof(struct sockaddr_in));
+		pr_debug("SO_ORIGINAL_DST: len %d not %Zu\n",
+			 *len, sizeof(struct sockaddr_in));
 		return -EINVAL;
 	}
 
@@ -346,17 +340,17 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 			.tuple.dst.u3.ip;
 		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
 
-		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
-		       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
+		pr_debug("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
+			 NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
 		nf_ct_put(ct);
 		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
 			return -EFAULT;
 		else
 			return 0;
 	}
-	DEBUGP("SO_ORIGINAL_DST: Can't find %u.%u.%u.%u/%u-%u.%u.%u.%u/%u.\n",
-	       NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
-	       NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
+	pr_debug("SO_ORIGINAL_DST: Can't find %u.%u.%u.%u/%u-%u.%u.%u.%u/%u.\n",
+		 NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
+		 NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
 	return -ENOENT;
 }
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index ab8e4c6..434e084 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -18,12 +18,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 #ifdef CONFIG_NF_CT_ACCT
 static unsigned int
 seq_print_counters(struct seq_file *s,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 91fb277..0fe8fb0 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -21,12 +21,6 @@
 
 static unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int icmp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct nf_conntrack_tuple *tuple)
@@ -125,8 +119,8 @@ static int icmp_new(struct nf_conn *conntrack,
 	if (conntrack->tuplehash[0].tuple.dst.u.icmp.type >= sizeof(valid_new)
 	    || !valid_new[conntrack->tuplehash[0].tuple.dst.u.icmp.type]) {
 		/* Can't create a new ICMP `conn' with this. */
-		DEBUGP("icmp: can't create new conn with type %u\n",
-		       conntrack->tuplehash[0].tuple.dst.u.icmp.type);
+		pr_debug("icmp: can't create new conn with type %u\n",
+			 conntrack->tuplehash[0].tuple.dst.u.icmp.type);
 		NF_CT_DUMP_TUPLE(&conntrack->tuplehash[0].tuple);
 		return 0;
 	}
@@ -159,8 +153,8 @@ icmp_error_message(struct sk_buff *skb,
 
 	/* Ignore ICMP's containing fragments (shouldn't happen) */
 	if (inside->ip.frag_off & htons(IP_OFFSET)) {
-		DEBUGP("icmp_error_message: fragment of proto %u\n",
-		       inside->ip.protocol);
+		pr_debug("icmp_error_message: fragment of proto %u\n",
+			 inside->ip.protocol);
 		return -NF_ACCEPT;
 	}
 
@@ -172,8 +166,8 @@ icmp_error_message(struct sk_buff *skb,
 	if (!nf_ct_get_tuple(skb, dataoff, dataoff + inside->ip.ihl*4, PF_INET,
 			     inside->ip.protocol, &origtuple,
 			     &nf_conntrack_l3proto_ipv4, innerproto)) {
-		DEBUGP("icmp_error_message: ! get_tuple p=%u",
-		       inside->ip.protocol);
+		pr_debug("icmp_error_message: ! get_tuple p=%u",
+			 inside->ip.protocol);
 		return -NF_ACCEPT;
 	}
 
@@ -181,7 +175,7 @@ icmp_error_message(struct sk_buff *skb,
 	   been preserved inside the ICMP. */
 	if (!nf_ct_invert_tuple(&innertuple, &origtuple,
 				&nf_conntrack_l3proto_ipv4, innerproto)) {
-		DEBUGP("icmp_error_message: no match\n");
+		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
 	}
 
@@ -196,7 +190,7 @@ icmp_error_message(struct sk_buff *skb,
 			h = nf_conntrack_find_get(&origtuple);
 
 		if (!h) {
-			DEBUGP("icmp_error_message: no match\n");
+			pr_debug("icmp_error_message: no match\n");
 			return -NF_ACCEPT;
 		}
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index f242ac6..e848d8d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -31,12 +31,6 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static DEFINE_RWLOCK(nf_nat_lock);
 
 static struct nf_conntrack_l3proto *l3proto = NULL;
@@ -242,7 +236,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	   manips not an issue.  */
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
-			DEBUGP("get_unique_tuple: Found current src map\n");
+			pr_debug("get_unique_tuple: Found current src map\n");
 			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
 				if (!nf_nat_used_tuple(tuple, ct))
 					return;
@@ -293,7 +287,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (!nat) {
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
-			DEBUGP("failed to add NAT extension\n");
+			pr_debug("failed to add NAT extension\n");
 			return NF_ACCEPT;
 		}
 	}
@@ -462,8 +456,9 @@ int nf_nat_icmp_reply_translation(struct nf_conn *ct,
 			return 0;
 	}
 
-	DEBUGP("icmp_reply_translation: translating error %p manp %u dir %s\n",
-	       *pskb, manip, dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
+	pr_debug("icmp_reply_translation: translating error %p manip %u "
+		 "dir %s\n", *pskb, manip,
+		 dir == IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY");
 
 	/* rcu_read_lock()ed by nf_hook_slow */
 	l4proto = __nf_ct_l4proto_find(PF_INET, inside->ip.protocol);
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index cae4b46..3663bd8 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -25,12 +25,6 @@ MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
 MODULE_ALIAS("ip_nat_ftp");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* FIXME: Time out? --RR */
 
 static int
@@ -47,7 +41,7 @@ mangle_rfc959_packet(struct sk_buff **pskb,
 	sprintf(buffer, "%u,%u,%u,%u,%u,%u",
 		NIPQUAD(newip), port>>8, port&0xFF);
 
-	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+	pr_debug("calling nf_nat_mangle_tcp_packet\n");
 
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
@@ -67,7 +61,7 @@ mangle_eprt_packet(struct sk_buff **pskb,
 
 	sprintf(buffer, "|1|%u.%u.%u.%u|%u|", NIPQUAD(newip), port);
 
-	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+	pr_debug("calling nf_nat_mangle_tcp_packet\n");
 
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
@@ -87,7 +81,7 @@ mangle_epsv_packet(struct sk_buff **pskb,
 
 	sprintf(buffer, "|||%u|", port);
 
-	DEBUGP("calling nf_nat_mangle_tcp_packet\n");
+	pr_debug("calling nf_nat_mangle_tcp_packet\n");
 
 	return nf_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,
 					matchlen, buffer, strlen(buffer));
@@ -117,7 +111,7 @@ static unsigned int nf_nat_ftp(struct sk_buff **pskb,
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conn *ct = exp->master;
 
-	DEBUGP("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
+	pr_debug("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
 
 	/* Connection will come from wherever this packet goes, hence !dir */
 	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 3d760dd..c1b059a 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -21,12 +21,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /****************************************************************************/
 static int set_addr(struct sk_buff **pskb,
 		    unsigned char **data, int dataoff,
@@ -126,12 +120,11 @@ static int set_sig_addr(struct sk_buff **pskb, struct nf_conn *ct,
 				    (ntohl(addr.ip) & 0xff000000) == 0x7f000000)
 					i = 0;
 
-				DEBUGP
-				    ("nf_nat_ras: set signal address "
-				     "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-				     NIPQUAD(ip), port,
-				     NIPQUAD(ct->tuplehash[!dir].tuple.dst.
-					     ip), info->sig_port[!dir]);
+				pr_debug("nf_nat_ras: set signal address "
+					 "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+					 NIPQUAD(addr.ip), port,
+					 NIPQUAD(ct->tuplehash[!dir].tuple.dst.u3.ip),
+					 info->sig_port[!dir]);
 				return set_h225_addr(pskb, data, 0, &taddr[i],
 						     &ct->tuplehash[!dir].
 						     tuple.dst.u3,
@@ -139,12 +132,11 @@ static int set_sig_addr(struct sk_buff **pskb, struct nf_conn *ct,
 			} else if (addr.ip == ct->tuplehash[dir].tuple.dst.u3.ip &&
 				   port == info->sig_port[dir]) {
 				/* GK->GW */
-				DEBUGP
-				    ("nf_nat_ras: set signal address "
-				     "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-				     NIPQUAD(ip), port,
-				     NIPQUAD(ct->tuplehash[!dir].tuple.src.
-					     ip), info->sig_port[!dir]);
+				pr_debug("nf_nat_ras: set signal address "
+					 "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+					 NIPQUAD(addr.ip), port,
+					 NIPQUAD(ct->tuplehash[!dir].tuple.src.u3.ip),
+					 info->sig_port[!dir]);
 				return set_h225_addr(pskb, data, 0, &taddr[i],
 						     &ct->tuplehash[!dir].
 						     tuple.src.u3,
@@ -171,12 +163,11 @@ static int set_ras_addr(struct sk_buff **pskb, struct nf_conn *ct,
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
 		    addr.ip == ct->tuplehash[dir].tuple.src.u3.ip &&
 		    port == ct->tuplehash[dir].tuple.src.u.udp.port) {
-			DEBUGP("nf_nat_ras: set rasAddress "
-			       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-			       NIPQUAD(ip), ntohs(port),
-			       NIPQUAD(ct->tuplehash[!dir].tuple.dst.u3.ip),
-			       ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.
-				     port));
+			pr_debug("nf_nat_ras: set rasAddress "
+				 "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+				 NIPQUAD(addr.ip), ntohs(port),
+				 NIPQUAD(ct->tuplehash[!dir].tuple.dst.u3.ip),
+				 ntohs(ct->tuplehash[!dir].tuple.dst.u.udp.port));
 			return set_h225_addr(pskb, data, 0, &taddr[i],
 					     &ct->tuplehash[!dir].tuple.dst.u3,
 					     ct->tuplehash[!dir].tuple.
@@ -267,16 +258,16 @@ static int nat_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	DEBUGP("nf_nat_h323: expect RTP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(rtp_exp->tuple.src.ip),
-	       ntohs(rtp_exp->tuple.src.u.udp.port),
-	       NIPQUAD(rtp_exp->tuple.dst.ip),
-	       ntohs(rtp_exp->tuple.dst.u.udp.port));
-	DEBUGP("nf_nat_h323: expect RTCP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(rtcp_exp->tuple.src.ip),
-	       ntohs(rtcp_exp->tuple.src.u.udp.port),
-	       NIPQUAD(rtcp_exp->tuple.dst.ip),
-	       ntohs(rtcp_exp->tuple.dst.u.udp.port));
+	pr_debug("nf_nat_h323: expect RTP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(rtp_exp->tuple.src.u3.ip),
+		 ntohs(rtp_exp->tuple.src.u.udp.port),
+		 NIPQUAD(rtp_exp->tuple.dst.u3.ip),
+		 ntohs(rtp_exp->tuple.dst.u.udp.port));
+	pr_debug("nf_nat_h323: expect RTCP %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(rtcp_exp->tuple.src.u3.ip),
+		 ntohs(rtcp_exp->tuple.src.u.udp.port),
+		 NIPQUAD(rtcp_exp->tuple.dst.u3.ip),
+		 ntohs(rtcp_exp->tuple.dst.u.udp.port));
 
 	return 0;
 }
@@ -317,9 +308,11 @@ static int nat_t120(struct sk_buff **pskb, struct nf_conn *ct,
 		return -1;
 	}
 
-	DEBUGP("nf_nat_h323: expect T.120 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),
-	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));
+	pr_debug("nf_nat_h323: expect T.120 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(exp->tuple.src.u3.ip),
+		 ntohs(exp->tuple.src.u.tcp.port),
+		 NIPQUAD(exp->tuple.dst.u3.ip),
+		 ntohs(exp->tuple.dst.u.tcp.port));
 
 	return 0;
 }
@@ -369,9 +362,11 @@ static int nat_h245(struct sk_buff **pskb, struct nf_conn *ct,
 		return -1;
 	}
 
-	DEBUGP("nf_nat_q931: expect H.245 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),
-	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));
+	pr_debug("nf_nat_q931: expect H.245 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(exp->tuple.src.u3.ip),
+		 ntohs(exp->tuple.src.u.tcp.port),
+		 NIPQUAD(exp->tuple.dst.u3.ip),
+		 ntohs(exp->tuple.dst.u.tcp.port));
 
 	return 0;
 }
@@ -465,9 +460,11 @@ static int nat_q931(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	DEBUGP("nf_nat_ras: expect Q.931 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),
-	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));
+	pr_debug("nf_nat_ras: expect Q.931 %u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(exp->tuple.src.u3.ip),
+		 ntohs(exp->tuple.src.u.tcp.port),
+		 NIPQUAD(exp->tuple.dst.u3.ip),
+		 ntohs(exp->tuple.dst.u.tcp.port));
 
 	return 0;
 }
@@ -536,10 +533,12 @@ static int nat_callforwarding(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	/* Success */
-	DEBUGP("nf_nat_q931: expect Call Forwarding "
-	       "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
-	       NIPQUAD(exp->tuple.src.ip), ntohs(exp->tuple.src.u.tcp.port),
-	       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.tcp.port));
+	pr_debug("nf_nat_q931: expect Call Forwarding "
+		 "%u.%u.%u.%u:%hu->%u.%u.%u.%u:%hu\n",
+		 NIPQUAD(exp->tuple.src.u3.ip),
+		 ntohs(exp->tuple.src.u.tcp.port),
+		 NIPQUAD(exp->tuple.dst.u3.ip),
+		 ntohs(exp->tuple.dst.u.tcp.port));
 
 	return 0;
 }
@@ -566,8 +565,6 @@ static int __init init(void)
 	rcu_assign_pointer(nat_h245_hook, nat_h245);
 	rcu_assign_pointer(nat_callforwarding_hook, nat_callforwarding);
 	rcu_assign_pointer(nat_q931_hook, nat_q931);
-
-	DEBUGP("nf_nat_h323: init success\n");
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index f3383fc..93d8a0a 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -26,13 +26,9 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 
-#if 0
-#define DEBUGP printk
-#define DUMP_OFFSET(x)	printk("offset_before=%d, offset_after=%d, correction_pos=%u\n", x->offset_before, x->offset_after, x->correction_pos);
-#else
-#define DEBUGP(format, args...)
-#define DUMP_OFFSET(x)
-#endif
+#define DUMP_OFFSET(x) \
+	pr_debug("offset_before=%d, offset_after=%d, correction_pos=%u\n", \
+		 x->offset_before, x->offset_after, x->correction_pos);
 
 static DEFINE_SPINLOCK(nf_nat_seqofs_lock);
 
@@ -47,15 +43,15 @@ adjust_tcp_sequence(u32 seq,
 	struct nf_nat_seq *this_way, *other_way;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 
-	DEBUGP("nf_nat_resize_packet: old_size = %u, new_size = %u\n",
-		(*skb)->len, new_size);
+	pr_debug("adjust_tcp_sequence: seq = %u, sizediff = %d\n",
+		 ntohl(seq), seq);
 
 	dir = CTINFO2DIR(ctinfo);
 
 	this_way = &nat->seq[dir];
 	other_way = &nat->seq[!dir];
 
-	DEBUGP("nf_nat_resize_packet: Seq_offset before: ");
+	pr_debug("nf_nat_resize_packet: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
 
 	spin_lock_bh(&nf_nat_seqofs_lock);
@@ -72,7 +68,7 @@ adjust_tcp_sequence(u32 seq,
 	}
 	spin_unlock_bh(&nf_nat_seqofs_lock);
 
-	DEBUGP("nf_nat_resize_packet: Seq_offset after: ");
+	pr_debug("nf_nat_resize_packet: Seq_offset after: ");
 	DUMP_OFFSET(this_way);
 }
 
@@ -100,14 +96,12 @@ static void mangle_contents(struct sk_buff *skb,
 
 	/* update skb info */
 	if (rep_len > match_len) {
-		DEBUGP("nf_nat_mangle_packet: Extending packet by "
-		       "%u from %u bytes\n", rep_len - match_len,
-		       skb->len);
+		pr_debug("nf_nat_mangle_packet: Extending packet by "
+			 "%u from %u bytes\n", rep_len - match_len, skb->len);
 		skb_put(skb, rep_len - match_len);
 	} else {
-		DEBUGP("nf_nat_mangle_packet: Shrinking packet from "
-		       "%u from %u bytes\n", match_len - rep_len,
-		       skb->len);
+		pr_debug("nf_nat_mangle_packet: Shrinking packet from "
+			 "%u from %u bytes\n", match_len - rep_len, skb->len);
 		__skb_trim(skb, skb->len + rep_len - match_len);
 	}
 
@@ -320,9 +314,9 @@ sack_adjust(struct sk_buff *skb,
 			new_end_seq = htonl(ntohl(sack->end_seq)
 				      - natseq->offset_before);
 
-		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
-			ntohl(sack->start_seq), new_start_seq,
-			ntohl(sack->end_seq), new_end_seq);
+		pr_debug("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
+			 ntohl(sack->start_seq), new_start_seq,
+			 ntohl(sack->end_seq), new_end_seq);
 
 		nf_proto_csum_replace4(&tcph->check, skb,
 				       sack->start_seq, new_start_seq, 0);
@@ -414,9 +408,9 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 	nf_proto_csum_replace4(&tcph->check, *pskb, tcph->seq, newseq, 0);
 	nf_proto_csum_replace4(&tcph->check, *pskb, tcph->ack_seq, newack, 0);
 
-	DEBUGP("Adjusting sequence number from %u->%u, ack from %u->%u\n",
-		ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
-		ntohl(newack));
+	pr_debug("Adjusting sequence number from %u->%u, ack from %u->%u\n",
+		 ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
+		 ntohl(newack));
 
 	tcph->seq = newseq;
 	tcph->ack_seq = newack;
diff --git a/net/ipv4/netfilter/nf_nat_irc.c b/net/ipv4/netfilter/nf_nat_irc.c
index db7fbf6..bcf274b 100644
--- a/net/ipv4/netfilter/nf_nat_irc.c
+++ b/net/ipv4/netfilter/nf_nat_irc.c
@@ -22,12 +22,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_irc.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
@@ -44,9 +38,6 @@ static unsigned int help(struct sk_buff **pskb,
 	u_int16_t port;
 	unsigned int ret;
 
-	DEBUGP("IRC_NAT: info (seq %u + %u) in %u\n",
-	       expect->seq, exp_irc_info->len, ntohl(tcph->seq));
-
 	/* Reply comes from server. */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
@@ -64,8 +55,8 @@ static unsigned int help(struct sk_buff **pskb,
 
 	ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
 	sprintf(buffer, "%u %u", ip, port);
-	DEBUGP("nf_nat_irc: inserting '%s' == %u.%u.%u.%u, port %u\n",
-	       buffer, NIPQUAD(ip), port);
+	pr_debug("nf_nat_irc: inserting '%s' == %u.%u.%u.%u, port %u\n",
+		 buffer, NIPQUAD(ip), port);
 
 	ret = nf_nat_mangle_tcp_packet(pskb, exp->master, ctinfo,
 				       matchoff, matchlen, buffer,
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index deb80ae..984ec83 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -37,14 +37,6 @@ MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
 MODULE_ALIAS("ip_nat_pptp");
 
-#if 0
-extern const char *pptp_msg_name[];
-#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, \
-				       __FUNCTION__, ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static void pptp_nat_expected(struct nf_conn *ct,
 			      struct nf_conntrack_expect *exp)
 {
@@ -60,7 +52,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	/* And here goes the grand finale of corrosion... */
 	if (exp->dir == IP_CT_DIR_ORIGINAL) {
-		DEBUGP("we are PNS->PAC\n");
+		pr_debug("we are PNS->PAC\n");
 		/* therefore, build tuple for PAC->PNS */
 		t.src.l3num = AF_INET;
 		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
@@ -69,7 +61,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		t.dst.u.gre.key = ct_pptp_info->pns_call_id;
 		t.dst.protonum = IPPROTO_GRE;
 	} else {
-		DEBUGP("we are PAC->PNS\n");
+		pr_debug("we are PAC->PNS\n");
 		/* build tuple for PNS->PAC */
 		t.src.l3num = AF_INET;
 		t.src.u3.ip = master->tuplehash[!exp->dir].tuple.src.u3.ip;
@@ -79,15 +71,15 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		t.dst.protonum = IPPROTO_GRE;
 	}
 
-	DEBUGP("trying to unexpect other dir: ");
+	pr_debug("trying to unexpect other dir: ");
 	NF_CT_DUMP_TUPLE(&t);
 	other_exp = nf_ct_expect_find_get(&t);
 	if (other_exp) {
 		nf_ct_unexpect_related(other_exp);
 		nf_ct_expect_put(other_exp);
-		DEBUGP("success\n");
+		pr_debug("success\n");
 	} else {
-		DEBUGP("not found!\n");
+		pr_debug("not found!\n");
 	}
 
 	/* This must be a fresh one. */
@@ -161,9 +153,9 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		cid_off = offsetof(union pptp_ctrl_union, clrreq.callID);
 		break;
 	default:
-		DEBUGP("unknown outbound packet 0x%04x:%s\n", msg,
-		      (msg <= PPTP_MSG_MAX)?
-		      pptp_msg_name[msg]:pptp_msg_name[0]);
+		pr_debug("unknown outbound packet 0x%04x:%s\n", msg,
+			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
+					       pptp_msg_name[0]);
 		/* fall through */
 	case PPTP_SET_LINK_INFO:
 		/* only need to NAT in case PAC is behind NAT box */
@@ -179,8 +171,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 
 	/* only OUT_CALL_REQUEST, IN_CALL_REPLY, CALL_CLEAR_REQUEST pass
 	 * down to here */
-	DEBUGP("altering call id from 0x%04x to 0x%04x\n",
-		ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
+	pr_debug("altering call id from 0x%04x to 0x%04x\n",
+		 ntohs(REQ_CID(pptpReq, cid_off)), ntohs(new_callid));
 
 	/* mangle packet */
 	if (nf_nat_mangle_tcp_packet(pskb, ct, ctinfo,
@@ -255,8 +247,9 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		pcid_off = offsetof(union pptp_ctrl_union, setlink.peersCallID);
 		break;
 	default:
-		DEBUGP("unknown inbound packet %s\n", (msg <= PPTP_MSG_MAX)?
-			pptp_msg_name[msg]:pptp_msg_name[0]);
+		pr_debug("unknown inbound packet %s\n",
+			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
+					       pptp_msg_name[0]);
 		/* fall through */
 	case PPTP_START_SESSION_REQUEST:
 	case PPTP_START_SESSION_REPLY:
@@ -272,8 +265,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	 * WAN_ERROR_NOTIFY, CALL_DISCONNECT_NOTIFY pass down here */
 
 	/* mangle packet */
-	DEBUGP("altering peer call id from 0x%04x to 0x%04x\n",
-		ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
+	pr_debug("altering peer call id from 0x%04x to 0x%04x\n",
+		 ntohs(REQ_CID(pptpReq, pcid_off)), ntohs(new_pcid));
 
 	if (nf_nat_mangle_tcp_packet(pskb, ct, ctinfo,
 				     pcid_off + sizeof(struct pptp_pkt_hdr) +
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index c3908bc..2e40cc8 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -36,13 +36,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 
-#if 0
-#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, \
-				       __FUNCTION__, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
-
 /* is key in given range between min and max */
 static int
 gre_in_range(const struct nf_conntrack_tuple *tuple,
@@ -83,7 +76,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		keyptr = &tuple->dst.u.gre.key;
 
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
-		DEBUGP("%p: NATing GRE PPTP\n", conntrack);
+		pr_debug("%p: NATing GRE PPTP\n", conntrack);
 		min = 1;
 		range_size = 0xffff;
 	} else {
@@ -91,7 +84,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		range_size = ntohs(range->max.gre.key) - min + 1;
 	}
 
-	DEBUGP("min = %u, range_size = %u\n", min, range_size);
+	pr_debug("min = %u, range_size = %u\n", min, range_size);
 
 	for (i = 0; i < range_size; i++, key++) {
 		*keyptr = htons(min + key % range_size);
@@ -99,7 +92,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 			return 1;
 	}
 
-	DEBUGP("%p: no NAT mapping\n", conntrack);
+	pr_debug("%p: no NAT mapping\n", conntrack);
 	return 0;
 }
 
@@ -132,11 +125,11 @@ gre_manip_pkt(struct sk_buff **pskb, unsigned int iphdroff,
 		 * Try to behave like "nf_nat_proto_unknown" */
 		break;
 	case GRE_VERSION_PPTP:
-		DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
+		pr_debug("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
 		pgreh->call_id = tuple->dst.u.gre.key;
 		break;
 	default:
-		DEBUGP("can't nat unknown GRE version\n");
+		pr_debug("can't nat unknown GRE version\n");
 		return 0;
 	}
 	return 1;
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 080393a..0f45427 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -24,12 +24,6 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_rule.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 #define NAT_VALID_HOOKS ((1<<NF_IP_PRE_ROUTING) | (1<<NF_IP_POST_ROUTING) | (1<<NF_IP_LOCAL_OUT))
 
 static struct
@@ -186,8 +180,8 @@ alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 	struct nf_nat_range range
 		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
 
-	DEBUGP("Allocating NULL binding for %p (%u.%u.%u.%u)\n",
-	       ct, NIPQUAD(ip));
+	pr_debug("Allocating NULL binding for %p (%u.%u.%u.%u)\n",
+		 ct, NIPQUAD(ip));
 	return nf_nat_setup_info(ct, &range, hooknum);
 }
 
@@ -205,8 +199,8 @@ alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum)
 	struct nf_nat_range range
 		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { all }, { all } };
 
-	DEBUGP("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
-	       ct, NIPQUAD(ip));
+	pr_debug("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
+		 ct, NIPQUAD(ip));
 	return nf_nat_setup_info(ct, &range, hooknum);
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 940cdfc..a889ec3 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -26,12 +26,6 @@ MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
 MODULE_ALIAS("ip_nat_sip");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 struct addr_map {
 	struct {
 		char		src[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
@@ -257,8 +251,6 @@ static unsigned int ip_nat_sdp(struct sk_buff **pskb,
 	__be32 newip;
 	u_int16_t port;
 
-	DEBUGP("ip_nat_sdp():\n");
-
 	/* Connection will come from reply */
 	if (ct->tuplehash[dir].tuple.src.u3.ip ==
 	    ct->tuplehash[!dir].tuple.dst.u3.ip)
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 30eeaa4..332814d 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -27,12 +27,6 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
@@ -117,7 +111,7 @@ nf_nat_fn(unsigned int hooknum,
 	if (!nat) {
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
-			DEBUGP("failed to add NAT extension\n");
+			pr_debug("failed to add NAT extension\n");
 			return NF_ACCEPT;
 		}
 	}
@@ -154,9 +148,9 @@ nf_nat_fn(unsigned int hooknum,
 				return ret;
 			}
 		} else
-			DEBUGP("Already setup manip %s for ct %p\n",
-			       maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
-			       ct);
+			pr_debug("Already setup manip %s for ct %p\n",
+				 maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
+				 ct);
 		break;
 
 	default:
@@ -270,7 +264,7 @@ nf_nat_adjust(unsigned int hooknum,
 
 	ct = nf_ct_get(*pskb, &ctinfo);
 	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
-		DEBUGP("nf_nat_standalone: adjusting sequence number\n");
+		pr_debug("nf_nat_standalone: adjusting sequence number\n");
 		if (!nf_nat_seq_adjust(pskb, ct, ctinfo))
 			return NF_DROP;
 	}
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 540bf14..b05327e 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -32,12 +32,6 @@ struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Use lock to serialize, so printks don't overlap */
 static DEFINE_SPINLOCK(log_lock);
 
@@ -466,12 +460,12 @@ static bool ip6t_log_checkentry(const char *tablename,
 	const struct ip6t_log_info *loginfo = targinfo;
 
 	if (loginfo->level >= 8) {
-		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
+		pr_debug("LOG: level %u >= 8\n", loginfo->level);
 		return false;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
-		DEBUGP("LOG: prefix term %i\n",
-		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
+		pr_debug("LOG: prefix term %i\n",
+			 loginfo->prefix[sizeof(loginfo->prefix)-1]);
 		return false;
 	}
 	return true;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 14008dc..2f487cd 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -34,12 +34,6 @@ MODULE_AUTHOR("Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
 MODULE_DESCRIPTION("IP6 tables REJECT target module");
 MODULE_LICENSE("GPL");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb)
 {
@@ -54,7 +48,7 @@ static void send_reset(struct sk_buff *oldskb)
 
 	if ((!(ipv6_addr_type(&oip6h->saddr) & IPV6_ADDR_UNICAST)) ||
 	    (!(ipv6_addr_type(&oip6h->daddr) & IPV6_ADDR_UNICAST))) {
-		DEBUGP("ip6t_REJECT: addr is not unicast.\n");
+		pr_debug("ip6t_REJECT: addr is not unicast.\n");
 		return;
 	}
 
@@ -62,7 +56,7 @@ static void send_reset(struct sk_buff *oldskb)
 	tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data), &proto);
 
 	if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
-		DEBUGP("ip6t_REJECT: Can't get TCP header.\n");
+		pr_debug("ip6t_REJECT: Can't get TCP header.\n");
 		return;
 	}
 
@@ -70,8 +64,9 @@ static void send_reset(struct sk_buff *oldskb)
 
 	/* IP header checks: fragment, too short. */
 	if (proto != IPPROTO_TCP || otcplen < sizeof(struct tcphdr)) {
-		DEBUGP("ip6t_REJECT: proto(%d) != IPPROTO_TCP, or too short. otcplen = %d\n",
-			proto, otcplen);
+		pr_debug("ip6t_REJECT: proto(%d) != IPPROTO_TCP, "
+			 "or too short. otcplen = %d\n",
+			 proto, otcplen);
 		return;
 	}
 
@@ -80,14 +75,14 @@ static void send_reset(struct sk_buff *oldskb)
 
 	/* No RST for RST. */
 	if (otcph.rst) {
-		DEBUGP("ip6t_REJECT: RST is set\n");
+		pr_debug("ip6t_REJECT: RST is set\n");
 		return;
 	}
 
 	/* Check checksum. */
 	if (csum_ipv6_magic(&oip6h->saddr, &oip6h->daddr, otcplen, IPPROTO_TCP,
 			    skb_checksum(oldskb, tcphoff, otcplen, 0))) {
-		DEBUGP("ip6t_REJECT: TCP checksum is invalid\n");
+		pr_debug("ip6t_REJECT: TCP checksum is invalid\n");
 		return;
 	}
 
@@ -186,7 +181,7 @@ static unsigned int reject6_target(struct sk_buff **pskb,
 {
 	const struct ip6t_reject_info *reject = targinfo;
 
-	DEBUGP(KERN_DEBUG "%s: medium point\n", __FUNCTION__);
+	pr_debug("%s: medium point\n", __FUNCTION__);
 	/* WARNING: This code causes reentry within ip6tables.
 	   This means that the ip6tables jump stack is now crap.  We
 	   must return an absolute verdict. --RR */
@@ -237,7 +232,7 @@ static bool check(const char *tablename,
 		/* Must specify that it's a TCP packet */
 		if (e->ipv6.proto != IPPROTO_TCP
 		    || (e->ipv6.invflags & XT_INV_PROTO)) {
-			DEBUGP("ip6t_REJECT: TCP_RESET illegal for non-tcp\n");
+			printk("ip6t_REJECT: TCP_RESET illegal for non-tcp\n");
 			return false;
 		}
 	}
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index a9fe2aa..2a25fe2 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -23,21 +23,16 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IPv6 AH match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline bool
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 {
 	bool r;
-	DEBUGP("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-	       min,spi,max);
+
+	pr_debug("ah spi_match:%c 0x%x <= 0x%x <= 0x%x",
+		 invert ? '!' : ' ', min, spi, max);
 	r = (spi >= min && spi <= max) ^ invert;
-	DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
+	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -73,22 +68,22 @@ match(const struct sk_buff *skb,
 
 	hdrlen = (ah->hdrlen + 2) << 2;
 
-	DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
-	DEBUGP("RES %04X ", ah->reserved);
-	DEBUGP("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
-
-	DEBUGP("IPv6 AH spi %02X ",
-	       spi_match(ahinfo->spis[0], ahinfo->spis[1],
-			 ntohl(ah->spi),
-			 !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
-	DEBUGP("len %02X %04X %02X ",
-	       ahinfo->hdrlen, hdrlen,
-	       (!ahinfo->hdrlen ||
-		(ahinfo->hdrlen == hdrlen) ^
-		!!(ahinfo->invflags & IP6T_AH_INV_LEN)));
-	DEBUGP("res %02X %04X %02X\n",
-	       ahinfo->hdrres, ah->reserved,
-	       !(ahinfo->hdrres && ah->reserved));
+	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
+	pr_debug("RES %04X ", ah->reserved);
+	pr_debug("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
+
+	pr_debug("IPv6 AH spi %02X ",
+		 spi_match(ahinfo->spis[0], ahinfo->spis[1],
+			   ntohl(ah->spi),
+			   !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
+	pr_debug("len %02X %04X %02X ",
+		 ahinfo->hdrlen, hdrlen,
+		 (!ahinfo->hdrlen ||
+		  (ahinfo->hdrlen == hdrlen) ^
+		  !!(ahinfo->invflags & IP6T_AH_INV_LEN)));
+	pr_debug("res %02X %04X %02X\n",
+		 ahinfo->hdrres, ah->reserved,
+		 !(ahinfo->hdrres && ah->reserved));
 
 	return (ah != NULL)
 	       &&
@@ -114,7 +109,7 @@ checkentry(const char *tablename,
 	const struct ip6t_ah *ahinfo = matchinfo;
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
-		DEBUGP("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
+		pr_debug("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
 		return false;
 	}
 	return true;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index bb1cfa8..968aeba 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -22,21 +22,15 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IPv6 FRAG match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline bool
 id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
 	bool r;
-	DEBUGP("frag id_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
-	       min, id, max);
+	pr_debug("frag id_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
+		 min, id, max);
 	r = (id >= min && id <= max) ^ invert;
-	DEBUGP(" result %s\n", r ? "PASS" : "FAILED");
+	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -69,37 +63,37 @@ match(const struct sk_buff *skb,
 		return false;
 	}
 
-	DEBUGP("INFO %04X ", fh->frag_off);
-	DEBUGP("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
-	DEBUGP("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
-	DEBUGP("MF %04X ", fh->frag_off & htons(IP6_MF));
-	DEBUGP("ID %u %08X\n", ntohl(fh->identification),
-	       ntohl(fh->identification));
-
-	DEBUGP("IPv6 FRAG id %02X ",
-	       id_match(fraginfo->ids[0], fraginfo->ids[1],
-			 ntohl(fh->identification),
-			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)));
-	DEBUGP("res %02X %02X%04X %02X ",
-	       fraginfo->flags & IP6T_FRAG_RES, fh->reserved,
-	       ntohs(fh->frag_off) & 0x6,
-	       !((fraginfo->flags & IP6T_FRAG_RES)
-		 && (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
-	DEBUGP("first %02X %02X %02X ",
-	       fraginfo->flags & IP6T_FRAG_FST,
-	       ntohs(fh->frag_off) & ~0x7,
-	       !((fraginfo->flags & IP6T_FRAG_FST)
-		 && (ntohs(fh->frag_off) & ~0x7)));
-	DEBUGP("mf %02X %02X %02X ",
-	       fraginfo->flags & IP6T_FRAG_MF,
-	       ntohs(fh->frag_off) & IP6_MF,
-	       !((fraginfo->flags & IP6T_FRAG_MF)
-		 && !((ntohs(fh->frag_off) & IP6_MF))));
-	DEBUGP("last %02X %02X %02X\n",
-	       fraginfo->flags & IP6T_FRAG_NMF,
-	       ntohs(fh->frag_off) & IP6_MF,
-	       !((fraginfo->flags & IP6T_FRAG_NMF)
-		 && (ntohs(fh->frag_off) & IP6_MF)));
+	pr_debug("INFO %04X ", fh->frag_off);
+	pr_debug("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
+	pr_debug("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
+	pr_debug("MF %04X ", fh->frag_off & htons(IP6_MF));
+	pr_debug("ID %u %08X\n", ntohl(fh->identification),
+		 ntohl(fh->identification));
+
+	pr_debug("IPv6 FRAG id %02X ",
+		 id_match(fraginfo->ids[0], fraginfo->ids[1],
+			  ntohl(fh->identification),
+			  !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)));
+	pr_debug("res %02X %02X%04X %02X ",
+		 fraginfo->flags & IP6T_FRAG_RES, fh->reserved,
+		 ntohs(fh->frag_off) & 0x6,
+		 !((fraginfo->flags & IP6T_FRAG_RES)
+		   && (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
+	pr_debug("first %02X %02X %02X ",
+		 fraginfo->flags & IP6T_FRAG_FST,
+		 ntohs(fh->frag_off) & ~0x7,
+		 !((fraginfo->flags & IP6T_FRAG_FST)
+		   && (ntohs(fh->frag_off) & ~0x7)));
+	pr_debug("mf %02X %02X %02X ",
+		 fraginfo->flags & IP6T_FRAG_MF,
+		 ntohs(fh->frag_off) & IP6_MF,
+		 !((fraginfo->flags & IP6T_FRAG_MF)
+		   && !((ntohs(fh->frag_off) & IP6_MF))));
+	pr_debug("last %02X %02X %02X\n",
+		 fraginfo->flags & IP6T_FRAG_NMF,
+		 ntohs(fh->frag_off) & IP6_MF,
+		 !((fraginfo->flags & IP6T_FRAG_NMF)
+		   && (ntohs(fh->frag_off) & IP6_MF)));
 
 	return (fh != NULL)
 	       &&
@@ -131,7 +125,7 @@ checkentry(const char *tablename,
 	const struct ip6t_frag *fraginfo = matchinfo;
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
-		DEBUGP("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
+		pr_debug("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
 		return false;
 	}
 	return true;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6247d4c..e6ca601 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -25,12 +25,6 @@ MODULE_DESCRIPTION("IPv6 opts match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 MODULE_ALIAS("ip6t_dst");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /*
  *  (Type & 0xC0) >> 6
  *	0	-> ignorable
@@ -90,13 +84,13 @@ match(const struct sk_buff *skb,
 		return false;
 	}
 
-	DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
+	pr_debug("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
 
-	DEBUGP("len %02X %04X %02X ",
-	       optinfo->hdrlen, hdrlen,
-	       (!(optinfo->flags & IP6T_OPTS_LEN) ||
-		((optinfo->hdrlen == hdrlen) ^
-		 !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
+	pr_debug("len %02X %04X %02X ",
+		 optinfo->hdrlen, hdrlen,
+		 (!(optinfo->flags & IP6T_OPTS_LEN) ||
+		  ((optinfo->hdrlen == hdrlen) ^
+		   !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
 
 	ret = (oh != NULL) &&
 	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
@@ -108,10 +102,10 @@ match(const struct sk_buff *skb,
 	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
 		return ret;
 	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
-		DEBUGP("Not strict - not implemented");
+		pr_debug("Not strict - not implemented");
 	} else {
-		DEBUGP("Strict ");
-		DEBUGP("#%d ", optinfo->optsnr);
+		pr_debug("Strict ");
+		pr_debug("#%d ", optinfo->optsnr);
 		for (temp = 0; temp < optinfo->optsnr; temp++) {
 			/* type field exists ? */
 			if (hdrlen < 1)
@@ -123,12 +117,11 @@ match(const struct sk_buff *skb,
 
 			/* Type check */
 			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
-				DEBUGP("Tbad %02X %02X\n",
-				       *tp,
-				       (optinfo->opts[temp] & 0xFF00) >> 8);
+				pr_debug("Tbad %02X %02X\n", *tp,
+					 (optinfo->opts[temp] & 0xFF00) >> 8);
 				return false;
 			} else {
-				DEBUGP("Tok ");
+				pr_debug("Tok ");
 			}
 			/* Length check */
 			if (*tp) {
@@ -145,23 +138,23 @@ match(const struct sk_buff *skb,
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
 				if (spec_len != 0x00FF && spec_len != *lp) {
-					DEBUGP("Lbad %02X %04X\n", *lp,
-					       spec_len);
+					pr_debug("Lbad %02X %04X\n", *lp,
+						 spec_len);
 					return false;
 				}
-				DEBUGP("Lok ");
+				pr_debug("Lok ");
 				optlen = *lp + 2;
 			} else {
-				DEBUGP("Pad1\n");
+				pr_debug("Pad1\n");
 				optlen = 1;
 			}
 
 			/* Step to the next */
-			DEBUGP("len%04X \n", optlen);
+			pr_debug("len%04X \n", optlen);
 
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
 			    temp < optinfo->optsnr - 1) {
-				DEBUGP("new pointer is too large! \n");
+				pr_debug("new pointer is too large! \n");
 				break;
 			}
 			ptr += optlen;
@@ -187,7 +180,7 @@ checkentry(const char *tablename,
 	const struct ip6t_opts *optsinfo = matchinfo;
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
-		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
+		pr_debug("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
 		return false;
 	}
 	return true;
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 549deea..357cea7 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -24,21 +24,15 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IPv6 RT match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
 	bool r;
-	DEBUGP("rt segsleft_match:%c 0x%x <= 0x%x <= 0x%x",
-	       invert ? '!' : ' ', min, id, max);
+	pr_debug("rt segsleft_match:%c 0x%x <= 0x%x <= 0x%x",
+		 invert ? '!' : ' ', min, id, max);
 	r = (id >= min && id <= max) ^ invert;
-	DEBUGP(" result %s\n", r ? "PASS" : "FAILED");
+	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
 	return r;
 }
 
@@ -82,29 +76,29 @@ match(const struct sk_buff *skb,
 		return false;
 	}
 
-	DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	DEBUGP("TYPE %04X ", rh->type);
-	DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-	DEBUGP("IPv6 RT segsleft %02X ",
-	       segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-			      rh->segments_left,
-			      !!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	DEBUGP("type %02X %02X %02X ",
-	       rtinfo->rt_type, rh->type,
-	       (!(rtinfo->flags & IP6T_RT_TYP) ||
-		((rtinfo->rt_type == rh->type) ^
-		 !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	DEBUGP("len %02X %04X %02X ",
-	       rtinfo->hdrlen, hdrlen,
-	       !(rtinfo->flags & IP6T_RT_LEN) ||
-		((rtinfo->hdrlen == hdrlen) ^
-		 !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	DEBUGP("res %02X %02X %02X ",
-	       rtinfo->flags & IP6T_RT_RES,
-	       ((const struct rt0_hdr *)rh)->reserved,
-	       !((rtinfo->flags & IP6T_RT_RES) &&
-		 (((const struct rt0_hdr *)rh)->reserved)));
+	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
+	pr_debug("TYPE %04X ", rh->type);
+	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
+
+	pr_debug("IPv6 RT segsleft %02X ",
+		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+				rh->segments_left,
+				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
+	pr_debug("type %02X %02X %02X ",
+		 rtinfo->rt_type, rh->type,
+		 (!(rtinfo->flags & IP6T_RT_TYP) ||
+		  ((rtinfo->rt_type == rh->type) ^
+		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
+	pr_debug("len %02X %04X %02X ",
+		 rtinfo->hdrlen, hdrlen,
+		 !(rtinfo->flags & IP6T_RT_LEN) ||
+		  ((rtinfo->hdrlen == hdrlen) ^
+		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
+	pr_debug("res %02X %02X %02X ",
+		 rtinfo->flags & IP6T_RT_RES,
+		 ((const struct rt0_hdr *)rh)->reserved,
+		 !((rtinfo->flags & IP6T_RT_RES) &&
+		   (((const struct rt0_hdr *)rh)->reserved)));
 
 	ret = (rh != NULL)
 	      &&
@@ -131,18 +125,18 @@ match(const struct sk_buff *skb,
 		ret = (*rp == 0);
 	}
 
-	DEBUGP("#%d ", rtinfo->addrnr);
+	pr_debug("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		DEBUGP("Not strict ");
+		pr_debug("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			DEBUGP("There isn't enough space\n");
+			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			DEBUGP("#%d ", rtinfo->addrnr);
+			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -156,25 +150,25 @@ match(const struct sk_buff *skb,
 				BUG_ON(ap == NULL);
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					DEBUGP("i=%d temp=%d;\n", i, temp);
+					pr_debug("i=%d temp=%d;\n", i, temp);
 					i++;
 				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			DEBUGP("i=%d #%d\n", i, rtinfo->addrnr);
+			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		DEBUGP("Strict ");
+		pr_debug("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			DEBUGP("There isn't enough space\n");
+			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
-			DEBUGP("#%d ", rtinfo->addrnr);
+			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -187,7 +181,7 @@ match(const struct sk_buff *skb,
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			DEBUGP("temp=%d #%d\n", temp, rtinfo->addrnr);
+			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
@@ -210,14 +204,14 @@ checkentry(const char *tablename,
 	const struct ip6t_rt *rtinfo = matchinfo;
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
-		DEBUGP("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
+		pr_debug("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
 		return false;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
-		DEBUGP("`--rt-type 0' required before `--rt-0-*'");
+		pr_debug("`--rt-type 0' required before `--rt-0-*'");
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index f2d2649..f0a9efa 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -21,12 +21,6 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_IP6_LOCAL_OUT) | \
 			    (1 << NF_IP6_POST_ROUTING))
 
-#if 0
-#define DEBUGP(x, args...)	printk(KERN_DEBUG x, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
-
 static struct
 {
 	struct ip6t_replace repl;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 0acda45..ec290e4 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -8,12 +8,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_OUT))
 
-#if 0
-#define DEBUGP(x, args...)	printk(KERN_DEBUG x, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
-
 static struct
 {
 	struct ip6t_replace repl;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 747b01e..89e20ab 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -26,12 +26,6 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -136,7 +130,7 @@ ipv6_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
 	 * except of IPv6 & ext headers. but it's tracked anyway. - YK
 	 */
 	if ((protoff < 0) || (protoff > (*pskb)->len)) {
-		DEBUGP("ip6_conntrack_core: can't find proto in pkt\n");
+		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
 		NF_CT_STAT_INC_ATOMIC(error);
 		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -NF_ACCEPT;
@@ -178,7 +172,7 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 	protoff = nf_ct_ipv6_skip_exthdr(*pskb, extoff, &pnum,
 					 (*pskb)->len - extoff);
 	if (protoff > (*pskb)->len || pnum == NEXTHDR_FRAGMENT) {
-		DEBUGP("proto header not found\n");
+		pr_debug("proto header not found\n");
 		return NF_ACCEPT;
 	}
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index a514661..9defc7e 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -27,12 +27,6 @@
 
 static unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 			       unsigned int dataoff,
 			       struct nf_conntrack_tuple *tuple)
@@ -125,8 +119,8 @@ static int icmpv6_new(struct nf_conn *conntrack,
 
 	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
 		/* Can't create a new ICMPv6 `conn' with this. */
-		DEBUGP("icmpv6: can't create new conn with type %u\n",
-		       type + 128);
+		pr_debug("icmpv6: can't create new conn with type %u\n",
+			 type + 128);
 		NF_CT_DUMP_TUPLE(&conntrack->tuplehash[0].tuple);
 		return 0;
 	}
@@ -152,14 +146,15 @@ icmpv6_error_message(struct sk_buff *skb,
 
 	hp = skb_header_pointer(skb, icmp6off, sizeof(_hdr), &_hdr);
 	if (hp == NULL) {
-		DEBUGP("icmpv6_error: Can't get ICMPv6 hdr.\n");
+		pr_debug("icmpv6_error: Can't get ICMPv6 hdr.\n");
 		return -NF_ACCEPT;
 	}
 
 	inip6off = icmp6off + sizeof(_hdr);
 	if (skb_copy_bits(skb, inip6off+offsetof(struct ipv6hdr, nexthdr),
 			  &inprotonum, sizeof(inprotonum)) != 0) {
-		DEBUGP("icmpv6_error: Can't get nexthdr in inner IPv6 header.\n");
+		pr_debug("icmpv6_error: Can't get nexthdr in inner IPv6 "
+			 "header.\n");
 		return -NF_ACCEPT;
 	}
 	inprotoff = nf_ct_ipv6_skip_exthdr(skb,
@@ -169,7 +164,8 @@ icmpv6_error_message(struct sk_buff *skb,
 						    - sizeof(struct ipv6hdr));
 
 	if ((inprotoff > skb->len) || (inprotonum == NEXTHDR_FRAGMENT)) {
-		DEBUGP("icmpv6_error: Can't get protocol header in ICMPv6 payload.\n");
+		pr_debug("icmpv6_error: Can't get protocol header in ICMPv6 "
+			 "payload.\n");
 		return -NF_ACCEPT;
 	}
 
@@ -179,7 +175,7 @@ icmpv6_error_message(struct sk_buff *skb,
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuple(skb, inip6off, inprotoff, PF_INET6, inprotonum,
 			     &origtuple, &nf_conntrack_l3proto_ipv6, inproto)) {
-		DEBUGP("icmpv6_error: Can't get tuple\n");
+		pr_debug("icmpv6_error: Can't get tuple\n");
 		return -NF_ACCEPT;
 	}
 
@@ -187,7 +183,7 @@ icmpv6_error_message(struct sk_buff *skb,
 	   been preserved inside the ICMP. */
 	if (!nf_ct_invert_tuple(&intuple, &origtuple,
 				&nf_conntrack_l3proto_ipv6, inproto)) {
-		DEBUGP("icmpv6_error: Can't invert tuple\n");
+		pr_debug("icmpv6_error: Can't invert tuple\n");
 		return -NF_ACCEPT;
 	}
 
@@ -195,7 +191,7 @@ icmpv6_error_message(struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(&intuple);
 	if (!h) {
-		DEBUGP("icmpv6_error: no match\n");
+		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
 	} else {
 		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 347ab76..25442a8 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -44,12 +44,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 #define NF_CT_FRAG6_HIGH_THRESH 262144 /* == 256*1024 */
 #define NF_CT_FRAG6_LOW_THRESH 196608  /* == 192*1024 */
 #define NF_CT_FRAG6_TIMEOUT IPV6_FRAG_TIMEOUT
@@ -343,7 +337,7 @@ nf_ct_frag6_create(unsigned int hash, __be32 id, struct in6_addr *src,				   str
 	struct nf_ct_frag6_queue *fq;
 
 	if ((fq = frag_alloc_queue()) == NULL) {
-		DEBUGP("Can't alloc new queue\n");
+		pr_debug("Can't alloc new queue\n");
 		goto oom;
 	}
 
@@ -393,7 +387,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 	int offset, end;
 
 	if (fq->last_in & COMPLETE) {
-		DEBUGP("Allready completed\n");
+		pr_debug("Allready completed\n");
 		goto err;
 	}
 
@@ -402,7 +396,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
 
 	if ((unsigned int)end > IPV6_MAXPLEN) {
-		DEBUGP("offset is too large.\n");
+		pr_debug("offset is too large.\n");
 		return -1;
 	}
 
@@ -420,7 +414,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 		 */
 		if (end < fq->len ||
 		    ((fq->last_in & LAST_IN) && end != fq->len)) {
-			DEBUGP("already received last fragment\n");
+			pr_debug("already received last fragment\n");
 			goto err;
 		}
 		fq->last_in |= LAST_IN;
@@ -433,13 +427,13 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			/* RFC2460 says always send parameter problem in
 			 * this case. -DaveM
 			 */
-			DEBUGP("the end of this fragment is not rounded to 8 bytes.\n");
+			pr_debug("end of fragment not rounded to 8 bytes.\n");
 			return -1;
 		}
 		if (end > fq->len) {
 			/* Some bits beyond end -> corruption. */
 			if (fq->last_in & LAST_IN) {
-				DEBUGP("last packet already reached.\n");
+				pr_debug("last packet already reached.\n");
 				goto err;
 			}
 			fq->len = end;
@@ -451,11 +445,11 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 
 	/* Point into the IP datagram 'data' part. */
 	if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data)) {
-		DEBUGP("queue: message is too short.\n");
+		pr_debug("queue: message is too short.\n");
 		goto err;
 	}
 	if (pskb_trim_rcsum(skb, end - offset)) {
-		DEBUGP("Can't trim\n");
+		pr_debug("Can't trim\n");
 		goto err;
 	}
 
@@ -480,11 +474,11 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 		if (i > 0) {
 			offset += i;
 			if (end <= offset) {
-				DEBUGP("overlap\n");
+				pr_debug("overlap\n");
 				goto err;
 			}
 			if (!pskb_pull(skb, i)) {
-				DEBUGP("Can't pull\n");
+				pr_debug("Can't pull\n");
 				goto err;
 			}
 			if (skb->ip_summed != CHECKSUM_UNNECESSARY)
@@ -503,7 +497,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 			/* Eat head of the next overlapped fragment
 			 * and leave the loop. The next ones cannot overlap.
 			 */
-			DEBUGP("Eat head of the overlapped parts.: %d", i);
+			pr_debug("Eat head of the overlapped parts.: %d", i);
 			if (!pskb_pull(next, i))
 				goto err;
 
@@ -586,13 +580,13 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_queue *fq, struct net_device *dev)
 		       sizeof(struct ipv6hdr) + fq->len -
 		       sizeof(struct frag_hdr));
 	if (payload_len > IPV6_MAXPLEN) {
-		DEBUGP("payload len is too large.\n");
+		pr_debug("payload len is too large.\n");
 		goto out_oversize;
 	}
 
 	/* Head of list must not be cloned. */
 	if (skb_cloned(head) && pskb_expand_head(head, 0, 0, GFP_ATOMIC)) {
-		DEBUGP("skb is cloned but can't expand head");
+		pr_debug("skb is cloned but can't expand head");
 		goto out_oom;
 	}
 
@@ -604,7 +598,7 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_queue *fq, struct net_device *dev)
 		int i, plen = 0;
 
 		if ((clone = alloc_skb(0, GFP_ATOMIC)) == NULL) {
-			DEBUGP("Can't alloc skb\n");
+			pr_debug("Can't alloc skb\n");
 			goto out_oom;
 		}
 		clone->next = head->next;
@@ -719,11 +713,11 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 			return -1;
 		}
 		if (len < (int)sizeof(struct ipv6_opt_hdr)) {
-			DEBUGP("too short\n");
+			pr_debug("too short\n");
 			return -1;
 		}
 		if (nexthdr == NEXTHDR_NONE) {
-			DEBUGP("next header is none\n");
+			pr_debug("next header is none\n");
 			return -1;
 		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
@@ -764,7 +758,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 
 	/* Jumbo payload inhibits frag. header */
 	if (ipv6_hdr(skb)->payload_len == 0) {
-		DEBUGP("payload len = 0\n");
+		pr_debug("payload len = 0\n");
 		return skb;
 	}
 
@@ -773,14 +767,14 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 
 	clone = skb_clone(skb, GFP_ATOMIC);
 	if (clone == NULL) {
-		DEBUGP("Can't clone skb\n");
+		pr_debug("Can't clone skb\n");
 		return skb;
 	}
 
 	NFCT_FRAG6_CB(clone)->orig = skb;
 
 	if (!pskb_may_pull(clone, fhoff + sizeof(*fhdr))) {
-		DEBUGP("message is too short.\n");
+		pr_debug("message is too short.\n");
 		goto ret_orig;
 	}
 
@@ -789,7 +783,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 	fhdr = (struct frag_hdr *)skb_transport_header(clone);
 
 	if (!(fhdr->frag_off & htons(0xFFF9))) {
-		DEBUGP("Invalid fragment offset\n");
+		pr_debug("Invalid fragment offset\n");
 		/* It is not a fragmented frame */
 		goto ret_orig;
 	}
@@ -799,7 +793,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 
 	fq = fq_find(fhdr->identification, &hdr->saddr, &hdr->daddr);
 	if (fq == NULL) {
-		DEBUGP("Can't find and can't create new queue\n");
+		pr_debug("Can't find and can't create new queue\n");
 		goto ret_orig;
 	}
 
@@ -807,7 +801,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 
 	if (nf_ct_frag6_queue(fq, clone, fhdr, nhoff) < 0) {
 		spin_unlock(&fq->lock);
-		DEBUGP("Can't insert skb to queue\n");
+		pr_debug("Can't insert skb to queue\n");
 		fq_put(fq, NULL);
 		goto ret_orig;
 	}
@@ -815,7 +809,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 	if (fq->last_in == (FIRST_IN|LAST_IN) && fq->meat == fq->len) {
 		ret_skb = nf_ct_frag6_reasm(fq, dev);
 		if (ret_skb == NULL)
-			DEBUGP("Can't reassemble fragmented packets\n");
+			pr_debug("Can't reassemble fragmented packets\n");
 	}
 	spin_unlock(&fq->lock);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 472396d..3d14110 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -40,12 +40,6 @@
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 DEFINE_RWLOCK(nf_conntrack_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
@@ -141,7 +135,7 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
 static void
 clean_from_lists(struct nf_conn *ct)
 {
-	DEBUGP("clean_from_lists(%p)\n", ct);
+	pr_debug("clean_from_lists(%p)\n", ct);
 	hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
 	hlist_del(&ct->tuplehash[IP_CT_DIR_REPLY].hnode);
 
@@ -155,7 +149,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 	struct nf_conntrack_l4proto *l4proto;
 
-	DEBUGP("destroy_conntrack(%p)\n", ct);
+	pr_debug("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
@@ -194,7 +188,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
+	pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
 	nf_conntrack_free(ct);
 }
 
@@ -313,7 +307,7 @@ __nf_conntrack_confirm(struct sk_buff **pskb)
 	/* No external references means noone else could have
 	   confirmed us. */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
-	DEBUGP("Confirming conntrack %p\n", ct);
+	pr_debug("Confirming conntrack %p\n", ct);
 
 	write_lock_bh(&nf_conntrack_lock);
 
@@ -446,7 +440,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 
 	conntrack = kmem_cache_zalloc(nf_conntrack_cachep, GFP_ATOMIC);
 	if (conntrack == NULL) {
-		DEBUGP("nf_conntrack_alloc: Can't alloc conntrack.\n");
+		pr_debug("nf_conntrack_alloc: Can't alloc conntrack.\n");
 		atomic_dec(&nf_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -485,27 +479,27 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	struct nf_conntrack_expect *exp;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
-		DEBUGP("Can't invert tuple.\n");
+		pr_debug("Can't invert tuple.\n");
 		return NULL;
 	}
 
 	conntrack = nf_conntrack_alloc(tuple, &repl_tuple);
 	if (conntrack == NULL || IS_ERR(conntrack)) {
-		DEBUGP("Can't allocate conntrack.\n");
+		pr_debug("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)conntrack;
 	}
 
 	if (!l4proto->new(conntrack, skb, dataoff)) {
 		nf_conntrack_free(conntrack);
-		DEBUGP("init conntrack: can't track with proto module\n");
+		pr_debug("init conntrack: can't track with proto module\n");
 		return NULL;
 	}
 
 	write_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(tuple);
 	if (exp) {
-		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
-			conntrack, exp);
+		pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
+			 conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = exp->master;
@@ -568,7 +562,7 @@ resolve_normal_ct(struct sk_buff *skb,
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, l3num, protonum, &tuple, l3proto,
 			     l4proto)) {
-		DEBUGP("resolve_normal_ct: Can't get tuple\n");
+		pr_debug("resolve_normal_ct: Can't get tuple\n");
 		return NULL;
 	}
 
@@ -591,13 +585,14 @@ resolve_normal_ct(struct sk_buff *skb,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			DEBUGP("nf_conntrack_in: normal packet for %p\n", ct);
+			pr_debug("nf_conntrack_in: normal packet for %p\n", ct);
 			*ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			DEBUGP("nf_conntrack_in: related packet for %p\n", ct);
+			pr_debug("nf_conntrack_in: related packet for %p\n",
+				 ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
-			DEBUGP("nf_conntrack_in: new packet for %p\n", ct);
+			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
@@ -629,7 +624,7 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 	l3proto = __nf_ct_l3proto_find((u_int16_t)pf);
 
 	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
-		DEBUGP("not prepared to track yet or error occured\n");
+		pr_debug("not prepared to track yet or error occured\n");
 		return -ret;
 	}
 
@@ -665,7 +660,7 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 	if (ret < 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
-		DEBUGP("nf_conntrack_in: Can't track with proto module\n");
+		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
 		NF_CT_STAT_INC_ATOMIC(invalid);
@@ -706,7 +701,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 
-	DEBUGP("Altering reply tuple of %p to ", ct);
+	pr_debug("Altering reply tuple of %p to ", ct);
 	NF_CT_DUMP_TUPLE(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index cd9c2d0..c763ee7 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -51,12 +51,6 @@ unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				struct nf_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int try_rfc959(const char *, size_t, struct nf_conntrack_man *, char);
 static int try_eprt(const char *, size_t, struct nf_conntrack_man *, char);
 static int try_epsv_response(const char *, size_t, struct nf_conntrack_man *,
@@ -138,13 +132,13 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 			if (*data == term && i == array_size - 1)
 				return len;
 
-			DEBUGP("Char %u (got %u nums) `%u' unexpected\n",
-			       len, i, *data);
+			pr_debug("Char %u (got %u nums) `%u' unexpected\n",
+				 len, i, *data);
 			return 0;
 		}
 	}
-	DEBUGP("Failed to fill %u numbers separated by %c\n", array_size, sep);
-
+	pr_debug("Failed to fill %u numbers separated by %c\n",
+		 array_size, sep);
 	return 0;
 }
 
@@ -178,13 +172,13 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
 			if (tmp_port == 0)
 				break;
 			*port = htons(tmp_port);
-			DEBUGP("get_port: return %d\n", tmp_port);
+			pr_debug("get_port: return %d\n", tmp_port);
 			return i + 1;
 		}
 		else if (data[i] >= '0' && data[i] <= '9')
 			tmp_port = tmp_port*10 + data[i] - '0';
 		else { /* Some other crap */
-			DEBUGP("get_port: invalid char.\n");
+			pr_debug("get_port: invalid char.\n");
 			break;
 		}
 	}
@@ -201,22 +195,22 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 	/* First character is delimiter, then "1" for IPv4 or "2" for IPv6,
 	   then delimiter again. */
 	if (dlen <= 3) {
-		DEBUGP("EPRT: too short\n");
+		pr_debug("EPRT: too short\n");
 		return 0;
 	}
 	delim = data[0];
 	if (isdigit(delim) || delim < 33 || delim > 126 || data[2] != delim) {
-		DEBUGP("try_eprt: invalid delimitter.\n");
+		pr_debug("try_eprt: invalid delimitter.\n");
 		return 0;
 	}
 
 	if ((cmd->l3num == PF_INET && data[1] != '1') ||
 	    (cmd->l3num == PF_INET6 && data[1] != '2')) {
-		DEBUGP("EPRT: invalid protocol number.\n");
+		pr_debug("EPRT: invalid protocol number.\n");
 		return 0;
 	}
 
-	DEBUGP("EPRT: Got %c%c%c\n", delim, data[1], delim);
+	pr_debug("EPRT: Got %c%c%c\n", delim, data[1], delim);
 
 	if (data[1] == '1') {
 		u_int32_t array[4];
@@ -234,7 +228,7 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 
 	if (length == 0)
 		return 0;
-	DEBUGP("EPRT: Got IP address!\n");
+	pr_debug("EPRT: Got IP address!\n");
 	/* Start offset includes initial "|1|", and trailing delimiter */
 	return get_port(data, 3 + length + 1, dlen, delim, &cmd->u.tcp.port);
 }
@@ -267,7 +261,7 @@ static int find_pattern(const char *data, size_t dlen,
 {
 	size_t i;
 
-	DEBUGP("find_pattern `%s': dlen = %u\n", pattern, dlen);
+	pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
 	if (dlen == 0)
 		return 0;
 
@@ -282,17 +276,17 @@ static int find_pattern(const char *data, size_t dlen,
 #if 0
 		size_t i;
 
-		DEBUGP("ftp: string mismatch\n");
+		pr_debug("ftp: string mismatch\n");
 		for (i = 0; i < plen; i++) {
-			DEBUGP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				i, data[i], data[i],
-				pattern[i], pattern[i]);
+			pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
+				 i, data[i], data[i],
+				 pattern[i], pattern[i]);
 		}
 #endif
 		return 0;
 	}
 
-	DEBUGP("Pattern matches!\n");
+	pr_debug("Pattern matches!\n");
 	/* Now we've found the constant string, try to skip
 	   to the 'skip' character */
 	for (i = plen; data[i] != skip; i++)
@@ -301,14 +295,14 @@ static int find_pattern(const char *data, size_t dlen,
 	/* Skip over the last character */
 	i++;
 
-	DEBUGP("Skipped up to `%c'!\n", skip);
+	pr_debug("Skipped up to `%c'!\n", skip);
 
 	*numoff = i;
 	*numlen = getnum(data + i, dlen - i, cmd, term);
 	if (!*numlen)
 		return -1;
 
-	DEBUGP("Match succeeded!\n");
+	pr_debug("Match succeeded!\n");
 	return 1;
 }
 
@@ -373,7 +367,7 @@ static int help(struct sk_buff **pskb,
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
 	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
-		DEBUGP("ftp: Conntrackinfo = %u\n", ctinfo);
+		pr_debug("ftp: Conntrackinfo = %u\n", ctinfo);
 		return NF_ACCEPT;
 	}
 
@@ -384,8 +378,8 @@ static int help(struct sk_buff **pskb,
 	dataoff = protoff + th->doff * 4;
 	/* No data? */
 	if (dataoff >= (*pskb)->len) {
-		DEBUGP("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
-			(*pskb)->len);
+		pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
+			 (*pskb)->len);
 		return NF_ACCEPT;
 	}
 	datalen = (*pskb)->len - dataoff;
@@ -400,11 +394,11 @@ static int help(struct sk_buff **pskb,
 	/* Look up to see if we're just after a \n. */
 	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
 		/* Now if this ends in \n, update ftp info. */
-		DEBUGP("nf_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
-		       ct_ftp_info->seq_aft_nl_num[dir] > 0 ? "" : "(UNSET)",
-		       ct_ftp_info->seq_aft_nl[dir][0],
-		       ct_ftp_info->seq_aft_nl_num[dir] > 1 ? "" : "(UNSET)",
-		       ct_ftp_info->seq_aft_nl[dir][1]);
+		pr_debug("nf_conntrack_ftp: wrong seq pos %s(%u) or %s(%u)\n",
+			 ct_ftp_info->seq_aft_nl_num[dir] > 0 ? "" : "(UNSET)",
+			 ct_ftp_info->seq_aft_nl[dir][0],
+			 ct_ftp_info->seq_aft_nl_num[dir] > 1 ? "" : "(UNSET)",
+			 ct_ftp_info->seq_aft_nl[dir][1]);
 		ret = NF_ACCEPT;
 		goto out_update_nl;
 	}
@@ -442,9 +436,9 @@ static int help(struct sk_buff **pskb,
 		goto out_update_nl;
 	}
 
-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-	       (int)matchlen, fb_ptr + matchoff,
-	       matchlen, ntohl(th->seq) + matchoff);
+	pr_debug("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
+		 matchlen, fb_ptr + matchoff,
+		 matchlen, ntohl(th->seq) + matchoff);
 
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL) {
@@ -466,14 +460,16 @@ static int help(struct sk_buff **pskb,
 		   different IP address.  Simply don't record it for
 		   NAT. */
 		if (cmd.l3num == PF_INET) {
-			DEBUGP("conntrack_ftp: NOT RECORDING: " NIPQUAD_FMT " != " NIPQUAD_FMT "\n",
-			       NIPQUAD(cmd.u3.ip),
-			       NIPQUAD(ct->tuplehash[dir].tuple.src.u3.ip));
+			pr_debug("conntrack_ftp: NOT RECORDING: " NIPQUAD_FMT
+				 " != " NIPQUAD_FMT "\n",
+				 NIPQUAD(cmd.u3.ip),
+				 NIPQUAD(ct->tuplehash[dir].tuple.src.u3.ip));
 		} else {
-			DEBUGP("conntrack_ftp: NOT RECORDING: " NIP6_FMT " != " NIP6_FMT "\n",
-			       NIP6(*((struct in6_addr *)cmd.u3.ip6)),
-			       NIP6(*((struct in6_addr *)ct->tuplehash[dir]
-							.tuple.src.u3.ip6)));
+			pr_debug("conntrack_ftp: NOT RECORDING: " NIP6_FMT
+				 " != " NIP6_FMT "\n",
+				 NIP6(*((struct in6_addr *)cmd.u3.ip6)),
+				 NIP6(*((struct in6_addr *)
+					ct->tuplehash[dir].tuple.src.u3.ip6)));
 		}
 
 		/* Thanks to Cristiano Lincoln Mattos
@@ -530,9 +526,9 @@ static void nf_conntrack_ftp_fini(void)
 			if (ftp[i][j].me == NULL)
 				continue;
 
-			DEBUGP("nf_ct_ftp: unregistering helper for pf: %d "
-			       "port: %d\n",
-				ftp[i][j].tuple.src.l3num, ports[i]);
+			pr_debug("nf_ct_ftp: unregistering helper for pf: %d "
+				 "port: %d\n",
+				 ftp[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&ftp[i][j]);
 		}
 	}
@@ -571,9 +567,9 @@ static int __init nf_conntrack_ftp_init(void)
 				sprintf(tmpname, "ftp-%d", ports[i]);
 			ftp[i][j].name = tmpname;
 
-			DEBUGP("nf_ct_ftp: registering helper for pf: %d "
-			       "port: %d\n",
-				ftp[i][j].tuple.src.l3num, ports[i]);
+			pr_debug("nf_ct_ftp: registering helper for pf: %d "
+				 "port: %d\n",
+				 ftp[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&ftp[i][j]);
 			if (ret) {
 				printk("nf_ct_ftp: failed to register helper "
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index aa5ba99..a8a9dfb 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -31,12 +31,6 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_h323.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Parameters */
 static unsigned int default_rrq_ttl __read_mostly = 300;
 module_param(default_rrq_ttl, uint, 0600);
@@ -150,9 +144,9 @@ static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 		if (tcpdatalen < 4 || tpkt[0] != 0x03 || tpkt[1] != 0) {
 			/* Netmeeting sends TPKT header and data separately */
 			if (info->tpkt_len[dir] > 0) {
-				DEBUGP("nf_ct_h323: previous packet "
-				       "indicated separate TPKT data of %hu "
-				       "bytes\n", info->tpkt_len[dir]);
+				pr_debug("nf_ct_h323: previous packet "
+					 "indicated separate TPKT data of %hu "
+					 "bytes\n", info->tpkt_len[dir]);
 				if (info->tpkt_len[dir] <= tcpdatalen) {
 					/* Yes, there was a TPKT header
 					 * received */
@@ -163,7 +157,7 @@ static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 				}
 
 				/* Fragmented TPKT */
-				DEBUGP("nf_ct_h323: fragmented TPKT\n");
+				pr_debug("nf_ct_h323: fragmented TPKT\n");
 				goto clear_out;
 			}
 
@@ -190,9 +184,9 @@ static int get_tpkt_data(struct sk_buff **pskb, unsigned int protoff,
 	if (tpktlen > tcpdatalen) {
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */
-			DEBUGP("nf_ct_h323: separate TPKT header indicates "
-			       "there will be TPKT data of %hu bytes\n",
-			       tpktlen - 4);
+			pr_debug("nf_ct_h323: separate TPKT header indicates "
+				 "there will be TPKT data of %hu bytes\n",
+				 tpktlen - 4);
 			info->tpkt_len[dir] = tpktlen - 4;
 			return 0;
 		}
@@ -308,9 +302,9 @@ static int expect_rtp_rtcp(struct sk_buff **pskb, struct nf_conn *ct,
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(rtp_exp) == 0) {
 			if (nf_ct_expect_related(rtcp_exp) == 0) {
-				DEBUGP("nf_ct_h323: expect RTP ");
+				pr_debug("nf_ct_h323: expect RTP ");
 				NF_CT_DUMP_TUPLE(&rtp_exp->tuple);
-				DEBUGP("nf_ct_h323: expect RTCP ");
+				pr_debug("nf_ct_h323: expect RTCP ");
 				NF_CT_DUMP_TUPLE(&rtcp_exp->tuple);
 			} else {
 				nf_ct_unexpect_related(rtp_exp);
@@ -365,7 +359,7 @@ static int expect_t120(struct sk_buff **pskb,
 			       port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			DEBUGP("nf_ct_h323: expect T.120 ");
+			pr_debug("nf_ct_h323: expect T.120 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
@@ -413,7 +407,7 @@ static int process_olc(struct sk_buff **pskb, struct nf_conn *ct,
 {
 	int ret;
 
-	DEBUGP("nf_ct_h323: OpenLogicalChannel\n");
+	pr_debug("nf_ct_h323: OpenLogicalChannel\n");
 
 	if (olc->forwardLogicalChannelParameters.multiplexParameters.choice ==
 	    eOpenLogicalChannel_forwardLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters)
@@ -473,7 +467,7 @@ static int process_olca(struct sk_buff **pskb, struct nf_conn *ct,
 	H2250LogicalChannelAckParameters *ack;
 	int ret;
 
-	DEBUGP("nf_ct_h323: OpenLogicalChannelAck\n");
+	pr_debug("nf_ct_h323: OpenLogicalChannelAck\n");
 
 	if ((olca->options &
 	     eOpenLogicalChannelAck_reverseLogicalChannelParameters) &&
@@ -544,8 +538,8 @@ static int process_h245(struct sk_buff **pskb, struct nf_conn *ct,
 			return process_olc(pskb, ct, ctinfo, data, dataoff,
 					   &mscm->request.openLogicalChannel);
 		}
-		DEBUGP("nf_ct_h323: H.245 Request %d\n",
-		       mscm->request.choice);
+		pr_debug("nf_ct_h323: H.245 Request %d\n",
+			 mscm->request.choice);
 		break;
 	case eMultimediaSystemControlMessage_response:
 		if (mscm->response.choice ==
@@ -554,11 +548,11 @@ static int process_h245(struct sk_buff **pskb, struct nf_conn *ct,
 					    &mscm->response.
 					    openLogicalChannelAck);
 		}
-		DEBUGP("nf_ct_h323: H.245 Response %d\n",
-		       mscm->response.choice);
+		pr_debug("nf_ct_h323: H.245 Response %d\n",
+			 mscm->response.choice);
 		break;
 	default:
-		DEBUGP("nf_ct_h323: H.245 signal %d\n", mscm->choice);
+		pr_debug("nf_ct_h323: H.245 signal %d\n", mscm->choice);
 		break;
 	}
 
@@ -580,23 +574,23 @@ static int h245_help(struct sk_buff **pskb, unsigned int protoff,
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
 		return NF_ACCEPT;
 	}
-	DEBUGP("nf_ct_h245: skblen = %u\n", (*pskb)->len);
+	pr_debug("nf_ct_h245: skblen = %u\n", (*pskb)->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
 	/* Process each TPKT */
 	while (get_tpkt_data(pskb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
-		DEBUGP("nf_ct_h245: TPKT len=%d ", datalen);
+		pr_debug("nf_ct_h245: TPKT len=%d ", datalen);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode H.245 signal */
 		ret = DecodeMultimediaSystemControlMessage(data, datalen,
 							   &mscm);
 		if (ret < 0) {
-			DEBUGP("nf_ct_h245: decoding error: %s\n",
-			       ret == H323_ERROR_BOUND ?
-			       "out of bound" : "out of range");
+			pr_debug("nf_ct_h245: decoding error: %s\n",
+				 ret == H323_ERROR_BOUND ?
+				 "out of bound" : "out of range");
 			/* We don't drop when decoding error */
 			break;
 		}
@@ -697,7 +691,7 @@ static int expect_h245(struct sk_buff **pskb, struct nf_conn *ct,
 			       port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			DEBUGP("nf_ct_q931: expect H.245 ");
+			pr_debug("nf_ct_q931: expect H.245 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
@@ -786,7 +780,7 @@ static int expect_callforwarding(struct sk_buff **pskb,
 	if (callforward_filter &&
 	    callforward_do_filter(&addr, &ct->tuplehash[!dir].tuple.src.u3,
 				  ct->tuplehash[!dir].tuple.src.l3num)) {
-		DEBUGP("nf_ct_q931: Call Forwarding not tracked\n");
+		pr_debug("nf_ct_q931: Call Forwarding not tracked\n");
 		return 0;
 	}
 
@@ -808,7 +802,7 @@ static int expect_callforwarding(struct sk_buff **pskb,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			DEBUGP("nf_ct_q931: expect Call Forwarding ");
+			pr_debug("nf_ct_q931: expect Call Forwarding ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 		} else
 			ret = -1;
@@ -832,7 +826,7 @@ static int process_setup(struct sk_buff **pskb, struct nf_conn *ct,
 	union nf_conntrack_address addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
-	DEBUGP("nf_ct_q931: Setup\n");
+	pr_debug("nf_ct_q931: Setup\n");
 
 	if (setup->options & eSetup_UUIE_h245Address) {
 		ret = expect_h245(pskb, ct, ctinfo, data, dataoff,
@@ -847,11 +841,11 @@ static int process_setup(struct sk_buff **pskb, struct nf_conn *ct,
 	    get_h225_addr(ct, *data, &setup->destCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.src.u3, sizeof(addr))) {
-		DEBUGP("nf_ct_q931: set destCallSignalAddress "
-		       NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
-		       NIP6(*(struct in6_addr *)&addr), ntohs(port),
-		       NIP6(*(struct in6_addr *)&ct->tuplehash[!dir].tuple.src.u3),
-		       ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));
+		pr_debug("nf_ct_q931: set destCallSignalAddress "
+			 NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
+			 NIP6(*(struct in6_addr *)&addr), ntohs(port),
+			 NIP6(*(struct in6_addr *)&ct->tuplehash[!dir].tuple.src.u3),
+			 ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));
 		ret = set_h225_addr(pskb, data, dataoff,
 				    &setup->destCallSignalAddress,
 				    &ct->tuplehash[!dir].tuple.src.u3,
@@ -865,11 +859,11 @@ static int process_setup(struct sk_buff **pskb, struct nf_conn *ct,
 	    get_h225_addr(ct, *data, &setup->sourceCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.dst.u3, sizeof(addr))) {
-		DEBUGP("nf_ct_q931: set sourceCallSignalAddress "
-		       NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
-		       NIP6(*(struct in6_addr *)&addr), ntohs(port),
-		       NIP6(*(struct in6_addr *)&ct->tuplehash[!dir].tuple.dst.u3),
-		       ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));
+		pr_debug("nf_ct_q931: set sourceCallSignalAddress "
+			 NIP6_FMT ":%hu->" NIP6_FMT ":%hu\n",
+			 NIP6(*(struct in6_addr *)&addr), ntohs(port),
+			 NIP6(*(struct in6_addr *)&ct->tuplehash[!dir].tuple.dst.u3),
+			 ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));
 		ret = set_h225_addr(pskb, data, dataoff,
 				    &setup->sourceCallSignalAddress,
 				    &ct->tuplehash[!dir].tuple.dst.u3,
@@ -900,7 +894,7 @@ static int process_callproceeding(struct sk_buff **pskb,
 	int ret;
 	int i;
 
-	DEBUGP("nf_ct_q931: CallProceeding\n");
+	pr_debug("nf_ct_q931: CallProceeding\n");
 
 	if (callproc->options & eCallProceeding_UUIE_h245Address) {
 		ret = expect_h245(pskb, ct, ctinfo, data, dataoff,
@@ -930,7 +924,7 @@ static int process_connect(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	DEBUGP("nf_ct_q931: Connect\n");
+	pr_debug("nf_ct_q931: Connect\n");
 
 	if (connect->options & eConnect_UUIE_h245Address) {
 		ret = expect_h245(pskb, ct, ctinfo, data, dataoff,
@@ -960,7 +954,7 @@ static int process_alerting(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	DEBUGP("nf_ct_q931: Alerting\n");
+	pr_debug("nf_ct_q931: Alerting\n");
 
 	if (alert->options & eAlerting_UUIE_h245Address) {
 		ret = expect_h245(pskb, ct, ctinfo, data, dataoff,
@@ -990,7 +984,7 @@ static int process_facility(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	DEBUGP("nf_ct_q931: Facility\n");
+	pr_debug("nf_ct_q931: Facility\n");
 
 	if (facility->reason.choice == eFacilityReason_callForwarded) {
 		if (facility->options & eFacility_UUIE_alternativeAddress)
@@ -1029,7 +1023,7 @@ static int process_progress(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	int i;
 
-	DEBUGP("nf_ct_q931: Progress\n");
+	pr_debug("nf_ct_q931: Progress\n");
 
 	if (progress->options & eProgress_UUIE_h245Address) {
 		ret = expect_h245(pskb, ct, ctinfo, data, dataoff,
@@ -1086,8 +1080,8 @@ static int process_q931(struct sk_buff **pskb, struct nf_conn *ct,
 				       &pdu->h323_message_body.progress);
 		break;
 	default:
-		DEBUGP("nf_ct_q931: Q.931 signal %d\n",
-		       pdu->h323_message_body.choice);
+		pr_debug("nf_ct_q931: Q.931 signal %d\n",
+			 pdu->h323_message_body.choice);
 		break;
 	}
 
@@ -1121,22 +1115,22 @@ static int q931_help(struct sk_buff **pskb, unsigned int protoff,
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
 		return NF_ACCEPT;
 	}
-	DEBUGP("nf_ct_q931: skblen = %u\n", (*pskb)->len);
+	pr_debug("nf_ct_q931: skblen = %u\n", (*pskb)->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
 	/* Process each TPKT */
 	while (get_tpkt_data(pskb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
-		DEBUGP("nf_ct_q931: TPKT len=%d ", datalen);
+		pr_debug("nf_ct_q931: TPKT len=%d ", datalen);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 		/* Decode Q.931 signal */
 		ret = DecodeQ931(data, datalen, &q931);
 		if (ret < 0) {
-			DEBUGP("nf_ct_q931: decoding error: %s\n",
-			       ret == H323_ERROR_BOUND ?
-			       "out of bound" : "out of range");
+			pr_debug("nf_ct_q931: decoding error: %s\n",
+				 ret == H323_ERROR_BOUND ?
+				 "out of bound" : "out of range");
 			/* We don't drop when decoding error */
 			break;
 		}
@@ -1274,7 +1268,7 @@ static int expect_q931(struct sk_buff **pskb, struct nf_conn *ct,
 		ret = nat_q931(pskb, ct, ctinfo, data, taddr, i, port, exp);
 	} else {		/* Conntrack only */
 		if (nf_ct_expect_related(exp) == 0) {
-			DEBUGP("nf_ct_ras: expect Q.931 ");
+			pr_debug("nf_ct_ras: expect Q.931 ");
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 
 			/* Save port for looking up expect in processing RCF */
@@ -1295,7 +1289,7 @@ static int process_grq(struct sk_buff **pskb, struct nf_conn *ct,
 {
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	DEBUGP("nf_ct_ras: GRQ\n");
+	pr_debug("nf_ct_ras: GRQ\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK)	/* NATed */
@@ -1315,7 +1309,7 @@ static int process_gcf(struct sk_buff **pskb, struct nf_conn *ct,
 	union nf_conntrack_address addr;
 	struct nf_conntrack_expect *exp;
 
-	DEBUGP("nf_ct_ras: GCF\n");
+	pr_debug("nf_ct_ras: GCF\n");
 
 	if (!get_h225_addr(ct, *data, &gcf->rasAddress, &addr, &port))
 		return 0;
@@ -1338,7 +1332,7 @@ static int process_gcf(struct sk_buff **pskb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_ras;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		DEBUGP("nf_ct_ras: expect RAS ");
+		pr_debug("nf_ct_ras: expect RAS ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
@@ -1357,7 +1351,7 @@ static int process_rrq(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	DEBUGP("nf_ct_ras: RRQ\n");
+	pr_debug("nf_ct_ras: RRQ\n");
 
 	ret = expect_q931(pskb, ct, ctinfo, data,
 			  rrq->callSignalAddress.item,
@@ -1375,7 +1369,7 @@ static int process_rrq(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	if (rrq->options & eRegistrationRequest_timeToLive) {
-		DEBUGP("nf_ct_ras: RRQ TTL = %u seconds\n", rrq->timeToLive);
+		pr_debug("nf_ct_ras: RRQ TTL = %u seconds\n", rrq->timeToLive);
 		info->timeout = rrq->timeToLive;
 	} else
 		info->timeout = default_rrq_ttl;
@@ -1394,7 +1388,7 @@ static int process_rcf(struct sk_buff **pskb, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	DEBUGP("nf_ct_ras: RCF\n");
+	pr_debug("nf_ct_ras: RCF\n");
 
 	set_sig_addr = rcu_dereference(set_sig_addr_hook);
 	if (set_sig_addr && ct->status & IPS_NAT_MASK) {
@@ -1406,14 +1400,13 @@ static int process_rcf(struct sk_buff **pskb, struct nf_conn *ct,
 	}
 
 	if (rcf->options & eRegistrationConfirm_timeToLive) {
-		DEBUGP("nf_ct_ras: RCF TTL = %u seconds\n", rcf->timeToLive);
+		pr_debug("nf_ct_ras: RCF TTL = %u seconds\n", rcf->timeToLive);
 		info->timeout = rcf->timeToLive;
 	}
 
 	if (info->timeout > 0) {
-		DEBUGP
-		    ("nf_ct_ras: set RAS connection timeout to %u seconds\n",
-		     info->timeout);
+		pr_debug("nf_ct_ras: set RAS connection timeout to "
+			 "%u seconds\n", info->timeout);
 		nf_ct_refresh(ct, *pskb, info->timeout * HZ);
 
 		/* Set expect timeout */
@@ -1421,9 +1414,9 @@ static int process_rcf(struct sk_buff **pskb, struct nf_conn *ct,
 		exp = find_expect(ct, &ct->tuplehash[dir].tuple.dst.u3,
 				  info->sig_port[!dir]);
 		if (exp) {
-			DEBUGP("nf_ct_ras: set Q.931 expect "
-			       "timeout to %u seconds for",
-			       info->timeout);
+			pr_debug("nf_ct_ras: set Q.931 expect "
+				 "timeout to %u seconds for",
+				 info->timeout);
 			NF_CT_DUMP_TUPLE(&exp->tuple);
 			set_expect_timeout(exp, info->timeout);
 		}
@@ -1443,7 +1436,7 @@ static int process_urq(struct sk_buff **pskb, struct nf_conn *ct,
 	int ret;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	DEBUGP("nf_ct_ras: URQ\n");
+	pr_debug("nf_ct_ras: URQ\n");
 
 	set_sig_addr = rcu_dereference(set_sig_addr_hook);
 	if (set_sig_addr && ct->status & IPS_NAT_MASK) {
@@ -1476,7 +1469,7 @@ static int process_arq(struct sk_buff **pskb, struct nf_conn *ct,
 	union nf_conntrack_address addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
-	DEBUGP("nf_ct_ras: ARQ\n");
+	pr_debug("nf_ct_ras: ARQ\n");
 
 	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((arq->options & eAdmissionRequest_destCallSignalAddress) &&
@@ -1519,7 +1512,7 @@ static int process_acf(struct sk_buff **pskb, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	DEBUGP("nf_ct_ras: ACF\n");
+	pr_debug("nf_ct_ras: ACF\n");
 
 	if (!get_h225_addr(ct, *data, &acf->destCallSignalAddress,
 			   &addr, &port))
@@ -1544,7 +1537,7 @@ static int process_acf(struct sk_buff **pskb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_q931;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		DEBUGP("nf_ct_ras: expect Q.931 ");
+		pr_debug("nf_ct_ras: expect Q.931 ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
@@ -1561,7 +1554,7 @@ static int process_lrq(struct sk_buff **pskb, struct nf_conn *ct,
 {
 	typeof(set_ras_addr_hook) set_ras_addr;
 
-	DEBUGP("nf_ct_ras: LRQ\n");
+	pr_debug("nf_ct_ras: LRQ\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK)
@@ -1581,7 +1574,7 @@ static int process_lcf(struct sk_buff **pskb, struct nf_conn *ct,
 	union nf_conntrack_address addr;
 	struct nf_conntrack_expect *exp;
 
-	DEBUGP("nf_ct_ras: LCF\n");
+	pr_debug("nf_ct_ras: LCF\n");
 
 	if (!get_h225_addr(ct, *data, &lcf->callSignalAddress,
 			   &addr, &port))
@@ -1597,7 +1590,7 @@ static int process_lcf(struct sk_buff **pskb, struct nf_conn *ct,
 	exp->helper = nf_conntrack_helper_q931;
 
 	if (nf_ct_expect_related(exp) == 0) {
-		DEBUGP("nf_ct_ras: expect Q.931 ");
+		pr_debug("nf_ct_ras: expect Q.931 ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
 	} else
 		ret = -1;
@@ -1618,7 +1611,7 @@ static int process_irr(struct sk_buff **pskb, struct nf_conn *ct,
 	typeof(set_ras_addr_hook) set_ras_addr;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
-	DEBUGP("nf_ct_ras: IRR\n");
+	pr_debug("nf_ct_ras: IRR\n");
 
 	set_ras_addr = rcu_dereference(set_ras_addr_hook);
 	if (set_ras_addr && ct->status & IPS_NAT_MASK) {
@@ -1677,7 +1670,7 @@ static int process_ras(struct sk_buff **pskb, struct nf_conn *ct,
 		return process_irr(pskb, ct, ctinfo, data,
 				   &ras->infoRequestResponse);
 	default:
-		DEBUGP("nf_ct_ras: RAS message %d\n", ras->choice);
+		pr_debug("nf_ct_ras: RAS message %d\n", ras->choice);
 		break;
 	}
 
@@ -1693,7 +1686,7 @@ static int ras_help(struct sk_buff **pskb, unsigned int protoff,
 	int datalen = 0;
 	int ret;
 
-	DEBUGP("nf_ct_ras: skblen = %u\n", (*pskb)->len);
+	pr_debug("nf_ct_ras: skblen = %u\n", (*pskb)->len);
 
 	spin_lock_bh(&nf_h323_lock);
 
@@ -1701,15 +1694,15 @@ static int ras_help(struct sk_buff **pskb, unsigned int protoff,
 	data = get_udp_data(pskb, protoff, &datalen);
 	if (data == NULL)
 		goto accept;
-	DEBUGP("nf_ct_ras: RAS message len=%d ", datalen);
+	pr_debug("nf_ct_ras: RAS message len=%d ", datalen);
 	NF_CT_DUMP_TUPLE(&ct->tuplehash[CTINFO2DIR(ctinfo)].tuple);
 
 	/* Decode RAS message */
 	ret = DecodeRasMessage(data, datalen, &ras);
 	if (ret < 0) {
-		DEBUGP("nf_ct_ras: decoding error: %s\n",
-		       ret == H323_ERROR_BOUND ?
-		       "out of bound" : "out of range");
+		pr_debug("nf_ct_ras: decoding error: %s\n",
+			 ret == H323_ERROR_BOUND ?
+			 "out of bound" : "out of range");
 		goto accept;
 	}
 
@@ -1760,7 +1753,7 @@ static void __exit nf_conntrack_h323_fini(void)
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[1]);
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
 	kfree(h323_buffer);
-	DEBUGP("nf_ct_h323: fini\n");
+	pr_debug("nf_ct_h323: fini\n");
 }
 
 /****************************************************************************/
@@ -1783,7 +1776,7 @@ static int __init nf_conntrack_h323_init(void)
 	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[1]);
 	if (ret < 0)
 		goto err4;
-	DEBUGP("nf_ct_h323: init success\n");
+	pr_debug("nf_ct_h323: init success\n");
 	return 0;
 
 err4:
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 8c73407..1562ca9 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -12,6 +12,7 @@
 #include <linux/moduleparam.h>
 #include <linux/skbuff.h>
 #include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/netfilter.h>
 
@@ -55,13 +56,6 @@ static const char *dccprotos[] = {
 
 #define MINMATCHLEN	5
 
-#if 0
-#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s:" format, \
-				       __FILE__, __FUNCTION__ , ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* tries to get the ip_addr and port out of a dcc command
  * return value: -1 on failure, 0 on success
  *	data		pointer to first byte of DCC command data
@@ -99,6 +93,7 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff;
+	struct iphdr *iph;
 	struct tcphdr _tcph, *th;
 	char *data, *data_limit, *ib_ptr;
 	int dir = CTINFO2DIR(ctinfo);
@@ -148,9 +143,10 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 		data += 5;
 		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
 
-		DEBUGP("DCC found in master %u.%u.%u.%u:%u %u.%u.%u.%u:%u...\n",
-			NIPQUAD(iph->saddr), ntohs(th->source),
-			NIPQUAD(iph->daddr), ntohs(th->dest));
+		iph = ip_hdr(*pskb);
+		pr_debug("DCC found in master %u.%u.%u.%u:%u %u.%u.%u.%u:%u\n",
+			 NIPQUAD(iph->saddr), ntohs(th->source),
+			 NIPQUAD(iph->daddr), ntohs(th->dest));
 
 		for (i = 0; i < ARRAY_SIZE(dccprotos); i++) {
 			if (memcmp(data, dccprotos[i], strlen(dccprotos[i]))) {
@@ -158,18 +154,18 @@ static int help(struct sk_buff **pskb, unsigned int protoff,
 				continue;
 			}
 			data += strlen(dccprotos[i]);
-			DEBUGP("DCC %s detected\n", dccprotos[i]);
+			pr_debug("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
 			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc((char *)data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
-				DEBUGP("unable to parse dcc command\n");
+				pr_debug("unable to parse dcc command\n");
 				continue;
 			}
-			DEBUGP("DCC bound ip/port: %u.%u.%u.%u:%u\n",
-				HIPQUAD(dcc_ip), dcc_port);
+			pr_debug("DCC bound ip/port: %u.%u.%u.%u:%u\n",
+				 HIPQUAD(dcc_ip), dcc_port);
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
 			tuple = &ct->tuplehash[dir].tuple;
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 2fd0f11..b1bfa20 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -31,12 +31,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 				struct nf_conntrack_tuple *tuple)
 {
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 63dac5e..b080419 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -65,7 +65,7 @@ void
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
-#if 0
+#ifdef DEBUG
 /* PptpControlMessageType names */
 const char *pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
@@ -86,9 +86,6 @@ const char *pptp_msg_name[] = {
 	"SET_LINK_INFO"
 };
 EXPORT_SYMBOL(pptp_msg_name);
-#define DEBUGP(format, args...)	printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
-#else
-#define DEBUGP(format, args...)
 #endif
 
 #define SECS *HZ
@@ -102,7 +99,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 			 struct nf_conntrack_expect *exp)
 {
 	typeof(nf_nat_pptp_hook_expectfn) nf_nat_pptp_expectfn;
-	DEBUGP("increasing timeouts\n");
+	pr_debug("increasing timeouts\n");
 
 	/* increase timeout of GRE data channel conntrack entry */
 	ct->proto.gre.timeout	     = PPTP_GRE_TIMEOUT;
@@ -121,17 +118,17 @@ static void pptp_expectfn(struct nf_conn *ct,
 
 		/* obviously this tuple inversion only works until you do NAT */
 		nf_ct_invert_tuplepr(&inv_t, &exp->tuple);
-		DEBUGP("trying to unexpect other dir: ");
+		pr_debug("trying to unexpect other dir: ");
 		NF_CT_DUMP_TUPLE(&inv_t);
 
 		exp_other = nf_ct_expect_find_get(&inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
-			DEBUGP("found\n");
+			pr_debug("found\n");
 			nf_ct_unexpect_related(exp_other);
 			nf_ct_expect_put(exp_other);
 		} else {
-			DEBUGP("not found\n");
+			pr_debug("not found\n");
 		}
 	}
 	rcu_read_unlock();
@@ -143,13 +140,13 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *sibling;
 
-	DEBUGP("trying to timeout ct or exp for tuple ");
+	pr_debug("trying to timeout ct or exp for tuple ");
 	NF_CT_DUMP_TUPLE(t);
 
 	h = nf_conntrack_find_get(t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
-		DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
+		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
 		sibling->proto.gre.timeout	  = 0;
 		sibling->proto.gre.stream_timeout = 0;
 		if (del_timer(&sibling->timeout))
@@ -159,7 +156,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 	} else {
 		exp = nf_ct_expect_find_get(t);
 		if (exp) {
-			DEBUGP("unexpect_related of expect %p\n", exp);
+			pr_debug("unexpect_related of expect %p\n", exp);
 			nf_ct_unexpect_related(exp);
 			nf_ct_expect_put(exp);
 			return 1;
@@ -182,7 +179,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	if (!destroy_sibling_or_exp(&t))
-		DEBUGP("failed to timeout original pns->pac ct/exp\n");
+		pr_debug("failed to timeout original pns->pac ct/exp\n");
 
 	/* try reply (pac->pns) tuple */
 	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
@@ -190,7 +187,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	if (!destroy_sibling_or_exp(&t))
-		DEBUGP("failed to timeout reply pac->pns ct/exp\n");
+		pr_debug("failed to timeout reply pac->pns ct/exp\n");
 }
 
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
@@ -270,7 +267,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
-	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("inbound control message %s\n", pptp_msg_name[msg]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
@@ -305,8 +302,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		pcid = pptpReq->ocack.peersCallID;
 		if (info->pns_call_id != pcid)
 			goto invalid;
-		DEBUGP("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
-			ntohs(cid), ntohs(pcid));
+		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
+			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
 			info->cstate = PPTP_CALL_OUT_CONF;
@@ -322,7 +319,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 			goto invalid;
 
 		cid = pptpReq->icreq.callID;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_IN_REQ;
 		info->pac_call_id = cid;
 		break;
@@ -341,7 +338,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		if (info->pns_call_id != pcid)
 			goto invalid;
 
-		DEBUGP("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		pr_debug("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
@@ -351,7 +348,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	case PPTP_CALL_DISCONNECT_NOTIFY:
 		/* server confirms disconnect */
 		cid = pptpReq->disc.callID;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
@@ -374,11 +371,11 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	return NF_ACCEPT;
 
 invalid:
-	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
-	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
-	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
-	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
+	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
+		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
 }
 
@@ -396,7 +393,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
-	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("outbound control message %s\n", pptp_msg_name[msg]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
@@ -418,7 +415,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
 		cid = pptpReq->ocreq.callID;
-		DEBUGP("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
 		info->pns_call_id = cid;
 		break;
 
@@ -432,8 +429,8 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
-		DEBUGP("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
-		       ntohs(cid), ntohs(pcid));
+		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
 			/* part two of the three-way handshake */
@@ -469,11 +466,11 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	return NF_ACCEPT;
 
 invalid:
-	DEBUGP("invalid %s: type=%d cid=%u pcid=%u "
-	       "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-	       msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
-	       msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
-	       ntohs(info->pns_call_id), ntohs(info->pac_call_id));
+	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
+		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
+		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
+		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
 }
 
@@ -524,7 +521,7 @@ conntrack_pptp_help(struct sk_buff **pskb, unsigned int protoff,
 
 	pptph = skb_header_pointer(*pskb, nexthdr_off, sizeof(_pptph), &_pptph);
 	if (!pptph) {
-		DEBUGP("no full PPTP header, can't track\n");
+		pr_debug("no full PPTP header, can't track\n");
 		return NF_ACCEPT;
 	}
 	nexthdr_off += sizeof(_pptph);
@@ -533,7 +530,7 @@ conntrack_pptp_help(struct sk_buff **pskb, unsigned int protoff,
 	/* if it's not a control message we can't do anything with it */
 	if (ntohs(pptph->packetType) != PPTP_PACKET_CONTROL ||
 	    ntohl(pptph->magicCookie) != PPTP_MAGIC_COOKIE) {
-		DEBUGP("not a control packet\n");
+		pr_debug("not a control packet\n");
 		return NF_ACCEPT;
 	}
 
@@ -569,8 +566,8 @@ conntrack_pptp_help(struct sk_buff **pskb, unsigned int protoff,
 		/* server -> client (PAC -> PNS) */
 		ret = pptp_inbound_pkt(pskb, ctlh, pptpReq, reqlen, ct,
 				       ctinfo);
-	DEBUGP("sstate: %d->%d, cstate: %d->%d\n",
-		oldsstate, info->sstate, oldcstate, info->cstate);
+	pr_debug("sstate: %d->%d, cstate: %d->%d\n",
+		 oldsstate, info->sstate, oldcstate, info->cstate);
 	spin_unlock_bh(&nf_pptp_lock);
 
 	return ret;
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 339c397..771c4c2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -40,12 +40,6 @@
 #define GRE_TIMEOUT		(30 * HZ)
 #define GRE_STREAM_TIMEOUT	(180 * HZ)
 
-#if 0
-#define DEBUGP(format, args...)	printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
-
 static DEFINE_RWLOCK(nf_ct_gre_lock);
 static LIST_HEAD(gre_keymap_list);
 
@@ -87,7 +81,7 @@ static __be16 gre_keymap_lookup(struct nf_conntrack_tuple *t)
 	}
 	read_unlock_bh(&nf_ct_gre_lock);
 
-	DEBUGP("lookup src key 0x%x for ", key);
+	pr_debug("lookup src key 0x%x for ", key);
 	NF_CT_DUMP_TUPLE(t);
 
 	return key;
@@ -107,8 +101,8 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			if (gre_key_cmpfn(km, t) && km == *kmp)
 				return 0;
 		}
-		DEBUGP("trying to override keymap_%s for ct %p\n",
-			dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
+		pr_debug("trying to override keymap_%s for ct %p\n",
+			 dir == IP_CT_DIR_REPLY ? "reply" : "orig", ct);
 		return -EEXIST;
 	}
 
@@ -118,7 +112,7 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	memcpy(&km->tuple, t, sizeof(*t));
 	*kmp = km;
 
-	DEBUGP("adding new entry %p: ", km);
+	pr_debug("adding new entry %p: ", km);
 	NF_CT_DUMP_TUPLE(&km->tuple);
 
 	write_lock_bh(&nf_ct_gre_lock);
@@ -135,13 +129,13 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
 	struct nf_conn_help *help = nfct_help(ct);
 	enum ip_conntrack_dir dir;
 
-	DEBUGP("entering for ct %p\n", ct);
+	pr_debug("entering for ct %p\n", ct);
 
 	write_lock_bh(&nf_ct_gre_lock);
 	for (dir = IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
 		if (help->help.ct_pptp_info.keymap[dir]) {
-			DEBUGP("removing %p from list\n",
-				help->help.ct_pptp_info.keymap[dir]);
+			pr_debug("removing %p from list\n",
+				 help->help.ct_pptp_info.keymap[dir]);
 			list_del(&help->help.ct_pptp_info.keymap[dir]->list);
 			kfree(help->help.ct_pptp_info.keymap[dir]);
 			help->help.ct_pptp_info.keymap[dir] = NULL;
@@ -186,7 +180,7 @@ static int gre_pkt_to_tuple(const struct sk_buff *skb,
 		return 1;
 
 	if (ntohs(grehdr->protocol) != GRE_PROTOCOL_PPTP) {
-		DEBUGP("GRE_VERSION_PPTP but unknown proto\n");
+		pr_debug("GRE_VERSION_PPTP but unknown proto\n");
 		return 0;
 	}
 
@@ -242,7 +236,7 @@ static int gre_packet(struct nf_conn *ct,
 static int gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 		   unsigned int dataoff)
 {
-	DEBUGP(": ");
+	pr_debug(": ");
 	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	/* initialize to sane value.  Ideally a conntrack helper
@@ -258,10 +252,10 @@ static int gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 static void gre_destroy(struct nf_conn *ct)
 {
 	struct nf_conn *master = ct->master;
-	DEBUGP(" entering\n");
+	pr_debug(" entering\n");
 
 	if (!master)
-		DEBUGP("no master !?!\n");
+		pr_debug("no master !?!\n");
 	else
 		nf_ct_gre_keymap_destroy(master);
 }
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0d3254b..265769e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -25,12 +25,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
-#if 0
-#define DEBUGP(format, ...) printk(format, ## __VA_ARGS__)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Protects conntrack->proto.sctp */
 static DEFINE_RWLOCK(sctp_lock);
 
@@ -151,9 +145,6 @@ static int sctp_pkt_to_tuple(const struct sk_buff *skb,
 {
 	sctp_sctphdr_t _hdr, *hp;
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
 	if (hp == NULL)
@@ -167,9 +158,6 @@ static int sctp_pkt_to_tuple(const struct sk_buff *skb,
 static int sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
 			     const struct nf_conntrack_tuple *orig)
 {
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	tuple->src.u.sctp.port = orig->dst.u.sctp.port;
 	tuple->dst.u.sctp.port = orig->src.u.sctp.port;
 	return 1;
@@ -179,9 +167,6 @@ static int sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
 static int sctp_print_tuple(struct seq_file *s,
 			    const struct nf_conntrack_tuple *tuple)
 {
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	return seq_printf(s, "sport=%hu dport=%hu ",
 			  ntohs(tuple->src.u.sctp.port),
 			  ntohs(tuple->dst.u.sctp.port));
@@ -193,9 +178,6 @@ static int sctp_print_conntrack(struct seq_file *s,
 {
 	enum sctp_conntrack state;
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	read_lock_bh(&sctp_lock);
 	state = conntrack->proto.sctp.state;
 	read_unlock_bh(&sctp_lock);
@@ -219,13 +201,10 @@ static int do_basic_checks(struct nf_conn *conntrack,
 	sctp_chunkhdr_t _sch, *sch;
 	int flag;
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	flag = 0;
 
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		DEBUGP("Chunk Num: %d  Type: %d\n", count, sch->type);
+		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
 
 		if (sch->type == SCTP_CID_INIT
 			|| sch->type == SCTP_CID_INIT_ACK
@@ -242,7 +221,7 @@ static int do_basic_checks(struct nf_conn *conntrack,
 			|| sch->type == SCTP_CID_COOKIE_ECHO
 			|| flag)
 		      && count !=0) || !sch->length) {
-			DEBUGP("Basic checks failed\n");
+			pr_debug("Basic checks failed\n");
 			return 1;
 		}
 
@@ -251,7 +230,7 @@ static int do_basic_checks(struct nf_conn *conntrack,
 		}
 	}
 
-	DEBUGP("Basic checks passed\n");
+	pr_debug("Basic checks passed\n");
 	return count == 0;
 }
 
@@ -261,50 +240,47 @@ static int new_state(enum ip_conntrack_dir dir,
 {
 	int i;
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
-	DEBUGP("Chunk type: %d\n", chunk_type);
+	pr_debug("Chunk type: %d\n", chunk_type);
 
 	switch (chunk_type) {
 		case SCTP_CID_INIT:
-			DEBUGP("SCTP_CID_INIT\n");
+			pr_debug("SCTP_CID_INIT\n");
 			i = 0; break;
 		case SCTP_CID_INIT_ACK:
-			DEBUGP("SCTP_CID_INIT_ACK\n");
+			pr_debug("SCTP_CID_INIT_ACK\n");
 			i = 1; break;
 		case SCTP_CID_ABORT:
-			DEBUGP("SCTP_CID_ABORT\n");
+			pr_debug("SCTP_CID_ABORT\n");
 			i = 2; break;
 		case SCTP_CID_SHUTDOWN:
-			DEBUGP("SCTP_CID_SHUTDOWN\n");
+			pr_debug("SCTP_CID_SHUTDOWN\n");
 			i = 3; break;
 		case SCTP_CID_SHUTDOWN_ACK:
-			DEBUGP("SCTP_CID_SHUTDOWN_ACK\n");
+			pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
 			i = 4; break;
 		case SCTP_CID_ERROR:
-			DEBUGP("SCTP_CID_ERROR\n");
+			pr_debug("SCTP_CID_ERROR\n");
 			i = 5; break;
 		case SCTP_CID_COOKIE_ECHO:
-			DEBUGP("SCTP_CID_COOKIE_ECHO\n");
+			pr_debug("SCTP_CID_COOKIE_ECHO\n");
 			i = 6; break;
 		case SCTP_CID_COOKIE_ACK:
-			DEBUGP("SCTP_CID_COOKIE_ACK\n");
+			pr_debug("SCTP_CID_COOKIE_ACK\n");
 			i = 7; break;
 		case SCTP_CID_SHUTDOWN_COMPLETE:
-			DEBUGP("SCTP_CID_SHUTDOWN_COMPLETE\n");
+			pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
 			i = 8; break;
 		default:
 			/* Other chunks like DATA, SACK, HEARTBEAT and
 			its ACK do not cause a change in state */
-			DEBUGP("Unknown chunk type, Will stay in %s\n",
-						sctp_conntrack_names[cur_state]);
+			pr_debug("Unknown chunk type, Will stay in %s\n",
+				 sctp_conntrack_names[cur_state]);
 			return cur_state;
 	}
 
-	DEBUGP("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
-			dir, sctp_conntrack_names[cur_state], chunk_type,
-			sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
+	pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
+		 dir, sctp_conntrack_names[cur_state], chunk_type,
+		 sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
 
 	return sctp_conntracks[dir][i][cur_state];
 }
@@ -323,9 +299,6 @@ static int sctp_packet(struct nf_conn *conntrack,
 	u_int32_t offset, count;
 	char map[256 / sizeof (char)] = {0};
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
 		return -1;
@@ -340,7 +313,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 		&& !test_bit(SCTP_CID_ABORT, (void *)map)
 		&& !test_bit(SCTP_CID_SHUTDOWN_ACK, (void *)map)
 		&& (sh->vtag != conntrack->proto.sctp.vtag[CTINFO2DIR(ctinfo)])) {
-		DEBUGP("Verification tag check failed\n");
+		pr_debug("Verification tag check failed\n");
 		return -1;
 	}
 
@@ -385,8 +358,9 @@ static int sctp_packet(struct nf_conn *conntrack,
 
 		/* Invalid */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
-			DEBUGP("nf_conntrack_sctp: Invalid dir=%i ctype=%u conntrack=%u\n",
-			       CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
+			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
+				 "conntrack=%u\n",
+				 CTINFO2DIR(ctinfo), sch->type, oldsctpstate);
 			write_unlock_bh(&sctp_lock);
 			return -1;
 		}
@@ -402,8 +376,8 @@ static int sctp_packet(struct nf_conn *conntrack,
 					write_unlock_bh(&sctp_lock);
 					return -1;
 			}
-			DEBUGP("Setting vtag %x for dir %d\n",
-					ih->init_tag, !CTINFO2DIR(ctinfo));
+			pr_debug("Setting vtag %x for dir %d\n",
+				 ih->init_tag, !CTINFO2DIR(ctinfo));
 			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
 
@@ -418,7 +392,7 @@ static int sctp_packet(struct nf_conn *conntrack,
 	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED
 		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
-		DEBUGP("Setting assured bit\n");
+		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
 	}
@@ -436,9 +410,6 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 	u_int32_t offset, count;
 	char map[256 / sizeof (char)] = {0};
 
-	DEBUGP(__FUNCTION__);
-	DEBUGP("\n");
-
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
 		return 0;
@@ -461,7 +432,7 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 
 		/* Invalid: delete conntrack */
 		if (newconntrack == SCTP_CONNTRACK_MAX) {
-			DEBUGP("nf_conntrack_sctp: invalid new deleting.\n");
+			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
 			return 0;
 		}
 
@@ -475,8 +446,8 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 				if (ih == NULL)
 					return 0;
 
-				DEBUGP("Setting vtag %x for new conn\n",
-					ih->init_tag);
+				pr_debug("Setting vtag %x for new conn\n",
+					 ih->init_tag);
 
 				conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] =
 								ih->init_tag;
@@ -488,8 +459,8 @@ static int sctp_new(struct nf_conn *conntrack, const struct sk_buff *skb,
 		/* If it is a shutdown ack OOTB packet, we expect a return
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
 		else {
-			DEBUGP("Setting vtag %x for new conn OOTB\n",
-				sh->vtag);
+			pr_debug("Setting vtag %x for new conn OOTB\n",
+				 sh->vtag);
 			conntrack->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
 		}
 
@@ -688,8 +659,6 @@ int __init nf_conntrack_proto_sctp_init(void)
  cleanup_sctp4:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
  out:
-	DEBUGP("SCTP conntrack module loading %s\n",
-					ret ? "failed": "succeeded");
 	return ret;
 }
 
@@ -697,7 +666,6 @@ void __exit nf_conntrack_proto_sctp_fini(void)
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
-	DEBUGP("SCTP conntrack module unloaded\n");
 }
 
 module_init(nf_conntrack_proto_sctp_init);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ccdd5d2..1c8206e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -26,13 +26,6 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
-#if 0
-#define DEBUGP printk
-#define DEBUGP_VARS
-#else
-#define DEBUGP(format, args...)
-#endif
-
 /* Protects conntrack->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
 
@@ -496,7 +489,8 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
-static int tcp_in_window(struct ip_ct_tcp *state,
+static int tcp_in_window(struct nf_conn *ct,
+			 struct ip_ct_tcp *state,
 			 enum ip_conntrack_dir dir,
 			 unsigned int index,
 			 const struct sk_buff *skb,
@@ -506,6 +500,7 @@ static int tcp_in_window(struct ip_ct_tcp *state,
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
+	struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
 	int res;
 
@@ -520,18 +515,17 @@ static int tcp_in_window(struct ip_ct_tcp *state,
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
 		tcp_sack(skb, dataoff, tcph, &sack);
 
-	DEBUGP("tcp_in_window: START\n");
-	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
-	       "seq=%u ack=%u sack=%u win=%u end=%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest),
-		seq, ack, sack, win, end);
-	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale,
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		receiver->td_scale);
+	pr_debug("tcp_in_window: START\n");
+	pr_debug("tcp_in_window: ");
+	NF_CT_DUMP_TUPLE(tuple);
+	pr_debug("seq=%u ack=%u sack=%u win=%u end=%u\n",
+		 seq, ack, sack, win, end);
+	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		 sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 sender->td_scale,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		 receiver->td_scale);
 
 	if (sender->td_end == 0) {
 		/*
@@ -609,23 +603,22 @@ static int tcp_in_window(struct ip_ct_tcp *state,
 		 */
 		seq = end = sender->td_end;
 
-	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
-	       "seq=%u ack=%u sack =%u win=%u end=%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest),
-		seq, ack, sack, win, end);
-	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale,
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		receiver->td_scale);
-
-	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
-		before(seq, sender->td_maxend + 1),
-		after(end, sender->td_end - receiver->td_maxwin - 1),
-		before(sack, receiver->td_end + 1),
-		after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+	pr_debug("tcp_in_window: ");
+	NF_CT_DUMP_TUPLE(tuple);
+	pr_debug("seq=%u ack=%u sack =%u win=%u end=%u\n",
+		 seq, ack, sack, win, end);
+	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
+		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		 sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 sender->td_scale,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		 receiver->td_scale);
+
+	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
+		 before(seq, sender->td_maxend + 1),
+		 after(end, sender->td_end - receiver->td_maxwin - 1),
+		 before(sack, receiver->td_end + 1),
+		 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
 
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
@@ -694,10 +687,10 @@ static int tcp_in_window(struct ip_ct_tcp *state,
 			: "SEQ is over the upper bound (over the window of the receiver)");
 	}
 
-	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
-	       "receiver end=%u maxend=%u maxwin=%u\n",
-		res, sender->td_end, sender->td_maxend, sender->td_maxwin,
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
+	pr_debug("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
+		 "receiver end=%u maxend=%u maxwin=%u\n",
+		 res, sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
 
 	return res;
 }
@@ -711,11 +704,9 @@ void nf_conntrack_tcp_update(struct sk_buff *skb,
 			     int dir)
 {
 	struct tcphdr *tcph = (void *)skb->data + dataoff;
-	__u32 end;
-#ifdef DEBUGP_VARS
 	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[dir];
 	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
-#endif
+	__u32 end;
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, dataoff, tcph);
 
@@ -727,12 +718,12 @@ void nf_conntrack_tcp_update(struct sk_buff *skb,
 		conntrack->proto.tcp.seen[dir].td_end = end;
 	conntrack->proto.tcp.last_end = end;
 	write_unlock_bh(&tcp_lock);
-	DEBUGP("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
-	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale,
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		receiver->td_scale);
+	pr_debug("tcp_update: sender end=%u maxend=%u maxwin=%u scale=%i "
+		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		 sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 sender->td_scale,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		 receiver->td_scale);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tcp_update);
 #endif
@@ -823,6 +814,7 @@ static int tcp_packet(struct nf_conn *conntrack,
 		      int pf,
 		      unsigned int hooknum)
 {
+	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir;
 	struct tcphdr *th, _tcph;
@@ -837,6 +829,7 @@ static int tcp_packet(struct nf_conn *conntrack,
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
+	tuple = &conntrack->tuplehash[dir].tuple;
 
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
@@ -880,9 +873,8 @@ static int tcp_packet(struct nf_conn *conntrack,
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
-		DEBUGP("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
-		       dir, get_conntrack_index(th),
-		       old_state);
+		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
+			 dir, get_conntrack_index(th), old_state);
 		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
@@ -933,7 +925,7 @@ static int tcp_packet(struct nf_conn *conntrack,
 		break;
 	}
 
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, index,
+	if (!tcp_in_window(conntrack, &conntrack->proto.tcp, dir, index,
 			   skb, dataoff, th, pf)) {
 		write_unlock_bh(&tcp_lock);
 		return -NF_ACCEPT;
@@ -942,13 +934,12 @@ static int tcp_packet(struct nf_conn *conntrack,
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
 
-	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
-	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
-		NIPQUAD(iph->saddr), ntohs(th->source),
-		NIPQUAD(iph->daddr), ntohs(th->dest),
-		(th->syn ? 1 : 0), (th->ack ? 1 : 0),
-		(th->fin ? 1 : 0), (th->rst ? 1 : 0),
-		old_state, new_state);
+	pr_debug("tcp_conntracks: ");
+	NF_CT_DUMP_TUPLE(tuple);
+	pr_debug("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
+		 (th->syn ? 1 : 0), (th->ack ? 1 : 0),
+		 (th->fin ? 1 : 0), (th->rst ? 1 : 0),
+		 old_state, new_state);
 
 	conntrack->proto.tcp.state = new_state;
 	if (old_state != new_state
@@ -997,10 +988,8 @@ static int tcp_new(struct nf_conn *conntrack,
 {
 	enum tcp_conntrack new_state;
 	struct tcphdr *th, _tcph;
-#ifdef DEBUGP_VARS
 	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
 	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
-#endif
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
@@ -1012,7 +1001,7 @@ static int tcp_new(struct nf_conn *conntrack,
 
 	/* Invalid: delete conntrack */
 	if (new_state >= TCP_CONNTRACK_MAX) {
-		DEBUGP("nf_ct_tcp: invalid new deleting.\n");
+		pr_debug("nf_ct_tcp: invalid new deleting.\n");
 		return 0;
 	}
 
@@ -1065,12 +1054,12 @@ static int tcp_new(struct nf_conn *conntrack,
 	conntrack->proto.tcp.state = TCP_CONNTRACK_NONE;
 	conntrack->proto.tcp.last_index = TCP_NONE_SET;
 
-	DEBUGP("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
-	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		sender->td_end, sender->td_maxend, sender->td_maxwin,
-		sender->td_scale,
-		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		receiver->td_scale);
+	pr_debug("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
+		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		 sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 sender->td_scale,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		 receiver->td_scale);
 	return 1;
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 627eda7..355d371 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -40,12 +40,6 @@ static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 struct sane_request {
 	__be32 RPC_code;
 #define SANE_NET_START      7   /* RPC code */
@@ -125,15 +119,15 @@ static int help(struct sk_buff **pskb,
 	ct_sane_info->state = SANE_STATE_NORMAL;
 
 	if (datalen < sizeof(struct sane_reply_net_start)) {
-		DEBUGP("nf_ct_sane: NET_START reply too short\n");
+		pr_debug("nf_ct_sane: NET_START reply too short\n");
 		goto out;
 	}
 
 	reply = (struct sane_reply_net_start *)sb_ptr;
 	if (reply->status != htonl(SANE_STATUS_SUCCESS)) {
 		/* saned refused the command */
-		DEBUGP("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
-			ntohl(reply->status));
+		pr_debug("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
+			 ntohl(reply->status));
 		goto out;
 	}
 
@@ -151,9 +145,8 @@ static int help(struct sk_buff **pskb,
 	nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
 			  IPPROTO_TCP, NULL, &reply->port);
 
-	DEBUGP("nf_ct_sane: expect: ");
+	pr_debug("nf_ct_sane: expect: ");
 	NF_CT_DUMP_TUPLE(&exp->tuple);
-	NF_CT_DUMP_TUPLE(&exp->mask);
 
 	/* Can't expect this?  Best to drop packet now. */
 	if (nf_ct_expect_related(exp) != 0)
@@ -176,9 +169,9 @@ static void nf_conntrack_sane_fini(void)
 
 	for (i = 0; i < ports_c; i++) {
 		for (j = 0; j < 2; j++) {
-			DEBUGP("nf_ct_sane: unregistering helper for pf: %d "
-			       "port: %d\n",
-				sane[i][j].tuple.src.l3num, ports[i]);
+			pr_debug("nf_ct_sane: unregistering helper for pf: %d "
+				 "port: %d\n",
+				 sane[i][j].tuple.src.l3num, ports[i]);
 			nf_conntrack_helper_unregister(&sane[i][j]);
 		}
 	}
@@ -217,9 +210,9 @@ static int __init nf_conntrack_sane_init(void)
 				sprintf(tmpname, "sane-%d", ports[i]);
 			sane[i][j].name = tmpname;
 
-			DEBUGP("nf_ct_sane: registering helper for pf: %d "
-			       "port: %d\n",
-				sane[i][j].tuple.src.l3num, ports[i]);
+			pr_debug("nf_ct_sane: registering helper for pf: %d "
+				 "port: %d\n",
+				 sane[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&sane[i][j]);
 			if (ret) {
 				printk(KERN_ERR "nf_ct_sane: failed to "
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5b78f0e..1276a44 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -21,12 +21,6 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP connection tracking helper");
@@ -285,7 +279,7 @@ static int epaddr_len(struct nf_conn *ct, const char *dptr,
 	const char *aux = dptr;
 
 	if (!parse_addr(ct, dptr, &dptr, &addr, limit)) {
-		DEBUGP("ip: %s parse failed.!\n", dptr);
+		pr_debug("ip: %s parse failed.!\n", dptr);
 		return 0;
 	}
 
@@ -344,8 +338,8 @@ int ct_sip_get_info(struct nf_conn *ct,
 				    ct_sip_lnlen(dptr, limit),
 				    hnfo->case_sensitive);
 		if (!aux) {
-			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str,
-			       hnfo->lname);
+			pr_debug("'%s' not found in '%s'.\n", hnfo->ln_str,
+				 hnfo->lname);
 			return -1;
 		}
 		aux += hnfo->ln_strlen;
@@ -356,11 +350,11 @@ int ct_sip_get_info(struct nf_conn *ct,
 
 		*matchoff = (aux - k) + shift;
 
-		DEBUGP("%s match succeeded! - len: %u\n", hnfo->lname,
-		       *matchlen);
+		pr_debug("%s match succeeded! - len: %u\n", hnfo->lname,
+			 *matchlen);
 		return 1;
 	}
-	DEBUGP("%s header not found.\n", hnfo->lname);
+	pr_debug("%s header not found.\n", hnfo->lname);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_info);
@@ -424,7 +418,7 @@ static int sip_help(struct sk_buff **pskb,
 	if (!skb_is_nonlinear(*pskb))
 		dptr = (*pskb)->data + dataoff;
 	else {
-		DEBUGP("Copy of skbuff not supported yet.\n");
+		pr_debug("Copy of skbuff not supported yet.\n");
 		goto out;
 	}
 
@@ -518,7 +512,7 @@ static int __init nf_conntrack_sip_init(void)
 				sprintf(tmpname, "sip-%u", i);
 			sip[i][j].name = tmpname;
 
-			DEBUGP("port #%u: %u\n", i, ports[i]);
+			pr_debug("port #%u: %u\n", i, ports[i]);
 
 			ret = nf_conntrack_helper_register(&sip[i][j]);
 			if (ret) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6af96c6..54498bc 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -25,12 +25,6 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_PROC_FS
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index db0387c..cc19506 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -29,13 +29,6 @@ static int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
-#if 0
-#define DEBUGP(format, args...) printk("%s:%s:" format, \
-				       __FILE__, __FUNCTION__ , ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 unsigned int (*nf_nat_tftp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
 				 struct nf_conntrack_expect *exp) __read_mostly;
@@ -62,7 +55,6 @@ static int tftp_help(struct sk_buff **pskb,
 	case TFTP_OPCODE_READ:
 	case TFTP_OPCODE_WRITE:
 		/* RRQ and WRQ works the same way */
-		DEBUGP("");
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
@@ -73,9 +65,8 @@ static int tftp_help(struct sk_buff **pskb,
 		nf_ct_expect_init(exp, family, &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
-		DEBUGP("expect: ");
+		pr_debug("expect: ");
 		NF_CT_DUMP_TUPLE(&exp->tuple);
-		NF_CT_DUMP_TUPLE(&exp->mask);
 
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
@@ -86,13 +77,13 @@ static int tftp_help(struct sk_buff **pskb,
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
-		DEBUGP("Data/ACK opcode\n");
+		pr_debug("Data/ACK opcode\n");
 		break;
 	case TFTP_OPCODE_ERROR:
-		DEBUGP("Error opcode\n");
+		pr_debug("Error opcode\n");
 		break;
 	default:
-		DEBUGP("Unknown opcode\n");
+		pr_debug("Unknown opcode\n");
 	}
 	return ret;
 }
