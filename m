From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] iptables modifications for backwards compatibility
Date: Thu, 25 Nov 2004 15:53:03 +1100
Message-ID: <1101358383.5842.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

1) final_check needs a pointer to the target/match so the size can be
reduced for backwards compatibility.
2) MARK enhanced to take advantage of it.
3) iptables delete-matching-rule code needs to use size if it's less
than the compare mask size (ie. was reduced by backwards compat code).

Index: include/ip6tables.h
===================================================================
--- include/ip6tables.h	(revision 3246)
+++ include/ip6tables.h	(working copy)
@@ -40,7 +40,8 @@
 		     struct ip6t_entry_match **match);
 
 	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
+	void (*final_check)(struct ip6t_entry_match *match,
+			    unsigned int flags);
 
 	/* Prints out the match iff non-NULL: put space at end */
 	void (*print)(const struct ip6t_ip6 *ip,
@@ -89,7 +90,8 @@
 		     struct ip6t_entry_target **target);
 	
 	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
+	void (*final_check)(struct ip6t_entry_target *target,
+			    unsigned int flags);
 
 	/* Prints out the target iff non-NULL: put space at end */
 	void (*print)(const struct ip6t_ip6 *ip,
Index: include/linux/netfilter_ipv4/ipt_MARK.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_MARK.h	(revision 3246)
+++ include/linux/netfilter_ipv4/ipt_MARK.h	(working copy)
@@ -1,12 +1,26 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
 
+struct ipt_mark_target_old_info {
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned long long mark;
+#else
+	unsigned long mark;
+#endif
+};
+
+enum {
+	IPT_MARK_SET=0,
+	IPT_MARK_AND,
+	IPT_MARK_OR
+};
+
 struct ipt_mark_target_info {
 #ifdef KERNEL_64_USERSPACE_32
 	unsigned long long mark;
 #else
 	unsigned long mark;
 #endif
+	u_int8_t mode;
 };
-
 #endif /*_IPT_MARK_H_target*/
Index: include/iptables.h
===================================================================
--- include/iptables.h	(revision 3246)
+++ include/iptables.h	(working copy)
@@ -44,7 +44,7 @@
 		     struct ipt_entry_match **match);
 
 	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
+	void (*final_check)(struct ipt_entry_match *match, unsigned int flags);
 
 	/* Prints out the match iff non-NULL: put space at end */
 	void (*print)(const struct ipt_ip *ip,
@@ -93,7 +93,7 @@
 		     struct ipt_entry_target **target);
 
 	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
+	void (*final_check)(struct ipt_entry_target *target, unsigned int flags);
 
 	/* Prints out the target iff non-NULL: put space at end */
 	void (*print)(const struct ipt_ip *ip,
Index: iptables.c
===================================================================
--- iptables.c	(revision 3259)
+++ iptables.c	(working copy)
@@ -1420,9 +1420,11 @@
 	mptr = mask + sizeof(struct ipt_entry);
 
 	for (matchp = matches; matchp; matchp = matchp->next) {
+		size = matchp->match->userspacesize;
+		if (size > matchp->match->size)
+			size = matchp->match->size;
 		memset(mptr, 0xFF,
-		       IPT_ALIGN(sizeof(struct ipt_entry_match))
-		       + matchp->match->userspacesize);
+		       IPT_ALIGN(sizeof(struct ipt_entry_match)) + size);
 		mptr += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
 	}
 
@@ -2136,10 +2138,11 @@
 	}
 
 	for (matchp = matches; matchp; matchp = matchp->next)
-		matchp->match->final_check(matchp->match->mflags);
+		matchp->match->final_check(matchp->match->m,
+					   matchp->match->mflags);
 
 	if (target)
-		target->final_check(target->tflags);
+		target->final_check(target->t, target->tflags);
 
 	/* Fix me: must put inverse options checking here --MN */
 
Index: extensions/libipt_account.c
===================================================================
--- extensions/libipt_account.c	(revision 3246)
+++ extensions/libipt_account.c	(working copy)
@@ -214,7 +214,7 @@
 }
 
 /* Final check whether network/netmask was specified */
-static void final_check(unsigned int flags) {
+static void final_check(struct ipt_entry_match *match, unsigned int flags) {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "account: You need specify '--aaddr' parameter");
 }
Index: extensions/libipt_connlimit.c
===================================================================
--- extensions/libipt_connlimit.c	(revision 3246)
+++ extensions/libipt_connlimit.c	(working copy)
@@ -79,7 +79,7 @@
 }
 
 /* Final check */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags & 1)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--connlimit-above'");
Index: extensions/libipt_ROUTE.c
===================================================================
--- extensions/libipt_ROUTE.c	(revision 3246)
+++ extensions/libipt_ROUTE.c	(working copy)
@@ -149,7 +149,7 @@
 
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_pkttype.c
===================================================================
--- extensions/libipt_pkttype.c	(revision 3246)
+++ extensions/libipt_pkttype.c	(working copy)
@@ -114,7 +114,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--pkt-type'");
Index: extensions/libipt_TTL.c
===================================================================
--- extensions/libipt_TTL.c	(revision 3246)
+++ extensions/libipt_TTL.c	(working copy)
@@ -1,7 +1,7 @@
 /* Shared library add-on to iptables for the TTL target
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
- * $Id: libipt_TTL.c,v 1.6 2002/05/29 13:08:16 laforge Exp $
+ * $Id$
  *
  * This program is distributed under the terms of GNU GPL
  */
@@ -89,7 +89,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!(flags & IPT_TTL_USED))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_random.c
===================================================================
--- extensions/libip6t_random.c	(revision 3246)
+++ extensions/libip6t_random.c	(working copy)
@@ -99,7 +99,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_CONNMARK.c
===================================================================
--- extensions/libipt_CONNMARK.c	(revision 3246)
+++ extensions/libipt_CONNMARK.c	(working copy)
@@ -119,7 +119,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_connmark.c
===================================================================
--- extensions/libipt_connmark.c	(revision 3246)
+++ extensions/libipt_connmark.c	(working copy)
@@ -95,7 +95,7 @@
 
 /* Final check; must have specified --mark. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_IPV4OPTSSTRIP.c
===================================================================
--- extensions/libipt_IPV4OPTSSTRIP.c	(revision 3246)
+++ extensions/libipt_IPV4OPTSSTRIP.c	(working copy)
@@ -39,7 +39,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_MIRROR.c
===================================================================
--- extensions/libipt_MIRROR.c	(revision 3246)
+++ extensions/libipt_MIRROR.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_childlevel.c
===================================================================
--- extensions/libipt_childlevel.c	(revision 3246)
+++ extensions/libipt_childlevel.c	(working copy)
@@ -69,7 +69,7 @@
 }
 
 /* Final check; must have specified --level. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_ah.c
===================================================================
--- extensions/libip6t_ah.c	(revision 3246)
+++ extensions/libip6t_ah.c	(working copy)
@@ -128,7 +128,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_conntrack.c
===================================================================
--- extensions/libipt_conntrack.c	(revision 3246)
+++ extensions/libipt_conntrack.c	(working copy)
@@ -345,7 +345,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify one or more options");
Index: extensions/libipt_physdev.c
===================================================================
--- extensions/libipt_physdev.c	(revision 3246)
+++ extensions/libipt_physdev.c	(working copy)
@@ -152,7 +152,7 @@
 
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
Index: extensions/libip6t_multiport.c
===================================================================
--- extensions/libip6t_multiport.c	(revision 3246)
+++ extensions/libip6t_multiport.c	(working copy)
@@ -155,7 +155,7 @@
 
 /* Final check; must specify something. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
Index: extensions/libipt_multiport.c
===================================================================
--- extensions/libipt_multiport.c	(revision 3246)
+++ extensions/libipt_multiport.c	(working copy)
@@ -155,7 +155,7 @@
 
 /* Final check; must specify something. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
Index: extensions/libipt_REDIRECT.c
===================================================================
--- extensions/libipt_REDIRECT.c	(revision 3246)
+++ extensions/libipt_REDIRECT.c	(working copy)
@@ -107,7 +107,7 @@
 }
 
 /* Final check; don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 3246)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -122,7 +122,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_CLASSIFY.c
===================================================================
--- extensions/libipt_CLASSIFY.c	(revision 3246)
+++ extensions/libipt_CLASSIFY.c	(working copy)
@@ -72,7 +72,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_fuzzy.c
===================================================================
--- extensions/libip6t_fuzzy.c	(revision 3246)
+++ extensions/libip6t_fuzzy.c	(working copy)
@@ -111,7 +111,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_length.c
===================================================================
--- extensions/libipt_length.c	(revision 3246)
+++ extensions/libipt_length.c	(working copy)
@@ -100,7 +100,7 @@
 
 /* Final check; must have specified --length. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_hashlimit.c
===================================================================
--- extensions/libipt_hashlimit.c	(revision 3246)
+++ extensions/libipt_hashlimit.c	(working copy)
@@ -237,7 +237,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_fuzzy.c
===================================================================
--- extensions/libipt_fuzzy.c	(revision 3246)
+++ extensions/libipt_fuzzy.c	(working copy)
@@ -110,7 +110,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_MASQUERADE.c
===================================================================
--- extensions/libipt_MASQUERADE.c	(revision 3246)
+++ extensions/libipt_MASQUERADE.c	(working copy)
@@ -107,7 +107,7 @@
 }
 
 /* Final check; don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_DSCP.c
===================================================================
--- extensions/libipt_DSCP.c	(revision 3246)
+++ extensions/libipt_DSCP.c	(working copy)
@@ -108,7 +108,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_MARK.c
===================================================================
--- extensions/libipt_MARK.c	(revision 3246)
+++ extensions/libipt_MARK.c	(working copy)
@@ -9,6 +9,9 @@
 /* For 64bit kernel / 32bit userspace */
 #include "../include/linux/netfilter_ipv4/ipt_MARK.h"
 
+#define OLD_TARGET_SIZE (IPT_ALIGN(sizeof(struct ipt_entry_target)) \
+			 + IPT_ALIGN(sizeof(struct ipt_mark_target_old_info)))
+
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -16,12 +19,16 @@
 	printf(
 "MARK target v%s options:\n"
 "  --set-mark value                   Set nfmark value\n"
+"  --and-mark value                   Binary AND the nfmark with value\n"
+"  --or-mark  value                   Binary OR  the nfmark with value\n"
 "\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
+	{ "and-mark", 1, 0, '2' },
+	{ "or-mark", 1, 0, '3' },
 	{ 0 }
 };
 
@@ -38,38 +45,52 @@
       const struct ipt_entry *entry,
       struct ipt_entry_target **target)
 {
+	unsigned int new_flags;
 	struct ipt_mark_target_info *markinfo
 		= (struct ipt_mark_target_info *)(*target)->data;
 
 	switch (c) {
 	case '1':
-#ifdef KERNEL_64_USERSPACE_32
-		if (string_to_number_ll(optarg, 0, 0, 
-				     &markinfo->mark))
-#else
-		if (string_to_number_l(optarg, 0, 0, 
-				     &markinfo->mark))
-#endif
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARK target: Can't specify --set-mark twice");
-		*flags = 1;
+	        markinfo->mode = IPT_MARK_SET;
+		new_flags = 1;
 		break;
-
+	case '2':
+	        markinfo->mode = IPT_MARK_AND;
+		new_flags = 2;
+		break;
+	case '3':
+	        markinfo->mode = IPT_MARK_OR;
+		new_flags = 2;
+ 		break;
 	default:
 		return 0;
 	}
 
+#ifdef KERNEL_64_USERSPACE_32
+	if (string_to_number_ll(optarg, 0, 0,  &markinfo->mark))
+#else
+	if (string_to_number_l(optarg, 0, 0, &markinfo->mark))
+#endif
+		exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "MARK target: Can't specify --set-mark twice");
+
+	*flags = new_flags;
 	return 1;
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "MARK target: Parameter --set-mark is required");
+		           "MARK target: Additional parameter required");
+
+	/* Compatibility mode: use shorter structure. */
+	if (flags == 1)
+		target->u.target_size = OLD_TARGET_SIZE;
 }
 
 #ifdef KERNEL_64_USERSPACE_32
@@ -94,7 +115,22 @@
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
-	printf("MARK set ");
+
+	if (target->u.target_size == OLD_TARGET_SIZE)
+		printf("MARK set ");
+	else {
+		switch (markinfo->mode) {
+		case IPT_MARK_SET:
+			printf("MARK set ");
+			break;
+		case IPT_MARK_AND:
+			printf("MARK and ");
+			break;
+		case IPT_MARK_OR: 
+			printf("MARK or ");
+			break;
+		}
+	}
 	print_mark(markinfo->mark);
 }
 
@@ -105,7 +141,21 @@
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
 
-	printf("--set-mark ");
+	if (target->u.target_size == OLD_TARGET_SIZE)
+		printf("--set-mark ");
+	else {
+		switch (markinfo->mode) {
+		case IPT_MARK_SET:
+			printf("--set-mark ");
+			break;
+		case IPT_MARK_AND:
+			printf("--and-mark ");
+			break;
+		case IPT_MARK_OR: 
+			printf("--or-mark ");
+			break;
+		}
+	}
 	print_mark(markinfo->mark);
 }
 
Index: extensions/libipt_set.c
===================================================================
--- extensions/libipt_set.c	(revision 3246)
+++ extensions/libipt_set.c	(working copy)
@@ -79,7 +79,7 @@
 }
 
 /* Final check; must have specified --set. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_realm.c
===================================================================
--- extensions/libipt_realm.c	(revision 3246)
+++ extensions/libipt_realm.c	(working copy)
@@ -106,7 +106,7 @@
 
 /* Final check; must have specified --mark. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_standard.c
===================================================================
--- extensions/libipt_standard.c	(revision 3246)
+++ extensions/libipt_standard.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 /* Final check; don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_connbytes.c
===================================================================
--- extensions/libipt_connbytes.c	(revision 3246)
+++ extensions/libipt_connbytes.c	(working copy)
@@ -81,7 +81,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes'");
Index: extensions/libipt_tos.c
===================================================================
--- extensions/libipt_tos.c	(revision 3246)
+++ extensions/libipt_tos.c	(working copy)
@@ -121,7 +121,7 @@
 
 /* Final check; must have specified --tos. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_LOG.c
===================================================================
--- extensions/libip6t_LOG.c	(revision 3246)
+++ extensions/libip6t_LOG.c	(working copy)
@@ -176,7 +176,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_POOL.c
===================================================================
--- extensions/libipt_POOL.c	(revision 3246)
+++ extensions/libipt_POOL.c	(working copy)
@@ -87,7 +87,7 @@
 }
 
 /* Final check; don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_TCPLAG.c
===================================================================
--- extensions/libipt_TCPLAG.c	(revision 3246)
+++ extensions/libipt_TCPLAG.c	(working copy)
@@ -163,7 +163,7 @@
  *
  * In this case, no errors are possible
  */
-static void final_check( unsigned int flags ) { }
+static void final_check(struct ipt_entry_target *target, unsigned int flags ) { }
 /*
  * This print is for the purpose of user-readable display
  * such as what "iptables -L" would give. The notes in
Index: extensions/libipt_FTOS.c
===================================================================
--- extensions/libipt_FTOS.c	(revision 3246)
+++ extensions/libipt_FTOS.c	(working copy)
@@ -77,7 +77,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_udp.c
===================================================================
--- extensions/libip6t_udp.c	(revision 3246)
+++ extensions/libip6t_udp.c	(working copy)
@@ -133,7 +133,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_recent.c
===================================================================
--- extensions/libipt_recent.c	(revision 3246)
+++ extensions/libipt_recent.c	(working copy)
@@ -165,7 +165,7 @@
 
 /* Final check; must have specified a specific option. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 
 	if (!flags)
Index: extensions/libipt_random.c
===================================================================
--- extensions/libipt_random.c	(revision 3246)
+++ extensions/libipt_random.c	(working copy)
@@ -98,7 +98,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_unclean.c
===================================================================
--- extensions/libipt_unclean.c	(revision 3246)
+++ extensions/libipt_unclean.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 /* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_ah.c
===================================================================
--- extensions/libipt_ah.c	(revision 3246)
+++ extensions/libipt_ah.c	(working copy)
@@ -107,7 +107,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_dstlimit.c
===================================================================
--- extensions/libipt_dstlimit.c	(revision 3246)
+++ extensions/libipt_dstlimit.c	(working copy)
@@ -218,7 +218,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_nth.c
===================================================================
--- extensions/libipt_nth.c	(revision 3246)
+++ extensions/libipt_nth.c	(working copy)
@@ -176,7 +176,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_mac.c
===================================================================
--- extensions/libipt_mac.c	(revision 3246)
+++ extensions/libipt_mac.c	(working copy)
@@ -97,7 +97,7 @@
 }
 
 /* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_TARPIT.c
===================================================================
--- extensions/libipt_TARPIT.c	(revision 3246)
+++ extensions/libipt_TARPIT.c	(working copy)
@@ -30,7 +30,7 @@
 	return 0;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_ttl.c
===================================================================
--- extensions/libipt_ttl.c	(revision 3246)
+++ extensions/libipt_ttl.c	(working copy)
@@ -1,7 +1,7 @@
 /* Shared library add-on to iptables to add TTL matching support 
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
- * $Id: libipt_ttl.c,v 1.6 2002/05/29 13:08:16 laforge Exp $
+ * $Id$
  *
  * This program is released under the terms of GNU GPL */
 
@@ -82,7 +82,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags) 
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_SNAT.c
===================================================================
--- extensions/libipt_SNAT.c	(revision 3246)
+++ extensions/libipt_SNAT.c	(working copy)
@@ -167,7 +167,7 @@
 }
 
 /* Final check; must have specfied --to-source. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_tcpmss.c
===================================================================
--- extensions/libipt_tcpmss.c	(revision 3246)
+++ extensions/libipt_tcpmss.c	(working copy)
@@ -106,7 +106,7 @@
 
 /* Final check; must have specified --mss. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_connrate.c
===================================================================
--- extensions/libipt_connrate.c	(revision 3246)
+++ extensions/libipt_connrate.c	(working copy)
@@ -113,7 +113,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!(flags & CONNRATE_OPT))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_tcp.c
===================================================================
--- extensions/libip6t_tcp.c	(revision 3246)
+++ extensions/libip6t_tcp.c	(working copy)
@@ -252,7 +252,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_state.c
===================================================================
--- extensions/libipt_state.c	(revision 3246)
+++ extensions/libipt_state.c	(working copy)
@@ -97,7 +97,7 @@
 }
 
 /* Final check; must have specified --state. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--state'");
Index: extensions/libip6t_MARK.c
===================================================================
--- extensions/libip6t_MARK.c	(revision 3246)
+++ extensions/libip6t_MARK.c	(working copy)
@@ -65,7 +65,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_owner.c
===================================================================
--- extensions/libip6t_owner.c	(revision 3246)
+++ extensions/libip6t_owner.c	(working copy)
@@ -198,7 +198,7 @@
 
 /* Final check; must have specified --own. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_dst.c
===================================================================
--- extensions/libip6t_dst.c	(revision 3246)
+++ extensions/libip6t_dst.c	(working copy)
@@ -182,7 +182,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_IPMARK.c
===================================================================
--- extensions/libipt_IPMARK.c	(revision 3246)
+++ extensions/libipt_IPMARK.c	(working copy)
@@ -105,7 +105,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!(flags & IPT_ADDR_USED))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_standard.c
===================================================================
--- extensions/libip6t_standard.c	(revision 3246)
+++ extensions/libip6t_standard.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 /* Final check; don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_esp.c
===================================================================
--- extensions/libipt_esp.c	(revision 3246)
+++ extensions/libipt_esp.c	(working copy)
@@ -107,7 +107,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_HL.c
===================================================================
--- extensions/libip6t_HL.c	(revision 3246)
+++ extensions/libip6t_HL.c	(working copy)
@@ -89,7 +89,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 	if (!(flags & IP6T_HL_USED))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_owner.c
===================================================================
--- extensions/libipt_owner.c	(revision 3246)
+++ extensions/libipt_owner.c	(working copy)
@@ -199,7 +199,7 @@
 
 /* Final check; must have specified --own. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_mport.c
===================================================================
--- extensions/libipt_mport.c	(revision 3246)
+++ extensions/libipt_mport.c	(working copy)
@@ -176,7 +176,7 @@
 
 /* Final check; must specify something. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "mport expects an option");
Index: extensions/libip6t_REJECT.c
===================================================================
--- extensions/libip6t_REJECT.c	(revision 3246)
+++ extensions/libip6t_REJECT.c	(working copy)
@@ -116,7 +116,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_NETLINK.c
===================================================================
--- extensions/libipt_NETLINK.c	(revision 3246)
+++ extensions/libipt_NETLINK.c	(working copy)
@@ -96,7 +96,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	/* ?? */
 }
Index: extensions/libipt_ECN.c
===================================================================
--- extensions/libipt_ECN.c	(revision 3246)
+++ extensions/libipt_ECN.c	(working copy)
@@ -6,7 +6,7 @@
  *
  * libipt_ECN.c borrowed heavily from libipt_DSCP.c
  *
- * $Id: libipt_ECN.c,v 1.11 2002/08/07 10:04:42 laforge Exp $
+ * $Id$
  */
 #include <stdio.h>
 #include <string.h>
@@ -105,7 +105,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_physdev.c
===================================================================
--- extensions/libip6t_physdev.c	(revision 3246)
+++ extensions/libip6t_physdev.c	(working copy)
@@ -152,7 +152,7 @@
 
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
Index: extensions/libipt_sctp.c
===================================================================
--- extensions/libipt_sctp.c	(revision 3246)
+++ extensions/libipt_sctp.c	(working copy)
@@ -335,7 +335,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_u32.c
===================================================================
--- extensions/libipt_u32.c	(revision 3246)
+++ extensions/libipt_u32.c	(working copy)
@@ -229,7 +229,7 @@
 
 /* Final check; must specify something. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_rt.c
===================================================================
--- extensions/libip6t_rt.c	(revision 3246)
+++ extensions/libip6t_rt.c	(working copy)
@@ -240,7 +240,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_condition.c
===================================================================
--- extensions/libip6t_condition.c	(revision 3246)
+++ extensions/libip6t_condition.c	(working copy)
@@ -63,7 +63,7 @@
 
 
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_eui64.c
===================================================================
--- extensions/libip6t_eui64.c	(revision 3246)
+++ extensions/libip6t_eui64.c	(working copy)
@@ -46,7 +46,7 @@
 }
 
 /* Final check */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_record_rpc.c
===================================================================
--- extensions/libipt_record_rpc.c	(revision 3246)
+++ extensions/libipt_record_rpc.c	(working copy)
@@ -36,7 +36,7 @@
 }
 
 /* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_rpc.c
===================================================================
--- extensions/libipt_rpc.c	(revision 3246)
+++ extensions/libipt_rpc.c	(working copy)
@@ -302,7 +302,7 @@
 }
 
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (flags != (flags | IPT_RPC_RPCS)) {
 		printf("%s option \"--rpcs\" was not used ... reverting ", preerr);
Index: extensions/libipt_SAME.c
===================================================================
--- extensions/libipt_SAME.c	(revision 3246)
+++ extensions/libipt_SAME.c	(working copy)
@@ -125,7 +125,7 @@
 }
 
 /* Final check; need --to. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!(flags & IPT_SAME_OPT_TO))
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_condition.c
===================================================================
--- extensions/libipt_condition.c	(revision 3246)
+++ extensions/libipt_condition.c	(working copy)
@@ -63,7 +63,7 @@
 
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_icmp.c
===================================================================
--- extensions/libipt_icmp.c	(revision 3246)
+++ extensions/libipt_icmp.c	(working copy)
@@ -283,7 +283,7 @@
 }
 
 /* Final check; we don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_quota.c
===================================================================
--- extensions/libipt_quota.c	(revision 3246)
+++ extensions/libipt_quota.c	(working copy)
@@ -89,7 +89,7 @@
 
 /* no final check */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_frag.c
===================================================================
--- extensions/libip6t_frag.c	(revision 3246)
+++ extensions/libip6t_frag.c	(working copy)
@@ -159,7 +159,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_string.c
===================================================================
--- extensions/libipt_string.c	(revision 3246)
+++ extensions/libipt_string.c	(working copy)
@@ -185,7 +185,7 @@
 
 /* Final check; must have specified --string. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_ULOG.c
===================================================================
--- extensions/libipt_ULOG.c	(revision 3246)
+++ extensions/libipt_ULOG.c	(working copy)
@@ -151,7 +151,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_XOR.c
===================================================================
--- extensions/libipt_XOR.c	(revision 3246)
+++ extensions/libipt_XOR.c	(working copy)
@@ -61,7 +61,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!(flags & IPT_KEY_SET))
 		exit_error(PARAMETER_PROBLEM, "XOR: You must specify a key");
Index: extensions/libipt_TCPMSS.c
===================================================================
--- extensions/libipt_TCPMSS.c	(revision 3246)
+++ extensions/libipt_TCPMSS.c	(working copy)
@@ -79,7 +79,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_ipv6header.c
===================================================================
--- extensions/libip6t_ipv6header.c	(revision 3246)
+++ extensions/libip6t_ipv6header.c	(working copy)
@@ -227,7 +227,7 @@
 
 /* Checks the flags variable */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags) exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no options specified");
 }
Index: extensions/libipt_dscp.c
===================================================================
--- extensions/libipt_dscp.c	(revision 3246)
+++ extensions/libipt_dscp.c	(working copy)
@@ -118,7 +118,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_hl.c
===================================================================
--- extensions/libip6t_hl.c	(revision 3246)
+++ extensions/libip6t_hl.c	(working copy)
@@ -87,7 +87,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags) 
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_icmpv6.c
===================================================================
--- extensions/libip6t_icmpv6.c	(revision 3246)
+++ extensions/libip6t_icmpv6.c	(working copy)
@@ -253,7 +253,7 @@
 }
 
 /* Final check; we don't care. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_mark.c
===================================================================
--- extensions/libipt_mark.c	(revision 3246)
+++ extensions/libipt_mark.c	(working copy)
@@ -95,7 +95,7 @@
 
 /* Final check; must have specified --mark. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_ipv4options.c
===================================================================
--- extensions/libipt_ipv4options.c	(revision 3246)
+++ extensions/libipt_ipv4options.c	(working copy)
@@ -225,7 +225,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_time.c
===================================================================
--- extensions/libipt_time.c	(revision 3246)
+++ extensions/libipt_time.c	(working copy)
@@ -417,7 +417,7 @@
 
 /* Final check */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	/* Nothing to do */
 }
Index: extensions/libipt_comment.c
===================================================================
--- extensions/libipt_comment.c	(revision 3246)
+++ extensions/libipt_comment.c	(working copy)
@@ -77,7 +77,7 @@
 
 /* Final check; must have specified --comment. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_pool.c
===================================================================
--- extensions/libipt_pool.c	(revision 3246)
+++ extensions/libipt_pool.c	(working copy)
@@ -79,7 +79,7 @@
 }
 
 /* Final check; must have specified --srcpool or --dstpool. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify either `--srcpool or --dstpool'");
Index: extensions/libipt_REJECT.c
===================================================================
--- extensions/libipt_REJECT.c	(revision 3246)
+++ extensions/libipt_REJECT.c	(working copy)
@@ -135,7 +135,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_nth.c
===================================================================
--- extensions/libip6t_nth.c	(revision 3246)
+++ extensions/libip6t_nth.c	(working copy)
@@ -176,7 +176,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_helper.c
===================================================================
--- extensions/libipt_helper.c	(revision 3246)
+++ extensions/libipt_helper.c	(working copy)
@@ -60,7 +60,7 @@
 
 /* Final check; must have specified --helper. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_LOG.c
===================================================================
--- extensions/libipt_LOG.c	(revision 3246)
+++ extensions/libipt_LOG.c	(working copy)
@@ -176,7 +176,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_TRACE.c
===================================================================
--- extensions/libip6t_TRACE.c	(revision 3246)
+++ extensions/libip6t_TRACE.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_NETMAP.c
===================================================================
--- extensions/libipt_NETMAP.c	(revision 3246)
+++ extensions/libipt_NETMAP.c	(working copy)
@@ -142,7 +142,7 @@
 }
 
 /* Final check; need --to */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_BALANCE.c
===================================================================
--- extensions/libipt_BALANCE.c	(revision 3246)
+++ extensions/libipt_BALANCE.c	(working copy)
@@ -91,7 +91,7 @@
 }
 
 /* Final check; need --to-dest. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_mac.c
===================================================================
--- extensions/libip6t_mac.c	(revision 3246)
+++ extensions/libip6t_mac.c	(working copy)
@@ -97,7 +97,7 @@
 }
 
 /* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_udp.c
===================================================================
--- extensions/libipt_udp.c	(revision 3246)
+++ extensions/libipt_udp.c	(working copy)
@@ -133,7 +133,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_SET.c
===================================================================
--- extensions/libipt_SET.c	(revision 3246)
+++ extensions/libipt_SET.c	(working copy)
@@ -100,7 +100,7 @@
 }
 
 /* Final check; must specify at least one. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_TRACE.c
===================================================================
--- extensions/libipt_TRACE.c	(revision 3246)
+++ extensions/libipt_TRACE.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libipt_NOTRACK.c
===================================================================
--- extensions/libipt_NOTRACK.c	(revision 3246)
+++ extensions/libipt_NOTRACK.c	(working copy)
@@ -37,7 +37,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_limit.c
===================================================================
--- extensions/libip6t_limit.c	(revision 3246)
+++ extensions/libip6t_limit.c	(working copy)
@@ -130,7 +130,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_ecn.c
===================================================================
--- extensions/libipt_ecn.c	(revision 3246)
+++ extensions/libipt_ecn.c	(working copy)
@@ -93,7 +93,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_TOS.c
===================================================================
--- extensions/libipt_TOS.c	(revision 3246)
+++ extensions/libipt_TOS.c	(working copy)
@@ -109,7 +109,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_length.c
===================================================================
--- extensions/libip6t_length.c	(revision 3246)
+++ extensions/libip6t_length.c	(working copy)
@@ -102,7 +102,7 @@
 
 /* Final check; must have specified --length. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_CLUSTERIP.c
===================================================================
--- extensions/libipt_CLUSTERIP.c	(revision 3246)
+++ extensions/libipt_CLUSTERIP.c	(working copy)
@@ -151,7 +151,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (flags == 0)
 		return;
Index: extensions/libip6t_esp.c
===================================================================
--- extensions/libip6t_esp.c	(revision 3246)
+++ extensions/libip6t_esp.c	(working copy)
@@ -106,7 +106,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_limit.c
===================================================================
--- extensions/libipt_limit.c	(revision 3246)
+++ extensions/libipt_limit.c	(working copy)
@@ -130,7 +130,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libip6t_mark.c
===================================================================
--- extensions/libip6t_mark.c	(revision 3246)
+++ extensions/libip6t_mark.c	(working copy)
@@ -95,7 +95,7 @@
 
 /* Final check; must have specified --mark. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libip6t_ROUTE.c
===================================================================
--- extensions/libip6t_ROUTE.c	(revision 3246)
+++ extensions/libip6t_ROUTE.c	(working copy)
@@ -129,7 +129,7 @@
 
 
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_iprange.c
===================================================================
--- extensions/libipt_iprange.c	(revision 3246)
+++ extensions/libipt_iprange.c	(working copy)
@@ -110,7 +110,7 @@
 
 /* Final check; must have specified --src-range or --dst-range. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_psd.c
===================================================================
--- extensions/libipt_psd.c	(revision 3246)
+++ extensions/libipt_psd.c	(working copy)
@@ -142,7 +142,7 @@
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_DNAT.c
===================================================================
--- extensions/libipt_DNAT.c	(revision 3246)
+++ extensions/libipt_DNAT.c	(working copy)
@@ -167,7 +167,7 @@
 }
 
 /* Final check; must have specfied --to-source. */
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_target *target, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_tcp.c
===================================================================
--- extensions/libipt_tcp.c	(revision 3246)
+++ extensions/libipt_tcp.c	(working copy)
@@ -252,7 +252,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 }
 
Index: extensions/libipt_osf.c
===================================================================
--- extensions/libipt_osf.c	(revision 3246)
+++ extensions/libipt_osf.c	(working copy)
@@ -115,7 +115,7 @@
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void final_check(struct ipt_entry_match *match, unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "OS fingerprint match: You must specify `--genre'");
Index: extensions/libip6t_hbh.c
===================================================================
--- extensions/libip6t_hbh.c	(revision 3246)
+++ extensions/libip6t_hbh.c	(working copy)
@@ -180,7 +180,7 @@
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+final_check(struct ip6t_entry_match *match, unsigned int flags)
 {
 }
 

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
