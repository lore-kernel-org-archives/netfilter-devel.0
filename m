From: Tim Gardner <timg@tpi.com>
Subject: [PATCH] 3 of 3 for patch-o-matic-ng
Date: Wed, 17 Mar 2004 15:30:47 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403171530.47451.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_BVRQ2X5TZ3N8RU95WQ6L"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_BVRQ2X5TZ3N8RU95WQ6L
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This match filter is an extension of the ideas in FUZZY, though it is a=20
complete rewrite. It matches at a linearly increasing rate if the number =
of=20
packets per second from an specific IP address exceed a proscribed minimu=
m=20
value. I use this filter to limit traffic from ICMP type viruses to a few=
=20
packets per second.
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_BVRQ2X5TZ3N8RU95WQ6L
Content-Type: text/x-diff;
  charset="us-ascii";
  name="fuzzyp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="fuzzyp.diff"

diff -r -u --new-file patch-o-matic-ng/fuzzyp/help patch-o-matic-ng.psdp.fuzzyp/fuzzyp/help
--- patch-o-matic-ng/fuzzyp/help	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/help	2004-01-01 19:52:57.000000000 -0700
@@ -0,0 +1,15 @@
+This filter adds fuzzy packet limits based on source or destination IP addresses.
+It embraces and extends the ideas put forth in ipt_fuzzy.c.
+
+Examples:
+
+# Limit any single IP address to at most 100 packets per second with
+# linearly increasing packet loss between 50 and 100 packets per second.
+
+iptables -A FORWARD -m fuzzyp --fuzzyp-lower-limit 50 --fuzzyp-upper-limit 100 --fuzzyp-mode src-ip --fuzzyp-mask-bits 32 -j DROP
+
+# Limit all packets destined for a class C subnet to at most 100 packets per second.
+iptables -A FORWARD -m fuzzyp --fuzzyp-lower-limit 50 --fuzzyp-upper-limit 100 --fuzzyp-mode dst-ip --fuzzyp-mask-bits 24 -j DRO
+P
+
+
diff -r -u --new-file patch-o-matic-ng/fuzzyp/info patch-o-matic-ng.psdp.fuzzyp/fuzzyp/info
--- patch-o-matic-ng/fuzzyp/info	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/info	2004-03-17 14:06:42.000000000 -0700
@@ -0,0 +1,6 @@
+Author: Tim Gardner <timg@tpi.com>
+Status: Stable
+Repository: extra
+Depends: hash
+Recompile: netfilter
+Recompile: iptables
diff -r -u --new-file patch-o-matic-ng/fuzzyp/iptables/extensions/.fuzzyp-test patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/.fuzzyp-test
--- patch-o-matic-ng/fuzzyp/iptables/extensions/.fuzzyp-test	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/.fuzzyp-test	2003-12-31 17:00:16.000000000 -0700
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -e $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_fuzzyp.h ] && echo fuzzyp 
diff -r -u --new-file patch-o-matic-ng/fuzzyp/iptables/extensions/libipt_fuzzyp.c patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/libipt_fuzzyp.c
--- patch-o-matic-ng/fuzzyp/iptables/extensions/libipt_fuzzyp.c	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/libipt_fuzzyp.c	2003-12-31 17:00:16.000000000 -0700
@@ -0,0 +1,226 @@
+/* 
+   Shared library add-on to iptables to add match support for the fuzzy plus match.
+   
+   This file is distributed under the terms of the GNU General Public
+   License (GPL). Copies of the GPL can be obtained from:
+   ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+2002-08-07 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Initial version.
+2003-06-09 Hime Aguiar e Oliveira Jr. <hime@engineer.com> : Bug corrections in
+the save function , thanks to information given by Jean-Francois Patenaude .
+
+*/
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_fuzzyp.h>
+
+
+static void
+help(void)
+{
+	printf(
+		"fuzzyp v%s options:\n"
+		"                      --fuzzyp-lower-limit NUM (in packets per second, default %u)\n"
+		"                      --fuzzyp-upper-limit NUM (in packets per second, default %u)\n"
+		"                      --fuzzyp-mode MODE (src-ip or dst-ip, default %s)\n"
+		"                      --fuzzyp-mask-bits NUM (number of netmask bits in mask (0-32), default %u)\n"
+		,
+		IPTABLES_VERSION,
+		DEF_MIN_FUZZYP_RATE,
+		DEF_MAX_FUZZYP_RATE,
+		"src-ip",
+		32
+	);
+};
+
+static struct option opts[] = {
+	{ "fuzzyp-lower-limit", 1 , 0 , '1' } ,
+	{ "fuzzyp-upper-limit", 1 , 0 , '2' } ,
+	{ "fuzzyp-mode",		1 , 0 , '3' } ,
+	{ "fuzzyp-mask-bits",	1 , 0 , '4' } ,
+	{ 0 }
+};
+
+/* Initialize data structures */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	struct ipt_fuzzyp_info *presentinfo = (struct ipt_fuzzyp_info *)(m)->data;
+	*nfcache |= NFC_UNKNOWN;
+
+	presentinfo->minimum_rate	= DEF_MIN_FUZZYP_RATE;
+	presentinfo->maximum_rate	= DEF_MAX_FUZZYP_RATE;
+	presentinfo->mask_bits		= 32;
+	presentinfo->mode			= fzp_src_ip;
+}
+
+/*
+ * Only decimal numbers need apply.
+ */
+static int
+	optarg_to_num(
+	char            *opt,
+	unsigned int    min,
+	unsigned int    max,
+	unsigned int    *num
+	)
+{
+	if (sscanf(opt,"%u",num) != 1)
+	{
+		return(-1);
+	}
+	if ((*num) < min)
+	{
+		return(-1);
+	}
+	if ((*num) > max)
+	{
+		return(-1);
+	}
+	return(0);
+}
+
+#define IPT_FUZZYP_OPT_MINIMUM	0x01
+#define IPT_FUZZYP_OPT_MAXIMUM	0x02
+#define IPT_FUZZYP_OPT_MODE		0x04
+#define IPT_FUZZYP_OPT_MASK		0x08
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+
+	struct ipt_fuzzyp_info *fuzzyinfo = (struct ipt_fuzzyp_info *)(*match)->data;
+
+	u_int32_t num;
+
+	if (invert)
+	       	exit_error(PARAMETER_PROBLEM,"Can't specify inversion");
+
+	switch (c) {
+
+	case '1':
+		
+	if (*flags & IPT_FUZZYP_OPT_MINIMUM)
+       	      exit_error(PARAMETER_PROBLEM,"Can't specify --fuzzyp-lower-limit twice");
+	
+	if (optarg_to_num(optarg,MIN_FUZZYP_RATE,MAX_FUZZYP_RATE-1,&num) < 0)
+			exit_error(PARAMETER_PROBLEM,"BAD --fuzzyp-lower-limit");
+
+		fuzzyinfo->minimum_rate = num;
+
+		*flags |= IPT_FUZZYP_OPT_MINIMUM;
+		
+		break;
+
+	case '2':
+
+	if (*flags & IPT_FUZZYP_OPT_MAXIMUM)
+	   exit_error(PARAMETER_PROBLEM,"Can't specify --fuzzyp-upper-limit twice");
+
+	if (optarg_to_num(optarg,MIN_FUZZYP_RATE+1,MAX_FUZZYP_RATE,&num) < 0)
+		exit_error(PARAMETER_PROBLEM,"BAD --fuzzyp-upper-limit");
+
+		fuzzyinfo->maximum_rate = num;
+
+		*flags |= IPT_FUZZYP_OPT_MAXIMUM;
+
+		break ;
+
+	case '3':
+		if (*flags & IPT_FUZZYP_OPT_MODE)
+		   exit_error(PARAMETER_PROBLEM,"Can't specify --fuzzyp-mode twice");
+
+		if (!strncmp("src-ip",optarg,6))
+		{
+			fuzzyinfo->mode = fzp_src_ip;
+		}
+		else if (!strncmp("dst-ip",optarg,6))
+		{
+			fuzzyinfo->mode = fzp_dst_ip;
+		}
+		else
+		{
+			exit_error(PARAMETER_PROBLEM,"BAD --fuzzyp-mode");
+		}
+		break;
+
+	case '4':
+		if (*flags & IPT_FUZZYP_OPT_MASK)
+		   exit_error(PARAMETER_PROBLEM,"Can't specify --fuzzyp-mask-bits twice");
+
+		if (optarg_to_num(optarg,0,32,&num) < 0)
+			exit_error(PARAMETER_PROBLEM,"BAD --fuzzyp-mask-bits");
+
+		fuzzyinfo->mask_bits = num;
+
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+}
+
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	const struct ipt_fuzzyp_info *fuzzyinfo
+		= (const struct ipt_fuzzyp_info *)match->data;
+
+	printf(" fuzzy: lower limit = %u pps - upper limit = %u pps - mode %s - mask bits %u",
+		fuzzyinfo->minimum_rate,
+		fuzzyinfo->maximum_rate,
+		fuzzyinfo->mode==fzp_src_ip?"src-ip":"dst-ip",
+		fuzzyinfo->mask_bits
+	);
+
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_fuzzyp_info *fuzzyinfo
+		= (const struct ipt_fuzzyp_info *)match->data;
+
+	printf("--fuzzyp-lower-limit %u ",fuzzyinfo->minimum_rate);
+	printf("--fuzzyp-upper-limit %u ",fuzzyinfo->maximum_rate);
+	printf("--fuzzyp-mode %s ",fuzzyinfo->mode==fzp_src_ip?"src-ip":"dst-ip");
+	printf("--fuzzyp-mask-bits %u ",fuzzyinfo->mask_bits);
+}
+
+struct iptables_match fuzzyp_match
+= { NULL,
+    "fuzzyp",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_fuzzyp_info)),
+    IPT_ALIGN(sizeof(struct ipt_fuzzyp_info)),
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
+	register_match(&fuzzyp_match);
+}
diff -r -u --new-file patch-o-matic-ng/fuzzyp/iptables/extensions/libipt_fuzzyp.man patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/libipt_fuzzyp.man
--- patch-o-matic-ng/fuzzyp/iptables/extensions/libipt_fuzzyp.man	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/iptables/extensions/libipt_fuzzyp.man	2004-03-17 14:32:22.000000000 -0700
@@ -0,0 +1,2 @@
+This filter target is used to limit the number of packets per
+second from any single IP address.
diff -r -u --new-file patch-o-matic-ng/fuzzyp/linux/include/linux/netfilter_ipv4/ipt_fuzzyp.h patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/include/linux/netfilter_ipv4/ipt_fuzzyp.h
--- patch-o-matic-ng/fuzzyp/linux/include/linux/netfilter_ipv4/ipt_fuzzyp.h	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/include/linux/netfilter_ipv4/ipt_fuzzyp.h	2003-12-31 17:00:16.000000000 -0700
@@ -0,0 +1,33 @@
+#ifndef _IPT_FUZZYP_H
+#define _IPT_FUZZYP_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+#define MAX_FUZZYP_RATE		10000000
+#define MIN_FUZZYP_RATE		3
+#define DEF_MIN_FUZZYP_RATE 1000
+#define DEF_MAX_FUZZYP_RATE 2000
+
+#define FUZZYP_MAX_HASH_LEN	4096
+
+struct fzp;
+enum ipt_fuzzyp_mode {
+	fzp_src_ip,
+	fzp_dst_ip
+};
+
+struct ipt_fuzzyp_info
+{
+	u_int32_t				minimum_rate;
+	u_int32_t				maximum_rate;
+	u_int32_t				mask_bits;
+	enum ipt_fuzzyp_mode	mode;
+
+	/*
+	 * Kernel stuff.
+	 */
+	struct fzp				*fzp_state;
+};
+
+#endif /*_IPT_FUZZYP_H*/
diff -r -u --new-file patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Config.in.ladd patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Config.in.ladd
--- patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Config.in.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Config.in.ladd	2004-03-17 14:39:55.000000000 -0700
@@ -0,0 +1,2 @@
+  dep_tristate '  Packet type match support' CONFIG_IP_NF_MATCH_PKTTYPE $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  Fuzzy Plus filter support.' CONFIG_IP_NF_FUZZYP $CONFIG_IP_NF_HASH
diff -r -u --new-file patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/ipt_fuzzyp.c patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/ipt_fuzzyp.c
--- patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/ipt_fuzzyp.c	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/ipt_fuzzyp.c	2004-01-27 19:30:20.000000000 -0700
@@ -0,0 +1,573 @@
+/*
+ * This module extends the concepts introduced in the original fuzzy match filter.
+ * In that filter, a packet rate is calculated for an entire interface. The
+ * rate hysterisys was a function of the total number of packets seen from that
+ * interface.
+ *
+ * This module, which I call fuzzy plus, maintains a packet rate for an individual
+ * IP address or subnet depending on input options. If packets arrive at a rate that
+ * is below the minimum rate specified, then no packets will match. If the packet
+ * rate falls somewhere between the minimum and maximum rate inclusive, then a sliding
+ * percentage of packets are matched. For example, if the min and max rates are 10 and 50,
+ * and the rate that packets arrive in the filter is 15 packets per second, then the
+ * filter will match 15/(50-10) or 37.5% of all packets. As you can see, as the packet
+ * rate nears the maximum, the percentage of packets matched approaches 100%. If the
+ * packet rate exceeds the specified maximum rate, then all packets are matched.
+ *
+ * The theoretical use for this filter is to attempt to gracefully limit some kinds
+ * of abusive traffic. Non-stream kinds of IP such as ICMP and UDP can consume an
+ * inordinate amount of network resource if allowed to propogate beyond an initial
+ * firewall. Viruses are a good example of the kinds of traffic that this filter
+ * would limit without completely shutting down everything.
+ *
+ * 2004-01-01  Tim Gardner <timg@tpi.com> : Initial version.
+*/
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/timer.h>
+#include <linux/random.h>
+#include <net/tcp.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_fuzzyp.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include "ipt_hash.h"
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
+#include <linux/workqueue.h>
+#else
+#include <linux/tqueue.h>
+#ifndef INIT_WORK
+#define work_struct tq_struct
+#define INIT_WORK INIT_TQUEUE
+#define schedule_work schedule_task
+#endif
+#endif
+
+MODULE_AUTHOR("Tim Gardner <timg@tpi.com>");
+MODULE_DESCRIPTION("IP tables Fuzzy Logic Plus Controller match module");
+MODULE_LICENSE("GPL");
+
+#define FZP_MAGIC	0xdeadbeef
+#define ASSERT_FZP_MAGIC(_p) IPT_DBG_ASSERT((_p)->magic == FZP_MAGIC)
+
+#define FUZZYP_DECAY_TIMEOUT		(5*HZ)
+#define FUZZYP_MEASUREMENT_PERIOD	(2*HZ)
+
+/*
+ * Filter context structure.
+ */
+struct fzp
+{
+	__u32                       magic;
+#ifdef CONFIG_NETFILTER_DEBUG
+	struct spinlock_debug		lock;
+#else
+	spinlock_t                  lock;
+#endif
+	__u32                       netmask;
+	struct ipt_hash_table       *ip_hash_tab;
+
+	struct timer_list           decay_timer;
+	int                         decay_timer_running;
+	int                         decay_worker_exited;
+	struct work_struct          decay_worker;
+	struct ipt_hash_location    decay_loc;
+
+	__u32                       rate_range;
+	int                         exiting;
+};
+
+/*
+ * A hash table entry.
+ */
+struct fzp_ip
+{
+	__u32               magic;
+
+	/*
+	 * This structure is keyed by its IP address in the hash table.
+	 */
+	__u32               ip_addr;
+
+	/*
+	 * If no packets have arrived within this time, then flush the structure.
+	 */
+	unsigned long	expire_time;
+
+	/*
+	 * Measure input packet rates over some period of time.
+	 */
+	__u32			pkts_in_period;
+	unsigned long	start_of_period_jiffie;
+
+	/*
+	 * Debug announce time.
+	 */
+	unsigned long	next_announce_time;
+};
+
+static __inline__ __u32 msec_to_jiffies(__u32 msec)
+{
+	return( (msec*HZ)/1000 );
+}
+
+static __inline__ __u32
+	jiffies_to_msec(__u32 jiffs)
+{
+	return((jiffs * 1000) / HZ);
+}
+
+STATIC_INLINE void fzp_lock(struct fzp *fzp, unsigned long *flags)
+{
+	LOCK_BH(&fzp->lock);
+}
+
+STATIC_INLINE void fzp_unlock(struct fzp *fzp, unsigned long flags)
+{
+	UNLOCK_BH(&fzp->lock);
+}
+
+STATIC void fzp_init_lock(struct fzp *fzp)
+{
+	spin_lock_init(&fzp->lock);
+}
+
+STATIC void fzp_add_timer(
+	struct fzp *fzp
+	)
+{
+	if ((!fzp->decay_timer_running) && ipt_hash_num_entries(fzp->ip_hash_tab))
+	{
+		fzp->decay_timer_running = 1;
+		fzp->decay_timer.expires = jiffies + msec_to_jiffies(10);
+		add_timer(&fzp->decay_timer);
+	}
+}
+
+STATIC_INLINE void fzp_clear_ip_counters(
+	struct fzp      *fzp,
+	struct fzp_ip   *ip
+	)
+{
+	ip->pkts_in_period			= 0;
+	ip->start_of_period_jiffie	= jiffies;
+}
+
+STATIC_INLINE struct fzp_ip *fzp_find_ip(
+	struct fzp      *fzp,
+	__u32           ip_addr
+	)
+{
+	struct fzp_ip *ip;
+	ip = (struct fzp_ip *)ipt_hash_find_entry(fzp->ip_hash_tab,&ip_addr);
+	return(ip);
+}
+
+STATIC struct fzp_ip *fzp_create_ip(
+	struct fzp      *fzp,
+	__u32           ip_addr
+	)
+{
+	struct fzp_ip *ip;
+
+	if (!(ip = (struct fzp_ip *)ipt_hash_create_entry(fzp->ip_hash_tab,&ip_addr)))
+	{
+		return(ip);
+	}
+	memset(ip,0,sizeof(struct fzp_ip));
+
+	ip->magic       = FZP_MAGIC;
+	ip->ip_addr     = ip_addr;
+
+	fzp_clear_ip_counters(fzp,ip);
+	fzp_add_timer(fzp);
+
+	IPT_DBG("ip %08x\n",ntohl(ip->ip_addr));
+
+	return(ip);
+}
+
+STATIC_INLINE unsigned long fzp_add_pkt(
+	struct ipt_fuzzyp_info  *info,
+	struct fzp      		*fzp,
+	struct fzp_ip   		*ip
+	)
+{
+	__u32			match;
+	unsigned long	now = jiffies;
+	unsigned long	delta;
+	__u32			min_rate;
+	__u32			max_rate;
+	__u32			match_rate;
+	__u32			input_pkts_per_sec;
+	__u8			rnd;
+
+	ip->expire_time = now + FUZZYP_DECAY_TIMEOUT;
+
+	ip->pkts_in_period += 1;
+
+	delta = now - ip->start_of_period_jiffie;
+	if (delta < FUZZYP_MEASUREMENT_PERIOD)
+	{
+		return(0);
+	}
+
+	min_rate = (__u32)info->minimum_rate;
+	max_rate = (__u32)info->maximum_rate;
+
+	input_pkts_per_sec = (HZ * ip->pkts_in_period) / delta;
+
+	if (input_pkts_per_sec < min_rate)
+	{
+		/*
+		 * Restart rate calculation.
+		 */
+		fzp_clear_ip_counters(fzp,ip);
+		match_rate = 0;
+	}
+
+	else if (input_pkts_per_sec > max_rate)
+	{
+		/*
+		 * Match 100%
+		 */
+		match_rate = 100;
+	}
+	else
+	{
+		/*
+		 * The match rate gets larger as the mean input rate gets higher.
+		 */
+		match_rate = ((input_pkts_per_sec-min_rate)*100) / fzp->rate_range;
+	}
+
+	get_random_bytes((void *)(&rnd), sizeof(rnd));
+
+	/*
+	 * The closer match_rate gets to 100, the greater the odds are
+	 * that rnd will be less then 255 and therefore a match.
+	 */
+	match = ((rnd < ((255 * match_rate) / 100)) ? 1 : 0);
+
+	if (ip->next_announce_time < jiffies)
+	{
+		IPT_DBG("pps %u mr %u\n",input_pkts_per_sec,match_rate);
+		ip->next_announce_time = jiffies + (20*HZ);
+	}
+
+	return(match);
+}
+
+STATIC void fzp_destroy_ip(
+	struct fzp      *fzp,
+	struct fzp_ip   *ip
+	)
+{
+	__u32   ip_addr;
+
+	IPT_DBG("ip %08x\n",ntohl(ip->ip_addr));
+
+	ip_addr = ip->ip_addr;
+
+	ipt_hash_delete_entry(fzp->ip_hash_tab,&ip_addr);
+}
+
+/*
+ * The decay worker thread looks at the next source IP hash table entry
+ * and grooms the destination tuples list.
+ */
+STATIC void fzp_decay_worker(
+	void *context
+	)
+{
+	unsigned long               flags;
+	struct fzp                  *fzp = (struct fzp *)context;
+	struct fzp_ip               *ip;
+
+	fzp_lock(fzp,&flags);
+
+	fzp->decay_timer_running = 0;
+
+	/*
+	 * Only handle one IP per invocation.
+	 */
+	if ((ip=(struct fzp_ip *)ipt_hash_traverse(fzp->ip_hash_tab,&fzp->decay_loc)) != NULL)
+	{
+		ASSERT_FZP_MAGIC(ip);
+
+		if (time_after(jiffies,ip->expire_time))
+		{
+			fzp_destroy_ip(fzp,ip);
+		}
+	}
+	else
+	{
+		/*
+		 * End of the source IP's list, so start over on the next pass.
+		 */
+		ipt_hash_traverse_init(&fzp->decay_loc);
+	}
+
+	if (fzp->exiting)
+	{
+		fzp->decay_worker_exited = 1;
+	}
+	else
+	{
+		fzp_add_timer(fzp);
+	}
+
+	fzp_unlock(fzp,flags);
+}
+
+STATIC void fzp_decay_timer(
+	unsigned long context
+	)
+{
+	struct fzp *fzp = (struct fzp *)context;
+	schedule_work(&fzp->decay_worker);
+}
+
+STATIC_INLINE int fzp_get_ip_addr(
+	__u32                   netmask,
+	enum ipt_fuzzyp_mode    mode,
+	struct iphdr            *ip_hdr,
+	__u32                   *ip_addr
+	)
+{
+	/*
+	 * Sanity check.
+	 */
+	if (ntohs(ip_hdr->frag_off) & IP_OFFSET)
+	{
+		return(-1);
+	}
+	if (mode == fzp_src_ip)
+	{
+		if (!ip_hdr->saddr)
+		{
+			return(-1);
+		}
+		*ip_addr = ip_hdr->saddr & netmask;
+	}
+	else if (mode == fzp_dst_ip)
+	{
+		if (!ip_hdr->daddr)
+		{
+			return(-1);
+		}
+		*ip_addr = ip_hdr->daddr & netmask;
+	}
+	else
+	{
+		return(-1);
+	}
+	return(0);
+}
+
+STATIC int ipt_fzp_match(
+	const struct sk_buff    *pskb,
+	const struct net_device *in,
+	const struct net_device *out,
+	const void              *matchinfo,
+	int                     offset,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+	const void              *hdr,
+	u_int16_t               datalen,
+#endif
+	int                     *hotdrop
+	)
+{
+	struct ipt_fuzzyp_info  *info = (struct ipt_fuzzyp_info *) matchinfo;
+	struct fzp              *fzp = info->fzp_state;
+	unsigned long           flags;
+	__u32                   ip_addr;
+	struct fzp_ip           *ip;
+
+	ASSERT_FZP_MAGIC(fzp);
+
+	if (fzp_get_ip_addr(fzp->netmask,info->mode,pskb->nh.iph,&ip_addr) < 0)
+	{
+		return(0);
+	}
+
+	fzp_lock(fzp,&flags);
+
+	if ((ip = fzp_find_ip(fzp,ip_addr)) == NULL)
+	{
+		if ((ip = fzp_create_ip(fzp,ip_addr)) == NULL)
+		{
+			goto out_no_match; 
+		}
+	}
+
+	ASSERT_FZP_MAGIC(ip);
+
+	if (fzp_add_pkt(info,fzp,ip))
+	{
+		goto out_match; 
+	}
+
+out_no_match:
+	fzp_unlock(fzp,flags);
+	return(0);
+
+out_match:
+	fzp_unlock(fzp,flags);
+	return(1);
+}
+
+STATIC __u32 fzp_hash_func(void *hash_data)
+{
+	return( ntohl(*(__u32 *)hash_data) );
+}
+
+STATIC int ipt_fzp_checkentry(
+	const char *tablename,
+	const struct ipt_ip *e,
+	void *matchinfo,
+	unsigned int matchsize,
+	unsigned int hook_mask)
+{
+
+	struct ipt_fuzzyp_info  *info = matchinfo;
+	struct fzp              *fzp=NULL;
+	__u32                   hash_len;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_fuzzyp_info)))
+	{
+		printk("ipt_fuzzyp: matchsize %u != %u\n", matchsize,
+			IPT_ALIGN(sizeof(struct ipt_fuzzyp_info)));
+		return(0);
+	}
+
+	if (
+		(info->minimum_rate < MIN_FUZZYP_RATE)
+		||
+		(info->maximum_rate > MAX_FUZZYP_RATE)
+		||
+		(info->minimum_rate >= info->maximum_rate )
+		)
+	{
+		printk(KERN_ERR "ipt_fuzzyp: BAD limits , please verify !!!\n");
+		return(0);
+	}
+
+	if (!(fzp=kmalloc(sizeof(struct fzp),GFP_ATOMIC)))
+	{
+		printk(KERN_ERR "ipt_fuzzyp: Could not allocate memory for fuzzyp state.\n");
+		goto ipt_fzp_checkentry_err;
+	}
+	memset(fzp,0,sizeof(struct fzp));
+
+	fzp->magic = FZP_MAGIC;
+	fzp->netmask = htonl(0xffffffff << (32-info->mask_bits));
+
+	ipt_hash_traverse_init(&fzp->decay_loc);
+	INIT_WORK(&fzp->decay_worker,fzp_decay_worker,fzp);
+
+	init_timer(&fzp->decay_timer);
+	fzp->decay_timer.data = (unsigned long)fzp;
+	fzp->decay_timer.function = fzp_decay_timer;
+
+	fzp_init_lock(fzp);
+
+	hash_len = (1<<(32-(info->mask_bits)));
+	if (hash_len > FUZZYP_MAX_HASH_LEN)
+	{
+		hash_len = FUZZYP_MAX_HASH_LEN;
+	}
+
+	fzp->ip_hash_tab = ipt_hash_create_table(hash_len,fzp_hash_func,sizeof(struct fzp_ip),sizeof(__u32));
+	if (!fzp->ip_hash_tab)
+	{
+		goto ipt_fzp_checkentry_err;
+	}
+
+	fzp->rate_range = info->maximum_rate - info->minimum_rate;
+
+	info->fzp_state = fzp;
+
+	return(1);
+
+ipt_fzp_checkentry_err:
+	if (fzp)
+	{
+		if (fzp->ip_hash_tab)
+		{
+			ipt_hash_delete_table(fzp->ip_hash_tab);
+		}
+		kfree(fzp);
+	}
+	return(0);
+}
+
+STATIC void ipt_fzp_destroy(
+	void *matchinfo,
+	unsigned int matchinfosize
+	)
+{
+	struct ipt_fuzzyp_info  *info = matchinfo;
+	struct fzp              *fzp=info->fzp_state;
+	struct fzp_ip           *ip;
+	wait_queue_head_t       wait_q;
+	unsigned long           flags;
+
+	ASSERT_FZP_MAGIC(fzp);
+
+	init_waitqueue_head(&wait_q);
+
+	del_timer(&fzp->decay_timer);
+	fzp->exiting = 1;
+
+	while (!fzp->decay_worker_exited)
+	{
+		schedule_work(&fzp->decay_worker);
+		sleep_on_timeout(&wait_q,2);
+	}
+
+	fzp_lock(fzp,&flags);
+
+	ipt_hash_traverse_init(&fzp->decay_loc);
+	while ((ip=(struct fzp_ip *)ipt_hash_traverse(fzp->ip_hash_tab,&fzp->decay_loc)) != NULL)
+	{
+		ASSERT_FZP_MAGIC(ip);
+
+		fzp_destroy_ip(fzp,ip);
+	}
+	ipt_hash_delete_table(fzp->ip_hash_tab);
+
+	fzp_unlock(fzp,flags);
+
+	kfree(fzp);
+	info->fzp_state = NULL;
+}
+
+static struct ipt_match ipt_fzp_reg =
+{ 
+	.name       = "fuzzyp",
+	.match      = ipt_fzp_match,
+	.checkentry = ipt_fzp_checkentry,
+	.destroy    = ipt_fzp_destroy,
+	.me         = THIS_MODULE
+};
+
+static int __init init(void)
+{
+	if (ipt_register_match(&ipt_fzp_reg))
+		return(-EINVAL);
+
+	return(0);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&ipt_fzp_reg);
+}
+
+module_init(init);
+module_exit(fini);
diff -r -u --new-file patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Kconfig.ladd patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Kconfig.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Kconfig.ladd	2004-03-17 15:04:47.000000000 -0700
@@ -0,0 +1,6 @@
+
+config IP_NF_FUZZYP
+	tristate "Fuzzy Plus match filter support"
+	help
+	  This filter drops packets on a sliding scale when the packet
+	  rate exceeds a specified minimum rate.
diff -r -u --new-file patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng/fuzzyp/linux/net/ipv4/netfilter/Makefile.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/fuzzyp/linux/net/ipv4/netfilter/Makefile.ladd	2004-03-17 14:40:10.000000000 -0700
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
+obj-$(CONFIG_IP_NF_FUZZYP) += ipt_fuzzyp.o


--------------Boundary-00=_BVRQ2X5TZ3N8RU95WQ6L--
