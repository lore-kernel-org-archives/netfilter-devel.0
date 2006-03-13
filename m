From: Amin Azez <azez@ufomechanic.net>
Subject: ipt_recent patch
Date: Mon, 13 Mar 2006 17:47:05 +0000
Message-ID: <4415B019.6050409@ufomechanic.net>
References: <dt51lh$b63$1@sea.gmane.org>
	<43F9EA77.4060208@ufomechanic.net>	<44096532.2070000@trash.net>
	<440DAB6B.4020208@ufomechanic.net> <440ECB1B.4070507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040607090504080700000509"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <440ECB1B.4070507@trash.net>
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

This is a multi-part message in MIME format.
--------------040607090504080700000509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch has some sort of versioning built in so that the new userland 
features are not enabled unless built against a new header file.

If a new kernel module is called with rules by old userland, then it 
refuses to accept the rule.

I don't know if you will like my CPP macros, I could expand them out?

Changes:
* /proc/net/ipt_recent/* is sorted by age, most recent first
* include Per Hedelands patch in message 
<200603062203.k26M3pI5024778@tordmule.bluetail.com>
* fix problem of not moving up list entries after deleting entries which 
meant that sometimes you could never fill the list
* fix problems of items with hash of 0 being erased whenever an empty 
slot is used
* Add these new features:

       [!] --listcount-lt count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-*  specifier)  is 
  less
              than  count  (or not !). No other options are considered 
if this
              is not true.

       [!] --listcount-le count
              Requires as a precondition that the number of IP entries 
in  the
              list  (subject  to  the optional --listtime-* specifier) 
is less
              than or equal to count (or not !). No other options are 
consid-
              ered if this is not true.

       [!] --listcount-eq count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-* specifier)  is 
  equal
              to  (or not !) count. No other options are considered if 
this is
              not true.

       [!] --listcount-ge count
              Requires as a precondition that the number of IP entries 
in  the
              list (subject to the optional --listtime-* specifier) is 
greater
              than or equal to count (or not !). No other options are 
consid-
              ered if this is not true.

       [!] --listcount-gt count
              Requires  as a precondition that the number of IP entries 
in the
              list (subject to the optional --listtime-* specifier) is 
greater
              than  count  (or not !). No other options are considered 
if this
              is not true.

       Only one --listcount-* option can be specified.

       [!] --listtime-lt seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated less than seconds seconds ago.

       [!] --listtime-le seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated less than or equal to seconds seconds ago.

       [!] --listtime-ge seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated more than or equal to seconds seconds ago.

       [!] --listtime-gt seconds
              Affects the --listcount-* so that instead of counting the 
number
              of  items  in  the list, it counts the number of items 
that were
              last updated more than seconds seconds ago.

       Only one --listtime-* option can be specified. --listtime-* 
options act
              as select clauses for what to count. The ! negation for 
--list-
              time-*  options merely inverts the comparison, so ! 
--listime-le
              is the same as --listtime-gt

...

              The next example accepts the packet if less than 5 ip 
addresses
              in the list have been updated in the last 60 seconds

              #  iptables  -A FORWARD -m recent --listcount-lt 5 
--listtime-lt
              60 --set -j ACCEPT

--------------040607090504080700000509
Content-Type: text/x-patch;
 name="iptables.recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables.recent.patch"

--- extensions/Makefile.orig	2005-07-13 15:25:35.000000000 +0100
+++ extensions/Makefile	2005-07-13 15:25:54.000000000 +0100
@@ -6,8 +6,9 @@
 #
 PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG layer7
 PF_EXT_SLIB+=connrate ROUTE time account quota
 PF_EXT_SLIB+=condition
+PF_EXT_SLIB+=recent
 PF_EXT_SLIB+=vlan
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner physdev standard tcp udp HL LOG NFQUEUE MARK TRACE
  
 # Optionals
--- extensions/libipt_recent.man.orig	2006-03-01 12:39:29.000000000 +0000
+++ extensions/libipt_recent.man	2006-03-02 10:40:53.000000000 +0000
@@ -9,6 +9,63 @@
 Specify the list to use for the commands. If no name is given then 'DEFAULT'
 will be used.
 .TP
+[\fB!\fR] \fB--listcount-lt \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+(subject to the optional --listtime-* specifier)
+is less than count (or not !). No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--listcount-le \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+(subject to the optional --listtime-* specifier)
+is less than or equal to count (or not !). No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--listcount-eq \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+(subject to the optional --listtime-* specifier)
+is equal to (or not !) count. No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--listcount-ge \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+(subject to the optional --listtime-* specifier)
+is greater than or equal to count (or not !). No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--listcount-gt \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+(subject to the optional --listtime-* specifier)
+is greater than count (or not !). No other options are considered if
+this is not true.
+.TP
+Only one --listcount-* option can be specified.
+.TP
+[\fB!\fR] \fB--listtime-lt \fisecounds\fR
+Affects the --listcount-* so that instead of counting the number of
+items in the list, it counts the number of items that were last updated
+less than \fBseconds\fR seconds ago.
+.TP
+[\fB!\fR] \fB--listtime-le \fisecounds\fR
+Affects the --listcount-* so that instead of counting the number of
+items in the list, it counts the number of items that were last updated
+less than or equal to \fBseconds\fR seconds ago.
+.TP
+[\fB!\fR] \fB--listtime-ge \fisecounds\fR
+Affects the --listcount-* so that instead of counting the number of
+items in the list, it counts the number of items that were last updated
+more than or equal to \fBseconds\fR seconds ago.
+.TP
+[\fB!\fR] \fB--listtime-gt \fisecounds\fR
+Affects the --listcount-* so that instead of counting the number of
+items in the list, it counts the number of items that were last updated
+more than \fBseconds\fR seconds ago.
+.TP
+Only one --listtime-* option can be specified. --listtime-* options act
+as select clauses for what to count. The ! negation for --listtime-*
+options merely inverts the comparison, so \fB! --listime-le\fR is the same as
+\fB--listtime-gt\fR
+.TP
 [\fB!\fR] \fB--set\fR
 This will add the source address of the packet to the list. If the
 source address is already in the list, this will update the existing
@@ -56,6 +113,12 @@
 # iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
 
 # iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
+
+The next example accepts the packet if less than 5 ip addresses in the list have
+been updated in the last 60 seconds
+
+# iptables -A FORWARD -m recent --listcount-lt 5 --listtime-lt 60 --set -j ACCEPT
+
 .P
 Official website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
--- extensions/libipt_recent.c.orig	2006-03-13 17:02:03.000000000 +0000
+++ extensions/libipt_recent.c	2006-03-13 17:19:25.000000000 +0000
@@ -23,17 +23,28 @@
 
 /* Options for this module */
 static struct option opts[] = {
-	{ .name = "set",      .has_arg = 0, .flag = 0, .val = 201 }, 
-	{ .name = "rcheck",   .has_arg = 0, .flag = 0, .val = 202 }, 
-	{ .name = "update",   .has_arg = 0, .flag = 0, .val = 203 },
-	{ .name = "seconds",  .has_arg = 1, .flag = 0, .val = 204 }, 
-	{ .name = "hitcount", .has_arg = 1, .flag = 0, .val = 205 },
-	{ .name = "remove",   .has_arg = 0, .flag = 0, .val = 206 },
-	{ .name = "rttl",     .has_arg = 0, .flag = 0, .val = 207 },
-	{ .name = "name",     .has_arg = 1, .flag = 0, .val = 208 },
-	{ .name = "rsource",  .has_arg = 0, .flag = 0, .val = 209 },
-	{ .name = "rdest",    .has_arg = 0, .flag = 0, .val = 210 },
-	{ .name = 0,          .has_arg = 0, .flag = 0, .val = 0   }
+#ifdef IPT_RECENT_HAS_LIST_OPS
+	{ .name = "set",          .has_arg = 0, .flag = 0, .val = 201 }, 
+	{ .name = "rcheck",       .has_arg = 0, .flag = 0, .val = 202 }, 
+	{ .name = "update",       .has_arg = 0, .flag = 0, .val = 203 },
+	{ .name = "seconds",      .has_arg = 1, .flag = 0, .val = 204 }, 
+	{ .name = "hitcount",     .has_arg = 1, .flag = 0, .val = 205 },
+	{ .name = "remove",       .has_arg = 0, .flag = 0, .val = 206 },
+	{ .name = "rttl",         .has_arg = 0, .flag = 0, .val = 207 },
+	{ .name = "name",         .has_arg = 1, .flag = 0, .val = 208 },
+	{ .name = "rsource",      .has_arg = 0, .flag = 0, .val = 209 },
+	{ .name = "rdest",        .has_arg = 0, .flag = 0, .val = 210 },
+	{ .name = "listcount-lt", .has_arg = 1, .flag = 0, .val = 211 },
+	{ .name = "listcount-le", .has_arg = 1, .flag = 0, .val = 212 },
+	{ .name = "listcount-eq", .has_arg = 1, .flag = 0, .val = 213 },
+	{ .name = "listcount-ge", .has_arg = 1, .flag = 0, .val = 214 },
+	{ .name = "listcount-gt", .has_arg = 1, .flag = 0, .val = 215 },
+	{ .name = "listtime-lt",  .has_arg = 1, .flag = 0, .val = 216 },
+	{ .name = "listtime-le",  .has_arg = 1, .flag = 0, .val = 217 },
+	{ .name = "listtime-ge",  .has_arg = 1, .flag = 0, .val = 218 },
+	{ .name = "listtime-gt",  .has_arg = 1, .flag = 0, .val = 219 },
+#endif
+	{ .name = 0,              .has_arg = 0, .flag = 0, .val = 0   }
 };
 
 /* Function which prints out usage message. */
@@ -42,6 +53,20 @@
 {
 	printf(
 "recent v%s options:\n"
+#ifdef RECENT_HAS_LIST_OPS
+"    PRECONDITIONS               Only one precondition may be set.\n"
+"[!] --listcount-lt n            Only match if there are less than n items in the table\n"
+"[!] --listcount-le n            Only match if there are n items or less in the table\n"
+"[!] --listcount-eq n            Only match if there are n items in the table\n"
+"[!] --listcount-ge n            Only match if there are n items or more in the table\n"
+"[!] --listcount-gt n            Only match if there are more than n items in the table\n"
+
+"[!] --listtimes-lt n            --listcount option only applies to items less than n seconds old\n"
+"[!] --listtimes-le n            --listcount option only applies to items n seconds old or less\n"
+"[!] --listtimes-ge n            --listcount option only applies to items n seconds old or more\n"
+"[!] --listtimes-gt n            --listcount option only applies ti items more than n seconds old\n"
+#endif
+"                                The precondtion may be followed by:\n"
 "[!] --set                       Add source address to list, always matches.\n"
 "[!] --rcheck                    Match if source address in list.\n"
 "[!] --update                    Match if source address in list, also update last-seen time.\n"
@@ -78,6 +103,11 @@
 	 * better be safe, than sorry */
 	info->name[IPT_RECENT_NAME_LEN-1] = '\0';
 	info->side = IPT_RECENT_SOURCE;
+/* If kernel side supports LIST_OPS but we don't set this flag it will
+   presume we are an old client side and refuse the rule */
+#ifdef IPT_RECENT_HAS_LIST_OPS
+	info->check_set |= IPT_RECENT_HAS_LIST_OPS;
+#endif
 }
 
 /* Function which parses command options; returns true if it
@@ -155,6 +185,89 @@
 			info->side = IPT_RECENT_DEST;
 			break;
 
+#ifdef IPT_RECENT_HAS_LIST_OPS
+		case 211: /* listcount-lt */
+			if (info->count_ops & IPT_RECENT_COUNT_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listcount-lt', `--listcount-le' "
+                                        "`--listcount-eq', `--listcount-ge' `listcount-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= IPT_RECENT_COUNT_LT | (invert?IPT_RECENT_COUNT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 212: /* listcount-le */
+			if (info->count_ops & IPT_RECENT_COUNT_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listcount-lt', `--listcount-le' "
+                                        "`--listcount-eq', `--listcount-ge' `listcount-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= IPT_RECENT_COUNT_LE | (invert?IPT_RECENT_COUNT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 213: /* listcount-eq */
+			if (info->count_ops & IPT_RECENT_COUNT_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listcount-lt', `--listcount-le' "
+                                        "`--listcount-eq', `--listcount-ge' `listcount-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= IPT_RECENT_COUNT_EQ | (invert?IPT_RECENT_COUNT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 214: /* listcount-ge */
+			if (info->count_ops & IPT_RECENT_COUNT_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listcount-lt', `--listcount-le' "
+                                        "`--listcount-eq', `--listcount-ge' `listcount-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= IPT_RECENT_COUNT_GE | (invert?IPT_RECENT_COUNT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 215: /* listcount-gt */
+			if (info->count_ops & IPT_RECENT_COUNT_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listcount-lt', `--listcount-le' "
+                                        "`--listcount-eq', `--listcount-ge' `listcount-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= IPT_RECENT_COUNT_GT | (invert?IPT_RECENT_COUNT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 216: /* listtime-lt */
+			if (info->count_ops & IPT_RECENT_TIME_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listtime-lt', `--listtime-le' "
+                                        "`--listtime-eq', `--listtime-ge' `listtime-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= invert?IPT_RECENT_TIME_GE:IPT_RECENT_TIME_LT;
+			info->entry_time=atoi(optarg);
+			break;
+
+		case 217: /* listtime-le */
+			if (info->count_ops & IPT_RECENT_TIME_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listtime-lt', `--listtime-le' "
+                                        "`--listtime-eq', `--listtime-ge' `listtime-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= invert?IPT_RECENT_TIME_GT:IPT_RECENT_TIME_LE;
+			info->entry_time=atoi(optarg);
+			break;
+
+		case 218: /* listtime-ge */
+			if (info->count_ops & IPT_RECENT_TIME_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listtime-lt', `--listtime-le' "
+                                        "`--listtime-eq', `--listtime-ge' `listtime-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= invert?IPT_RECENT_TIME_LT:IPT_RECENT_TIME_GE;
+			info->entry_time=atoi(optarg);
+			break;
+
+		case 219: /* listtime-gt */
+			if (info->count_ops & IPT_RECENT_TIME_OPS) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--listtime-lt', `--listtime-le' "
+                                        "`--listtime-eq', `--listtime-ge' `listtime-gts'` "
+                                        " or `--eq' may be set");
+			info->count_ops |= invert?IPT_RECENT_TIME_LE:IPT_RECENT_TIME_GT;
+			info->entry_time=atoi(optarg);
+			break;
+#endif
+
 		default:
 			return 0;
 	}
@@ -181,10 +294,35 @@
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
+#ifdef IPT_RECENT_HAS_LIST_OPS
+	printf("recent: ");
+
+	/* handle the precondition first */
+	if (info->count_ops) {
+          if (info->count_ops & IPT_RECENT_COUNT_INVERT) printf("not ");
+	  switch (info->count_ops & IPT_RECENT_COUNT_OPS) {
+	    case IPT_RECENT_COUNT_LT: printf("< ");  break;
+	    case IPT_RECENT_COUNT_LE: printf("<= "); break;
+	    case IPT_RECENT_COUNT_EQ: printf("== "); break;
+	    case IPT_RECENT_COUNT_GE: printf(">= "); break;
+	    case IPT_RECENT_COUNT_GT: printf("> ");  break;
+	    default: printf(" ");
+	  }
+          printf("%d ",info->entry_count);
+	  if (info->count_ops & IPT_RECENT_TIME_OPS) switch (info->count_ops & IPT_RECENT_TIME_OPS) {
+	    case IPT_RECENT_TIME_LT: printf("< ");  break;
+	    case IPT_RECENT_TIME_LE: printf("<= "); break;
+	    case IPT_RECENT_TIME_GE: printf(">= "); break;
+	    case IPT_RECENT_TIME_GT: printf("> ");  break;
+	    default: printf(" ");
+	  }
+          printf("%d ",info->entry_time);
+	}
+#endif
+
 	if (info->invert)
 		fputc('!', stdout);
 
-	printf("recent: ");
 	if(info->check_set & IPT_RECENT_SET) printf("SET ");
 	if(info->check_set & IPT_RECENT_CHECK) printf("CHECK ");
 	if(info->check_set & IPT_RECENT_UPDATE) printf("UPDATE ");
@@ -203,6 +341,31 @@
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
+#ifdef IPT_RECENT_HAS_LIST_OPS
+	/* handle the precondition first */
+	if (info->count_ops) {
+          if (info->count_ops & IPT_RECENT_COUNT_INVERT) printf("! ");
+	  switch (info->count_ops & IPT_RECENT_COUNT_OPS) {
+	    case IPT_RECENT_COUNT_LT: printf("--listcount-lt ");  break;
+	    case IPT_RECENT_COUNT_LE: printf("--listcount-le "); break;
+	    case IPT_RECENT_COUNT_EQ: printf("--listcount-eq "); break;
+	    case IPT_RECENT_COUNT_GE: printf("--listcount-ge "); break;
+	    case IPT_RECENT_COUNT_GT: printf("--listcount-gt ");  break;
+	    default: printf(" ");
+	  }
+          printf("%d ",info->entry_count);
+
+	  if (info->count_ops & IPT_RECENT_TIME_OPS) switch (info->count_ops & IPT_RECENT_TIME_OPS) {
+	    case IPT_RECENT_TIME_LT: printf("--listtime-lt ");  break;
+	    case IPT_RECENT_TIME_LE: printf("--listtime-le "); break;
+	    case IPT_RECENT_TIME_GE: printf("--listtime-ge "); break;
+	    case IPT_RECENT_TIME_GT: printf("--listtime-gt ");  break;
+	    default: printf(" ");
+	  } 
+          printf("%d ",info->entry_time);
+	}
+#endif
+
 	if (info->invert)
 		printf("! ");
 

--------------040607090504080700000509
Content-Type: text/x-patch;
 name="kernel_ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_ipt_recent.patch"

--- net/ipv4/netfilter/ipt_recent.c.nolimit	2006-02-15 16:34:20.000000000 +0000
+++ net/ipv4/netfilter/ipt_recent.c	2006-03-13 17:26:41.000000000 +0000
@@ -1,11 +1,12 @@
 /* Kernel module to check if the source address has been seen recently. */
 /* Copyright 2002-2003, Stephen Frost, 2.5.x port by laforge@netfilter.org */
 /* Author: Stephen Frost <sfrost@snowman.net> */
+/* Copyright 2006 ufomechanic.net <azez@ufomechanic.net> 
+   for --listcount and --listtime enhancements */
 /* Project Page: http://snowman.net/projects/ipt_recent/ */
 /* This software is distributed under the terms of the GPL, Version 2 */
 /* This copyright does not cover user programs that use kernel services
  * by normal system calls. */
-
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
@@ -70,7 +71,11 @@
 /* Structure of our linked list of tables of recent lists. */
 struct recent_ip_tables {
 	char name[IPT_RECENT_NAME_LEN];
+	/* number of entries in list *table */
+	int entry_count;
+	/* number of reference to this structure from iptables rules */
 	int count;
+	/* an index increased with each operation which maps time_info[x].position to a position in table */
 	int time_pos;
 	struct recent_ip_list *table;
 	struct recent_ip_tables *next;
@@ -131,7 +136,7 @@
 
 static int ip_recent_get_info(char *buffer, char **start, off_t offset, int length, int *eof, void *data)
 {
-	int len = 0, count, last_len = 0, pkt_count;
+	int len = 0, index, time, count, last_len = 0, pkt_count;
 	off_t pos = 0;
 	off_t begin = 0;
 	struct recent_ip_tables *curr_table;
@@ -139,22 +144,27 @@
 	curr_table = (struct recent_ip_tables*) data;
 
 	spin_lock_bh(&curr_table->list_lock);
+	time=(curr_table->time_pos+ip_list_tot-1) % ip_list_tot;
 	for(count = 0; count < ip_list_tot; count++) {
-		if(!curr_table->table[count].addr) continue;
+		/* The next slot to be re-used is the oldest slot, so start there... */
+		index=curr_table->time_info[time].position;
 		last_len = len;
-		len += sprintf(buffer+len,"src=%u.%u.%u.%u ",NIPQUAD(curr_table->table[count].addr));
-		len += sprintf(buffer+len,"ttl: %u ",curr_table->table[count].ttl);
-		len += sprintf(buffer+len,"last_seen: %lu ",curr_table->table[count].last_seen);
-		len += sprintf(buffer+len,"oldest_pkt: %u ",curr_table->table[count].oldest_pkt);
-		len += sprintf(buffer+len,"last_pkts: %lu",curr_table->table[count].last_pkts[0]);
-		for(pkt_count = 1; pkt_count < ip_pkt_list_tot; pkt_count++) {
-			if(!curr_table->table[count].last_pkts[pkt_count]) break;
-			len += sprintf(buffer+len,", %lu",curr_table->table[count].last_pkts[pkt_count]);
-		}
-		len += sprintf(buffer+len,"\n");
-		pos = begin + len;
-		if(pos < offset) { len = 0; begin = pos; }
-		if(pos > offset + length) { len = last_len; break; }
+		if(curr_table->table[index].addr) {
+		  len += sprintf(buffer+len,"src=%u.%u.%u.%u ",NIPQUAD(curr_table->table[index].addr));
+		  len += sprintf(buffer+len,"ttl: %u ",curr_table->table[index].ttl);
+		  len += sprintf(buffer+len,"last_seen: %lu ",curr_table->table[index].last_seen);
+		  len += sprintf(buffer+len,"oldest_pkt: %u ",curr_table->table[index].oldest_pkt);
+		  len += sprintf(buffer+len,"last_pkts: %lu",curr_table->table[index].last_pkts[0]);
+		  for(pkt_count = 1; pkt_count < ip_pkt_list_tot; pkt_count++) {
+			if(!curr_table->table[index].last_pkts[pkt_count]) break;
+			len += sprintf(buffer+len,", %lu",curr_table->table[index].last_pkts[pkt_count]);
+		  }
+		  len += sprintf(buffer+len,"\n");
+		  pos = begin + len;
+		  if(pos < offset) { len = 0; begin = pos; }
+		  if(pos > offset + length) { len = last_len; break; }
+		}
+		time=(time-1+ip_list_tot) % ip_list_tot;
 	}
 
 	*start = buffer + (offset - begin);
@@ -216,6 +226,7 @@
 		used += 5;
 		spin_lock_bh(&curr_table->list_lock);
 		curr_table->time_pos = 0;
+		curr_table->entry_count = 0;
 		for(count = 0; count < ip_list_hash_size; count++) {
 			curr_table->hash_table[count] = -1;
 		}
@@ -297,6 +308,9 @@
 	info->seconds = 0;
 	info->hit_count = 0;
 	info->check_set = check_set;
+	info->entry_count = 0;
+	info->entry_time = 0;
+	info->count_ops = 0;
 	info->invert = 0;
 	info->side = IPT_RECENT_SOURCE;
 	strncpy(info->name,curr_table->name,IPT_RECENT_NAME_LEN);
@@ -350,6 +364,16 @@
  * --hitcount -- Option to --rcheck/--update, only match if seen hitcount times
  *   -- matchinfo->hit_count
  * --seconds and --hitcount can be combined
+ * --listcount-lt -- Options to see if how many entries in the table altogether
+ * --listcount-le
+ * --listcount-eq
+ * --listcount-ge
+ * --listcount-gt
+ * --listtime-lt -- change --listcount to refer to how many entries in the table we
+ *                  updated less than so many seconds ago
+ * --listtime-le
+ * --listtime-ge
+ * --listtime-gt
  */
 static int
 match(const struct sk_buff *skb,
@@ -403,7 +427,132 @@
 	/* Make sure no one is changing the list while we work with it */
 	spin_lock_bh(&curr_table->list_lock);
 
+	/* Get jiffies now in case they changed while we were waiting for a lock */
+	now = jiffies;
+
 	r_list = curr_table->table;
+
+	/* We seek: count of items matching time constraint.
+
+	   We don't actually want to count the number of items meeting
+	   the time constraints because it is a waste of time, we already
+	   have an index in time order, we can easily check that there
+	   are enough in the index.
+
+	     location = time_info[curr_table->time_pos].position;
+           references the next slot to be used, and which therefore is the 
+	   oldest slot to have been used if it has been used.
+
+	     start = time_info[(curr_table->time_pos + ip_list_tot -1) % ip_list_tot].position;
+	   refers to the most recent slot to be used if any have been used
+
+	   (or if curr_table->entry_count > 0)
+	     end = time_info[(curr_table->time_pos + ip_list_tot
+	       - curr_table->entry_count) % ip_list_tot ].position;
+	   will always show the oldest item if entry_count > 0
+
+	    SO, if we want to check that there are n items in the list that
+	   are < or <= to t then we go to position (END+n-1) and compare that.
+	   If it is < or <= t then so are the old items 
+	    If we want to check that there are n items > or >= t then we
+	   check item START-n+1 and compare that, if it is < or <= t then so
+	   are the items after it.
+
+	   Here are the full cases we cover. We don't do time= because its not
+	   very useful and difficult to optimize
+
+	   time >  t, count >  c : itemcount > c  && [start-c]>t      ; there are enough, and past the limitmatches
+	   time >  t, count >= c : itemcount >= c && [start-c+1]>t    ; there are enough and the limit matches
+	   time >  t, count =  c : itemcount >= c && [start-c+1]>t    ; there are at least enough and the limit matches
+	                                      && (c<=itemcount || !([start-c]>t)) ; others, if any, do not match
+	   time >  t, count <= c : itemcount <= c || !([start-c]>t)   ; either there aren't too many anyway, or the one just out of count doesn't match
+	   time >  t, count <  c : itemcount < c  || !([start-c+1]>t) ; either there aren't too many anyway, or the one just out of count doesn't match
+
+
+	   time >= t, count >  c : itemcount > c && [start-c]>=t      ; there are enough past the limit
+	   time >= t, count >= c : itemcount >=c && [start-c+1]>=t    ; there are enough and the limit matches
+	   time >= t, count =  c : itemcount >=c && [start-c+1]>=t    ; there are at least enough and the limit matches
+	                                      && (c<=itemcount || !([start-c]>=t)) ; others, if any, do not match
+	   time >= t, count <= c : itemcount <=c || !([start-c]>=t)   ; either there aren't too many anyway, or the one just out of count doesn't match
+	   time >= t, count <  c : itemcount < c || !([start-c+1]>=t) ; either there aren't too many anyway, or the one just out of count doesn't match
+
+
+	   time <= t, count >  c : itemcount > c  && [end+c]<=t        ; Make sure that at least 1 more than c matches
+	   time <= t, count >= c : itemcount >= c && [end+c-1]<=t      ; Make sure that at least c items match
+	   time <= t, count =  c : itemcount >= c && [end+c-1]<=t      ; there are at least enough and the limit matches
+	                                      && (c<=itemcount) || !([end+c]<=t)) ; others, if any, do not match
+	   time <= t, count <= c : itemcount <=c || !([end+c]<=t)      ; either there aren't too many anyway, or the one out of count doesn't match
+	   time <= t, count <  c : itemcount < c || !([end+c-1]<=t)      ; either there aren't too many anyway, or the one out of count doesn't match
+
+
+	   time <  t, count >  c : itemcount > c  && [end+c]<t         ; Make sure that at least 1 more than c matches
+	   time <  t, count >= c : itemcount >= c && [end+c-1]<t       ; Make sure that at least c items match
+	   time <  t, count =  c : itemcount >= c && [end+c-1]<t       ; there are at least enough and the limit matches
+	                                      && (c<=itemcount) || !([end+c]<t)) ; others, if any, do not match
+	   time <  t, count <= c : itemcount <=c || !([end+c]<t)       ; either there aren't too many anyway, or the one out of count doesn't match
+	   time <  t, count <  c : itemcount < c || !([end+c-1]<t)       ; either there aren't too many anyway, or the one out of count doesn't match
+	BTW the last rule is the same as this:
+	   time <  t, count <  c : !(itemcount >= c && ([end+c-1]<t)       ; either there aren't too many anyway, or the one out of count doesn't match
+
+
+	We can spot the pattern in thse and reduce it to one set of factorized rules.
+	This will sadden some people */
+
+	/* General parameterized count rule */
+	#define COUNT_(tablelist,timecheck,TIME_OP,COUNT_CHECK,limit) ( (tablelist->entry_count COUNT_CHECK \
+	                   ((!timecheck) || TIME_OP(now,tablelist->time_info[(limit+ip_list_tot)%ip_list_tot].time+(unsigned long)(timecheck)*HZ))) )
+
+	#define COUNT_GT(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) COUNT_(table,timecheck,TIME_OP, > countcheck &&,limit DIR_OP countcheck)
+	#define COUNT_GE(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) COUNT_(table,timecheck,TIME_OP,>= countcheck &&,limit DIR_OP countcheck - DIR_OP 1)
+	#define COUNT_EQ(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) COUNT_GE(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) \
+	                                                               && ! COUNT_GT(table,timecheck,TIME_OP,countcheck,limit,DIR_OP)
+	#define COUNT_LE(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) COUNT_(table,timecheck,TIME_OP,<= countcheck || !,limit DIR_OP countcheck)
+	#define COUNT_LT(table,timecheck,TIME_OP,countcheck,limit,DIR_OP) COUNT_(table,timecheck,TIME_OP, < countcheck || !,limit DIR_OP countcheck - DIR_OP 1)
+
+	/* and one rule to bind them.  Macros were made for this.
+	   Inline functions won't be efficient here because we would have to pass a function pointer or something */
+	#define COUNT(COUNT_FUNC,TIME_OP,table,timecheck,countcheck) (\
+	 (((TIME_OP)==IPT_RECENT_TIME_GT)?(COUNT_FUNC(table,timecheck,time_after,     countcheck,table->time_pos-table->entry_count,+)):\
+	  ((TIME_OP)==IPT_RECENT_TIME_GE)?(COUNT_FUNC(table,timecheck,time_after_eq,  countcheck,table->time_pos-table->entry_count,+)):\
+	  ((TIME_OP)==IPT_RECENT_TIME_LE)?(COUNT_FUNC(table,timecheck,time_before_eq, countcheck,table->time_pos-1,-)):\
+	  ((TIME_OP)==IPT_RECENT_TIME_LT)?(COUNT_FUNC(table,timecheck,time_before,    countcheck,table->time_pos-1,-)):\
+	  ((TIME_OP)==0                 )?(COUNT_FUNC(table,0,        time_after,     countcheck,table->time_pos-1,-)):\
+	  0) \
+	 )
+
+	/* we use do..while(0) so that the acceptable cases can "break" away from the 
+	   exit block which saves repeating the exit block for each case */
+	if(info->count_ops) do {
+	  int invert=(0!=(info->count_ops & IPT_RECENT_COUNT_INVERT));
+#ifdef DEBUG
+	if (debug) printk(KERN_INFO RECENT_NAME " match invert=%d count_ops=%x count=%d time=%d\n",invert,info->count_ops,info->entry_count,info->entry_time);
+#endif
+
+	  /* of course limit and over_limit may be invalid if c<count */
+	  /* For LT or LE limit=end+c-1; over_limit=limit+1; */
+	  /* treat GT, GE or EQ with same limits limit=start-c+1; over_limit=limit-1; */
+	  if ((info->count_ops & IPT_RECENT_COUNT_OPS)==IPT_RECENT_COUNT_LT) {
+	    if (invert ^ COUNT(COUNT_LT,info->count_ops & IPT_RECENT_TIME_OPS,curr_table,info->entry_time,info->entry_count)) break;
+	  } else if ((info->count_ops & IPT_RECENT_COUNT_OPS)==IPT_RECENT_COUNT_LE) {
+	    if (invert ^ COUNT(COUNT_LE,info->count_ops & IPT_RECENT_TIME_OPS,curr_table,info->entry_time,info->entry_count)) break;
+	  } else if ((info->count_ops & IPT_RECENT_COUNT_OPS)==IPT_RECENT_COUNT_EQ) {
+	    if (invert ^ COUNT(COUNT_EQ,info->count_ops & IPT_RECENT_TIME_OPS,curr_table,info->entry_time,info->entry_count)) break;
+	  } else if ((info->count_ops & IPT_RECENT_COUNT_OPS)== IPT_RECENT_COUNT_GE) {
+	    if (invert ^ COUNT(COUNT_GE,info->count_ops & IPT_RECENT_TIME_OPS,curr_table,info->entry_time,info->entry_count)) break;
+	  } else if ((info->count_ops & IPT_RECENT_COUNT_OPS)== IPT_RECENT_COUNT_GT) {
+	    if (invert ^ COUNT(COUNT_GT,info->count_ops & IPT_RECENT_TIME_OPS,curr_table,info->entry_time,info->entry_count)) break;
+	  }
+	  /* If we get here then a definite comparison failed */
+          spin_unlock_bh(&curr_table->list_lock);
+	  return 0;
+	} while(0);
+
+	/* this is the next slot to use. 
+	   If it has never been used then 0 is the oldest slot
+	   If it has been used then it is the oldest slot. */
+	location = time_info[curr_table->time_pos].position;
+	
+
 	if(info->side == IPT_RECENT_DEST) addr = skb->nh.iph->daddr; else addr = skb->nh.iph->saddr;
 
 	if(!addr) { 
@@ -418,8 +567,6 @@
 	if(debug) printk(KERN_INFO RECENT_NAME ": match(): checking table, addr: %u, ttl: %u, orig_ttl: %u\n",addr,ttl,skb->nh.iph->ttl);
 #endif
 
-	/* Get jiffies now in case they changed while we were waiting for a lock */
-	now = jiffies;
 	hash_table = curr_table->hash_table;
 	time_info = curr_table->time_info;
 
@@ -500,7 +647,27 @@
 
 		/* New item found and IPT_RECENT_SET, so we need to add it */
 		location = time_info[curr_table->time_pos].position;
-		hash_table[r_list[location].hash_entry] = -1;
+		/* 
+		   location is the next slot in r_list that we will use. 
+		   Maybe it is already used and we need to remove it from the hash.
+		   If it is used then: 
+		   1) hash_table[r_list[location].hash_entry]=location
+		   Which is to say that anything claiming to have a hash entry
+		   should also be pointed to BY that hash entry.
+		     This only comes up becase by default r_list[x].hash_entry=0
+		   i.e. all items claim to have hash entry 0, so if a real
+		   item has hash slot 0 it gets trashed because of lies.
+		   SO: If r_list[location].hash_entry]==0 we are in warning condition
+		   and need to double check that hash_table reciprocates before we
+		   set the hash_table entry to -1 (it may not really belong)
+		   This would work; 
+		     if (r_list[location].hash_entry!=0 || hash_table[0]==location) hash_table[r_list[location].hash_entry] = -1; 
+		   but we want to combine with a counter for new entries
+		*/
+		/* increase counter if this is a new item */
+		if (hash_table[r_list[location].hash_entry]!=location) curr_table->entry_count++;
+		else hash_table[r_list[location].hash_entry] = -1;
+
 		hash_table[hash_result] = location;
 		memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
 		r_list[location].time_pos = curr_table->time_pos;
@@ -587,7 +754,7 @@
 #endif
 			/* Check if this is part of a collision chain */
 			while(hash_table[(orig_hash_result+1) % ip_list_hash_size] != -1) {
-				orig_hash_result++;
+				orig_hash_result = (orig_hash_result+1) % ip_list_hash_size;
 				if(hash_func(r_list[hash_table[orig_hash_result]].addr,ip_list_hash_size) == hash_result) {
 					/* Found collision chain, how deep does this rabbit hole go? */
 #ifdef DEBUG
@@ -616,7 +783,10 @@
 			time_loc = r_list[location].time_pos;
 			time_info[time_loc].time = 0;
 			time_info[time_loc].position = location;
-			while((time_info[(time_loc+1) % ip_list_tot].time < time_info[time_loc].time) && ((time_loc+1) % ip_list_tot) != curr_table->time_pos) {
+			/* close up the gap we made in time_info. 
+			   Perhaps we should work out which is the quickest way around the ring buffer 
+			   and close up the gap the quickest way. We should use memmove while we are at it. */
+			while(((time_loc+1) % ip_list_tot) != curr_table->time_pos) {
 				time_temp = time_info[time_loc].time;
 				time_info[time_loc].time = time_info[(time_loc+1)%ip_list_tot].time;
 				time_info[(time_loc+1)%ip_list_tot].time = time_temp;
@@ -633,6 +803,9 @@
 			r_list[location].ttl = 0;
 			memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
 			r_list[location].oldest_pkt = 0;
+			curr_table->entry_count--;
+			/* back off next-free-slot time_pos to the free slot we just bubbled to the end */
+			curr_table->time_pos=(curr_table->time_pos+ip_list_tot-1)%ip_list_tot;
 			ans = !info->invert;
 		}
 		spin_unlock_bh(&curr_table->list_lock);
@@ -669,6 +842,11 @@
 
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_recent_info))) return 0;
 
+	if(! (info->check_set & IPT_RECENT_HAS_LIST_OPS)) {
+		printk(KERN_INFO RECENT_NAME ": supports LIST_OPS but user iptables does not!\n");
+		return 0;
+	}
+
 	/* seconds and hit_count only valid for CHECK/UPDATE */
 	if(info->check_set & IPT_RECENT_SET) { flag++; if(info->seconds || info->hit_count) return 0; }
 	if(info->check_set & IPT_RECENT_REMOVE) { flag++; if(info->seconds || info->hit_count) return 0; }
@@ -719,6 +897,7 @@
 	curr_table->next = NULL;
 	curr_table->count = 1;
 	curr_table->time_pos = 0;
+	curr_table->entry_count = 0;
 	strncpy(curr_table->name,info->name,IPT_RECENT_NAME_LEN);
 	curr_table->name[IPT_RECENT_NAME_LEN-1] = '\0';
 
--- include/linux/netfilter_ipv4/ipt_recent.h.nolimit	2006-02-20 10:12:06.000000000 +0000
+++ include/linux/netfilter_ipv4/ipt_recent.h	2006-03-13 17:11:08.000000000 +0000
@@ -2,13 +2,31 @@
 #define _IPT_RECENT_H
 
 #define RECENT_NAME	"ipt_recent"
-#define RECENT_VER	"v0.3.1"
+#define RECENT_VER	"v0.3.2"
 
 #define IPT_RECENT_CHECK  1
 #define IPT_RECENT_SET    2
 #define IPT_RECENT_UPDATE 4
 #define IPT_RECENT_REMOVE 8
 #define IPT_RECENT_TTL   16
+#define IPT_RECENT_HAS_LIST_OPS 32
+
+#ifdef IPT_RECENT_HAS_LIST_OPS
+#define IPT_RECENT_COUNT_INVERT 1 << 0
+#define IPT_RECENT_COUNT_LT	1 << 1
+#define IPT_RECENT_COUNT_EQ	1 << 2
+#define IPT_RECENT_COUNT_GT	1 << 3
+#define IPT_RECENT_COUNT_LE	(IPT_RECENT_COUNT_LT | IPT_RECENT_COUNT_EQ)
+#define IPT_RECENT_COUNT_GE	(IPT_RECENT_COUNT_GT | IPT_RECENT_COUNT_EQ)
+#define IPT_RECENT_COUNT_OPS	(IPT_RECENT_COUNT_LT | IPT_RECENT_COUNT_EQ | IPT_RECENT_COUNT_GT)
+
+#define IPT_RECENT_TIME_LT	1 << 4
+#define IPT_RECENT_TIME_EQ	1 << 5 /* But we don't implement checks for == itself */
+#define IPT_RECENT_TIME_GT	1 << 6
+#define IPT_RECENT_TIME_LE	(IPT_RECENT_TIME_LT | IPT_RECENT_TIME_EQ)
+#define IPT_RECENT_TIME_GE	(IPT_RECENT_TIME_GT | IPT_RECENT_TIME_EQ)
+#define IPT_RECENT_TIME_OPS	(IPT_RECENT_TIME_LT | IPT_RECENT_TIME_EQ | IPT_RECENT_TIME_GT)
+#endif
 
 #define IPT_RECENT_SOURCE 0
 #define IPT_RECENT_DEST   1
@@ -20,6 +38,11 @@
 	u_int32_t   hit_count;
 	u_int8_t    check_set;
 	u_int8_t    invert;
+#ifdef IPT_RECENT_HAS_LIST_OPS
+	u_int8_t    count_ops;
+	u_int32_t   entry_count;
+	u_int32_t   entry_time;
+#endif
 	char        name[IPT_RECENT_NAME_LEN];
 	u_int8_t    side;
 };

--------------040607090504080700000509--
