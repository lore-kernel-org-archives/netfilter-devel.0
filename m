From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] IPv6 port of the nth match.
Date: Wed, 30 Apr 2003 16:49:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304301648010.15553@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-653840266-1051714170=:15553"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-653840266-1051714170=:15553
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

here is a patch to add nth match to ip6tables.
Based on Fabrice Marie's IPv4 module.

Regards,
Maciej Soltysiak

diff -Nru netfilter.orig/patch-o-matic/base/nth6.patch.ipv6 netfilter/patch-o-matic/base/nth6.patch.ipv6
--- netfilter.orig/patch-o-matic/base/nth6.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/nth6.patch.ipv6	2003-04-30 16:29:30.000000000 +0200
@@ -0,0 +1,200 @@
+diff -Nru linux.orig/include/linux/netfilter_ipv6/ip6t_nth.h linux/include/linux/netfilter_ipv6/ip6t_nth.h
+--- linux.orig/include/linux/netfilter_ipv6/ip6t_nth.h	1970-01-01 01:00:00.000000000 +0100
++++ linux/include/linux/netfilter_ipv6/ip6t_nth.h	2003-04-30 16:06:31.000000000 +0200
+@@ -0,0 +1,19 @@
++#ifndef _IP6T_NTH_H
++#define _IP6T_NTH_H
++
++#include <linux/param.h>
++#include <linux/types.h>
++
++#ifndef IP6T_NTH_NUM_COUNTERS
++#define IP6T_NTH_NUM_COUNTERS 16
++#endif
++
++struct ip6t_nth_info {
++	u_int8_t every;
++	u_int8_t not;
++	u_int8_t startat;
++	u_int8_t counter;
++	u_int8_t packet;
++};
++
++#endif /*_IP6T_NTH_H*/
+diff -Nru linux.orig/net/ipv6/netfilter/ip6t_nth.c linux/net/ipv6/netfilter/ip6t_nth.c
+--- linux.orig/net/ipv6/netfilter/ip6t_nth.c	1970-01-01 01:00:00.000000000 +0100
++++ linux/net/ipv6/netfilter/ip6t_nth.c	2003-04-30 16:11:14.000000000 +0200
+@@ -0,0 +1,173 @@
++/*
++  This is a module which is used for match support for every Nth packet
++  This file is distributed under the terms of the GNU General Public
++  License (GPL). Copies of the GPL can be obtained from:
++     ftp://prep.ai.mit.edu/pub/gnu/GPL
++
++  2001-07-18 Fabrice MARIE <fabrice@netfilter.org> : initial implementation.
++  2001-09-20 Richard Wagner (rwagner@cloudnet.com)
++        * added support for multiple counters
++        * added support for matching on individual packets
++          in the counter cycle
++  2003-04-30 Maciej Soltysiak <solt@dns.toxicfilms.tv> : IPv6 Port
++
++*/
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <net/tcp.h>
++#include <linux/spinlock.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_nth.h>
++
++MODULE_LICENSE("GPL");
++
++/*
++ * State information.
++ */
++struct state {
++	spinlock_t lock;
++	u_int16_t number;
++};
++
++static struct state states[IP6T_NTH_NUM_COUNTERS];
++
++static int
++ip6t_nth_match(const struct sk_buff *pskb,
++	      const struct net_device *in,
++	      const struct net_device *out,
++	      const void *matchinfo,
++	      int offset,
++	      const void *hdr,
++	      u_int16_t datalen,
++	      int *hotdrop)
++{
++	/* Parameters from userspace */
++	const struct ip6t_nth_info *info = matchinfo;
++        unsigned counter = info->counter;
++       	if((counter < 0) || (counter >= IP6T_NTH_NUM_COUNTERS))
++      	{
++       		printk(KERN_WARNING "nth: invalid counter %u. counter between 0 and %u\n", counter, IP6T_NTH_NUM_COUNTERS-1);
++               return 0;
++        };
++
++        spin_lock(&states[counter].lock);
++
++        /* Are we matching every nth packet?*/
++        if (info->packet == 0xFF)
++        {
++		/* We're matching every nth packet and only every nth packet*/
++		/* Do we match or invert match? */
++		if (info->not == 0)
++		{
++			if (states[counter].number == 0)
++			{
++				++states[counter].number;
++				goto match;
++			}
++			if (states[counter].number >= info->every)
++				states[counter].number = 0; /* reset the counter */
++			else
++				++states[counter].number;
++			goto dontmatch;
++		}
++		else
++		{
++			if (states[counter].number == 0)
++			{
++				++states[counter].number;
++				goto dontmatch;
++			}
++			if (states[counter].number >= info->every)
++				states[counter].number = 0;
++			else
++				++states[counter].number;
++			goto match;
++		}
++        }
++        else
++        {
++		/* We're using the --packet, so there must be a rule for every value */
++		if (states[counter].number == info->packet)
++		{
++			/* only increment the counter when a match happens */
++			if (states[counter].number >= info->every)
++				states[counter].number = 0; /* reset the counter */
++			else
++				++states[counter].number;
++			goto match;
++		}
++		else
++			goto dontmatch;
++	}
++
++ dontmatch:
++	/* don't match */
++	spin_unlock(&states[counter].lock);
++	return 0;
++
++ match:
++	spin_unlock(&states[counter].lock);
++	return 1;
++}
++
++static int
++ip6t_nth_checkentry(const char *tablename,
++		   const struct ip6t_ip6 *e,
++		   void *matchinfo,
++		   unsigned int matchsize,
++		   unsigned int hook_mask)
++{
++	/* Parameters from userspace */
++	const struct ip6t_nth_info *info = matchinfo;
++        unsigned counter = info->counter;
++        if((counter < 0) || (counter >= IP6T_NTH_NUM_COUNTERS))
++	{
++		printk(KERN_WARNING "nth: invalid counter %u. counter between 0 and %u\n", counter, IP6T_NTH_NUM_COUNTERS-1);
++               	return 0;
++       	};
++
++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_nth_info))) {
++		printk("nth: matchsize %u != %u\n", matchsize,
++		       IP6T_ALIGN(sizeof(struct ip6t_nth_info)));
++		return 0;
++	}
++
++	states[counter].number = info->startat;
++
++	return 1;
++}
++
++static struct ip6t_match ip6t_nth_reg = {
++	{NULL, NULL},
++	"nth",
++	ip6t_nth_match,
++	ip6t_nth_checkentry,
++	NULL,
++	THIS_MODULE };
++
++static int __init init(void)
++{
++	unsigned counter;
++        memset(&states, 0, sizeof(states));
++	if (ip6t_register_match(&ip6t_nth_reg))
++		return -EINVAL;
++
++        for(counter = 0; counter < IP6T_NTH_NUM_COUNTERS; counter++)
++	{
++		spin_lock_init(&(states[counter].lock));
++        };
++
++	printk("ip6t_nth match loaded\n");
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_match(&ip6t_nth_reg);
++	printk("ip6t_nth match unloaded\n");
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.config.in netfilter/patch-o-matic/base/nth6.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/nth6.patch.ipv6.config.in	2003-04-30 16:30:15.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  Nth match support' CONFIG_IP6_NF_MATCH_NTH $CONFIG_IP6_NF_IPTABLES
diff -Nru netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.configure.help netfilter/patch-o-matic/base/nth6.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/nth6.patch.ipv6.configure.help	2003-04-30 16:42:02.000000000 +0200
@@ -0,0 +1,23 @@
+CONFIG_IP6_NF_MATCH_MAC
+Nth match support
+CONFIG_IP6_NF_MATCH_NTH
+  This option adds a `Nth' match, which allow you to make
+  rules that match every Nth packet.  By default there are
+  16 different counters.
+
+[options]
+   --every     Nth              Match every Nth packet
+  [--counter]  num              Use counter 0-15 (default:0)
+  [--start]    num              Initialize the counter at the number 'num'
+                                instead of 0. Must be between 0 and Nth-1
+  [--packet]   num              Match on 'num' packet. Must be between 0
+                                and Nth-1.
+
+                                If --packet is used for a counter than
+                                there must be Nth number of --packet
+                                rules, covering all values between 0 and
+                                Nth-1 inclusively.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
diff -Nru netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.help netfilter/patch-o-matic/base/nth6.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/nth6.patch.ipv6.help	2003-04-30 16:40:08.000000000 +0200
@@ -0,0 +1,45 @@
+Author: Fabrice MARIE <fabrice@netfilter.org>
+Ported: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Works For Me.
+
+This option adds CONFIG_IP6_NF_MATCH_NTH, which supplies a match
+module that will allow you to match every Nth packet encountered.
+By default there are 16 different counters that can be used.
+
+This match functions in one of two ways
+1) Match ever Nth packet, and only the Nth packet.
+   example:
+    ip6tables -t mangle -A PREROUTING -m nth --every 10 -j DROP
+   This rule will drop every 10th packet.
+
+2) Unique rule for every packet.
+
+[WARNING] Unlike the IPv4 version, rules below will not work until
+          ip6tables has NAT support and connection tracking.
+          Find out other uses than the one below.
+
+    ip6tables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 \
+             --every 3 --packet 0 -j SNAT --to-source 10.0.0.5
+    ip6tables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 \
+             --every 3 --packet 1 -j SNAT --to-source 10.0.0.6
+    ip6tables -t nat -A POSTROUTING -o eth0 -m nth --counter 7 \
+             --every 3 --packet 2 -j SNAT --to-source 10.0.0.7
+   This example evenly splits connections between the three SNAT
+   addresses.
+
+   By using the mangle table and iproute2, you can setup complex
+   load-balanced routing.  There's lot of other uses.  Be creative!
+
+Suppported options are:
+   --every     Nth         Match every Nth packet
+  [--counter]  num         Use counter 0-15 (default:0)
+  [--start]    num         Initialize the counter at the number 'num'
+                           instead of 0. Must be between 0 and Nth-1
+  [--packet]   num         Match on 'num' packet. Must be between 0
+                           and Nth-1.
+                           If --packet is used for a counter than
+                           there must be Nth number of --packet
+                           rules, covering all values between 0 and
+                           Nth-1 inclusively.
+
+   This is an IPv6 port from IPv4 module.
diff -Nru netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.makefile netfilter/patch-o-matic/base/nth6.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/nth6.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/nth6.patch.ipv6.makefile	2003-04-30 16:31:17.000000000 +0200
@@ -0,0 +1,3 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+
+obj-$(CONFIG_IP6_NF_MATCH_NTH) += ip6t_nth.o
diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile	2003-04-09 16:30:03.000000000 +0200
+++ netfilter/userspace/extensions/Makefile	2003-04-30 16:22:19.000000000 +0200
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp iplimit length limit mac mark multiport owner physdev pkttype rpc standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
-PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK fuzzy
+PF6_EXT_SLIB:=eui64 hl icmpv6 length nth limit mac mark multiport owner standard tcp udp HL LOG MARK

 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
diff -Nru netfilter.orig/userspace/extensions/libip6t_nth.c netfilter/userspace/extensions/libip6t_nth.c
--- netfilter.orig/userspace/extensions/libip6t_nth.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_nth.c	2003-04-30 16:20:52.000000000 +0200
@@ -0,0 +1,238 @@
+/*
+   Shared library add-on to iptables to add match support for every Nth packet
+
+   This file is distributed under the terms of the GNU General Public
+   License (GPL). Copies of the GPL can be obtained from:
+   ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+   2001-07-17 Fabrice MARIE <fabrice@netfilter.org> : initial development.
+   2001-09-20 Richard Wagner (rwagner@cloudnet.com)
+        * added support for multiple counters
+        * added support for matching on individual packets
+          in the counter cycle
+*/
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_nth.h>
+
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"nth v%s options:\n"
+"   --every     Nth              Match every Nth packet\n"
+"  [--counter]  num              Use counter 0-%u (default:0)\n"
+"  [--start]    num              Initialize the counter at the number 'num'\n"
+"                                instead of 0. Must be between 0 and Nth-1\n"
+"  [--packet]   num              Match on 'num' packet. Must be between 0\n"
+"                                and Nth-1.\n\n"
+"                                If --packet is used for a counter than\n"
+"                                there must be Nth number of --packet\n"
+"                                rules, covering all values between 0 and\n"
+"                                Nth-1 inclusively.\n",
+IPTABLES_VERSION, IP6T_NTH_NUM_COUNTERS-1);
+}
+
+static struct option opts[] = {
+	{ "every", 1, 0, '1' },
+	{ "start", 1, 0, '2' },
+        { "counter", 1, 0, '3' },
+        { "packet", 1, 0, '4' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	*nfcache |= NFC_UNKNOWN;
+}
+
+#define IP6T_NTH_OPT_EVERY	0x01
+#define IP6T_NTH_OPT_NOT_EVERY	0x02
+#define IP6T_NTH_OPT_START	0x04
+#define IP6T_NTH_OPT_COUNTER     0x08
+#define IP6T_NTH_OPT_PACKET      0x10
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_nth_info *nthinfo = (struct ip6t_nth_info *)(*match)->data;
+	unsigned int num;
+
+	switch (c) {
+	case '1':
+		/* check for common mistakes... */
+		if ((!invert) && (*flags & IP6T_NTH_OPT_EVERY))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --every twice");
+		if (invert && (*flags & IP6T_NTH_OPT_NOT_EVERY))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify ! --every twice");
+		if ((!invert) && (*flags & IP6T_NTH_OPT_NOT_EVERY))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --every with ! --every");
+		if (invert && (*flags & IP6T_NTH_OPT_EVERY))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify ! --every with --every");
+
+		/* Remember, this function will interpret a leading 0 to be
+		   Octal, a leading 0x to be hexdecimal... */
+                if (string_to_number(optarg, 2, 100, &num) == -1 || num < 2)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad --every `%s', must be between 2 and 100", optarg);
+
+		/* assign the values */
+		nthinfo->every = num-1;
+		nthinfo->startat = 0;
+                nthinfo->packet = 0xFF;
+                if(!(*flags & IP6T_NTH_OPT_EVERY))
+                {
+                        nthinfo->counter = 0;
+                }
+		if (invert)
+		{
+			*flags |= IP6T_NTH_OPT_NOT_EVERY;
+			nthinfo->not = 1;
+		}
+		else
+		{
+			*flags |= IP6T_NTH_OPT_EVERY;
+			nthinfo->not = 0;
+		}
+		break;
+	case '2':
+		/* check for common mistakes... */
+		if (!((*flags & IP6T_NTH_OPT_EVERY) ||
+		      (*flags & IP6T_NTH_OPT_NOT_EVERY)))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --start before --every");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify with ! --start");
+		if (*flags & IP6T_NTH_OPT_START)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --start twice");
+		if (string_to_number(optarg, 0, nthinfo->every, &num) == -1)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad --start `%s', must between 0 and %u", optarg, nthinfo->every);
+		*flags |= IP6T_NTH_OPT_START;
+		nthinfo->startat = num;
+		break;
+        case '3':
+                /* check for common mistakes... */
+                if (invert)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify with ! --counter");
+                if (*flags & IP6T_NTH_OPT_COUNTER)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --counter twice");
+                if (string_to_number(optarg, 0, IP6T_NTH_NUM_COUNTERS-1, &num) == -1)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad --counter `%s', must between 0 and %u", optarg, IP6T_NTH_NUM_COUNTERS-1);
+                /* assign the values */
+                *flags |= IP6T_NTH_OPT_COUNTER;
+                nthinfo->counter = num;
+                break;
+        case '4':
+                /* check for common mistakes... */
+                if (!((*flags & IP6T_NTH_OPT_EVERY) ||
+                      (*flags & IP6T_NTH_OPT_NOT_EVERY)))
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --packet before --every");
+                if ((*flags & IP6T_NTH_OPT_NOT_EVERY))
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --packet with ! --every");
+                if (invert)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify with ! --packet");
+                if (*flags & IP6T_NTH_OPT_PACKET)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "Can't specify --packet twice");
+                if (string_to_number(optarg, 0, nthinfo->every, &num) == -1)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "bad --packet `%s', must between 0 and %u", optarg, nthinfo->every);
+                *flags |= IP6T_NTH_OPT_PACKET;
+                nthinfo->packet = num;
+                break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_nth_info *nthinfo
+		= (const struct ip6t_nth_info *)match->data;
+
+	if (nthinfo->not == 1)
+		printf(" !");
+	printf("every %uth ", (nthinfo->every +1));
+	if (nthinfo->counter != 0)
+		printf("counter #%u ", (nthinfo->counter));
+        if (nthinfo->packet != 0xFF)
+                printf("packet #%u ", nthinfo->packet);
+	if (nthinfo->startat != 0)
+		printf("start at %u ", nthinfo->startat);
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_nth_info *nthinfo
+		= (const struct ip6t_nth_info *)match->data;
+
+	if (nthinfo->not == 1)
+		printf("! ");
+	printf("--every %u ", (nthinfo->every +1));
+	printf("--counter %u ", (nthinfo->counter));
+	if (nthinfo->startat != 0)
+		printf("--start %u ", nthinfo->startat );
+        if (nthinfo->packet != 0xFF)
+                printf("--packet %u ", nthinfo->packet );
+}
+
+struct ip6tables_match nth
+= { NULL,
+    "nth",
+    IPTABLES_VERSION,
+    IP6T_ALIGN(sizeof(struct ip6t_nth_info)),
+    IP6T_ALIGN(sizeof(struct ip6t_nth_info)),
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
+	register_match6(&nth);
+}
---23717851-653840266-1051714170=:15553
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=q1
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0304301649300.15553@dns.toxicfilms.tv>
Content-Description: nth6.patch
Content-Disposition: attachment; filename=q1

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9u
dGg2LnBhdGNoLmlwdjYgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9u
dGg2LnBhdGNoLmlwdjYNCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1h
dGljL2Jhc2UvbnRoNi5wYXRjaC5pcHY2CTE5NzAtMDEtMDEgMDE6MDA6MDAu
MDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMv
YmFzZS9udGg2LnBhdGNoLmlwdjYJMjAwMy0wNC0zMCAxNjoyOTozMC4wMDAw
MDAwMDAgKzAyMDANCkBAIC0wLDAgKzEsMjAwIEBADQorZGlmZiAtTnJ1IGxp
bnV4Lm9yaWcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X250
aC5oIGxpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9u
dGguaA0KKy0tLSBsaW51eC5vcmlnL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVy
X2lwdjYvaXA2dF9udGguaAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAw
MCArMDEwMA0KKysrKyBsaW51eC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9p
cHY2L2lwNnRfbnRoLmgJMjAwMy0wNC0zMCAxNjowNjozMS4wMDAwMDAwMDAg
KzAyMDANCitAQCAtMCwwICsxLDE5IEBADQorKyNpZm5kZWYgX0lQNlRfTlRI
X0gNCisrI2RlZmluZSBfSVA2VF9OVEhfSA0KKysNCisrI2luY2x1ZGUgPGxp
bnV4L3BhcmFtLmg+DQorKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KKysN
CisrI2lmbmRlZiBJUDZUX05USF9OVU1fQ09VTlRFUlMNCisrI2RlZmluZSBJ
UDZUX05USF9OVU1fQ09VTlRFUlMgMTYNCisrI2VuZGlmDQorKw0KKytzdHJ1
Y3QgaXA2dF9udGhfaW5mbyB7DQorKwl1X2ludDhfdCBldmVyeTsNCisrCXVf
aW50OF90IG5vdDsNCisrCXVfaW50OF90IHN0YXJ0YXQ7DQorKwl1X2ludDhf
dCBjb3VudGVyOw0KKysJdV9pbnQ4X3QgcGFja2V0Ow0KKyt9Ow0KKysNCisr
I2VuZGlmIC8qX0lQNlRfTlRIX0gqLw0KK2RpZmYgLU5ydSBsaW51eC5vcmln
L25ldC9pcHY2L25ldGZpbHRlci9pcDZ0X250aC5jIGxpbnV4L25ldC9pcHY2
L25ldGZpbHRlci9pcDZ0X250aC5jDQorLS0tIGxpbnV4Lm9yaWcvbmV0L2lw
djYvbmV0ZmlsdGVyL2lwNnRfbnRoLmMJMTk3MC0wMS0wMSAwMTowMDowMC4w
MDAwMDAwMDAgKzAxMDANCisrKysgbGludXgvbmV0L2lwdjYvbmV0ZmlsdGVy
L2lwNnRfbnRoLmMJMjAwMy0wNC0zMCAxNjoxMToxNC4wMDAwMDAwMDAgKzAy
MDANCitAQCAtMCwwICsxLDE3MyBAQA0KKysvKg0KKysgIFRoaXMgaXMgYSBt
b2R1bGUgd2hpY2ggaXMgdXNlZCBmb3IgbWF0Y2ggc3VwcG9ydCBmb3IgZXZl
cnkgTnRoIHBhY2tldA0KKysgIFRoaXMgZmlsZSBpcyBkaXN0cmlidXRlZCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYw0KKysg
IExpY2Vuc2UgKEdQTCkuIENvcGllcyBvZiB0aGUgR1BMIGNhbiBiZSBvYnRh
aW5lZCBmcm9tOg0KKysgICAgIGZ0cDovL3ByZXAuYWkubWl0LmVkdS9wdWIv
Z251L0dQTA0KKysNCisrICAyMDAxLTA3LTE4IEZhYnJpY2UgTUFSSUUgPGZh
YnJpY2VAbmV0ZmlsdGVyLm9yZz4gOiBpbml0aWFsIGltcGxlbWVudGF0aW9u
Lg0KKysgIDIwMDEtMDktMjAgUmljaGFyZCBXYWduZXIgKHJ3YWduZXJAY2xv
dWRuZXQuY29tKQ0KKysgICAgICAgICogYWRkZWQgc3VwcG9ydCBmb3IgbXVs
dGlwbGUgY291bnRlcnMNCisrICAgICAgICAqIGFkZGVkIHN1cHBvcnQgZm9y
IG1hdGNoaW5nIG9uIGluZGl2aWR1YWwgcGFja2V0cw0KKysgICAgICAgICAg
aW4gdGhlIGNvdW50ZXIgY3ljbGUNCisrICAyMDAzLTA0LTMwIE1hY2llaiBT
b2x0eXNpYWsgPHNvbHRAZG5zLnRveGljZmlsbXMudHY+IDogSVB2NiBQb3J0
DQorKw0KKysqLw0KKysNCisrI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0K
KysjaW5jbHVkZSA8bGludXgvc2tidWZmLmg+DQorKyNpbmNsdWRlIDxsaW51
eC9pcC5oPg0KKysjaW5jbHVkZSA8bmV0L3RjcC5oPg0KKysjaW5jbHVkZSA8
bGludXgvc3BpbmxvY2suaD4NCisrI2luY2x1ZGUgPGxpbnV4L25ldGZpbHRl
cl9pcHY2L2lwNl90YWJsZXMuaD4NCisrI2luY2x1ZGUgPGxpbnV4L25ldGZp
bHRlcl9pcHY2L2lwNnRfbnRoLmg+DQorKw0KKytNT0RVTEVfTElDRU5TRSgi
R1BMIik7DQorKw0KKysvKg0KKysgKiBTdGF0ZSBpbmZvcm1hdGlvbi4NCisr
ICovDQorK3N0cnVjdCBzdGF0ZSB7DQorKwlzcGlubG9ja190IGxvY2s7DQor
Kwl1X2ludDE2X3QgbnVtYmVyOw0KKyt9Ow0KKysNCisrc3RhdGljIHN0cnVj
dCBzdGF0ZSBzdGF0ZXNbSVA2VF9OVEhfTlVNX0NPVU5URVJTXTsNCisrDQor
K3N0YXRpYyBpbnQNCisraXA2dF9udGhfbWF0Y2goY29uc3Qgc3RydWN0IHNr
X2J1ZmYgKnBza2IsDQorKwkgICAgICBjb25zdCBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqaW4sDQorKwkgICAgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0
LA0KKysJICAgICAgY29uc3Qgdm9pZCAqbWF0Y2hpbmZvLA0KKysJICAgICAg
aW50IG9mZnNldCwNCisrCSAgICAgIGNvbnN0IHZvaWQgKmhkciwNCisrCSAg
ICAgIHVfaW50MTZfdCBkYXRhbGVuLA0KKysJICAgICAgaW50ICpob3Rkcm9w
KQ0KKyt7DQorKwkvKiBQYXJhbWV0ZXJzIGZyb20gdXNlcnNwYWNlICovDQor
Kwljb25zdCBzdHJ1Y3QgaXA2dF9udGhfaW5mbyAqaW5mbyA9IG1hdGNoaW5m
bzsNCisrICAgICAgICB1bnNpZ25lZCBjb3VudGVyID0gaW5mby0+Y291bnRl
cjsNCisrICAgICAgIAlpZigoY291bnRlciA8IDApIHx8IChjb3VudGVyID49
IElQNlRfTlRIX05VTV9DT1VOVEVSUykpIA0KKysgICAgICAJew0KKysgICAg
ICAgCQlwcmludGsoS0VSTl9XQVJOSU5HICJudGg6IGludmFsaWQgY291bnRl
ciAldS4gY291bnRlciBiZXR3ZWVuIDAgYW5kICV1XG4iLCBjb3VudGVyLCBJ
UDZUX05USF9OVU1fQ09VTlRFUlMtMSk7DQorKyAgICAgICAgICAgICAgIHJl
dHVybiAwOw0KKysgICAgICAgIH07DQorKw0KKysgICAgICAgIHNwaW5fbG9j
aygmc3RhdGVzW2NvdW50ZXJdLmxvY2spOw0KKysNCisrICAgICAgICAvKiBB
cmUgd2UgbWF0Y2hpbmcgZXZlcnkgbnRoIHBhY2tldD8qLw0KKysgICAgICAg
IGlmIChpbmZvLT5wYWNrZXQgPT0gMHhGRikNCisrICAgICAgICB7DQorKwkJ
LyogV2UncmUgbWF0Y2hpbmcgZXZlcnkgbnRoIHBhY2tldCBhbmQgb25seSBl
dmVyeSBudGggcGFja2V0Ki8NCisrCQkvKiBEbyB3ZSBtYXRjaCBvciBpbnZl
cnQgbWF0Y2g/ICovDQorKwkJaWYgKGluZm8tPm5vdCA9PSAwKQ0KKysJCXsN
CisrCQkJaWYgKHN0YXRlc1tjb3VudGVyXS5udW1iZXIgPT0gMCkNCisrCQkJ
ew0KKysJCQkJKytzdGF0ZXNbY291bnRlcl0ubnVtYmVyOw0KKysJCQkJZ290
byBtYXRjaDsNCisrCQkJfQ0KKysJCQlpZiAoc3RhdGVzW2NvdW50ZXJdLm51
bWJlciA+PSBpbmZvLT5ldmVyeSkNCisrCQkJCXN0YXRlc1tjb3VudGVyXS5u
dW1iZXIgPSAwOyAvKiByZXNldCB0aGUgY291bnRlciAqLw0KKysJCQllbHNl
DQorKwkJCQkrK3N0YXRlc1tjb3VudGVyXS5udW1iZXI7DQorKwkJCWdvdG8g
ZG9udG1hdGNoOw0KKysJCX0NCisrCQllbHNlDQorKwkJew0KKysJCQlpZiAo
c3RhdGVzW2NvdW50ZXJdLm51bWJlciA9PSAwKQ0KKysJCQl7DQorKwkJCQkr
K3N0YXRlc1tjb3VudGVyXS5udW1iZXI7DQorKwkJCQlnb3RvIGRvbnRtYXRj
aDsNCisrCQkJfQ0KKysJCQlpZiAoc3RhdGVzW2NvdW50ZXJdLm51bWJlciA+
PSBpbmZvLT5ldmVyeSkNCisrCQkJCXN0YXRlc1tjb3VudGVyXS5udW1iZXIg
PSAwOw0KKysJCQllbHNlDQorKwkJCQkrK3N0YXRlc1tjb3VudGVyXS5udW1i
ZXI7DQorKwkJCWdvdG8gbWF0Y2g7DQorKwkJfQ0KKysgICAgICAgIH0NCisr
ICAgICAgICBlbHNlDQorKyAgICAgICAgew0KKysJCS8qIFdlJ3JlIHVzaW5n
IHRoZSAtLXBhY2tldCwgc28gdGhlcmUgbXVzdCBiZSBhIHJ1bGUgZm9yIGV2
ZXJ5IHZhbHVlICovDQorKwkJaWYgKHN0YXRlc1tjb3VudGVyXS5udW1iZXIg
PT0gaW5mby0+cGFja2V0KQ0KKysJCXsNCisrCQkJLyogb25seSBpbmNyZW1l
bnQgdGhlIGNvdW50ZXIgd2hlbiBhIG1hdGNoIGhhcHBlbnMgKi8NCisrCQkJ
aWYgKHN0YXRlc1tjb3VudGVyXS5udW1iZXIgPj0gaW5mby0+ZXZlcnkpDQor
KwkJCQlzdGF0ZXNbY291bnRlcl0ubnVtYmVyID0gMDsgLyogcmVzZXQgdGhl
IGNvdW50ZXIgKi8NCisrCQkJZWxzZQ0KKysJCQkJKytzdGF0ZXNbY291bnRl
cl0ubnVtYmVyOw0KKysJCQlnb3RvIG1hdGNoOw0KKysJCX0NCisrCQllbHNl
DQorKwkJCWdvdG8gZG9udG1hdGNoOw0KKysJfQ0KKysNCisrIGRvbnRtYXRj
aDoNCisrCS8qIGRvbid0IG1hdGNoICovDQorKwlzcGluX3VubG9jaygmc3Rh
dGVzW2NvdW50ZXJdLmxvY2spOw0KKysJcmV0dXJuIDA7DQorKw0KKysgbWF0
Y2g6DQorKwlzcGluX3VubG9jaygmc3RhdGVzW2NvdW50ZXJdLmxvY2spOw0K
KysJcmV0dXJuIDE7DQorK30NCisrDQorK3N0YXRpYyBpbnQNCisraXA2dF9u
dGhfY2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJsZW5hbWUsDQorKwkJICAg
Y29uc3Qgc3RydWN0IGlwNnRfaXA2ICplLA0KKysJCSAgIHZvaWQgKm1hdGNo
aW5mbywNCisrCQkgICB1bnNpZ25lZCBpbnQgbWF0Y2hzaXplLA0KKysJCSAg
IHVuc2lnbmVkIGludCBob29rX21hc2spDQorK3sNCisrCS8qIFBhcmFtZXRl
cnMgZnJvbSB1c2Vyc3BhY2UgKi8NCisrCWNvbnN0IHN0cnVjdCBpcDZ0X250
aF9pbmZvICppbmZvID0gbWF0Y2hpbmZvOw0KKysgICAgICAgIHVuc2lnbmVk
IGNvdW50ZXIgPSBpbmZvLT5jb3VudGVyOw0KKysgICAgICAgIGlmKChjb3Vu
dGVyIDwgMCkgfHwgKGNvdW50ZXIgPj0gSVA2VF9OVEhfTlVNX0NPVU5URVJT
KSkgDQorKwl7DQorKwkJcHJpbnRrKEtFUk5fV0FSTklORyAibnRoOiBpbnZh
bGlkIGNvdW50ZXIgJXUuIGNvdW50ZXIgYmV0d2VlbiAwIGFuZCAldVxuIiwg
Y291bnRlciwgSVA2VF9OVEhfTlVNX0NPVU5URVJTLTEpOw0KKysgICAgICAg
ICAgICAgICAJcmV0dXJuIDA7DQorKyAgICAgICAJfTsNCisrDQorKwlpZiAo
bWF0Y2hzaXplICE9IElQNlRfQUxJR04oc2l6ZW9mKHN0cnVjdCBpcDZ0X250
aF9pbmZvKSkpIHsNCisrCQlwcmludGsoIm50aDogbWF0Y2hzaXplICV1ICE9
ICV1XG4iLCBtYXRjaHNpemUsDQorKwkJICAgICAgIElQNlRfQUxJR04oc2l6
ZW9mKHN0cnVjdCBpcDZ0X250aF9pbmZvKSkpOw0KKysJCXJldHVybiAwOw0K
KysJfQ0KKysNCisrCXN0YXRlc1tjb3VudGVyXS5udW1iZXIgPSBpbmZvLT5z
dGFydGF0Ow0KKysNCisrCXJldHVybiAxOw0KKyt9DQorKw0KKytzdGF0aWMg
c3RydWN0IGlwNnRfbWF0Y2ggaXA2dF9udGhfcmVnID0geyANCisrCXtOVUxM
LCBOVUxMfSwNCisrCSJudGgiLA0KKysJaXA2dF9udGhfbWF0Y2gsDQorKwlp
cDZ0X250aF9jaGVja2VudHJ5LA0KKysJTlVMTCwNCisrCVRISVNfTU9EVUxF
IH07DQorKw0KKytzdGF0aWMgaW50IF9faW5pdCBpbml0KHZvaWQpDQorK3sN
CisrCXVuc2lnbmVkIGNvdW50ZXI7DQorKyAgICAgICAgbWVtc2V0KCZzdGF0
ZXMsIDAsIHNpemVvZihzdGF0ZXMpKTsNCisrCWlmIChpcDZ0X3JlZ2lzdGVy
X21hdGNoKCZpcDZ0X250aF9yZWcpKQ0KKysJCXJldHVybiAtRUlOVkFMOw0K
KysNCisrICAgICAgICBmb3IoY291bnRlciA9IDA7IGNvdW50ZXIgPCBJUDZU
X05USF9OVU1fQ09VTlRFUlM7IGNvdW50ZXIrKykgDQorKwl7DQorKwkJc3Bp
bl9sb2NrX2luaXQoJihzdGF0ZXNbY291bnRlcl0ubG9jaykpOw0KKysgICAg
ICAgIH07DQorKw0KKysJcHJpbnRrKCJpcDZ0X250aCBtYXRjaCBsb2FkZWRc
biIpOw0KKysJcmV0dXJuIDA7DQorK30NCisrDQorK3N0YXRpYyB2b2lkIF9f
ZXhpdCBmaW5pKHZvaWQpDQorK3sNCisrCWlwNnRfdW5yZWdpc3Rlcl9tYXRj
aCgmaXA2dF9udGhfcmVnKTsNCisrCXByaW50aygiaXA2dF9udGggbWF0Y2gg
dW5sb2FkZWRcbiIpOw0KKyt9DQorKw0KKyttb2R1bGVfaW5pdChpbml0KTsN
CisrbW9kdWxlX2V4aXQoZmluaSk7DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9y
aWcvcGF0Y2gtby1tYXRpYy9iYXNlL250aDYucGF0Y2guaXB2Ni5jb25maWcu
aW4gbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9udGg2LnBhdGNoLmlw
djYuY29uZmlnLmluDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRp
Yy9iYXNlL250aDYucGF0Y2guaXB2Ni5jb25maWcuaW4JMTk3MC0wMS0wMSAw
MTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gt
by1tYXRpYy9iYXNlL250aDYucGF0Y2guaXB2Ni5jb25maWcuaW4JMjAwMy0w
NC0zMCAxNjozMDoxNS4wMDAwMDAwMDAgKzAyMDANCkBAIC0wLDAgKzEsMiBA
QA0KKyAgZGVwX3RyaXN0YXRlICcgIE1BQyBhZGRyZXNzIG1hdGNoIHN1cHBv
cnQnIENPTkZJR19JUDZfTkZfTUFUQ0hfTUFDICRDT05GSUdfSVA2X05GX0lQ
VEFCTEVTDQorICBkZXBfdHJpc3RhdGUgJyAgTnRoIG1hdGNoIHN1cHBvcnQn
IENPTkZJR19JUDZfTkZfTUFUQ0hfTlRIICRDT05GSUdfSVA2X05GX0lQVEFC
TEVTDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9i
YXNlL250aDYucGF0Y2guaXB2Ni5jb25maWd1cmUuaGVscCBuZXRmaWx0ZXIv
cGF0Y2gtby1tYXRpYy9iYXNlL250aDYucGF0Y2guaXB2Ni5jb25maWd1cmUu
aGVscA0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9u
dGg2LnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMTk3MC0wMS0wMSAwMTow
MDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1t
YXRpYy9iYXNlL250aDYucGF0Y2guaXB2Ni5jb25maWd1cmUuaGVscAkyMDAz
LTA0LTMwIDE2OjQyOjAyLjAwMDAwMDAwMCArMDIwMA0KQEAgLTAsMCArMSwy
MyBAQA0KK0NPTkZJR19JUDZfTkZfTUFUQ0hfTUFDDQorTnRoIG1hdGNoIHN1
cHBvcnQNCitDT05GSUdfSVA2X05GX01BVENIX05USA0KKyAgVGhpcyBvcHRp
b24gYWRkcyBhIGBOdGgnIG1hdGNoLCB3aGljaCBhbGxvdyB5b3UgdG8gbWFr
ZQ0KKyAgcnVsZXMgdGhhdCBtYXRjaCBldmVyeSBOdGggcGFja2V0LiAgQnkg
ZGVmYXVsdCB0aGVyZSBhcmUgDQorICAxNiBkaWZmZXJlbnQgY291bnRlcnMu
DQorDQorW29wdGlvbnNdDQorICAgLS1ldmVyeSAgICAgTnRoICAgICAgICAg
ICAgICBNYXRjaCBldmVyeSBOdGggcGFja2V0DQorICBbLS1jb3VudGVyXSAg
bnVtICAgICAgICAgICAgICBVc2UgY291bnRlciAwLTE1IChkZWZhdWx0OjAp
DQorICBbLS1zdGFydF0gICAgbnVtICAgICAgICAgICAgICBJbml0aWFsaXpl
IHRoZSBjb3VudGVyIGF0IHRoZSBudW1iZXIgJ251bScNCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGluc3RlYWQgb2YgMC4gTXVzdCBiZSBi
ZXR3ZWVuIDAgYW5kIE50aC0xDQorICBbLS1wYWNrZXRdICAgbnVtICAgICAg
ICAgICAgICBNYXRjaCBvbiAnbnVtJyBwYWNrZXQuIE11c3QgYmUgYmV0d2Vl
biAwDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhbmQgTnRo
LTEuDQorDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJZiAt
LXBhY2tldCBpcyB1c2VkIGZvciBhIGNvdW50ZXIgdGhhbg0KKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgdGhlcmUgbXVzdCBiZSBOdGggbnVt
YmVyIG9mIC0tcGFja2V0DQorICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBydWxlcywgY292ZXJpbmcgYWxsIHZhbHVlcyBiZXR3ZWVuIDAgYW5k
DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBOdGgtMSBpbmNs
dXNpdmVseS4NCisgDQorICBJZiB5b3Ugd2FudCB0byBjb21waWxlIGl0IGFz
IGEgbW9kdWxlLCBzYXkgTSBoZXJlIGFuZCByZWFkDQorICBEb2N1bWVudGF0
aW9uL21vZHVsZXMudHh0LiAgSWYgdW5zdXJlLCBzYXkgYE4nLg0KKw0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9udGg2
LnBhdGNoLmlwdjYuaGVscCBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNl
L250aDYucGF0Y2guaXB2Ni5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0
Y2gtby1tYXRpYy9iYXNlL250aDYucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEt
MDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3Bh
dGNoLW8tbWF0aWMvYmFzZS9udGg2LnBhdGNoLmlwdjYuaGVscAkyMDAzLTA0
LTMwIDE2OjQwOjA4LjAwMDAwMDAwMCArMDIwMA0KQEAgLTAsMCArMSw0NSBA
QA0KK0F1dGhvcjogRmFicmljZSBNQVJJRSA8ZmFicmljZUBuZXRmaWx0ZXIu
b3JnPg0KK1BvcnRlZDogTWFjaWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94
aWNmaWxtcy50dj4NCitTdGF0dXM6IFdvcmtzIEZvciBNZS4NCisNCitUaGlz
IG9wdGlvbiBhZGRzIENPTkZJR19JUDZfTkZfTUFUQ0hfTlRILCB3aGljaCBz
dXBwbGllcyBhIG1hdGNoDQorbW9kdWxlIHRoYXQgd2lsbCBhbGxvdyB5b3Ug
dG8gbWF0Y2ggZXZlcnkgTnRoIHBhY2tldCBlbmNvdW50ZXJlZC4NCitCeSBk
ZWZhdWx0IHRoZXJlIGFyZSAxNiBkaWZmZXJlbnQgY291bnRlcnMgdGhhdCBj
YW4gYmUgdXNlZC4NCisNCitUaGlzIG1hdGNoIGZ1bmN0aW9ucyBpbiBvbmUg
b2YgdHdvIHdheXMNCisxKSBNYXRjaCBldmVyIE50aCBwYWNrZXQsIGFuZCBv
bmx5IHRoZSBOdGggcGFja2V0Lg0KKyAgIGV4YW1wbGU6DQorICAgIGlwNnRh
YmxlcyAtdCBtYW5nbGUgLUEgUFJFUk9VVElORyAtbSBudGggLS1ldmVyeSAx
MCAtaiBEUk9QDQorICAgVGhpcyBydWxlIHdpbGwgZHJvcCBldmVyeSAxMHRo
IHBhY2tldC4NCisNCisyKSBVbmlxdWUgcnVsZSBmb3IgZXZlcnkgcGFja2V0
Lg0KKw0KK1tXQVJOSU5HXSBVbmxpa2UgdGhlIElQdjQgdmVyc2lvbiwgcnVs
ZXMgYmVsb3cgd2lsbCBub3Qgd29yayB1bnRpbA0KKyAgICAgICAgICBpcDZ0
YWJsZXMgaGFzIE5BVCBzdXBwb3J0IGFuZCBjb25uZWN0aW9uIHRyYWNraW5n
Lg0KKyAgICAgICAgICBGaW5kIG91dCBvdGhlciB1c2VzIHRoYW4gdGhlIG9u
ZSBiZWxvdy4NCisNCisgICAgaXA2dGFibGVzIC10IG5hdCAtQSBQT1NUUk9V
VElORyAtbyBldGgwIC1tIG50aCAtLWNvdW50ZXIgNyBcDQorICAgICAgICAg
ICAgIC0tZXZlcnkgMyAtLXBhY2tldCAwIC1qIFNOQVQgLS10by1zb3VyY2Ug
MTAuMC4wLjUNCisgICAgaXA2dGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElO
RyAtbyBldGgwIC1tIG50aCAtLWNvdW50ZXIgNyBcDQorICAgICAgICAgICAg
IC0tZXZlcnkgMyAtLXBhY2tldCAxIC1qIFNOQVQgLS10by1zb3VyY2UgMTAu
MC4wLjYNCisgICAgaXA2dGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElORyAt
byBldGgwIC1tIG50aCAtLWNvdW50ZXIgNyBcDQorICAgICAgICAgICAgIC0t
ZXZlcnkgMyAtLXBhY2tldCAyIC1qIFNOQVQgLS10by1zb3VyY2UgMTAuMC4w
LjcNCisgICBUaGlzIGV4YW1wbGUgZXZlbmx5IHNwbGl0cyBjb25uZWN0aW9u
cyBiZXR3ZWVuIHRoZSB0aHJlZSBTTkFUDQorICAgYWRkcmVzc2VzLg0KKw0K
KyAgIEJ5IHVzaW5nIHRoZSBtYW5nbGUgdGFibGUgYW5kIGlwcm91dGUyLCB5
b3UgY2FuIHNldHVwIGNvbXBsZXgNCisgICBsb2FkLWJhbGFuY2VkIHJvdXRp
bmcuICBUaGVyZSdzIGxvdCBvZiBvdGhlciB1c2VzLiAgQmUgY3JlYXRpdmUh
DQorDQorU3VwcHBvcnRlZCBvcHRpb25zIGFyZToNCisgICAtLWV2ZXJ5ICAg
ICBOdGggICAgICAgICBNYXRjaCBldmVyeSBOdGggcGFja2V0DQorICBbLS1j
b3VudGVyXSAgbnVtICAgICAgICAgVXNlIGNvdW50ZXIgMC0xNSAoZGVmYXVs
dDowKQ0KKyAgWy0tc3RhcnRdICAgIG51bSAgICAgICAgIEluaXRpYWxpemUg
dGhlIGNvdW50ZXIgYXQgdGhlIG51bWJlciAnbnVtJw0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGluc3RlYWQgb2YgMC4gTXVzdCBiZSBiZXR3ZWVu
IDAgYW5kIE50aC0xDQorICBbLS1wYWNrZXRdICAgbnVtICAgICAgICAgTWF0
Y2ggb24gJ251bScgcGFja2V0LiBNdXN0IGJlIGJldHdlZW4gMA0KKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGFuZCBOdGgtMS4NCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICBJZiAtLXBhY2tldCBpcyB1c2VkIGZvciBhIGNv
dW50ZXIgdGhhbg0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoZXJl
IG11c3QgYmUgTnRoIG51bWJlciBvZiAtLXBhY2tldA0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHJ1bGVzLCBjb3ZlcmluZyBhbGwgdmFsdWVzIGJl
dHdlZW4gMCBhbmQNCisgICAgICAgICAgICAgICAgICAgICAgICAgICBOdGgt
MSBpbmNsdXNpdmVseS4NCisNCisgICBUaGlzIGlzIGFuIElQdjYgcG9ydCBm
cm9tIElQdjQgbW9kdWxlLg0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3Bh
dGNoLW8tbWF0aWMvYmFzZS9udGg2LnBhdGNoLmlwdjYubWFrZWZpbGUgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9udGg2LnBhdGNoLmlwdjYubWFr
ZWZpbGUNCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2Uv
bnRoNi5wYXRjaC5pcHY2Lm1ha2VmaWxlCTE5NzAtMDEtMDEgMDE6MDA6MDAu
MDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMv
YmFzZS9udGg2LnBhdGNoLmlwdjYubWFrZWZpbGUJMjAwMy0wNC0zMCAxNjoz
MToxNy4wMDAwMDAwMDAgKzAyMDANCkBAIC0wLDAgKzEsMyBAQA0KK29iai0k
KENPTkZJR19JUDZfTkZfVEFSR0VUX0xPRykgKz0gaXA2dF9MT0cubw0KKw0K
K29iai0kKENPTkZJR19JUDZfTkZfTUFUQ0hfTlRIKSArPSBpcDZ0X250aC5v
DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lv
bnMvTWFrZWZpbGUgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL01h
a2VmaWxlDQotLS0gbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lv
bnMvTWFrZWZpbGUJMjAwMy0wNC0wOSAxNjozMDowMy4wMDAwMDAwMDAgKzAy
MDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvTWFrZWZp
bGUJMjAwMy0wNC0zMCAxNjoyMjoxOS4wMDAwMDAwMDAgKzAyMDANCkBAIC02
LDcgKzYsNyBAQA0KICMgcGFja2FnZSAoSFcpDQogIw0KIFBGX0VYVF9TTElC
Oj1haCBjb25udHJhY2sgZHNjcCBlY24gZXNwIGhlbHBlciBpY21wIGlwbGlt
aXQgbGVuZ3RoIGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBvd25lciBwaHlz
ZGV2IHBrdHR5cGUgcnBjIHN0YW5kYXJkIHN0YXRlIHRjcCB0Y3Btc3MgdG9z
IHR0bCB1ZHAgdW5jbGVhbiBETkFUIERTQ1AgRUNOIExPRyBNQVJLIE1BU1FV
RVJBREUgTUlSUk9SIFJFRElSRUNUIFJFSkVDVCBTQU1FIFNOQVQgVEFSUElU
IFRDUE1TUyBUT1MgVFRMIFVMT0cNCi1QRjZfRVhUX1NMSUI6PWV1aTY0IGhs
IGljbXB2NiBsZW5ndGggbGltaXQgbWFjIG1hcmsgbXVsdGlwb3J0IG93bmVy
IHN0YW5kYXJkIHRjcCB1ZHAgSEwgTE9HIE1BUksgZnV6enkNCitQRjZfRVhU
X1NMSUI6PWV1aTY0IGhsIGljbXB2NiBsZW5ndGggbnRoIGxpbWl0IG1hYyBt
YXJrIG11bHRpcG9ydCBvd25lciBzdGFuZGFyZCB0Y3AgdWRwIEhMIExPRyBN
QVJLDQogDQogIyBPcHRpb25hbHMNCiBQRl9FWFRfU0xJQl9PUFRTOj0kKGZv
cmVhY2ggVCwkKHdpbGRjYXJkIGV4dGVuc2lvbnMvLiotdGVzdCksJChzaGVs
bCBLRVJORUxfRElSPSQoS0VSTkVMX0RJUikgJChUKSkpDQpkaWZmIC1OcnUg
bmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9u
dGguYyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9u
dGguYw0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25z
L2xpYmlwNnRfbnRoLmMJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAwMDAwMDAg
KzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGli
aXA2dF9udGguYwkyMDAzLTA0LTMwIDE2OjIwOjUyLjAwMDAwMDAwMCArMDIw
MA0KQEAgLTAsMCArMSwyMzggQEANCisvKiANCisgICBTaGFyZWQgbGlicmFy
eSBhZGQtb24gdG8gaXB0YWJsZXMgdG8gYWRkIG1hdGNoIHN1cHBvcnQgZm9y
IGV2ZXJ5IE50aCBwYWNrZXQNCisgICANCisgICBUaGlzIGZpbGUgaXMgZGlz
dHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMNCisgICBMaWNlbnNlIChHUEwpLiBDb3BpZXMgb2YgdGhlIEdQTCBj
YW4gYmUgb2J0YWluZWQgZnJvbToNCisgICBmdHA6Ly9wcmVwLmFpLm1pdC5l
ZHUvcHViL2dudS9HUEwNCisNCisgICAyMDAxLTA3LTE3IEZhYnJpY2UgTUFS
SUUgPGZhYnJpY2VAbmV0ZmlsdGVyLm9yZz4gOiBpbml0aWFsIGRldmVsb3Bt
ZW50Lg0KKyAgIDIwMDEtMDktMjAgUmljaGFyZCBXYWduZXIgKHJ3YWduZXJA
Y2xvdWRuZXQuY29tKQ0KKyAgICAgICAgKiBhZGRlZCBzdXBwb3J0IGZvciBt
dWx0aXBsZSBjb3VudGVycw0KKyAgICAgICAgKiBhZGRlZCBzdXBwb3J0IGZv
ciBtYXRjaGluZyBvbiBpbmRpdmlkdWFsIHBhY2tldHMNCisgICAgICAgICAg
aW4gdGhlIGNvdW50ZXIgY3ljbGUNCisqLw0KKw0KKyNpbmNsdWRlIDxzdGRp
by5oPg0KKyNpbmNsdWRlIDxuZXRkYi5oPg0KKyNpbmNsdWRlIDxzdHJpbmcu
aD4NCisjaW5jbHVkZSA8c3RkbGliLmg+DQorI2luY2x1ZGUgPHN5c2xvZy5o
Pg0KKyNpbmNsdWRlIDxnZXRvcHQuaD4NCisjaW5jbHVkZSA8aXA2dGFibGVz
Lmg+DQorI2luY2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9pcHY2L2lwNl90YWJs
ZXMuaD4NCisjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9u
dGguaD4NCisNCisNCisvKiBGdW5jdGlvbiB3aGljaCBwcmludHMgb3V0IHVz
YWdlIG1lc3NhZ2UuICovDQorc3RhdGljIHZvaWQNCitoZWxwKHZvaWQpDQor
ew0KKwlwcmludGYoDQorIm50aCB2JXMgb3B0aW9uczpcbiINCisiICAgLS1l
dmVyeSAgICAgTnRoICAgICAgICAgICAgICBNYXRjaCBldmVyeSBOdGggcGFj
a2V0XG4iDQorIiAgWy0tY291bnRlcl0gIG51bSAgICAgICAgICAgICAgVXNl
IGNvdW50ZXIgMC0ldSAoZGVmYXVsdDowKVxuIg0KKyIgIFstLXN0YXJ0XSAg
ICBudW0gICAgICAgICAgICAgIEluaXRpYWxpemUgdGhlIGNvdW50ZXIgYXQg
dGhlIG51bWJlciAnbnVtJ1xuIg0KKyIgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGluc3RlYWQgb2YgMC4gTXVzdCBiZSBiZXR3ZWVuIDAgYW5k
IE50aC0xXG4iDQorIiAgWy0tcGFja2V0XSAgIG51bSAgICAgICAgICAgICAg
TWF0Y2ggb24gJ251bScgcGFja2V0LiBNdXN0IGJlIGJldHdlZW4gMFxuIg0K
KyIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFuZCBOdGgtMS5c
blxuIg0KKyIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIElmIC0t
cGFja2V0IGlzIHVzZWQgZm9yIGEgY291bnRlciB0aGFuXG4iDQorIiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhlcmUgbXVzdCBiZSBOdGgg
bnVtYmVyIG9mIC0tcGFja2V0XG4iDQorIiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcnVsZXMsIGNvdmVyaW5nIGFsbCB2YWx1ZXMgYmV0d2Vl
biAwIGFuZFxuIg0KKyIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IE50aC0xIGluY2x1c2l2ZWx5LlxuIiwNCitJUFRBQkxFU19WRVJTSU9OLCBJ
UDZUX05USF9OVU1fQ09VTlRFUlMtMSk7DQorfQ0KKw0KK3N0YXRpYyBzdHJ1
Y3Qgb3B0aW9uIG9wdHNbXSA9IHsNCisJeyAiZXZlcnkiLCAxLCAwLCAnMScg
fSwNCisJeyAic3RhcnQiLCAxLCAwLCAnMicgfSwNCisgICAgICAgIHsgImNv
dW50ZXIiLCAxLCAwLCAnMycgfSwNCisgICAgICAgIHsgInBhY2tldCIsIDEs
IDAsICc0JyB9LA0KKwl7IDAgfQ0KK307DQorDQorLyogSW5pdGlhbGl6ZSB0
aGUgdGFyZ2V0LiAqLw0KK3N0YXRpYyB2b2lkDQoraW5pdChzdHJ1Y3QgaXA2
dF9lbnRyeV9tYXRjaCAqbSwgdW5zaWduZWQgaW50ICpuZmNhY2hlKQ0KK3sN
CisJKm5mY2FjaGUgfD0gTkZDX1VOS05PV047DQorfQ0KKw0KKyNkZWZpbmUg
SVA2VF9OVEhfT1BUX0VWRVJZCTB4MDENCisjZGVmaW5lIElQNlRfTlRIX09Q
VF9OT1RfRVZFUlkJMHgwMg0KKyNkZWZpbmUgSVA2VF9OVEhfT1BUX1NUQVJU
CTB4MDQNCisjZGVmaW5lIElQNlRfTlRIX09QVF9DT1VOVEVSICAgICAweDA4
DQorI2RlZmluZSBJUDZUX05USF9PUFRfUEFDS0VUICAgICAgMHgxMA0KKw0K
Ky8qIEZ1bmN0aW9uIHdoaWNoIHBhcnNlcyBjb21tYW5kIG9wdGlvbnM7IHJl
dHVybnMgdHJ1ZSBpZiBpdA0KKyAgIGF0ZSBhbiBvcHRpb24gKi8NCitzdGF0
aWMgaW50DQorcGFyc2UoaW50IGMsIGNoYXIgKiphcmd2LCBpbnQgaW52ZXJ0
LCB1bnNpZ25lZCBpbnQgKmZsYWdzLA0KKyAgICAgIGNvbnN0IHN0cnVjdCBp
cDZ0X2VudHJ5ICplbnRyeSwNCisgICAgICB1bnNpZ25lZCBpbnQgKm5mY2Fj
aGUsDQorICAgICAgc3RydWN0IGlwNnRfZW50cnlfbWF0Y2ggKiptYXRjaCkN
Cit7DQorCXN0cnVjdCBpcDZ0X250aF9pbmZvICpudGhpbmZvID0gKHN0cnVj
dCBpcDZ0X250aF9pbmZvICopKCptYXRjaCktPmRhdGE7DQorCXVuc2lnbmVk
IGludCBudW07DQorDQorCXN3aXRjaCAoYykgew0KKwljYXNlICcxJzoNCisJ
CS8qIGNoZWNrIGZvciBjb21tb24gbWlzdGFrZXMuLi4gKi8NCisJCWlmICgo
IWludmVydCkgJiYgKCpmbGFncyAmIElQNlRfTlRIX09QVF9FVkVSWSkpDQor
CQkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJICAgIkNh
bid0IHNwZWNpZnkgLS1ldmVyeSB0d2ljZSIpOw0KKwkJaWYgKGludmVydCAm
JiAoKmZsYWdzICYgSVA2VF9OVEhfT1BUX05PVF9FVkVSWSkpDQorCQkJZXhp
dF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJICAgIkNhbid0IHNw
ZWNpZnkgISAtLWV2ZXJ5IHR3aWNlIik7DQorCQlpZiAoKCFpbnZlcnQpICYm
ICgqZmxhZ3MgJiBJUDZUX05USF9PUFRfTk9UX0VWRVJZKSkNCisJCQlleGl0
X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0KKwkJCQkgICAiQ2FuJ3Qgc3Bl
Y2lmeSAtLWV2ZXJ5IHdpdGggISAtLWV2ZXJ5Iik7DQorCQlpZiAoaW52ZXJ0
ICYmICgqZmxhZ3MgJiBJUDZUX05USF9PUFRfRVZFUlkpKQ0KKwkJCWV4aXRf
ZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJCSAgICJDYW4ndCBzcGVj
aWZ5ICEgLS1ldmVyeSB3aXRoIC0tZXZlcnkiKTsNCisNCisJCS8qIFJlbWVt
YmVyLCB0aGlzIGZ1bmN0aW9uIHdpbGwgaW50ZXJwcmV0IGEgbGVhZGluZyAw
IHRvIGJlIA0KKwkJICAgT2N0YWwsIGEgbGVhZGluZyAweCB0byBiZSBoZXhk
ZWNpbWFsLi4uICovDQorICAgICAgICAgICAgICAgIGlmIChzdHJpbmdfdG9f
bnVtYmVyKG9wdGFyZywgMiwgMTAwLCAmbnVtKSA9PSAtMSB8fCBudW0gPCAy
KQ0KKyAgICAgICAgICAgICAgICAgICAgICAgIGV4aXRfZXJyb3IoUEFSQU1F
VEVSX1BST0JMRU0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAiYmFkIC0tZXZlcnkgYCVzJywgbXVzdCBiZSBiZXR3ZWVuIDIgYW5k
IDEwMCIsIG9wdGFyZyk7DQorDQorCQkvKiBhc3NpZ24gdGhlIHZhbHVlcyAq
Lw0KKwkJbnRoaW5mby0+ZXZlcnkgPSBudW0tMTsNCisJCW50aGluZm8tPnN0
YXJ0YXQgPSAwOw0KKyAgICAgICAgICAgICAgICBudGhpbmZvLT5wYWNrZXQg
PSAweEZGOw0KKyAgICAgICAgICAgICAgICBpZighKCpmbGFncyAmIElQNlRf
TlRIX09QVF9FVkVSWSkpDQorICAgICAgICAgICAgICAgIHsNCisgICAgICAg
ICAgICAgICAgICAgICAgICBudGhpbmZvLT5jb3VudGVyID0gMDsNCisgICAg
ICAgICAgICAgICAgfQ0KKwkJaWYgKGludmVydCkNCisJCXsNCisJCQkqZmxh
Z3MgfD0gSVA2VF9OVEhfT1BUX05PVF9FVkVSWTsNCisJCQludGhpbmZvLT5u
b3QgPSAxOw0KKwkJfQ0KKwkJZWxzZQ0KKwkJew0KKwkJCSpmbGFncyB8PSBJ
UDZUX05USF9PUFRfRVZFUlk7DQorCQkJbnRoaW5mby0+bm90ID0gMDsNCisJ
CX0NCisJCWJyZWFrOw0KKwljYXNlICcyJzoNCisJCS8qIGNoZWNrIGZvciBj
b21tb24gbWlzdGFrZXMuLi4gKi8NCisJCWlmICghKCgqZmxhZ3MgJiBJUDZU
X05USF9PUFRfRVZFUlkpIHx8DQorCQkgICAgICAoKmZsYWdzICYgSVA2VF9O
VEhfT1BUX05PVF9FVkVSWSkpKQ0KKwkJCWV4aXRfZXJyb3IoUEFSQU1FVEVS
X1BST0JMRU0sDQorCQkJCSAgICJDYW4ndCBzcGVjaWZ5IC0tc3RhcnQgYmVm
b3JlIC0tZXZlcnkiKTsNCisJCWlmIChpbnZlcnQpDQorCQkJZXhpdF9lcnJv
cihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJICAgIkNhbid0IHNwZWNpZnkg
d2l0aCAhIC0tc3RhcnQiKTsNCisJCWlmICgqZmxhZ3MgJiBJUDZUX05USF9P
UFRfU1RBUlQpDQorCQkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwN
CisJCQkJICAgIkNhbid0IHNwZWNpZnkgLS1zdGFydCB0d2ljZSIpOw0KKwkJ
aWYgKHN0cmluZ190b19udW1iZXIob3B0YXJnLCAwLCBudGhpbmZvLT5ldmVy
eSwgJm51bSkgPT0gLTEpDQorICAgICAgICAgICAgICAgICAgICAgICAgZXhp
dF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICJiYWQgLS1zdGFydCBgJXMnLCBtdXN0IGJl
dHdlZW4gMCBhbmQgJXUiLCBvcHRhcmcsIG50aGluZm8tPmV2ZXJ5KTsNCisJ
CSpmbGFncyB8PSBJUDZUX05USF9PUFRfU1RBUlQ7DQorCQludGhpbmZvLT5z
dGFydGF0ID0gbnVtOw0KKwkJYnJlYWs7DQorICAgICAgICBjYXNlICczJzoN
CisgICAgICAgICAgICAgICAgLyogY2hlY2sgZm9yIGNvbW1vbiBtaXN0YWtl
cy4uLiAqLw0KKyAgICAgICAgICAgICAgICBpZiAoaW52ZXJ0KQ0KKyAgICAg
ICAgICAgICAgICAgICAgICAgIGV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JM
RU0sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiQ2Fu
J3Qgc3BlY2lmeSB3aXRoICEgLS1jb3VudGVyIik7DQorICAgICAgICAgICAg
ICAgIGlmICgqZmxhZ3MgJiBJUDZUX05USF9PUFRfQ09VTlRFUikNCisgICAg
ICAgICAgICAgICAgICAgICAgICBleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9C
TEVNLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIkNh
bid0IHNwZWNpZnkgLS1jb3VudGVyIHR3aWNlIik7DQorICAgICAgICAgICAg
ICAgIGlmIChzdHJpbmdfdG9fbnVtYmVyKG9wdGFyZywgMCwgSVA2VF9OVEhf
TlVNX0NPVU5URVJTLTEsICZudW0pID09IC0xKQ0KKyAgICAgICAgICAgICAg
ICAgICAgICAgIGV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiYmFkIC0tY291bnRl
ciBgJXMnLCBtdXN0IGJldHdlZW4gMCBhbmQgJXUiLCBvcHRhcmcsIElQNlRf
TlRIX05VTV9DT1VOVEVSUy0xKTsNCisgICAgICAgICAgICAgICAgLyogYXNz
aWduIHRoZSB2YWx1ZXMgKi8NCisgICAgICAgICAgICAgICAgKmZsYWdzIHw9
IElQNlRfTlRIX09QVF9DT1VOVEVSOw0KKyAgICAgICAgICAgICAgICBudGhp
bmZvLT5jb3VudGVyID0gbnVtOw0KKyAgICAgICAgICAgICAgICBicmVhazsN
CisgICAgICAgIGNhc2UgJzQnOg0KKyAgICAgICAgICAgICAgICAvKiBjaGVj
ayBmb3IgY29tbW9uIG1pc3Rha2VzLi4uICovDQorICAgICAgICAgICAgICAg
IGlmICghKCgqZmxhZ3MgJiBJUDZUX05USF9PUFRfRVZFUlkpIHx8DQorICAg
ICAgICAgICAgICAgICAgICAgICgqZmxhZ3MgJiBJUDZUX05USF9PUFRfTk9U
X0VWRVJZKSkpDQorICAgICAgICAgICAgICAgICAgICAgICAgZXhpdF9lcnJv
cihQQVJBTUVURVJfUFJPQkxFTSwNCisgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICJDYW4ndCBzcGVjaWZ5IC0tcGFja2V0IGJlZm9yZSAt
LWV2ZXJ5Iik7DQorICAgICAgICAgICAgICAgIGlmICgoKmZsYWdzICYgSVA2
VF9OVEhfT1BUX05PVF9FVkVSWSkpDQorICAgICAgICAgICAgICAgICAgICAg
ICAgZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICJDYW4ndCBzcGVjaWZ5IC0tcGFj
a2V0IHdpdGggISAtLWV2ZXJ5Iik7DQorICAgICAgICAgICAgICAgIGlmIChp
bnZlcnQpDQorICAgICAgICAgICAgICAgICAgICAgICAgZXhpdF9lcnJvcihQ
QVJBTUVURVJfUFJPQkxFTSwNCisgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICJDYW4ndCBzcGVjaWZ5IHdpdGggISAtLXBhY2tldCIpOw0K
KyAgICAgICAgICAgICAgICBpZiAoKmZsYWdzICYgSVA2VF9OVEhfT1BUX1BB
Q0tFVCkNCisgICAgICAgICAgICAgICAgICAgICAgICBleGl0X2Vycm9yKFBB
UkFNRVRFUl9QUk9CTEVNLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIkNhbid0IHNwZWNpZnkgLS1wYWNrZXQgdHdpY2UiKTsNCisg
ICAgICAgICAgICAgICAgaWYgKHN0cmluZ190b19udW1iZXIob3B0YXJnLCAw
LCBudGhpbmZvLT5ldmVyeSwgJm51bSkgPT0gLTEpDQorICAgICAgICAgICAg
ICAgICAgICAgICAgZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJiYWQgLS1wYWNr
ZXQgYCVzJywgbXVzdCBiZXR3ZWVuIDAgYW5kICV1Iiwgb3B0YXJnLCBudGhp
bmZvLT5ldmVyeSk7DQorICAgICAgICAgICAgICAgICpmbGFncyB8PSBJUDZU
X05USF9PUFRfUEFDS0VUOw0KKyAgICAgICAgICAgICAgICBudGhpbmZvLT5w
YWNrZXQgPSBudW07DQorICAgICAgICAgICAgICAgIGJyZWFrOw0KKwlkZWZh
dWx0Og0KKwkJcmV0dXJuIDA7DQorCX0NCisJcmV0dXJuIDE7DQorfQ0KKw0K
Ky8qIEZpbmFsIGNoZWNrOyBub3RoaW5nLiAqLw0KK3N0YXRpYyB2b2lkIGZp
bmFsX2NoZWNrKHVuc2lnbmVkIGludCBmbGFncykNCit7DQorfQ0KKw0KKy8q
IFByaW50cyBvdXQgdGhlIHRhcmdpbmZvLiAqLw0KK3N0YXRpYyB2b2lkDQor
cHJpbnQoY29uc3Qgc3RydWN0IGlwNnRfaXA2ICppcCwNCisgICAgICBjb25z
dCBzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRjaCAqbWF0Y2gsDQorICAgICAgaW50
IG51bWVyaWMpDQorew0KKwljb25zdCBzdHJ1Y3QgaXA2dF9udGhfaW5mbyAq
bnRoaW5mbw0KKwkJPSAoY29uc3Qgc3RydWN0IGlwNnRfbnRoX2luZm8gKilt
YXRjaC0+ZGF0YTsNCisNCisJaWYgKG50aGluZm8tPm5vdCA9PSAxKQ0KKwkJ
cHJpbnRmKCIgISIpOw0KKwlwcmludGYoImV2ZXJ5ICV1dGggIiwgKG50aGlu
Zm8tPmV2ZXJ5ICsxKSk7DQorCWlmIChudGhpbmZvLT5jb3VudGVyICE9IDAp
IA0KKwkJcHJpbnRmKCJjb3VudGVyICMldSAiLCAobnRoaW5mby0+Y291bnRl
cikpOw0KKyAgICAgICAgaWYgKG50aGluZm8tPnBhY2tldCAhPSAweEZGKQ0K
KyAgICAgICAgICAgICAgICBwcmludGYoInBhY2tldCAjJXUgIiwgbnRoaW5m
by0+cGFja2V0KTsNCisJaWYgKG50aGluZm8tPnN0YXJ0YXQgIT0gMCkNCisJ
CXByaW50Zigic3RhcnQgYXQgJXUgIiwgbnRoaW5mby0+c3RhcnRhdCk7DQor
fQ0KKw0KKy8qIFNhdmVzIHRoZSB1bmlvbiBpcDZ0X3RhcmdpbmZvIGluIHBh
cnNhYmxlIGZvcm0gdG8gc3Rkb3V0LiAqLw0KK3N0YXRpYyB2b2lkDQorc2F2
ZShjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlwLCBjb25zdCBzdHJ1Y3QgaXA2
dF9lbnRyeV9tYXRjaCAqbWF0Y2gpDQorew0KKwljb25zdCBzdHJ1Y3QgaXA2
dF9udGhfaW5mbyAqbnRoaW5mbw0KKwkJPSAoY29uc3Qgc3RydWN0IGlwNnRf
bnRoX2luZm8gKiltYXRjaC0+ZGF0YTsNCisNCisJaWYgKG50aGluZm8tPm5v
dCA9PSAxKQ0KKwkJcHJpbnRmKCIhICIpOw0KKwlwcmludGYoIi0tZXZlcnkg
JXUgIiwgKG50aGluZm8tPmV2ZXJ5ICsxKSk7DQorCXByaW50ZigiLS1jb3Vu
dGVyICV1ICIsIChudGhpbmZvLT5jb3VudGVyKSk7DQorCWlmIChudGhpbmZv
LT5zdGFydGF0ICE9IDApDQorCQlwcmludGYoIi0tc3RhcnQgJXUgIiwgbnRo
aW5mby0+c3RhcnRhdCApOw0KKyAgICAgICAgaWYgKG50aGluZm8tPnBhY2tl
dCAhPSAweEZGKQ0KKyAgICAgICAgICAgICAgICBwcmludGYoIi0tcGFja2V0
ICV1ICIsIG50aGluZm8tPnBhY2tldCApOw0KK30NCisNCitzdHJ1Y3QgaXA2
dGFibGVzX21hdGNoIG50aA0KKz0geyBOVUxMLA0KKyAgICAibnRoIiwNCisg
ICAgSVBUQUJMRVNfVkVSU0lPTiwNCisgICAgSVA2VF9BTElHTihzaXplb2Yo
c3RydWN0IGlwNnRfbnRoX2luZm8pKSwNCisgICAgSVA2VF9BTElHTihzaXpl
b2Yoc3RydWN0IGlwNnRfbnRoX2luZm8pKSwNCisgICAgJmhlbHAsDQorICAg
ICZpbml0LA0KKyAgICAmcGFyc2UsDQorICAgICZmaW5hbF9jaGVjaywNCisg
ICAgJnByaW50LA0KKyAgICAmc2F2ZSwNCisgICAgb3B0cw0KK307DQorDQor
dm9pZCBfaW5pdCh2b2lkKQ0KK3sNCisJcmVnaXN0ZXJfbWF0Y2g2KCZudGgp
Ow0KK30NCg==

---23717851-653840266-1051714170=:15553--
