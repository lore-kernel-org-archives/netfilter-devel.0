From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] Netfilter:  Get rid of initialized in nat structure:
	use conntrack status bits
Date: Tue, 11 Jan 2005 22:51:31 +1100
Message-ID: <1105444291.19331.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Get rid of initialized in nat structure: use conntrack status bits
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Fairly simple patch to move the "initialized" NAT bitfield to bits in
the 'status' word.  This saves the size of a pointer from the
connection tracking structure.

Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 22:42:16.866838528 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 22:42:19.950369760 +1100
@@ -62,13 +62,11 @@
 /* Noone using conntrack by the time this called. */
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
-	struct ip_nat_info *info = &conn->nat.info;
-
-	if (!info->initialized)
+	if (!(conn->status & IPS_NAT_DONE_MASK))
 		return;
 
 	WRITE_LOCK(&ip_nat_lock);
-	list_del(&info->bysource);
+	list_del(&conn->nat.info.bysource);
 	WRITE_UNLOCK(&ip_nat_lock);
 }
 
@@ -261,14 +259,14 @@
 {
 	struct ip_conntrack_tuple curr_tuple, new_tuple;
 	struct ip_nat_info *info = &conntrack->nat.info;
-	int have_to_hash = !info->initialized;
+	int have_to_hash = !(conntrack->status & IPS_NAT_DONE_MASK);
 	enum ip_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_POST_ROUTING
 		     || hooknum == NF_IP_LOCAL_IN
 		     || hooknum == NF_IP_LOCAL_OUT);
-	IP_NF_ASSERT(!(info->initialized & (1 << maniptype)));
+	BUG_ON(ip_nat_initialized(conntrack, maniptype));
 
 	/* What we've got will look like inverse of reply. Normally
 	   this is what is in the conntrack, except for prior
@@ -305,7 +303,11 @@
 	}
 
 	/* It's done. */
-	info->initialized |= (1 << maniptype);
+	if (maniptype == IP_NAT_MANIP_DST)
+		set_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
+	else
+		set_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
+
 	return NF_ACCEPT;
 }
 
@@ -420,10 +422,11 @@
            start talking to each other without our translation, and be
            confused... --RR */
 	if (inside->icmp.type == ICMP_REDIRECT) {
-		/* Don't care about races here. */
-		if (ct->nat.info.initialized
-		    != ((1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST))
-		    || (ct->status & IPS_NAT_MASK))
+		/* If NAT isn't finished, assume it and drop. */
+		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
+			return 0;
+
+		if (ct->status & IPS_NAT_MASK)
 			return 0;
 	}
 
@@ -503,11 +506,9 @@
 	/* FIXME: Man, this is a hack.  <SIGH> */
 	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
-	
-	/* Initialize fake conntrack so that NAT will skip it */
-	ip_conntrack_untracked.nat.info.initialized |= 
-		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
 
+	/* Initialize fake conntrack so that NAT will skip it */
+	ip_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 	return 0;
 }
 
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-11 22:42:16.870837920 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-11 22:42:19.950369760 +1100
@@ -411,7 +411,7 @@
 	struct ip_nat_range range;
 
 	/* This must be a fresh one. */
-	BUG_ON(ct->nat.info.initialized);
+	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
 
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 21:04:09.000000000 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 22:42:19.953369304 +1100
@@ -287,7 +287,7 @@
 	ret = ipt_do_table(pskb, hooknum, in, out, &nat_table, NULL);
 
 	if (ret == NF_ACCEPT) {
-		if (!(info->initialized & (1 << HOOK2MANIP(hooknum))))
+		if (!ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
 			/* NUL mapping */
 			ret = alloc_null_binding(ct, info, hooknum);
 	}
Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 22:42:10.737770288 +1100
+++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-11 22:42:19.953369304 +1100
@@ -55,9 +55,6 @@
 /* The structure embedded in the conntrack structure. */
 struct ip_nat_info
 {
-	/* Set to zero when conntrack created: bitmask of maniptypes */
-	u_int16_t initialized;
-
 	struct list_head bysource;
 
 	/* Helper (NULL if none). */
Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-11 22:42:16.870837920 +1100
+++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-11 22:42:19.954369152 +1100
@@ -55,6 +55,16 @@
 	/* Connection needs TCP sequence adjusted. */
 	IPS_SEQ_ADJUST_BIT = 6,
 	IPS_SEQ_ADJUST = (1 << IPS_SEQ_ADJUST_BIT),
+
+	/* NAT initialization bits. */
+	IPS_SRC_NAT_DONE_BIT = 7,
+	IPS_SRC_NAT_DONE = (1 << IPS_SRC_NAT_DONE_BIT),
+
+	IPS_DST_NAT_DONE_BIT = 8,
+	IPS_DST_NAT_DONE = (1 << IPS_DST_NAT_DONE_BIT),
+
+	/* Both together */
+	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
 };
 
 #ifdef __KERNEL__
@@ -291,5 +301,12 @@
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
+static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
+				     enum ip_nat_manip_type manip)
+{
+	if (manip == IP_NAT_MANIP_SRC)
+		return test_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
+	return test_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
+}
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
Index: linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.10-bk13-Netfilter.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-11 21:04:09.000000000 +1100
+++ linux-2.6.10-bk13-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-11 22:42:19.956368848 +1100
@@ -118,7 +118,7 @@
 
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
-		if (!(info->initialized & (1 << maniptype))) {
+		if (!ip_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
 			/* LOCAL_IN hook doesn't have a chain!  */
