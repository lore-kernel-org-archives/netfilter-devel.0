From: Nuutti Kotivuori <naked@iki.fi>
Subject: [PATCH] ipt_connrate: round two.
Date: Fri, 27 Feb 2004 04:56:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87llmp44e1.fsf@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
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

--=-=-=

So, I have reworked my patch based on the suggestions received on the
list. Notable changes are:

 * RWLOCK for conntrack->rate structures.
 * 'unsigned long' to 'u_int32_t' in 'from' and 'to' values.
 * Proper .connrate-test file.

With the CVS being down right at this moment, I wasn't able to fetch
the latest patch-o-matic-ng to build these patches against it. I will
do so with the next iteration.

The first patch is against the 2.6.3 kernel on this round but should
apply against any 2.6.x - and the second is still built against the
debian iptables version, but should apply against any most iptables
versions.

With this iteration I hope to get the kernel parts more or less
finalized. And with the next iteration, I hope to make this a patch
against patch-o-matic-ng and rewrite the libipt_connrate.c file to be
much cleaner and more in line with the extensions in the mainline
iptables.

Any feedback is greatly appreciated.

-- Naked

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=ipt_connrate.diff

diff -uprN kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack.h kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack.h
--- kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack.h	2003-05-27 12:34:07.000000000 +0300
+++ kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02-27 02:55:43.000000000 +0200
@@ -98,6 +98,10 @@ union ip_conntrack_nat_help {
 };
 #endif
 
+#ifdef CONFIG_IP_NF_CONNTRACK_RATE
+#include <linux/netfilter_ipv4/ip_conntrack_rate.h>
+#endif
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>
@@ -206,6 +210,10 @@ struct ip_conntrack
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
+#ifdef CONFIG_IP_NF_CONNTRACK_RATE
+        struct ip_conntrack_rate rate;
+#endif
+
 };
 
 /* get master conntrack via master expectation */
diff -uprN kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack_rate.h kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_rate.h
--- kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ip_conntrack_rate.h	1970-01-01 02:00:00.000000000 +0200
+++ kernel-source-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_rate.h	2004-02-27 02:55:43.000000000 +0200
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
diff -uprN kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ipt_connrate.h kernel-source-2.6.3/include/linux/netfilter_ipv4/ipt_connrate.h
--- kernel-source-2.6.3.old/include/linux/netfilter_ipv4/ipt_connrate.h	1970-01-01 02:00:00.000000000 +0200
+++ kernel-source-2.6.3/include/linux/netfilter_ipv4/ipt_connrate.h	2004-02-27 03:05:42.000000000 +0200
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
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/Kconfig kernel-source-2.6.3/net/ipv4/netfilter/Kconfig
--- kernel-source-2.6.3.old/net/ipv4/netfilter/Kconfig	2004-02-05 10:19:58.000000000 +0200
+++ kernel-source-2.6.3/net/ipv4/netfilter/Kconfig	2004-02-27 02:55:43.000000000 +0200
@@ -19,6 +19,22 @@ config IP_NF_CONNTRACK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
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
 config IP_NF_FTP
 	tristate "FTP protocol support"
 	depends on IP_NF_CONNTRACK
@@ -256,6 +272,19 @@ config IP_NF_MATCH_CONNTRACK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
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
+
 config IP_NF_MATCH_OWNER
 	tristate "Owner match support"
 	depends on IP_NF_IPTABLES
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/Makefile kernel-source-2.6.3/net/ipv4/netfilter/Makefile
--- kernel-source-2.6.3.old/net/ipv4/netfilter/Makefile	2003-09-27 03:02:03.000000000 +0300
+++ kernel-source-2.6.3/net/ipv4/netfilter/Makefile	2004-02-27 02:55:43.000000000 +0200
@@ -18,6 +18,7 @@ ipchains-objs		:= $(ip_nf_compat-objs) i
 
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_IP_NF_CONNTRACK_RATE) += ip_conntrack_rate.o
 
 # connection tracking helpers
 obj-$(CONFIG_IP_NF_AMANDA) += ip_conntrack_amanda.o
@@ -62,6 +63,7 @@ obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_STATE) += ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack.o
+obj-$(CONFIG_IP_NF_MATCH_CONNRATE) += ipt_connrate.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
 
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_core.c kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c
--- kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-19 10:56:05.000000000 +0200
+++ kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-27 02:55:43.000000000 +0200
@@ -778,6 +778,11 @@ resolve_normal_ct(struct sk_buff *skb,
 		*set_reply = 0;
 	}
 	skb->nfct = &h->ctrack->infos[*ctinfo];
+
+#ifdef CONFIG_IP_NF_CONNTRACK_RATE
+	ip_conntrack_rate_count(&h->ctrack->rate, skb->len);
+#endif
+
 	return h->ctrack;
 }
 
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_rate.c kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_rate.c
--- kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_rate.c	1970-01-01 02:00:00.000000000 +0200
+++ kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_rate.c	2004-02-27 03:33:35.000000000 +0200
@@ -0,0 +1,127 @@
+/*
+ * Connection transfer rate estimator for netfilter.
+ *
+ * Copyright (c) 2004 Nuutti Kotivuori
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
+	ctr->avgrate = new_bytes / (now - ctr->prev +
+				    IP_CONNTRACK_RATE_INTERVAL);
+	ctr->prev = now;
+	WRITE_UNLOCK(&rate_lock);
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
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_standalone.c kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c
--- kernel-source-2.6.3.old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-19 10:56:06.000000000 +0200
+++ kernel-source-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-27 02:55:43.000000000 +0200
@@ -110,6 +110,10 @@ print_conntrack(char *buffer, struct ip_
 		len += sprintf(buffer + len, "[ASSURED] ");
 	len += sprintf(buffer + len, "use=%u ",
 		       atomic_read(&conntrack->ct_general.use));
+#ifdef CONFIG_IP_NF_CONNTRACK_RATE
+	len += sprintf(buffer + len, "rate=%u ",
+		       ip_conntrack_rate_get(&conntrack->rate));
+#endif
 	len += sprintf(buffer + len, "\n");
 
 	return len;
diff -uprN kernel-source-2.6.3.old/net/ipv4/netfilter/ipt_connrate.c kernel-source-2.6.3/net/ipv4/netfilter/ipt_connrate.c
--- kernel-source-2.6.3.old/net/ipv4/netfilter/ipt_connrate.c	1970-01-01 02:00:00.000000000 +0200
+++ kernel-source-2.6.3/net/ipv4/netfilter/ipt_connrate.c	2004-02-27 02:55:43.000000000 +0200
@@ -0,0 +1,70 @@
+/* Connection transfer rate match for netfilter.
+ *
+ * Copyright (c) 2004 Nuutti Kotivuori
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
Content-Disposition: attachment; filename=libipt_connrate.diff

diff -uprN ../../debian.old/build/iptables-1.2.9/extensions/.connrate-test iptables-1.2.9/extensions/.connrate-test
--- ../../debian.old/build/iptables-1.2.9/extensions/.connrate-test	1970-01-01 02:00:00.000000000 +0200
+++ iptables-1.2.9/extensions/.connrate-test	2004-02-27 04:25:53.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_connrate.h ] && echo connrate
diff -uprN ../../debian.old/build/iptables-1.2.9/extensions/libipt_connrate.c iptables-1.2.9/extensions/libipt_connrate.c
--- ../../debian.old/build/iptables-1.2.9/extensions/libipt_connrate.c	1970-01-01 02:00:00.000000000 +0200
+++ iptables-1.2.9/extensions/libipt_connrate.c	2004-02-27 04:34:00.000000000 +0200
@@ -0,0 +1,135 @@
+/* Shared library add-on to iptables to add connection rate tracking
+   support. */
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
+" [!] --connrate from:[to]\n"
+"				FIXME\n"
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
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static void
+parse_range(const char *arg, struct ipt_connrate_info *si)
+{
+	char *colon,*p;
+
+	si->from = strtol(arg,&colon,10);
+	if (*colon != ':') 
+		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+	si->to = strtol(colon+1,&p,10);
+	if (p == colon+1) {
+		/* second number omited */
+		si->to = 0xffffffff;
+	}
+	if (si->from > si->to)
+		exit_error(PARAMETER_PROBLEM, "%u should be less than %u", si->from,si->to);
+}
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
+	int i;
+
+	switch (c) {
+	case '1':
+		if (check_inverse(optarg, &invert, &optind, 0))
+			optind++;
+
+		parse_range(argv[optind-1], sinfo);
+		if (invert) {
+			i = sinfo->from;
+			sinfo->from = sinfo->to;
+			sinfo->to = i;
+		}
+		*flags = 1;
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
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--connrate'");
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
+	if (sinfo->from > sinfo->to) 
+		printf("connrate ! %u:%u",sinfo->to,sinfo->from);
+	else
+		printf("connrate %u:%u",sinfo->from,sinfo->to);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
+
+	if (sinfo->from > sinfo->to) 
+		printf("! --connrate %u:%u",sinfo->to,sinfo->from);
+	else
+		printf("--connrate %u:%u",sinfo->from,sinfo->to);
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

--=-=-=--
