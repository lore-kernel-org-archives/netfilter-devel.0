From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: [PATCH] connrate for patch-o-matic-ng
Date: Thu, 18 Mar 2004 01:00:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87fzc7m63w.fsf@aka.i.naked.iki.fi>
References: <87znatx1en.fsf@iki.fi>
	<20040317141249.GF21899@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=

Harald Welte wrote:
> Due to recent events
> [http://www.netfilter.org/news/2004-03-02-fsc-gpl.html and others]
> we would ask you to explicitly include a GPL disclaimer in the
> header of all your .c files.

Fair enough. I have now done so.

> Please then re-submit to this list (and add me as Cc, this way I
> won't miss it).

Here they are again.

> Thanks for your patience

No worries. I am not a hasty man. Why, I have been expecting a reply
from Patrick McHardy that was coming tomorrow for a couple weeks
already ;-)

Thanks,
-- Naked

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=connrate.diff

Index: connrate/help
===================================================================
RCS file: connrate/help
diff -N connrate/help
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/help	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,34 @@
+The connrate match is used to match against the current transfer speed of a
+connection. The algorithm averages transferred bytes over a time sliding window
+of constant size. The maximum and minimum rates measurable are explained in the
+code, along the algorithm used in the measurements.
+
+This match can easily be used to reclassify connections based on their current
+transfer rate, but is not meant for directly dropping packets, because packet
+drops affect the rate being estimated.
+
+The transfer rate per connection can also be viewed through
+/proc/net/ip_conntrack.
+
+Usage:
+--connrate [!] [FROM]:[TO]
+
+will match packet from a connection which is currently transferring more than
+FROM bytes per second and less than TO byte per second. 'inf' can be used to
+signify largest measurable transfer rate. If FROM is omitted, it defaults to
+zero. If TO is omitted, it defaults to infinity. "!" is used to match packets
+not falling in the range.
+
+Example:
+
+iptables .. -m connrate --connrate 10000:100000 ...
+
+ => match packets in connections transferring faster than 10kbps, but slower
+    than 100kbps.
+
+iptables .. -m tos --tos Minimize-Delay \
+            -m connrate --connrate 20000:inf \
+            -j TOS --set-tos Maximize-Throughput
+
+ => match packets in minimize-delay TOS connections that are transferring
+    faster than 20kbps and change their tos to maximize-throughput instead.
Index: connrate/info
===================================================================
RCS file: connrate/info
diff -N connrate/info
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/info	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,4 @@
+Author: Nuutti Kotivuori <naked@iki.fi>
+Status: Working, but received only minimal testing
+Repository: extra
+Requires: linux >= 2.6.0
Index: connrate/linux.patch
===================================================================
RCS file: connrate/linux.patch
diff -N connrate/linux.patch
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux.patch	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,54 @@
+diff -uprN kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack.h kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack.h
+--- kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack.h	2003-05-27 12:34:07.000000000 +0300
++++ kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-27 02:55:43.000000000 +0200
+@@ -98,6 +98,10 @@ union ip_conntrack_nat_help {
+ };
+ #endif
+ 
++#ifdef CONFIG_IP_NF_CONNTRACK_RATE
++#include <linux/netfilter_ipv4/ip_conntrack_rate.h>
++#endif
++
+ #ifdef __KERNEL__
+ 
+ #include <linux/types.h>
+@@ -206,6 +210,10 @@ struct ip_conntrack
+ 	} nat;
+ #endif /* CONFIG_IP_NF_NAT_NEEDED */
+ 
++#ifdef CONFIG_IP_NF_CONNTRACK_RATE
++        struct ip_conntrack_rate rate;
++#endif
++
+ };
+ 
+ /* get master conntrack via master expectation */
+diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_core.c kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c
+--- kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-19 10:56:05.000000000 +0200
++++ kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-27 02:55:43.000000000 +0200
+@@ -778,6 +778,11 @@ resolve_normal_ct(struct sk_buff *skb,
+ 		*set_reply = 0;
+ 	}
+ 	skb->nfct = &h->ctrack->infos[*ctinfo];
++
++#ifdef CONFIG_IP_NF_CONNTRACK_RATE
++	ip_conntrack_rate_count(&h->ctrack->rate, skb->len);
++#endif
++
+ 	return h->ctrack;
+ }
+ 
+diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_standalone.c kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c
+--- kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-19 10:56:06.000000000 +0200
++++ kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-27 02:55:43.000000000 +0200
+@@ -110,6 +110,10 @@ print_conntrack(char *buffer, struct ip_
+ 		len += sprintf(buffer + len, "[ASSURED] ");
+ 	len += sprintf(buffer + len, "use=%u ",
+ 		       atomic_read(&conntrack->ct_general.use));
++#ifdef CONFIG_IP_NF_CONNTRACK_RATE
++	len += sprintf(buffer + len, "rate=%u ",
++		       ip_conntrack_rate_get(&conntrack->rate));
++#endif
+ 	len += sprintf(buffer + len, "\n");
+ 
+ 	return len;
Index: connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_rate.h
===================================================================
RCS file: connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_rate.h
diff -N connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_rate.h
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_rate.h	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,33 @@
+#ifndef _IP_CONNTRACK_RATE_H
+#define _IP_CONNTRACK_RATE_H
+
+/* estimation interval, in jiffies */
+#define IP_CONNTRACK_RATE_INTERVAL (3 * HZ)
+
+/* scale on how many tokens per byte to generate */
+#define IP_CONNTRACK_RATE_SCALE 100
+
+/* per conntrack: transfer rate in connection */
+struct ip_conntrack_rate {
+	/* jiffies of previous received packet */
+	unsigned long prev;
+	/* average rate of tokens per jiffy */
+	u_int32_t avgrate;
+};
+
+#ifdef __KERNEL__
+
+/* Count a packet of len into given rate structure. */
+extern void
+ip_conntrack_rate_count(struct ip_conntrack_rate *ctr,
+			unsigned int len);
+
+/* Return current rate as bytes per second. Note that the returned
+   rate is the rate at last received packet, not counting time has
+   that passed after it. */
+extern u_int32_t
+ip_conntrack_rate_get(struct ip_conntrack_rate *ctr);
+
+#endif /* __KERNEL__ */
+
+#endif /* _IP_CONNTRACK_RATE_H */
Index: connrate/linux/include/linux/netfilter_ipv4/ipt_connrate.h
===================================================================
RCS file: connrate/linux/include/linux/netfilter_ipv4/ipt_connrate.h
diff -N connrate/linux/include/linux/netfilter_ipv4/ipt_connrate.h
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/include/linux/netfilter_ipv4/ipt_connrate.h	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,12 @@
+#ifndef _IPT_CONNRATE_H
+#define _IPT_CONNRATE_H
+
+struct ipt_connrate_info
+{
+	/* Per connection transfer rate, in bytes per second. If
+	   'from' is smaller or equal to 'to', rate is matched to be
+	   inside the inclusive range [from,to], otherwise rate is
+	   matched to be outside the inclusive range [to,from]. */
+	u_int32_t from, to;
+};
+#endif
Index: connrate/linux/net/ipv4/netfilter/Kconfig.ladd
===================================================================
RCS file: connrate/linux/net/ipv4/netfilter/Kconfig.ladd
diff -N connrate/linux/net/ipv4/netfilter/Kconfig.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/net/ipv4/netfilter/Kconfig.ladd	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,28 @@
+config IP_NF_CONNTRACK_RATE
+	bool "Connection rate estimation"
+	depends on IP_NF_CONNTRACK
+	help
+
+	  This enables per connection transfer rate estimation in connection
+	  tracking code. This enlarges the amount of memory required by each
+	  connection tracked a bit and adds the overhead of calculating the
+	  transmission rate on every received packet.
+	
+	  This is required to be able to match on the per connection transfer
+	  rate, and can be a nice statistic to see in the connection tracking
+	  table, but is useless otherwise.
+	
+	  If unsure, say N.
+
+config IP_NF_MATCH_CONNRATE
+	tristate "Connection rate match support"
+	depends on IP_NF_CONNTRACK_RATE && IP_NF_CONNTRACK && IP_NF_IPTABLES
+	help
+	  This allows matching on the transfer rate on a per connection basis.
+
+	  Connection transfer rate estimation is performed separately by the
+	  connection tracking code and is unaffected by the presence of matches
+	  on it. Several connection rate matches may match a single packet and
+	  every match will see the same rate.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
Index: connrate/linux/net/ipv4/netfilter/Makefile.ladd
===================================================================
RCS file: connrate/linux/net/ipv4/netfilter/Makefile.ladd
diff -N connrate/linux/net/ipv4/netfilter/Makefile.ladd
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/net/ipv4/netfilter/Makefile.ladd	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_IP_NF_CONNTRACK_RATE) += ip_conntrack_rate.o
Index: connrate/linux/net/ipv4/netfilter/Makefile.ladd_2
===================================================================
RCS file: connrate/linux/net/ipv4/netfilter/Makefile.ladd_2
diff -N connrate/linux/net/ipv4/netfilter/Makefile.ladd_2
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/net/ipv4/netfilter/Makefile.ladd_2	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack.o
+obj-$(CONFIG_IP_NF_MATCH_CONNRATE) += ipt_connrate.o
Index: connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c
===================================================================
RCS file: connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c
diff -N connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,131 @@
+/* Connection transfer rate estimator for netfilter.
+ *
+ * Copyright (c) 2004 Nuutti Kotivuori <naked@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+#include <linux/jiffies.h>
+#include <linux/netfilter_ipv4/ip_conntrack_rate.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+/*
+   I wanted to build a simpler and more robust rate estimator than the
+   one used in sched/estimator.c. After evaluating a few choices I
+   settled with the one given in an example in [RFC2859], which is the
+   rate estimator described in [TON98].
+
+   I will copy the example table from [RFC2859] here:
+
+========================================================================
+|Initially:                                                            |
+|                                                                      |
+|      AVG_INTERVAL = a constant;                                      |
+|      avg-rate     = CTR;                                             |
+|      t-front      = 0;                                               |
+|                                                                      |
+|Upon each packet's arrival, the rate estimator updates its variables: |
+|                                                                      |
+|      Bytes_in_win = avg-rate * AVG_INTERVAL;                         |
+|      New_bytes    = Bytes_in_win + pkt_size;                         |
+|      avg-rate     = New_bytes/( now - t-front + AVG_INTERVAL);       |
+|      t-front      = now;                                             |
+|                                                                      |
+|Where:                                                                |
+|      now          = The time of the current packet arrival           |
+|      pkt_size     = The packet size in bytes of the arriving packet  |
+|      avg-rate     = Measured Arrival Rate of traffic stream          |
+|      AVG_INTERVAL = Time window over which history is kept           |
+|                                                                      |
+|                                                                      |
+|              Figure 2. Example Rate Estimator Algorithm              |
+|                                                                      |
+========================================================================
+
+   Additionally we have to be concerned about overflows, remainders
+   and resolution in the algorithm. These are documented in the code
+   below.
+
+   References:
+
+   [RFC2859] W. Fang, N. Seddigh and B. Nandy, "A Time Sliding Window
+             Three Colour Marker (TSWTCM)", RFC 2859, June 2000.
+
+   [TON98]   D.D. Clark, W. Fang, "Explicit Allocation of Best Effort
+             Packet Delivery Service", IEEE/ACM Transactions on
+             Networking, August 1998, Vol 6. No. 4, pp. 362-373.
+*/
+
+/* There are three important limits which need to be explored: maximum
+   expressable rate, minimum expressable rate, minimum packet size to
+   be countable.
+
+   Maximum expressable rate depends on the size of the window and the
+   scale we have chosen. It is approximately 2^32 / window /
+   scale. For example with a window of 3 seconds and a scale of 100,
+   the maximum rate is 14 megabytes per second, eg. 115Mbit/s.
+
+   Minimum expressable rate depends on scale and the HZ on the
+   architecture. It is HZ / scale. For example on most platforms where
+   HZ is now 1000, this is 10 bytes per second, eg. 0.08kbit/s.
+
+   Minimum packet size to be countable depends on the window size,
+   scale and HZ. This is basically the smallest packet that when
+   arriving immediately after the previous packet can cause the
+   average rate to rise from zero to one. It is (HZ * window) /
+   scale. For example with a window of 3 seconds, a scale of 100 and a
+   HZ of 1000, this would be 30. That is, a continuous stream of
+   packets less than 30 bytes long would not be able to rise the rate
+   above zero.
+
+   These limitations are a simple consequence of the current
+   implementation using integer arithmetics. */
+
+/* Maximum number of tokens in total that we can have in a window is
+   limited by the range of the u_int32_t datatype. We prevent the
+   overflow of this by first calculating the maximum amount of tokens
+   a single packet can add and substracting that from the maximum
+   value the window can get. */
+#define MAX_PACKET_IN_TOKENS (0x0000ffff * IP_CONNTRACK_RATE_SCALE)
+#define MAX_TOKENS_IN_WINDOW (0xffffffff - MAX_PACKET_IN_TOKENS)
+
+/* Synchronizes all accesses to ip_conntrack_rate structures. */
+static DECLARE_RWLOCK(rate_lock);
+
+void
+ip_conntrack_rate_count(struct ip_conntrack_rate *ctr,
+			unsigned int len)
+{
+	u_int32_t new_bytes;
+	unsigned long now = jiffies;
+
+	WRITE_LOCK(&rate_lock);
+	new_bytes = (ctr->avgrate * IP_CONNTRACK_RATE_INTERVAL +
+		     len * IP_CONNTRACK_RATE_SCALE);
+	if(new_bytes > MAX_TOKENS_IN_WINDOW)
+		new_bytes = MAX_TOKENS_IN_WINDOW;
+	if(now >= ctr->prev) /* Ignore packets at possible jiffie wraps */
+		ctr->avgrate = new_bytes / (now - ctr->prev +
+					    IP_CONNTRACK_RATE_INTERVAL);
+	ctr->prev = now;
+        WRITE_UNLOCK(&rate_lock);
+}
+
+u_int32_t
+ip_conntrack_rate_get(struct ip_conntrack_rate *ctr)
+{
+	u_int32_t rate;
+	READ_LOCK(&rate_lock);
+	/* Rate can not overflow here if IP_CONNTRACK_RATE_INTERVAL is
+	   atleast HZ. If it is not, we could change the order of
+	   calculations at the possible cost of precision. */
+	rate = ctr->avgrate * HZ / IP_CONNTRACK_RATE_SCALE;
+	READ_UNLOCK(&rate_lock);
+	return rate;
+}
Index: connrate/linux/net/ipv4/netfilter/ipt_connrate.c
===================================================================
RCS file: connrate/linux/net/ipv4/netfilter/ipt_connrate.c
diff -N connrate/linux/net/ipv4/netfilter/ipt_connrate.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ connrate/linux/net/ipv4/netfilter/ipt_connrate.c	17 Mar 2004 22:50:39 -0000
@@ -0,0 +1,74 @@
+/* Connection transfer rate match for netfilter.
+ *
+ * Copyright (c) 2004 Nuutti Kotivuori <naked@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_connrate.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nuutti Kotivuori <naked@iki.fi>");
+MODULE_DESCRIPTION("iptables connection transfer rate match module");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_connrate_info *sinfo = matchinfo;
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+	u_int32_t rate;
+
+	if (!(ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo)))
+		return 0; /* no match */
+
+	rate = ip_conntrack_rate_get(&ct->rate);
+	if (sinfo->from > sinfo->to) /* inverted range */
+		return (rate < sinfo->to || rate > sinfo->from);
+	else /* normal range */
+		return (rate >= sinfo->from && rate <= sinfo->to);
+}
+
+static int
+check(const char *tablename,
+      const struct ipt_ip *ip,
+      void *matchinfo,
+      unsigned int matchsize,
+      unsigned int hook_mask)
+{
+	if(matchsize != IPT_ALIGN(sizeof(struct ipt_connrate_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct ipt_match connrate_match = {
+	.name = "connrate",
+	.match = &match,
+	.checkentry = &check,
+	.me = THIS_MODULE
+};
+
+static int __init init(void)
+{
+	need_ip_conntrack();
+	return ipt_register_match(&connrate_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&connrate_match);
+}
+
+module_init(init);
+module_exit(fini);

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=iptables-connrate.diff

Index: extensions/.connrate-test
===================================================================
RCS file: extensions/.connrate-test
diff -N extensions/.connrate-test
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ extensions/.connrate-test	17 Mar 2004 22:50:58 -0000
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_connrate.h ] && echo connrate
Index: extensions/libipt_connrate.c
===================================================================
RCS file: extensions/libipt_connrate.c
diff -N extensions/libipt_connrate.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ extensions/libipt_connrate.c	17 Mar 2004 22:50:58 -0000
@@ -0,0 +1,189 @@
+/* Shared library add-on to iptables to add connection rate tracking
+ * support.
+ *
+ * Copyright (c) 2004 Nuutti Kotivuori <naked@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ **/
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ipt_connrate.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"connrate v%s options:\n"
+" --connrate [!] [from]:[to]\n"
+"				Match connection transfer rate in bytes\n"
+"				per second. `inf' can be used for maximum\n"
+"				expressible value.\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "connrate", 1, 0, '1' },
+	{0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* caching not yet implemented */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static u_int32_t
+parse_value(const char *arg, u_int32_t def)
+{
+	char *end;
+	size_t len;
+	u_int32_t value;
+
+	len = strlen(arg);
+	if(len == 0)
+		return def;
+	if(strcmp(arg, "inf") == 0)
+		return 0xFFFFFFFF;
+	value = strtoul(arg, &end, 0);
+	if(*end != '\0')
+		exit_error(PARAMETER_PROBLEM,
+			   "Bad value in range `%s'", arg);
+	return value;
+}
+
+static void
+parse_range(const char *arg, struct ipt_connrate_info *si)
+{
+	char *buffer;
+	char *colon;
+
+	buffer = strdup(arg);
+	if ((colon = strchr(buffer, ':')) == NULL)
+		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+	*colon = '\0';
+	si->from = parse_value(buffer, 0);
+	si->to = parse_value(colon+1, 0xFFFFFFFF);
+	if (si->from > si->to)
+		exit_error(PARAMETER_PROBLEM, "%u should be less than %u", si->from,si->to);
+	free(buffer);
+}
+
+#define CONNRATE_OPT 0x01
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)(*match)->data;
+	u_int32_t tmp;
+
+	switch (c) {
+	case '1':
+		if (*flags & CONNRATE_OPT)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--connrate' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_range(argv[optind-1], sinfo);
+		if (invert) {
+			tmp = sinfo->from;
+			sinfo->from = sinfo->to;
+			sinfo->to = tmp;
+		}
+		*flags |= CONNRATE_OPT;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & CONNRATE_OPT))
+		exit_error(PARAMETER_PROBLEM,
+			   "connrate match: You must specify `--connrate'");
+}
+
+static void
+print_value(u_int32_t value)
+{
+	if(value == 0xFFFFFFFF)
+		printf("inf");
+	else
+		printf("%u", value);
+}
+
+static void
+print_range(struct ipt_connrate_info *sinfo)
+{
+	if (sinfo->from > sinfo->to) {
+		printf("! ");
+		print_value(sinfo->to);
+		printf(":");
+		print_value(sinfo->from);
+	} else {
+		print_value(sinfo->from);
+		printf(":");
+		print_value(sinfo->to);
+	}
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
+
+	printf("connrate ");
+	print_range(sinfo);
+	printf(" ");
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
+
+	printf("--connrate ");
+	print_range(sinfo);
+	printf(" ");
+}
+
+static
+struct iptables_match state
+= { NULL,
+    "connrate",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_connrate_info)),
+    IPT_ALIGN(sizeof(struct ipt_connrate_info)),
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
Index: extensions/libipt_connrate.man
===================================================================
RCS file: extensions/libipt_connrate.man
diff -N extensions/libipt_connrate.man
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ extensions/libipt_connrate.man	17 Mar 2004 22:50:58 -0000
@@ -0,0 +1,6 @@
+This module matches the current transfer rate in a connection.
+.TP
+.BI "--connrate " "[!] [\fIfrom\fP]:[\fIto\fP]"
+Match against the current connection transfer rate being within 'from'
+and 'to' bytes per second. When the "!" argument is used before the
+range, the sense of the match is inverted.

--=-=-=--
