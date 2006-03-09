From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: [PATCH][RFC] iptables patch for: Unifiy logging in netfilter
	using nf_log, take #1
Date: Thu, 9 Mar 2006 20:36:37 +0100
Message-ID: <20060309193637.GB20613@net.in.tum.de>
References: <20060304173815.GA12715@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060304173815.GA12715@net.in.tum.de>
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


[PATCH][RFC] This patch adds support for the modified LOG targets
from the nf-log-unification patch. 

* Support for syslog and libnetfilter_log backend
* The nf-log backends can be combined (log to one
    backend, log to both, log to none)
* semantics of "old" LOG target are preserved


Signed-off-by: Gregor Maier <gregor@net.in.tum.de>

===================================================================
Index: include/linux/netfilter/xt_LOG.h
===================================================================
--- include/linux/netfilter/xt_LOG.h	(revision 0)
+++ include/linux/netfilter/xt_LOG.h	(revision 0)
@@ -0,0 +1,23 @@
+/* iptables module for logging / LOG target
+ *
+ * (C) 2006 Gregor Maier <gregor@majordomus.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+*/
+#ifndef _XT_LOG_TARGET_H
+#define _XT_LOG_TARGET_H
+
+/* This file intentionally left empty
+ *
+ * When the kernel doesn't provive xt_LOG.h this file will
+ * be included, so the preprocessor won't complain 
+ *
+ * In the "real" xt_LOG.h file XT_LOG_BACKEND_SYSLOG is defined
+ * and we use this to determine if the xt_LOG target is used
+ * or the ipt_LOG, ip6t_LOG targets 
+ *
+ * XXX: There must be a way to do this more nicely
+ */
+
+#endif /* _XT_LOG_TARGET_H */
Index: extensions/libip6t_LOG.c
===================================================================
--- extensions/libip6t_LOG.c	(revision 6554)
+++ extensions/libip6t_LOG.c	(working copy)
@@ -1,4 +1,4 @@
-/* Shared library add-on to iptables to add LOG support. */
+/* Shared library add-on to ip6tables to add LOG support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -6,35 +6,55 @@
 #include <syslog.h>
 #include <getopt.h>
 #include <ip6tables.h>
+/* xt_LOG.h is either from the kernel (then xt_LOG target is
+ * available) and XT_LOG_BACKEND_* are defined). Otherwise
+ * xt_LOG.h from the iptables include dir is used and XT_LOG_BACKEND_
+ * is not defined
+ */
+#include <linux/netfilter/xt_LOG.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+
+#ifndef XT_LOG_BACKEND_SYSLOG   
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
+#define xt_log_info ip6t_log_info
+#endif
+	
 
-#ifndef IP6T_LOG_UID	/* Old kernel */
-#define IP6T_LOG_UID	0x08
+#define LOG_DEFAULT_LEVEL LOG_WARNING
+
+#ifndef IP6T_LOG_UID /* Old kernel */
+#define IP6T_LOG_UID	0x08	/* Log UID owning local socket */
 #undef  IP6T_LOG_MASK
 #define IP6T_LOG_MASK	0x0f
 #endif
 
-#define LOG_DEFAULT_LEVEL LOG_WARNING
-
 /* Function which prints out usage message. */
 static void
 help(void)
 {
 	printf(
 "LOG v%s options:\n"
+" --log-prefix prefix		Prefix log messages with this prefix.\n"
+#ifdef XT_LOG_BACKEND_SYSLOG
+" --log-no-syslog		Do not use syslog backend for logging\n" 
+" --log-group group		Log to nf_netlink_log group group (0 - 65535)\n" 
+" Options when using syslog backend:\n"
+#endif
 " --log-level level		Level of logging (numeric or see syslog.conf)\n"
-" --log-prefix prefix		Prefix log messages with this prefix.\n\n"
-" --log-tcp-sequence		Log TCP sequence numbers.\n\n"
-" --log-tcp-options		Log TCP options.\n\n"
-" --log-ip-options		Log IP options.\n\n"
+" --log-tcp-sequence		Log TCP sequence numbers.\n"
+" --log-tcp-options		Log TCP options.\n"
+" --log-ip-options		Log IP options.\n"
 " --log-uid			Log UID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
+	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
+#ifdef XT_LOG_BACKEND_SYSLOG
+	{ .name = "log-no-syslog",    .has_arg = 0, .flag = 0, .val = 's' },
+	{ .name = "log-group",        .has_arg = 1, .flag = 0, .val = 'g' },
+#endif
 	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
-	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
 	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
 	{ .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val = '3' },
@@ -46,8 +66,11 @@
 static void
 init(struct ip6t_entry_target *t, unsigned int *nfcache)
 {
-	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)t->data;
+	struct xt_log_info *loginfo = (struct xt_log_info *)t->data;
 
+#ifdef XT_LOG_BACKEND_SYSLOG
+	loginfo->backends = XT_LOG_BACKEND_SYSLOG;
+#endif
 	loginfo->level = LOG_DEFAULT_LEVEL;
 
 }
@@ -105,6 +128,11 @@
 #define IP6T_LOG_OPT_TCPOPT 0x08
 #define IP6T_LOG_OPT_IPOPT 0x10
 #define IP6T_LOG_OPT_UID 0x20
+/* We don't ifdef those, since they don't hurt. And we can use them in parse to
+ * save tons of ifdefs */
+#define IP6T_LOG_OPT_SYSLOG_MASK (IP6T_LOG_OPT_LEVEL | IP6T_LOG_OPT_TCPSEQ | IP6T_LOG_OPT_TCPOPT | IP6T_LOG_OPT_IPOPT | IP6T_LOG_OPT_UID)
+#define IP6T_LOG_OPT_NO_SYSLOG 0x40
+#define IP6T_LOG_OPT_GROUP 0x80
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -113,10 +141,45 @@
       const struct ip6t_entry *entry,
       struct ip6t_entry_target **target)
 {
-	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
+	struct xt_log_info *loginfo = (struct xt_log_info *)(*target)->data;
 
 	switch (c) {
+#ifdef XT_LOG_BACKEND_SYSLOG  /* kernel with stackable loggers */
+		unsigned group;
+	case 's':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-no-syslog twice");
+
+		/* check if any of the syslog related opts has been specified */
+		if (*flags & IP6T_LOG_OPT_SYSLOG_MASK)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-no-syslog when using syslog only options");
+		loginfo->backends &= (~XT_LOG_BACKEND_SYSLOG);
+		*flags |= IP6T_LOG_OPT_NO_SYSLOG;
+		break;
+
+	case 'g':
+		if (*flags & IP6T_LOG_OPT_GROUP)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-group twice");
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --log-group");
+		if (string_to_number(optarg, 0, 65535, &group) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "--log-group has to be between 0 and 65535");
+		loginfo->group = group;
+		loginfo->backends |= XT_LOG_BACKEND_NFLOG;
+		*flags |= IP6T_LOG_OPT_GROUP;
+		break;
+#endif
+/* We can savely check for IP6T_LOG_OPT_NO_SYSLOG without the need for ifdefs */
 	case '!':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-level when not logging to syslog");
+
 		if (*flags & IP6T_LOG_OPT_LEVEL)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
@@ -152,6 +215,10 @@
 		break;
 
 	case '1':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-tcp-sequence when not logging to syslog");
+
 		if (*flags & IP6T_LOG_OPT_TCPSEQ)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-sequence "
@@ -162,6 +229,10 @@
 		break;
 
 	case '2':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-tcp-options when not logging to syslog");
+
 		if (*flags & IP6T_LOG_OPT_TCPOPT)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-options twice");
@@ -171,6 +242,10 @@
 		break;
 
 	case '3':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-ip-options when not logging to syslog");
+
 		if (*flags & IP6T_LOG_OPT_IPOPT)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-ip-options twice");
@@ -180,10 +255,14 @@
 		break;
 
 	case '4':
+		if (*flags & IP6T_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-uid when not logging to syslog");
+
 		if (*flags & IP6T_LOG_OPT_UID)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-uid twice");
-
+		
 		loginfo->logflags |= IP6T_LOG_UID;
 		*flags |= IP6T_LOG_OPT_UID;
 		break;
@@ -206,35 +285,63 @@
       const struct ip6t_entry_target *target,
       int numeric)
 {
-	const struct ip6t_log_info *loginfo
-		= (const struct ip6t_log_info *)target->data;
+	const struct xt_log_info *loginfo
+		= (const struct xt_log_info *)target->data;
 	unsigned int i = 0;
+	/* These flag saves some ifdefs and thus make the code more readable */
+	int use_syslog = 1; /* is uselog used as backend ? */
 
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (!(loginfo->backends & XT_LOG_BACKEND_SYSLOG))
+			use_syslog = 0;
+#endif
+
 	printf("LOG ");
-	if (numeric)
-		printf("flags %u level %u ",
-		       loginfo->logflags, loginfo->level);
+	if (numeric) {
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+			printf("group %u ", loginfo->group);
+#endif
+
+		if (!use_syslog)
+			printf("no-syslog ");
+		else 
+			printf("flags %u level %u ",
+			       loginfo->logflags, loginfo->level);
+	}
 	else {
-		for (i = 0;
-		     i < sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names);
-		     i++) {
-			if (loginfo->level == ip6t_log_names[i].level) {
-				printf("level %s ", ip6t_log_names[i].name);
-				break;
+		if (use_syslog) {
+			for (i = 0;
+			     i < sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names);
+			     i++) {
+				if (loginfo->level == ip6t_log_names[i].level) {
+					printf("level %s ", ip6t_log_names[i].name);
+					break;
+				}
 			}
 		}
-		if (i == sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names))
-			printf("UNKNOWN level %u ", loginfo->level);
-		if (loginfo->logflags & IP6T_LOG_TCPSEQ)
-			printf("tcp-sequence ");
-		if (loginfo->logflags & IP6T_LOG_TCPOPT)
-			printf("tcp-options ");
-		if (loginfo->logflags & IP6T_LOG_IPOPT)
-			printf("ip-options ");
-		if (loginfo->logflags & IP6T_LOG_UID)
-			printf("uid ");
-		if (loginfo->logflags & ~(IP6T_LOG_MASK))
-			printf("unknown-flags ");
+
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+			printf("group %u ", loginfo->group);
+#endif
+		if (!use_syslog) {
+			printf("no-syslog ");
+		}
+		else {
+			if (i == sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names))
+				printf("UNKNOWN level %u ", loginfo->level);
+			if (loginfo->logflags & IP6T_LOG_TCPSEQ)
+				printf("tcp-sequence ");
+			if (loginfo->logflags & IP6T_LOG_TCPOPT)
+				printf("tcp-options ");
+			if (loginfo->logflags & IP6T_LOG_IPOPT)
+				printf("ip-options ");
+			if (loginfo->logflags & IP6T_LOG_UID)
+				printf("uid ");
+			if (loginfo->logflags & ~(IP6T_LOG_MASK))
+				printf("unknown-flags ");
+		}
 	}
 
 	if (strcmp(loginfo->prefix, "") != 0)
@@ -245,14 +352,21 @@
 static void
 save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
 {
-	const struct ip6t_log_info *loginfo
-		= (const struct ip6t_log_info *)target->data;
-
+	const struct xt_log_info *loginfo
+		= (const struct xt_log_info *)target->data;
+#ifdef XT_LOG_BACKEND_SYSLOG
+	if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+		printf("--log-group %u ", loginfo->group);
+	if (!(loginfo->backends & XT_LOG_BACKEND_SYSLOG))
+		printf("--log-no-syslog ");
+#endif
+	/* Don't need to check for no-syslog, since the options won't be set if
+	 * not logging to syslog */
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
-		printf("--log-level %d ", loginfo->level);
+		printf("--log-level %u ", loginfo->level);
 
 	if (loginfo->logflags & IP6T_LOG_TCPSEQ)
 		printf("--log-tcp-sequence ");
@@ -269,8 +383,9 @@
 = {
     .name          = "LOG",
     .version       = IPTABLES_VERSION,
-    .size          = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
-    .userspacesize = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
+/* IP6T_ALIGN is defined as XT_ALIGN if available */
+    .size          = IP6T_ALIGN(sizeof(struct xt_log_info)), 
+    .userspacesize = IP6T_ALIGN(sizeof(struct xt_log_info)),
     .help          = &help,
     .init          = &init,
     .parse         = &parse,
Index: extensions/libip6t_LOG.man
===================================================================
--- extensions/libip6t_LOG.man	(revision 6554)
+++ extensions/libip6t_LOG.man	(working copy)
@@ -1,22 +1,39 @@
 Turn on kernel logging of matching packets.  When this option is set
-for a rule, the Linux kernel will print some information on all
-matching packets (like most IPv6 IPv6-header fields) via the kernel log
-(where it can be read with
+for a rule, the Linux kernel logs this packet to all specified logging
+backends. There is a syslog backend, which prints some 
+information on matching packets (like most IPv6 header fields) via the
+kernel log (where it can be read with
 .I dmesg
 or 
 .IR syslogd (8)).
-This is a "non-terminating target", i.e. rule traversal continues at
-the next rule.  So if you want to LOG the packets you refuse, use two
-separate rules with the same matching criteria, first using target LOG
-then DROP (or REJECT).
+The other backend is nfnetlink_log, which passes 
+packets to userspace to be handled there. Userspace processes my
+subsribe to various log groups and receive the packets. A packet can be
+logged to any number of backends. Default is to log only to the syslog 
+backend. 
+This is a "non-terminating target", i.e. rule traversal 
+continues at the next rule.  So if you want to LOG the packets you 
+refuse, use two separate rules with the same matching criteria, first
+using target LOG then DROP (or REJECT).
 .TP
-.BI "--log-level " "level"
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
-.TP
 .BI "--log-prefix " "prefix"
 Prefix log messages with the specified prefix; up to 29 letters long,
 and useful for distinguishing messages in the logs.
 .TP
+.B --log-no-syslog
+Do not log to syslog backend. 
+.TP
+.B Options for nfnetlink_log backend
+.TP
+.BI "--log-group " "group"
+Log this packet to nfnetlink_log backend. Group specifies the log group for
+this target.
+.TP
+.B Options for syslog backend
+.TP
+.BI "--log-level " "level"
+Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+.TP
 .B --log-tcp-sequence
 Log TCP sequence numbers. This is a security risk if the log is
 readable by users.
Index: extensions/libipt_LOG.c
===================================================================
--- extensions/libipt_LOG.c	(revision 6554)
+++ extensions/libipt_LOG.c	(working copy)
@@ -6,8 +6,19 @@
 #include <syslog.h>
 #include <getopt.h>
 #include <iptables.h>
+/* xt_LOG.h is either from the kernel (then xt_LOG target is
+ * available) and XT_LOG_BACKEND_* are defined). Otherwise
+ * xt_LOG.h from the iptables include dir is used and XT_LOG_BACKEND_
+ * is not defined
+ */
+#include <linux/netfilter/xt_LOG.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+
+#ifndef XT_LOG_BACKEND_SYSLOG   
 #include <linux/netfilter_ipv4/ipt_LOG.h>
+#define xt_log_info ipt_log_info
+#endif
+	
 
 #define LOG_DEFAULT_LEVEL LOG_WARNING
 
@@ -23,18 +34,27 @@
 {
 	printf(
 "LOG v%s options:\n"
+" --log-prefix prefix		Prefix log messages with this prefix.\n"
+#ifdef XT_LOG_BACKEND_SYSLOG
+" --log-no-syslog		Do not use syslog backend for logging\n" 
+" --log-group group		Log to nf_netlink_log group group (0 - 65535)\n" 
+" Options when using syslog backend:\n"
+#endif
 " --log-level level		Level of logging (numeric or see syslog.conf)\n"
-" --log-prefix prefix		Prefix log messages with this prefix.\n\n"
-" --log-tcp-sequence		Log TCP sequence numbers.\n\n"
-" --log-tcp-options		Log TCP options.\n\n"
-" --log-ip-options		Log IP options.\n\n"
+" --log-tcp-sequence		Log TCP sequence numbers.\n"
+" --log-tcp-options		Log TCP options.\n"
+" --log-ip-options		Log IP options.\n"
 " --log-uid			Log UID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
+	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
+#ifdef XT_LOG_BACKEND_SYSLOG
+	{ .name = "log-no-syslog",    .has_arg = 0, .flag = 0, .val = 's' },
+	{ .name = "log-group",        .has_arg = 1, .flag = 0, .val = 'g' },
+#endif
 	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
-	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
 	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
 	{ .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val = '3' },
@@ -46,8 +66,11 @@
 static void
 init(struct ipt_entry_target *t, unsigned int *nfcache)
 {
-	struct ipt_log_info *loginfo = (struct ipt_log_info *)t->data;
+	struct xt_log_info *loginfo = (struct xt_log_info *)t->data;
 
+#ifdef XT_LOG_BACKEND_SYSLOG
+	loginfo->backends = XT_LOG_BACKEND_SYSLOG;
+#endif
 	loginfo->level = LOG_DEFAULT_LEVEL;
 
 }
@@ -105,6 +128,11 @@
 #define IPT_LOG_OPT_TCPOPT 0x08
 #define IPT_LOG_OPT_IPOPT 0x10
 #define IPT_LOG_OPT_UID 0x20
+/* We don't ifdef those, since they don't hurt. And we can use them in parse to
+ * save tons of ifdefs */
+#define IPT_LOG_OPT_SYSLOG_MASK (IPT_LOG_OPT_LEVEL | IPT_LOG_OPT_TCPSEQ | IPT_LOG_OPT_TCPOPT | IPT_LOG_OPT_IPOPT | IPT_LOG_OPT_UID)
+#define IPT_LOG_OPT_NO_SYSLOG 0x40
+#define IPT_LOG_OPT_GROUP 0x80
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -113,10 +141,45 @@
       const struct ipt_entry *entry,
       struct ipt_entry_target **target)
 {
-	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
+	struct xt_log_info *loginfo = (struct xt_log_info *)(*target)->data;
 
 	switch (c) {
+#ifdef XT_LOG_BACKEND_SYSLOG  /* kernel with stackable loggers */
+		unsigned group;
+	case 's':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-no-syslog twice");
+
+		/* check if any of the syslog related opts has been specified */
+		if (*flags & IPT_LOG_OPT_SYSLOG_MASK)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-no-syslog when using syslog only options");
+		loginfo->backends &= (~XT_LOG_BACKEND_SYSLOG);
+		*flags |= IPT_LOG_OPT_NO_SYSLOG;
+		break;
+
+	case 'g':
+		if (*flags & IPT_LOG_OPT_GROUP)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-group twice");
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --log-group");
+		if (string_to_number(optarg, 0, 65535, &group) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "--log-group has to be between 0 and 65535");
+		loginfo->group = group;
+		loginfo->backends |= XT_LOG_BACKEND_NFLOG;
+		*flags |= IPT_LOG_OPT_GROUP;
+		break;
+#endif
+/* We can savely check for IPT_LOG_OPT_NO_SYSLOG without the need for ifdefs */
 	case '!':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-level when not logging to syslog");
+
 		if (*flags & IPT_LOG_OPT_LEVEL)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
@@ -152,6 +215,10 @@
 		break;
 
 	case '1':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-tcp-sequence when not logging to syslog");
+
 		if (*flags & IPT_LOG_OPT_TCPSEQ)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-sequence "
@@ -162,6 +229,10 @@
 		break;
 
 	case '2':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-tcp-options when not logging to syslog");
+
 		if (*flags & IPT_LOG_OPT_TCPOPT)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-options twice");
@@ -171,6 +242,10 @@
 		break;
 
 	case '3':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-ip-options when not logging to syslog");
+
 		if (*flags & IPT_LOG_OPT_IPOPT)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-ip-options twice");
@@ -180,10 +255,14 @@
 		break;
 
 	case '4':
+		if (*flags & IPT_LOG_OPT_NO_SYSLOG)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-uid when not logging to syslog");
+
 		if (*flags & IPT_LOG_OPT_UID)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-uid twice");
-
+		
 		loginfo->logflags |= IPT_LOG_UID;
 		*flags |= IPT_LOG_OPT_UID;
 		break;
@@ -206,35 +285,63 @@
       const struct ipt_entry_target *target,
       int numeric)
 {
-	const struct ipt_log_info *loginfo
-		= (const struct ipt_log_info *)target->data;
+	const struct xt_log_info *loginfo
+		= (const struct xt_log_info *)target->data;
 	unsigned int i = 0;
+	/* These flag saves some ifdefs and thus make the code more readable */
+	int use_syslog = 1; /* is uselog used as backend ? */
 
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (!(loginfo->backends & XT_LOG_BACKEND_SYSLOG))
+			use_syslog = 0;
+#endif
+
 	printf("LOG ");
-	if (numeric)
-		printf("flags %u level %u ",
-		       loginfo->logflags, loginfo->level);
+	if (numeric) {
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+			printf("group %u ", loginfo->group);
+#endif
+
+		if (!use_syslog)
+			printf("no-syslog ");
+		else 
+			printf("flags %u level %u ",
+			       loginfo->logflags, loginfo->level);
+	}
 	else {
-		for (i = 0;
-		     i < sizeof(ipt_log_names) / sizeof(struct ipt_log_names);
-		     i++) {
-			if (loginfo->level == ipt_log_names[i].level) {
-				printf("level %s ", ipt_log_names[i].name);
-				break;
+		if (use_syslog) {
+			for (i = 0;
+			     i < sizeof(ipt_log_names) / sizeof(struct ipt_log_names);
+			     i++) {
+				if (loginfo->level == ipt_log_names[i].level) {
+					printf("level %s ", ipt_log_names[i].name);
+					break;
+				}
 			}
 		}
-		if (i == sizeof(ipt_log_names) / sizeof(struct ipt_log_names))
-			printf("UNKNOWN level %u ", loginfo->level);
-		if (loginfo->logflags & IPT_LOG_TCPSEQ)
-			printf("tcp-sequence ");
-		if (loginfo->logflags & IPT_LOG_TCPOPT)
-			printf("tcp-options ");
-		if (loginfo->logflags & IPT_LOG_IPOPT)
-			printf("ip-options ");
-		if (loginfo->logflags & IPT_LOG_UID)
-			printf("uid ");
-		if (loginfo->logflags & ~(IPT_LOG_MASK))
-			printf("unknown-flags ");
+
+#ifdef XT_LOG_BACKEND_SYSLOG
+		if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+			printf("group %u ", loginfo->group);
+#endif
+		if (!use_syslog) {
+			printf("no-syslog ");
+		}
+		else {
+			if (i == sizeof(ipt_log_names) / sizeof(struct ipt_log_names))
+				printf("UNKNOWN level %u ", loginfo->level);
+			if (loginfo->logflags & IPT_LOG_TCPSEQ)
+				printf("tcp-sequence ");
+			if (loginfo->logflags & IPT_LOG_TCPOPT)
+				printf("tcp-options ");
+			if (loginfo->logflags & IPT_LOG_IPOPT)
+				printf("ip-options ");
+			if (loginfo->logflags & IPT_LOG_UID)
+				printf("uid ");
+			if (loginfo->logflags & ~(IPT_LOG_MASK))
+				printf("unknown-flags ");
+		}
 	}
 
 	if (strcmp(loginfo->prefix, "") != 0)
@@ -245,14 +352,21 @@
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
 {
-	const struct ipt_log_info *loginfo
-		= (const struct ipt_log_info *)target->data;
-
+	const struct xt_log_info *loginfo
+		= (const struct xt_log_info *)target->data;
+#ifdef XT_LOG_BACKEND_SYSLOG
+	if (loginfo->backends & XT_LOG_BACKEND_NFLOG)
+		printf("--log-group %u ", loginfo->group);
+	if (!(loginfo->backends & XT_LOG_BACKEND_SYSLOG))
+		printf("--log-no-syslog ");
+#endif
+	/* Don't need to check for no-syslog, since the options won't be set if
+	 * not logging to syslog */
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
-		printf("--log-level %d ", loginfo->level);
+		printf("--log-level %u ", loginfo->level);
 
 	if (loginfo->logflags & IPT_LOG_TCPSEQ)
 		printf("--log-tcp-sequence ");
@@ -269,8 +383,9 @@
 = {
     .name          = "LOG",
     .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_log_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_log_info)),
+/* IPT_ALIGN is defined as XT_ALIGN if available */
+    .size          = IPT_ALIGN(sizeof(struct xt_log_info)), 
+    .userspacesize = IPT_ALIGN(sizeof(struct xt_log_info)),
     .help          = &help,
     .init          = &init,
     .parse         = &parse,
Index: extensions/libipt_LOG.man
===================================================================
--- extensions/libipt_LOG.man	(revision 6554)
+++ extensions/libipt_LOG.man	(working copy)
@@ -1,22 +1,39 @@
 Turn on kernel logging of matching packets.  When this option is set
-for a rule, the Linux kernel will print some information on all
-matching packets (like most IP header fields) via the kernel log
-(where it can be read with
+for a rule, the Linux kernel logs this packet to all specified logging
+backends. There is a syslog backend, which prints some 
+information on matching packets (like most IP header fields) via the
+kernel log (where it can be read with
 .I dmesg
 or 
 .IR syslogd (8)).
-This is a "non-terminating target", i.e. rule traversal continues at
-the next rule.  So if you want to LOG the packets you refuse, use two
-separate rules with the same matching criteria, first using target LOG
-then DROP (or REJECT).
+The other backend is nfnetlink_log, which passes 
+packets to userspace to be handled there. Userspace processes my
+subsribe to various log groups and receive the packets. A packet can be
+logged to any number of backends. Default is to log only to the syslog 
+backend. 
+This is a "non-terminating target", i.e. rule traversal 
+continues at the next rule.  So if you want to LOG the packets you 
+refuse, use two separate rules with the same matching criteria, first
+using target LOG then DROP (or REJECT).
 .TP
-.BI "--log-level " "level"
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
-.TP
 .BI "--log-prefix " "prefix"
 Prefix log messages with the specified prefix; up to 29 letters long,
 and useful for distinguishing messages in the logs.
 .TP
+.B --log-no-syslog
+Do not log to syslog backend. 
+.TP
+.B Options for nfnetlink_log backend
+.TP
+.BI "--log-group " "group"
+Log this packet to nfnetlink_log backend. Group specifies the log group for
+this target.
+.TP
+.B Options for syslog backend
+.TP
+.BI "--log-level " "level"
+Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+.TP
 .B --log-tcp-sequence
 Log TCP sequence numbers. This is a security risk if the log is
 readable by users.
Index: Makefile
===================================================================
--- Makefile	(revision 6554)
+++ Makefile	(working copy)
@@ -12,7 +12,7 @@
 TOPLEVEL_INCLUDED=YES
 
 ifndef KERNEL_DIR
-KERNEL_DIR=/usr/src/linux
+KERNEL_DIR=/usr/src/linux-2.6.15.2
 endif
 IPTABLES_VERSION:=1.3.5
 OLD_IPTABLES_VERSION:=1.3.4
