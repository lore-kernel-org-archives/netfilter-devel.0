From: Piotr Chytla <pch@fouk.org>
Subject: Backported conntrack-acct/connbytes to 2.4 tree
Date: Tue, 16 Nov 2004 23:05:02 +0100
Message-ID: <20041116220502.GA2677@fouk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Hi ,

I attached two backports from 2.6 tree to 2.4 for patch-o-matic-ng , 

1) Backported conntrack-acct 
2) Backported connbytes with per-connection accounting support , also 
   shared library for iptables is attached . 
   Shared library for iptables works with connbytes from 2.6 tree.

/pch

PS. This is my first two patchs for pom-ng.

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="connbytes.patch"

diff -Nru -x '*.orig' -x '*.rej' a/connbytes/info b/connbytes/info
--- a/connbytes/info	2004-07-22 16:53:13.000000000 +0200
+++ b/connbytes/info	2004-11-15 23:45:29.000000000 +0100
@@ -1,4 +1,4 @@
-Author: Harald Welte <laforge@netfilter.org> / Martin Devera <devik@cdi.cz> 
+Author: Piotr Chytla <pch@fouk.org> / Harald Welte <laforge@netfilter.org> / Martin Devera <devik@cdi.cz> 
 Status: Experimental
 Repository: extra
 Depends: !CONNMARK
diff -Nru -x '*.orig' -x '*.rej' a/connbytes/iptables/extensions/libipt_connbytes.c b/connbytes/iptables/extensions/libipt_connbytes.c
--- a/connbytes/iptables/extensions/libipt_connbytes.c	1970-01-01 01:00:00.000000000 +0100
+++ b/connbytes/iptables/extensions/libipt_connbytes.c	2004-11-15 22:17:46.000000000 +0100
@@ -0,0 +1,256 @@
+/* Shared library add-on to iptables to add byte tracking support. 
+ *
+ * 2004-11-11 - Piotr Chytla <pch@fouk.org>
+ * 	- Some adaptation to backported module with per-conntrack accounting
+ * 	- Added connpkts/connavgpkt/direction ,
+ *
+ */ 
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ipt_connbytes.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"connbytes v%s options:\n"
+" [!] --connbytes from:[to]\n"
+"				Transfered bytes range to match\n"
+" [!] --connpkts from:[to]\n"
+"				Transfered number of packets range to match\n"
+" [!] --connavgpkt from:[to]\n"
+"				Transfered average packet size range to match\n"
+" --direction original|reply|both\n"
+"				Match only from direction \n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "connpkts", 1, 0, '1' },
+	{ "connbytes", 1, 0, '2' },
+	{ "connavgpkt", 1, 0, '3' },
+	{ "direction", 1, 0, '4'},
+	{0}
+};
+
+static char *sinfo_names[] = {
+	"connpkts",
+	"connbytes",
+	"connavgpkt",
+	NULL
+};
+
+static char *sinfo_directions[] = {
+	"original",
+	"replay",
+	"both",
+	NULL
+};
+
+#define IPT_CONNBYTES_PKTS	0x1
+#define IPT_CONNBYTES_BYTES	0x2
+#define IPT_CONNBYTES_AVGPKT	0x4
+#define IPT_CONNBYTES_ORIGINAL	0x8
+#define IPT_CONNBYTES_REPLY	0x10
+#define IPT_CONNBYTES_BOTH	0x20
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+} 
+
+static void
+parse_range(const char *arg, struct ipt_connbytes_info *si)
+{
+	char *colon,*p;
+
+	si->count.from = strtoul(arg,&colon,10);
+	if (*colon != ':') 
+		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+	si->count.to = strtoul(colon+1,&p,10);
+	if (p == colon+1) {
+		/* second number omited */
+		si->count.to = 0xffffffff;
+	}
+	if (si->count.from > si->count.to)
+		exit_error(PARAMETER_PROBLEM, "%llu should be less than %llu", si->count.from,si->count.to);
+}
+
+static int 
+parse_direction(const char *direction,size_t strlen,struct ipt_connbytes_info *sinfo,unsigned int *flags)
+{
+	if (strncasecmp(direction,"original",strlen) == 0)
+	{
+		sinfo->direction=IPT_CONNBYTES_DIR_ORIGINAL;
+		*flags |= IPT_CONNBYTES_ORIGINAL;
+	} else if (strncasecmp(direction,"both",strlen) == 0) 
+	{
+		sinfo->direction=IPT_CONNBYTES_DIR_BOTH;
+		*flags |= IPT_CONNBYTES_BOTH;
+	} else if (strncasecmp(direction,"replay",strlen) == 0)
+	{
+		sinfo->direction=IPT_CONNBYTES_DIR_REPLY;
+		*flags |= IPT_CONNBYTES_REPLY;
+	} else return 0;
+	return 1;
+}
+	
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)(*match)->data;
+	unsigned long i;
+	switch (c) {
+	case '2':
+		if (*flags & IPT_CONNBYTES_BYTES)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't specify --connbytes twice");
+		if (*flags & IPT_CONNBYTES_PKTS)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connpkts and --connbytes together");
+		if (*flags & IPT_CONNBYTES_AVGPKT)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connavgpkt and --connbytes together");
+
+		if (check_inverse(optarg, &invert, &optind, 0))
+			optind++;
+
+		parse_range(argv[optind-1], sinfo);
+		if (invert) {
+			i = sinfo->count.from;
+			sinfo->count.from = sinfo->count.to;
+			sinfo->count.to = i;
+		}
+		sinfo->what=IPT_CONNBYTES_WHAT_BYTES;
+		sinfo->direction=IPT_CONNBYTES_DIR_BOTH;
+		*flags |= IPT_CONNBYTES_BYTES;
+		break;
+	case '1':
+		if (*flags & IPT_CONNBYTES_PKTS)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't specify --connpkts twice");
+		if (*flags & IPT_CONNBYTES_BYTES)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connbytes and --connpkts together");
+		if (*flags & IPT_CONNBYTES_AVGPKT)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connavgpkt and --connpkts together");
+		
+		if (check_inverse(optarg,&invert,&optind,0))
+			optind++;
+
+		parse_range(argv[optind-1],sinfo);
+		if (invert) {
+			i = sinfo->count.from;
+			sinfo->count.from = sinfo->count.to;
+			sinfo->count.to = i;
+		}
+		sinfo->what=IPT_CONNBYTES_WHAT_PKTS;
+		sinfo->direction=IPT_CONNBYTES_DIR_BOTH;
+		*flags |= IPT_CONNBYTES_PKTS;
+		break;
+	case '3':
+		if (*flags & IPT_CONNBYTES_AVGPKT)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't specify --connavgpkt twice");
+		if (*flags & IPT_CONNBYTES_PKTS)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connpkts and --connavgpkt together");
+		if (*flags & IPT_CONNBYTES_BYTES)
+			exit_error(PARAMETER_PROBLEM,
+					"Can't use --connbytes and --connavgpkt together");
+		
+		if (check_inverse(optarg,&invert,&optind,0))
+			optind++;
+
+		parse_range(argv[optind-1],sinfo);
+		if (invert) {
+			i = sinfo->count.from;
+			sinfo->count.from = sinfo->count.to;
+			sinfo->count.to = i;
+		}
+		sinfo->what=IPT_CONNBYTES_WHAT_AVGPKT;
+		sinfo->direction=IPT_CONNBYTES_DIR_BOTH;
+		*flags |= IPT_CONNBYTES_AVGPKT;
+		break;
+	case '4':
+		if (*flags & (IPT_CONNBYTES_ORIGINAL|IPT_CONNBYTES_BOTH|IPT_CONNBYTES_REPLY))
+			exit_error(PARAMETER_PROBLEM,
+					"Can't specify --direction twice");
+		if (!parse_direction(argv[optind-1],strlen(argv[optind-1]),sinfo,flags))
+			exit_error(PARAMETER_PROBLEM, "Bad direction '%s'",argv[optind-1]);
+		
+		break;
+	default:	
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes or --connpkts or--connavgpkt'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+
+		if (sinfo->count.from > sinfo->count.to) 
+			printf("%s ! %llu:%llu direction:%s",sinfo_names[sinfo->what],sinfo->count.to,sinfo->count.from,sinfo_directions[sinfo->direction]);
+		else
+		printf("%s %llu:%llu direction:%s",sinfo_names[sinfo->what],sinfo->count.from,sinfo->count.to,sinfo_directions[sinfo->direction]);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+
+	if (sinfo->count.from > sinfo->count.to) 
+		printf("! --%s %llu:%llu --direction %s",sinfo_names[sinfo->what],sinfo->count.to,sinfo->count.from,sinfo_directions[sinfo->direction]);
+	else
+		printf("--%s %llu:%llu --direction %s",sinfo_names[sinfo->what],sinfo->count.from,sinfo->count.to,sinfo_directions[sinfo->direction]);
+}
+
+static
+struct iptables_match state
+= { NULL,
+    "connbytes",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
+    IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match(&state);
+}
diff -Nru -x '*.orig' -x '*.rej' a/connbytes/linux-2.4/include/linux/netfilter_ipv4/ipt_connbytes.h b/connbytes/linux-2.4/include/linux/netfilter_ipv4/ipt_connbytes.h
--- a/connbytes/linux-2.4/include/linux/netfilter_ipv4/ipt_connbytes.h	2004-04-07 13:04:28.000000000 +0200
+++ b/connbytes/linux-2.4/include/linux/netfilter_ipv4/ipt_connbytes.h	2004-11-11 21:05:52.000000000 +0100
@@ -1,10 +1,25 @@
 #ifndef _IPT_CONNBYTES_H
 #define _IPT_CONNBYTES_H
+enum ipt_connbytes_what {
+	        IPT_CONNBYTES_WHAT_PKTS,
+	        IPT_CONNBYTES_WHAT_BYTES,
+	        IPT_CONNBYTES_WHAT_AVGPKT,
+};
+
+enum ipt_connbytes_direction {
+	        IPT_CONNBYTES_DIR_ORIGINAL,
+	        IPT_CONNBYTES_DIR_REPLY,
+	        IPT_CONNBYTES_DIR_BOTH,
+};
 
 struct ipt_connbytes_info
 {
-       /* if from <= to then it matches the range; if from > to then
-          inverse range is matched */
-       unsigned long from, to;
+        struct {
+                u_int64_t from; /* count to be matched */
+                u_int64_t to;   /* count to be matched */
+        } count;
+        u_int8_t what;          /* ipt_connbytes_what */
+        u_int8_t direction;     /* ipt_connbytes_direction */
 };
+
 #endif
diff -Nru -x '*.orig' -x '*.rej' a/connbytes/linux-2.4/net/ipv4/netfilter/ipt_connbytes.c b/connbytes/linux-2.4/net/ipv4/netfilter/ipt_connbytes.c
--- a/connbytes/linux-2.4/net/ipv4/netfilter/ipt_connbytes.c	2004-04-07 13:04:28.000000000 +0200
+++ b/connbytes/linux-2.4/net/ipv4/netfilter/ipt_connbytes.c	2004-11-15 22:11:20.000000000 +0100
@@ -1,12 +1,32 @@
 /* Kernel module to match connection tracking byte counter.
  * GPL (C) 2002 Martin Devera (devik@cdi.cz).
+ *
+ * 2004-07-20 Harald Welte <laforge@netfilter.org>
+ *      - reimplemented to use per-connection accounting counters
+ *      - add functionality to match number of packets
+ *      - add functionality to match average packet size
+ *      - add support to match directions seperately
+ *
+ * 2004-10-24 Piotr Chytla <pch@fouk.org>
+ * 	- Connbytes with per-connection accouting backported to 2.4
+ * 	
  */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/types.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_connbytes.h>
 
+#include <asm/div64.h>
+
+static u_int64_t mydiv(u_int64_t arg1,u_int32_t arg2)
+{
+	do_div(arg1,arg2);
+	return arg1;
+}
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -17,17 +37,89 @@
       u_int16_t datalen,
       int *hotdrop)
 {
+	static u_int64_t what;
 	const struct ipt_connbytes_info *sinfo = matchinfo;
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct;
 
 	if (!(ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo)))
 		return 0; /* no match */
-	
-	if (sinfo->from > sinfo->to)
-		return (ct->bytes < sinfo->to || ct->bytes > sinfo->from);
-	else
-		return (ct->bytes >= sinfo->from && ct->bytes <= sinfo->to);
+        switch (sinfo->what) {
+        case IPT_CONNBYTES_WHAT_PKTS:
+                switch (sinfo->direction) {
+                case IPT_CONNBYTES_DIR_ORIGINAL:
+                        what = ct->counters[IP_CT_DIR_ORIGINAL].packets;
+                        break;
+                case IPT_CONNBYTES_DIR_REPLY:
+                        what = ct->counters[IP_CT_DIR_REPLY].packets;
+                        break;
+                case IPT_CONNBYTES_DIR_BOTH:
+                        what = ct->counters[IP_CT_DIR_ORIGINAL].packets;
+                        what += ct->counters[IP_CT_DIR_REPLY].packets;
+                        break;
+                }
+                break;
+        case IPT_CONNBYTES_WHAT_BYTES:
+                switch (sinfo->direction) {
+                case IPT_CONNBYTES_DIR_ORIGINAL:
+                        what = ct->counters[IP_CT_DIR_ORIGINAL].bytes;
+                        break;
+                case IPT_CONNBYTES_DIR_REPLY:
+                        what = ct->counters[IP_CT_DIR_REPLY].bytes;
+                        break;
+                case IPT_CONNBYTES_DIR_BOTH:
+                        what = ct->counters[IP_CT_DIR_ORIGINAL].bytes;
+                        what += ct->counters[IP_CT_DIR_REPLY].bytes;
+                        break;
+                }
+                break;
+        case IPT_CONNBYTES_WHAT_AVGPKT:
+                switch (sinfo->direction) {
+                case IPT_CONNBYTES_DIR_ORIGINAL:
+                        {
+                                u_int32_t pkts32;
+
+                                if (ct->counters[IP_CT_DIR_ORIGINAL].packets > 0xfffffffff)
+                                        pkts32 = 0xffffffff;
+                                else
+                                        pkts32 = ct->counters[IP_CT_DIR_ORIGINAL].packets;
+				what = mydiv(ct->counters[IP_CT_DIR_ORIGINAL].bytes,pkts32);
+                        }
+                        break;
+                case IPT_CONNBYTES_DIR_REPLY:
+                        {
+                                u_int32_t pkts32;
+
+                                if (ct->counters[IP_CT_DIR_REPLY].packets > 0xffffffff)
+                                        pkts32 = 0xffffffff;
+                                else
+                                        pkts32 = ct->counters[IP_CT_DIR_REPLY].packets;
+				what = mydiv(ct->counters[IP_CT_DIR_REPLY].bytes,pkts32);
+                        }
+                        break;
+                case IPT_CONNBYTES_DIR_BOTH:
+                        {
+                                u_int64_t bytes;
+                                u_int64_t pkts;
+                                u_int32_t pkts32;
+                                bytes = ct->counters[IP_CT_DIR_ORIGINAL].bytes +
+                                        ct->counters[IP_CT_DIR_REPLY].bytes;
+                                pkts = ct->counters[IP_CT_DIR_ORIGINAL].packets +
+                                        ct->counters[IP_CT_DIR_REPLY].packets;
+                                if (pkts > 0xffffffff)
+                                        pkts32 =  0xffffffff;
+                                else
+                                        pkts32 = pkts;
+				what = mydiv(bytes,pkts);
+                        }
+                        break;
+                }
+                break;
+        }
+        if (sinfo->count.to)
+                return (what <= sinfo->count.to && what >= sinfo->count.from);
+        else
+                return (what >= sinfo->count.from);
 }
 
 static int check(const char *tablename,
@@ -36,8 +128,19 @@
 		 unsigned int matchsize,
 		 unsigned int hook_mask)
 {
+	const struct ipt_connbytes_info *sinfo = matchinfo;
+
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_connbytes_info)))
 		return 0;
+        if (sinfo->what != IPT_CONNBYTES_WHAT_PKTS &&
+		       sinfo->what != IPT_CONNBYTES_WHAT_BYTES &&
+		       sinfo->what != IPT_CONNBYTES_WHAT_AVGPKT)
+		       return 0;
+
+       if (sinfo->direction != IPT_CONNBYTES_DIR_ORIGINAL &&
+			sinfo->direction != IPT_CONNBYTES_DIR_REPLY &&
+	                sinfo->direction != IPT_CONNBYTES_DIR_BOTH)
+		       return 0;
 
 	return 1;
 }

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="conntrack-acct.patch"

diff -Nru -x '*.orig' -x '*.rej' a/conntrack-acct/info b/conntrack-acct/info
--- a/conntrack-acct/info	2004-07-22 21:22:09.000000000 +0200
+++ b/conntrack-acct/info	2004-11-15 23:45:45.000000000 +0100
@@ -1,3 +1,3 @@
-Author: Harald Welte <laforge@netfilter.org> 
+Author: Piotr Chytla <pch@fouk.org> / Harald Welte <laforge@netfilter.org> 
 Status: Stable
 Repository: pending
diff -Nru -x '*.orig' -x '*.rej' a/conntrack-acct/linux-2.4/net/ipv4/netfilter/Config.in.ladd b/conntrack-acct/linux-2.4/net/ipv4/netfilter/Config.in.ladd
--- a/conntrack-acct/linux-2.4/net/ipv4/netfilter/Config.in.ladd	1970-01-01 01:00:00.000000000 +0100
+++ b/conntrack-acct/linux-2.4/net/ipv4/netfilter/Config.in.ladd	2004-11-15 22:43:12.000000000 +0100
@@ -0,0 +1,3 @@
+    dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CONNTRACK             
+    dep_tristate '  Connection tracking flow accounting' CONFIG_IP_NF_CT_ACCT $CONFIG_IP_NF_CONNTRACK
+
diff -Nru -x '*.orig' -x '*.rej' a/conntrack-acct/linux-2.4.patch b/conntrack-acct/linux-2.4.patch
--- a/conntrack-acct/linux-2.4.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/conntrack-acct/linux-2.4.patch	2004-11-15 23:09:20.000000000 +0100
@@ -0,0 +1,210 @@
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
+--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-08-08 01:26:06.000000000 +0200
++++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-14 20:55:47.000000000 +0100
+@@ -156,6 +156,12 @@
+ 	union ip_conntrack_expect_help help;
+ };
+ 
++struct ip_conntrack_counter
++{
++       u_int64_t packets;
++       u_int64_t bytes;
++};
++
+ struct ip_conntrack_helper;
+ 
+ struct ip_conntrack
+@@ -173,6 +179,12 @@
+ 	/* Timer function; drops refcnt when it goes off. */
+ 	struct timer_list timeout;
+ 
++#if defined(CONFIG_IP_NF_CT_ACCT) || \
++	defined(CONFIG_IP_NF_CT_ACCT_MODULE)
++       /* Accounting Information (same cache line as other written members) */
++       struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
++#endif
++
+ 	/* If we're expecting another related connection, this will be
+            in expected linked list */
+ 	struct list_head sibling_list;
+@@ -242,8 +254,10 @@
+ 			  const struct ip_conntrack_tuple *orig);
+ 
+ /* Refresh conntrack for this many jiffies */
+-extern void ip_ct_refresh(struct ip_conntrack *ct,
+-			  unsigned long extra_jiffies);
++extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
++                              enum ip_conntrack_info ctinfo,
++                              const struct iphdr *iph,
++                              unsigned long extra_jiffies);
+ 
+ /* These are for NAT.  Icky. */
+ /* Call me when a conntrack is destroyed. */
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
+--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-18 14:36:32.000000000 +0100
++++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-11-14 20:29:39.000000000 +0100
+@@ -75,7 +75,7 @@
+ 
+ 	/* increase the UDP timeout of the master connection as replies from
+ 	 * Amanda clients to the server can be quite delayed */
+-	ip_ct_refresh(ct, master_timeout * HZ);
++	ip_ct_refresh_acct(ct,ctinfo,NULL, master_timeout * HZ);
+ 	
+ 	/* Search for "CONNECT " string */
+ 	do {
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
+--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-08-08 01:26:06.000000000 +0200
++++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-11-14 20:29:52.000000000 +0100
+@@ -1164,21 +1164,40 @@
+ 	MOD_DEC_USE_COUNT;
+ }
+ 
++static inline void ct_add_counters(struct ip_conntrack *ct,
++                                enum ip_conntrack_info ctinfo,
++                                 const struct iphdr *iph)
++{
++#if defined(CONFIG_IP_NF_CT_ACCT) || \
++	defined(CONFIG_IP_NF_CT_ACCT_MODULE)
++     if (iph) {
++            ct->counters[CTINFO2DIR(ctinfo)].packets++;
++            ct->counters[CTINFO2DIR(ctinfo)].bytes += 
++                                ntohs(iph->tot_len);
++   }
++#endif
++}
++
+ /* Refresh conntrack for this many jiffies. */
+-void ip_ct_refresh(struct ip_conntrack *ct, unsigned long extra_jiffies)
++void ip_ct_refresh_acct(struct ip_conntrack *ct, 
++                       enum ip_conntrack_info ctinfo,
++                       const struct iphdr *iph,
++                       unsigned long extra_jiffies)
+ {
+ 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
+ 
+ 	WRITE_LOCK(&ip_conntrack_lock);
+ 	/* If not in hash table, timer will not be active yet */
+-	if (!is_confirmed(ct))
++	if (!is_confirmed(ct)) {
+ 		ct->timeout.expires = extra_jiffies;
+-	else {
++		ct_add_counters(ct, ctinfo,iph);
++	} else {
+ 		/* Need del_timer for race avoidance (may already be dying). */
+ 		if (del_timer(&ct->timeout)) {
+ 			ct->timeout.expires = jiffies + extra_jiffies;
+ 			add_timer(&ct->timeout);
+ 		}
++		ct_add_counters(ct, ctinfo, iph);
+ 	}
+ 	WRITE_UNLOCK(&ip_conntrack_lock);
+ }
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_proto_generic.c b/net/ipv4/netfilter/ip_conntrack_proto_generic.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2003-11-28 19:26:21.000000000 +0100
++++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-11-14 20:30:15.000000000 +0100
+@@ -41,9 +41,9 @@
+ /* Returns verdict for packet, or -1 for invalid. */
+ static int established(struct ip_conntrack *conntrack,
+ 		       struct iphdr *iph, size_t len,
+-		       enum ip_conntrack_info conntrackinfo)
++		       enum ip_conntrack_info ctinfo)
+ {
+-	ip_ct_refresh(conntrack, ip_ct_generic_timeout);
++	ip_ct_refresh_acct(conntrack, ctinfo,iph,ip_ct_generic_timeout);
+ 	return NF_ACCEPT;
+ }
+ 
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2003-11-28 19:26:21.000000000 +0100
++++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-11-14 20:30:18.000000000 +0100
+@@ -82,7 +82,7 @@
+ 			ct->timeout.function((unsigned long)ct);
+ 	} else {
+ 		atomic_inc(&ct->proto.icmp.count);
+-		ip_ct_refresh(ct, ip_ct_icmp_timeout);
++		ip_ct_refresh_acct(ct,ctinfo,iph, ip_ct_icmp_timeout);
+ 	}
+ 
+ 	return NF_ACCEPT;
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2003-11-28 19:26:21.000000000 +0100
++++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-11-14 20:30:26.000000000 +0100
+@@ -211,7 +211,7 @@
+ 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+ 
+ 		WRITE_UNLOCK(&tcp_lock);
+-		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
++		ip_ct_refresh_acct(conntrack,ctinfo,iph, *tcp_timeouts[newconntrack]);
+ 	}
+ 
+ 	return NF_ACCEPT;
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2003-11-28 19:26:21.000000000 +0100
++++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-11-14 20:30:23.000000000 +0100
+@@ -47,16 +47,16 @@
+ /* Returns verdict for packet, and may modify conntracktype */
+ static int udp_packet(struct ip_conntrack *conntrack,
+ 		      struct iphdr *iph, size_t len,
+-		      enum ip_conntrack_info conntrackinfo)
++		      enum ip_conntrack_info ctinfo)
+ {
+ 	/* If we've seen traffic both ways, this is some kind of UDP
+ 	   stream.  Extend timeout. */
+ 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+-		ip_ct_refresh(conntrack, ip_ct_udp_timeout_stream);
++		ip_ct_refresh_acct(conntrack,ctinfo,iph,ip_ct_udp_timeout_stream);
+ 		/* Also, more likely to be important, and not a probe */
+ 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+ 	} else
+-		ip_ct_refresh(conntrack, ip_ct_udp_timeout);
++		ip_ct_refresh_acct(conntrack,ctinfo,iph, ip_ct_udp_timeout);
+ 
+ 	return NF_ACCEPT;
+ }
+diff -Nru -x '*.orig' -x '*.rej' -x '*.in' a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
+--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-08-08 01:26:06.000000000 +0200
++++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-11-14 20:30:30.000000000 +0100
+@@ -79,6 +79,18 @@
+ 	return len;
+ }
+ 
++#if defined(CONFIG_IP_NF_CT_ACCT) || \
++	defined(CONFIG_IP_NF_CT_ACCT_MODULE)
++static unsigned int
++print_counters(char *buffer, struct ip_conntrack_counter *counter)
++{
++       return sprintf(buffer, "packets=%llu bytes=%llu ", 
++                       counter->packets, counter->bytes);
++}
++#else
++#define print_counters(x, y)   0
++#endif
++
+ static unsigned int
+ print_conntrack(char *buffer, struct ip_conntrack *conntrack)
+ {
+@@ -98,11 +110,15 @@
+ 	len += print_tuple(buffer + len,
+ 			   &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+ 			   proto);
++       len += print_counters(buffer + len, 
++                             &conntrack->counters[IP_CT_DIR_ORIGINAL]);
+ 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
+ 		len += sprintf(buffer + len, "[UNREPLIED] ");
+ 	len += print_tuple(buffer + len,
+ 			   &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
+ 			   proto);
++       len += print_counters(buffer + len, 
++                            &conntrack->counters[IP_CT_DIR_REPLY]);
+ 	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
+ 		len += sprintf(buffer + len, "[ASSURED] ");
+ 	len += sprintf(buffer + len, "use=%u ",
+@@ -467,7 +483,7 @@
+ EXPORT_SYMBOL(ip_conntrack_helper_register);
+ EXPORT_SYMBOL(ip_conntrack_helper_unregister);
+ EXPORT_SYMBOL(ip_ct_selective_cleanup);
+-EXPORT_SYMBOL(ip_ct_refresh);
++EXPORT_SYMBOL(ip_ct_refresh_acct);
+ EXPORT_SYMBOL(ip_ct_find_proto);
+ EXPORT_SYMBOL(__ip_ct_find_proto);
+ EXPORT_SYMBOL(ip_ct_find_helper);

--C7zPtVaVf+AK4Oqc--
