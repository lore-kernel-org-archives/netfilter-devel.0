From: Tim Gardner <timg@tpi.com>
Subject: [PATCH] 2 of 3 for patch-o-matic-ng
Date: Wed, 17 Mar 2004 15:30:31 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403171530.31437.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_VURQGG39ZVGVUOI7EHI0"
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


--------------Boundary-00=_VURQGG39ZVGVUOI7EHI0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This match filter is an extension of the ideas in PSD, though it is a com=
plete=20
rewrite. It matches TCP/UDP/ICMP connections on a per IP basis that excee=
d a=20
proscribed weight. I use it to detect port scan attacks from a single sou=
rce.
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_VURQGG39ZVGVUOI7EHI0
Content-Type: text/x-diff;
  charset="us-ascii";
  name="psdp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="psdp.diff"

diff -r -u --new-file patch-o-matic-ng/psdp/help patch-o-matic-ng.psdp.fuzzyp/psdp/help
--- patch-o-matic-ng/psdp/help	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/help	2004-01-01 19:46:10.000000000 -0700
@@ -0,0 +1,12 @@
+This filter extends the original PSD filter. It will keep track
+of connections from a single source IP address and assign weighting
+based on the destination port (for TCP/UDP) or ICMP type.
+
+Examples:
+
+# This will match all packets from a single IP source address that exceed the weight
+# threshold of 16. The memory for this IP address is  released after 20 seconds
+# of inactivity. The filter information for active IP addresses can be seen in
+# /proc/net/mypsdp.
+#
+iptables -A FORWARD -m psdp --psdp-name mypsdp --psdp-weight-threshold 16 --psdp-delay-threshold 20000 --psdp-lo-ports-weight 1 --psdp-hi-ports-weight 3 -j DROP
diff -r -u --new-file patch-o-matic-ng/psdp/info patch-o-matic-ng.psdp.fuzzyp/psdp/info
--- patch-o-matic-ng/psdp/info	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/info	2004-03-17 14:22:42.000000000 -0700
@@ -0,0 +1,6 @@
+Author: Tim Gardner <timg@tpi.com>
+Status: Stable
+Repository: extra
+Depends: hash
+Recompile: netfilter
+Recompile: iptables
diff -r -u --new-file patch-o-matic-ng/psdp/iptables/extensions/libipt_psdp.c patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/libipt_psdp.c
--- patch-o-matic-ng/psdp/iptables/extensions/libipt_psdp.c	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/libipt_psdp.c	2004-02-08 11:58:43.000000000 -0700
@@ -0,0 +1,288 @@
+/* 
+	Shared library add-on to iptables to add PSDP support 
+	
+	Copyright (C) 2004 Tim Gardner <timg@tpi.com>
+
+	This file is distributed under the terms of the GNU General Public
+	License (GPL). Copies of the GPL can be obtained from:
+	 ftp://prep.ai.mit.edu/pub/gnu/GPL
+
+	This file decends directly from libipt_psd.c
+	
+	2004-01-01 Tim Gardner <timg@tpi.com> : Initial release
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
+#include <linux/netfilter_ipv4/ipt_psdp.h>
+
+static void
+	help(void)
+{
+	printf(
+		"psdp v%s options:\n"
+		" --psdp-name               NAME        /proc/net/NAME (default pspd, e.g., /proc/net/psdp)\n\n"
+		" --psdp-weight-threshold   THRESHOLD   Portscan detection weight threshold, default %u, range %u-%u\n\n"
+		" --psdp-delay-threshold    MSEC        Portscan detection delay threshold, default %u, range %u-%u\n\n"
+		" --psdp-lo-ports-weight    WEIGHT      Privileged ports weight, default %u, range %u-%u\n\n"
+		" --psdp-hi-ports-weight    WEIGHT      High ports weight, default %u, range %u-%u\n"
+		" --psdp-blacklist                      Enable blacklisting of overweight sources.\n\n"
+		,
+
+		IPTABLES_VERSION,
+
+		PSDP_SCAN_WEIGHT_THRESHOLD_DEF,
+		PSDP_SCAN_WEIGHT_THRESHOLD_MIN,
+		PSDP_SCAN_WEIGHT_THRESHOLD_MAX,
+
+		PSDP_SCAN_DELAY_THRESHOLD_MSEC_DEF,
+		PSDP_SCAN_DELAY_THRESHOLD_MSEC_MIN,
+		PSDP_SCAN_DELAY_THRESHOLD_MSEC_MAX,
+
+		PSDP_PORT_WEIGHT_PRIV_DEF,
+		PSDP_PORT_WEIGHT_PRIV_MIN,
+		PSDP_PORT_WEIGHT_PRIV_MAX,
+
+		PSDP_PORT_WEIGHT_HIGH_DEF,
+		PSDP_PORT_WEIGHT_HIGH_MIN,
+		PSDP_PORT_WEIGHT_HIGH_MAX
+		);
+}
+
+static struct option opts[] = {
+	{ "psdp-weight-threshold",	1, 0, '1'},
+	{ "psdp-delay-threshold",	1, 0, '2'},
+	{ "psdp-lo-ports-weight",	1, 0, '3'},
+	{ "psdp-hi-ports-weight",	1, 0, '4'},
+	{ "psdp-name",				1, 0, '5'},
+	{ "psdp-blacklist",			0, 0, '6'},
+	{ 0}
+};
+
+/* Initialize the target. */
+static
+void init(
+	struct ipt_entry_match *m,
+	unsigned int *nfcache
+	)
+{
+	struct ipt_psdp_info *psdpinfo = (struct ipt_psdp_info *)m->data;
+
+	memset(psdpinfo,0,sizeof(struct ipt_psdp_info));
+
+	psdpinfo->weight_threshold	= PSDP_SCAN_WEIGHT_THRESHOLD_DEF;	
+	psdpinfo->decay_msec		= PSDP_SCAN_DELAY_THRESHOLD_MSEC_DEF;
+	psdpinfo->lo_ports_weight	= PSDP_PORT_WEIGHT_PRIV_DEF;
+	psdpinfo->hi_ports_weight	= PSDP_PORT_WEIGHT_HIGH_DEF;
+
+	strcpy(psdpinfo->name,PSDP_DEF_NAME);
+
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+
+typedef struct _code
+{
+	char	*c_name;
+	int	 c_val;
+} CODE;
+
+
+/*
+ * Only decimal numbers need apply.
+ */
+static
+int optarg_to_num(
+	char			*opt,
+	unsigned int	min,
+	unsigned int	max,
+	unsigned int	*num
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
+#define IPT_PSDP_OPT_CTRESH	 	0x01
+#define IPT_PSDP_OPT_DTRESH	 	0x02
+#define IPT_PSDP_OPT_LPWEIGHT	0x04
+#define IPT_PSDP_OPT_HPWEIGHT	0x08
+#define IPT_PSDP_OPT_NAME		0x10
+
+/* Function which parses command options; returns true if it
+	ate an option */
+static
+int parse(
+	int					 	c,
+	char					**argv,
+	int					 	invert,
+	unsigned int			*flags,
+	const struct ipt_entry	*entry,
+	unsigned int			*nfcache,
+	struct ipt_entry_match	**match)
+{
+	struct ipt_psdp_info	*psdinfo = (struct ipt_psdp_info *)(*match)->data;
+	unsigned int			num;
+
+	if (!optarg) exit_error(PARAMETER_PROBLEM, "psdp: '%c' missing optarg",c);
+
+	/* string_to_number needs a leading space */
+
+	switch (c)
+	{
+	/* PSD-weight-threshold */
+	case '1':
+		if (*flags & IPT_PSDP_OPT_CTRESH)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't specify --psdp-weight-threshold "
+				"twice");
+		if (optarg_to_num(optarg, PSDP_SCAN_WEIGHT_THRESHOLD_MIN, PSDP_SCAN_WEIGHT_THRESHOLD_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				"bad --psdp-weight-threshold `%s'", optarg);
+		psdinfo->weight_threshold = num;
+		*flags |= IPT_PSDP_OPT_CTRESH;
+		break;
+
+		/* PSD-delay-threshold */
+	case '2':
+		if (*flags & IPT_PSDP_OPT_DTRESH)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't specify --psdp-delay-threshold twice");
+		if (optarg_to_num(optarg, PSDP_SCAN_DELAY_THRESHOLD_MSEC_MIN, PSDP_SCAN_DELAY_THRESHOLD_MSEC_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				"bad --psdp-delay-threshold `%s'", optarg);
+		psdinfo->decay_msec = num;
+		*flags |= IPT_PSDP_OPT_DTRESH;
+		break;
+
+		/* PSD-lo-ports-weight */
+	case '3':
+		if (*flags & IPT_PSDP_OPT_LPWEIGHT)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't specify --psdp-lo-ports-weight twice");
+		if (optarg_to_num(optarg, PSDP_PORT_WEIGHT_PRIV_MIN, PSDP_PORT_WEIGHT_PRIV_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				"bad --psdp-lo-ports-weight `%s'", optarg);
+		psdinfo->lo_ports_weight = num;
+		*flags |= IPT_PSDP_OPT_LPWEIGHT;
+		break;
+
+		/* PSD-hi-ports-weight */
+	case '4':
+		if (*flags & IPT_PSDP_OPT_HPWEIGHT)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't specify --psdp-hi-ports-weight twice");
+		if (optarg_to_num(optarg, PSDP_PORT_WEIGHT_HIGH_MIN, PSDP_PORT_WEIGHT_HIGH_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				"bad --psdp-hi-ports-weight `%s'", optarg);
+		psdinfo->hi_ports_weight = num;
+		*flags |= IPT_PSDP_OPT_HPWEIGHT;
+		break;
+
+	case '5':
+		if (*flags & IPT_PSDP_OPT_NAME)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't specify --psdp-name twice");
+		if ((!optarg) || (!strlen(optarg)))
+			exit_error(PARAMETER_PROBLEM,
+				"--psdp-name too short (min 1 characters)");
+		if (strlen(optarg) >= PSDP_MAX_NAME_LEN)
+			exit_error(PARAMETER_PROBLEM,
+				"--psdp-name too long (max %u characters) `%s'", PSDP_MAX_NAME_LEN,optarg);
+		strcpy(psdinfo->name,optarg);
+		*flags |= IPT_PSDP_OPT_NAME;
+		break;
+
+	case '6':
+		psdinfo->blacklist = 1;
+		break;
+
+	default:
+		return(0);
+	}
+
+	return(1);
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static
+void print(
+	const struct ipt_ip				*ip,
+	const struct ipt_entry_match	*match,
+	int numeric
+	)
+{
+	const struct ipt_psdp_info *psdinfo
+		= (const struct ipt_psdp_info *)match->data;
+
+	printf("psdp ");
+	printf("weight-threshold: %u ", psdinfo->weight_threshold);
+	printf("delay-threshold: %u ", psdinfo->decay_msec);
+	printf("lo-ports-weight: %u ", psdinfo->lo_ports_weight);
+	printf("hi-ports-weight: %u ", psdinfo->hi_ports_weight);
+	printf("name: %s ", psdinfo->name);
+	printf("blacklist: %u ",psdinfo->blacklist);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static
+void save(
+	const struct ipt_ip 			*ip,
+	const struct ipt_entry_match 	*match
+	)
+{
+	const struct ipt_psdp_info *psdinfo
+		= (const struct ipt_psdp_info *)match->data;
+
+	printf("--psdp-name %s ",				psdinfo->name);
+	printf("--psdp-weight-threshold %u ",	psdinfo->weight_threshold);
+	printf("--psdp-delay-threshold %u ",	 psdinfo->decay_msec);
+	printf("--psdp-lo-ports-weight %u ",	 psdinfo->lo_ports_weight);
+	printf("--psdp-hi-ports-weight %u ",	 psdinfo->hi_ports_weight);
+	printf("--psdp-blacklist %u ",	 		psdinfo->blacklist);
+}
+
+static struct iptables_match psdp = 
+{
+	NULL,
+	"psdp",
+	IPTABLES_VERSION,
+	IPT_ALIGN(sizeof(struct ipt_psdp_info)),
+	IPT_ALIGN(sizeof(struct ipt_psdp_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+void _init(void)
+{
+	register_match(&psdp);
+}
+
diff -r -u --new-file patch-o-matic-ng/psdp/iptables/extensions/libipt_psdp.man patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/libipt_psdp.man
--- patch-o-matic-ng/psdp/iptables/extensions/libipt_psdp.man	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/libipt_psdp.man	2004-03-17 14:31:35.000000000 -0700
@@ -0,0 +1,2 @@
+This filter is used to detect an excessive number of connections from any
+single IP address. 
diff -r -u --new-file patch-o-matic-ng/psdp/iptables/extensions/.psdp-test patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/.psdp-test
--- patch-o-matic-ng/psdp/iptables/extensions/.psdp-test	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/iptables/extensions/.psdp-test	2003-12-10 13:35:11.000000000 -0700
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if psdp is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_psdp.h ] && echo psdp
diff -r -u --new-file patch-o-matic-ng/psdp/linux/include/linux/netfilter_ipv4/ipt_psdp.h patch-o-matic-ng.psdp.fuzzyp/psdp/linux/include/linux/netfilter_ipv4/ipt_psdp.h
--- patch-o-matic-ng/psdp/linux/include/linux/netfilter_ipv4/ipt_psdp.h	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/linux/include/linux/netfilter_ipv4/ipt_psdp.h	2004-02-07 22:14:50.000000000 -0700
@@ -0,0 +1,72 @@
+#ifndef _IPT_PSDP_H
+#define _IPT_PSDP_H
+
+#include <linux/param.h>
+#include <linux/types.h>
+
+/*
+ * High port numbers have a lower weight to reduce the frequency of false
+ * positives, such as from passive mode FTP transfers.
+ */
+#define PSDP_PORT_WEIGHT_PRIV_MIN			1
+#define PSDP_PORT_WEIGHT_PRIV_MAX			256
+#define PSDP_PORT_WEIGHT_PRIV_DEF			3
+
+#define PSDP_PORT_WEIGHT_HIGH_MIN			1
+#define PSDP_PORT_WEIGHT_HIGH_MAX			256
+#define PSDP_PORT_WEIGHT_HIGH_DEF			1
+
+#define PSDP_SCAN_WEIGHT_THRESHOLD_MIN		2
+#define PSDP_SCAN_WEIGHT_THRESHOLD_MAX		256
+#define PSDP_SCAN_WEIGHT_THRESHOLD_DEF		16
+
+#define PSDP_SCAN_DELAY_THRESHOLD_MSEC_MIN	10
+#define PSDP_SCAN_DELAY_THRESHOLD_MSEC_MAX	(24*3600*1000)
+#define PSDP_SCAN_DELAY_THRESHOLD_MSEC_DEF	10000
+
+#define PSDP_MAX_NAME_LEN					64
+#define PSDP_DEF_NAME						"psdp"
+
+struct psdp_state;
+struct ipt_psdp_info
+{
+	/*
+	 * Total weight before a match is returned.
+	 */
+	unsigned int weight_threshold;
+
+	/*
+	 * How long a tuple stays in the hash table without
+	 * being refreshed.
+	 */
+	unsigned int decay_msec;
+
+	/*
+	 * Tuples with with a dstination port of < 1024 get
+	 * this value.
+	 */
+	unsigned short lo_ports_weight;
+	/*
+	 * Tuples with with a dstination port of >= 1024 get
+	 * this value.
+	 */
+	unsigned short hi_ports_weight;
+
+	/*
+	 * Blacklist overweight IP source addresses, e.g., return
+	 * a match for every packet when a source IP is overweight.
+	 */
+	unsigned int blacklist;
+
+	/*
+	 * Name used in /proc/net
+	 */
+	char name[PSDP_MAX_NAME_LEN];
+
+	/*
+	 * Used by the kernel.
+	 */
+	struct psdp_state	*psdp;
+};
+
+#endif /*_IPT_PSDP_H*/
diff -r -u --new-file patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Config.in.ladd patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Config.in.ladd
--- patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Config.in.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Config.in.ladd	2004-03-17 14:38:40.000000000 -0700
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP_NF_MATCH_MAC $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  PSD Plus filter support.' CONFIG_IP_NF_PSDP $CONFIG_IP_NF_HASH
diff -r -u --new-file patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/ipt_psdp.c patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/ipt_psdp.c
--- patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/ipt_psdp.c	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/ipt_psdp.c	2004-02-18 08:24:47.000000000 -0700
@@ -0,0 +1,1152 @@
+/*
+  This is a module which is used for PSD (portscan detection)
+
+  Copyright (C) 2003 Tim Gardner <timg@tpi.com>, TriplePoint, Inc.
+
+  This file is distributed under the terms of the GNU General Public
+  License (GPL). Copies of the GPL can be obtained from: http://www.gnu.org
+
+  This module is descended from the original ipt_psd.c sources. However, it
+  has been largely rewritten to support multiple destination addresses using
+  a two level hash scheme. I'm calling it PSD Plus. Suggestions for a catchier
+  name will be entertained.
+  
+  The algorithm that I've employed attempts to detect port scans from a single
+  source to multiple destinations. It does this by creating a structure in
+  the first level hash that represents a source IP address. Each source IP
+  address contains a second level hash that manages the destination tuples
+  from that source IP address. A destination tuple is 3 pieces of information:
+  
+  TCP/UDP - destination IP address, destination port, and IP protocol number
+  or
+  ICMP - destination IP address, ICMP type, and IP protocol number.
+  
+  Each destination tuple has a weight that is a function of the destination
+  port or ICMP type. As each tuple is created, its weight is added to the 
+  cumulative weight of the source IP . When the cumulative exceeds the
+  weight threshold, then no more tuples are created and the match returns true.
+  
+  While this is going on, there is a task that runs periodically to check
+  tuples for ageing. If a destination tuple has not had a packet within the
+  delay threshold, then the tuple is deleted and its weight is subtracted from
+  the cumulative of the source IP address. If all traffic from a source IP
+  address ceases, then eventually all information related to that source IP will
+  be destroyed. When the last tuple for a source IP is deleted, then the structure
+  for the source IP is also deleted.
+  
+  This filter creates a directory in /proc/net that provides a snapshot of the
+  source IPs and tuples currently in the hash tables. The name used is dependent
+  on invocation options (--psdp-name name), but defaults to /proc/net/psdp. Within
+  that directory is at least the file 'overweight'. When read, /proc/net/psdp/overweight
+  lists the source IP addresses that have exceeded the weight threshold and are
+  returning a match. For each source IP address in the primary hash table, there
+  will also be a file in /proc/net/psdp that, when read, will disgorge the current
+  list of destination tuples for that source IP.
+
+*/
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/ip.h>
+#include <linux/timer.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_psdp.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/vmalloc.h>
+#include <linux/proc_fs.h>
+#include <asm/semaphore.h>
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
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tim Gardner <timg@tpi.com>");
+
+#define PSDP_MAGIC   0xdeadbeef
+#define ASSERT_PSDP_MAGIC(_p) IPT_DBG_ASSERT((_p)->magic == PSDP_MAGIC)
+
+STATIC_INLINE __u32 msec_to_jiffies(__u32 msec)
+{
+	return( (msec*HZ)/1000 );
+}
+
+STATIC_INLINE __u32 jiffies_to_msec(__u32 jiffs)
+{
+	return((jiffs * 1000) / HZ);
+}
+
+#define PSDP_SRC_IP_HASH_LEN 256
+#define OVERWEIGHT_NAME     "overweight"
+
+/*
+ * PSDP filter instance structure.
+ */
+struct psdp_state
+{
+	struct list_head            next;
+	struct ipt_psdp_info        *info;
+
+	unsigned int                magic;
+#ifdef CONFIG_NETFILTER_DEBUG
+	struct spinlock_debug		lock;
+#else
+	spinlock_t                  lock;
+#endif
+
+	struct ipt_hash_table       *src_ip_hash_tab;
+
+	struct proc_dir_entry       *pde;
+	struct proc_dir_entry       *overweight;
+
+	struct timer_list           decay_timer;
+	int                         decay_worker_exited;
+	struct work_struct          decay_worker;
+	struct ipt_hash_location    decay_loc;
+	unsigned long               decay_jiffies;
+
+	int                         exiting;
+};
+
+#define PSDP_SIP_NAME_LEN       16
+
+struct psdp_src_ip
+{
+	unsigned int                magic;
+
+	struct psdp_state           *state;
+	struct ipt_hash_table      *tuple_hash_tab;
+
+	struct proc_dir_entry       *pde;
+
+	/*
+	 * Source IP address and its ASCII string representation.
+	 */
+	__u32                       saddr;
+	char                        name[PSDP_SIP_NAME_LEN];
+
+	/*
+	 * No more tuples are created and a match is returned when
+	 * this value is >= the threshold weight.
+	 */
+	int                         cumulative_weight;
+};
+
+/*
+ * Tuple key. Note that this is not a packed structure. The structure
+ * alignment gaps must be zeroed before the hash table code can use it
+ * as a binary key.
+ */
+struct psdp_tuple_t
+{
+	__u32   daddr;			/* Destination IP address */
+	__u16   port;			/* PORT(TCP/UDP), or ICMP type */
+	__u8    protocol;		/* TCP/UDP/ICMP */
+};
+
+/*
+ * Destination tuple.
+ */
+struct psdp_tuple
+{
+	unsigned int        magic;
+	struct psdp_tuple_t t;
+	unsigned long       expire_time;   /* jiffies */
+	int                 weight;
+};
+
+STATIC_INLINE void psdp_lock(struct psdp_state *psdp, unsigned long *flags)
+{
+	LOCK_BH(&psdp->lock);
+}
+
+STATIC_INLINE void psdp_unlock(struct psdp_state *psdp, unsigned long flags)
+{
+	UNLOCK_BH(&psdp->lock);
+}
+
+STATIC void psdp_init_lock(struct psdp_state *psdp)
+{
+	spin_lock_init(&psdp->lock);
+}
+
+STATIC_INLINE void make_tuple(
+	struct psdp_tuple_t *tk, /* tuple key */
+	__u32               daddr,
+	__u16               port,
+	__u8                protocol
+	)
+{
+	/*
+	 * Make sure alignment bytes in the structure are cleared.
+	 * tk is used as a byte string for the purposes of the
+	 * hash table key.
+	 */
+	memset(tk,0,sizeof(struct psdp_tuple_t));
+	tk->daddr    = daddr;
+	tk->port     = port;
+	tk->protocol = protocol;
+}
+
+STATIC void make_ip_name(
+	__u32	addr,
+	char	*buff
+	)
+{
+	__u32 a = ntohl(addr);
+	sprintf(buff,"%u.%u.%u.%u",
+		(a>>(8*3)) & 0xff,
+		(a>>(8*2)) & 0xff,
+		(a>>(8*1)) & 0xff,
+		(a>>(8*0)) & 0xff
+		);
+}
+
+/*
+ * Keep track of all PSDP contexts.
+ */
+static struct list_head     	psdps_list;
+#ifdef CONFIG_NETFILTER_DEBUG
+static struct spinlock_debug	psdps_lock;
+#else
+static spinlock_t           	psdps_lock;
+#endif
+
+STATIC void add_psdp(
+	struct psdp_state   *psdp
+	)
+{
+	LOCK_BH(&psdps_lock);
+	list_add(&psdp->next,&psdps_list);
+	UNLOCK_BH(&psdps_lock);
+}
+
+STATIC void del_psdp(
+	struct psdp_state   *psdp
+	)
+{
+	LOCK_BH(&psdps_lock);
+	list_del(&psdp->next);
+	UNLOCK_BH(&psdps_lock);
+}
+
+STATIC struct psdp_state *check_for_existing_psdp_name(
+	struct ipt_psdp_info  *info
+	)
+{
+	struct list_head    *elem;
+	struct psdp_state   *psdp=NULL;
+
+	LOCK_BH(&psdps_lock);
+
+	elem = psdps_list.next;
+	while (elem != (&psdps_list))
+	{
+		psdp = list_entry(elem,struct psdp_state,next);
+		if (!strcmp(psdp->info->name,info->name))
+		{
+			break;
+		}
+		psdp = NULL;
+		elem = elem->next;
+	}
+
+	UNLOCK_BH(&psdps_lock);
+
+	return(psdp);
+}
+
+/*
+ * Destination tuple hashing function given to the hash
+ * algorithm search code. This function returns a (hopefully)
+ * somewhat unique value that is converted into a hash index.
+ */
+STATIC __u32 psdp_tuple_hashfunc(void *hash_data)
+{
+	struct psdp_tuple_t *t = (struct psdp_tuple_t *)hash_data;
+	__u32 hash;
+
+	hash = ntohl(t->daddr);
+	hash += ntohs(t->port);
+	hash += t->protocol;
+
+	return(hash);
+}
+
+/*
+ * Source IP hash key function. The source IP hash table
+ * has PSDP_SRC_IP_HASH_LEN entries. Therefore, collisions
+ * will occur within that power of 2 boundary. For example,
+ * if PSDP_SRC_IP_HASH_LEN is 256, then 172.16.0.1 and
+ * 172.16.1.1 will hash to the same index.
+ */
+STATIC __u32 psdp_src_ip_hashfunc(void *hash_data)
+{
+	return(ntohl(*(__u32 *)hash_data));
+}
+
+STATIC_INLINE void psdp_update_tuple_expire_time(
+	struct psdp_src_ip  *src_ip,
+	struct psdp_tuple   *t
+	)
+{
+	t->expire_time = jiffies + src_ip->state->decay_jiffies;
+}
+
+STATIC_INLINE struct psdp_tuple *psdp_find_tuple(
+	struct psdp_src_ip  *src_ip,
+	struct psdp_tuple_t *tk
+	)
+{
+	struct psdp_tuple *t;
+
+	if ((t = (struct psdp_tuple *)ipt_hash_find_entry(src_ip->tuple_hash_tab,tk)) != NULL)
+	{
+		ASSERT_PSDP_MAGIC(t);
+		psdp_update_tuple_expire_time(src_ip,t);
+	}
+	return(t);
+}
+
+STATIC_INLINE struct psdp_tuple *psdp_create_tuple(
+	struct psdp_src_ip  *src_ip,
+	struct psdp_tuple_t *tk
+	)
+{
+	struct psdp_tuple *t;
+
+	t = (struct psdp_tuple *)ipt_hash_create_entry(src_ip->tuple_hash_tab,tk);
+
+	if (t)
+	{
+		t->magic    = PSDP_MAGIC;
+		t->t        = *tk;
+		t->weight   = (tk->port < 1024) ? src_ip->state->info->lo_ports_weight :
+			src_ip->state->info->hi_ports_weight;
+
+		src_ip->cumulative_weight += t->weight;
+
+		psdp_update_tuple_expire_time(src_ip,t);
+
+		IPT_DBG("Created tuple src %08x dst %08x prot %u port %5u weight %u\n",
+			ntohl(src_ip->saddr),
+			ntohl(tk->daddr),
+			tk->protocol,
+			tk->port,t->weight
+		);
+	}
+
+	return(t);
+}
+
+STATIC void psdp_destroy_tuple(
+	struct psdp_src_ip *src_ip,
+	struct psdp_tuple *t
+	)
+{
+	struct psdp_tuple_t tk;
+
+	src_ip->cumulative_weight -= t->weight;
+
+	tk = t->t;
+
+	IPT_DBG("Destroy tuple src %08x dst %08x prot %u port %5u weight %u\n",
+		ntohl(src_ip->saddr),
+		ntohl(tk.daddr),
+		tk.protocol,
+		tk.port,
+		t->weight
+	);
+
+	ipt_hash_delete_entry(src_ip->tuple_hash_tab,&tk);
+}
+
+STATIC void psdp_destroy_src_ip(
+	struct psdp_src_ip *src_ip
+	)
+{
+	struct psdp_state           *psdp;
+	struct psdp_tuple           *t;
+	struct ipt_hash_location   loc;
+	__u32                       addr;
+
+	IPT_DBG("Destroy src IP %08x\n",ntohl(src_ip->saddr));
+
+	psdp = src_ip->state;
+
+	ipt_hash_traverse_init(&loc);
+	while ((t=(struct psdp_tuple *)ipt_hash_traverse(src_ip->tuple_hash_tab,&loc)) != NULL)
+	{
+		psdp_destroy_tuple(src_ip,t);
+	}
+
+	ipt_hash_delete_table(src_ip->tuple_hash_tab);
+
+	if (src_ip->pde)
+	{
+		remove_proc_entry(src_ip->name,src_ip->state->pde);
+	}
+
+	/*
+	 * 'tis good practice to copy the key from the structure you
+	 * are about to destroy before you perform the search.
+	 */
+	addr = src_ip->saddr;
+	ipt_hash_delete_entry(psdp->src_ip_hash_tab,&addr);
+}
+
+/*
+ * Don't overflow the user space buffer.
+ */
+STATIC void add_line(char *buff, int max_len, int *curr_len, char *line)
+{
+	int l_len = strlen(line);
+
+	max_len -= 1;
+
+	if ((max_len-(*curr_len)) <= l_len)
+	{
+		l_len = max_len - (*curr_len);
+		line[l_len] = '\0';
+	}
+
+	strcpy(buff+(*curr_len),line);
+	*curr_len += l_len;
+}
+
+STATIC int psdp_read_proc(
+	char *page,
+	char **start,
+	off_t off,
+	int count,
+	int *eof,
+	void *data
+	)
+{
+	unsigned long               flags;
+	char                        srcip[16];
+	char                        dstip[16];
+
+	struct psdp_src_ip          *src_ip = (struct psdp_src_ip *)data;
+	struct psdp_state           *psdp = src_ip->state;
+	struct psdp_tuple           *t;
+	struct ipt_hash_location   t_loc;
+	char                        *line;
+	__u32                       line_len=256;
+	int                         curr_len=0;
+	unsigned long               now = jiffies;
+
+	ASSERT_PSDP_MAGIC(src_ip);
+	ASSERT_PSDP_MAGIC(psdp);
+
+	if (!(line = vmalloc(line_len)))
+	{
+		return(0);
+	}
+
+	psdp_lock(psdp,&flags);
+
+	sprintf(line,"Legend: SrcIP DstIP Protocol Port Weight Age\n\n");
+	add_line(page,count,&curr_len,line);
+
+
+	make_ip_name(src_ip->saddr,srcip);
+	sprintf(line,"%15s conns %4u weight %4u%s\n",
+		srcip,
+		ipt_hash_num_entries(src_ip->tuple_hash_tab),
+		src_ip->cumulative_weight,
+		src_ip->cumulative_weight > psdp->info->weight_threshold ? " +" : ""
+		);
+	add_line(page,count,&curr_len,line);
+
+	ipt_hash_traverse_init(&t_loc);
+	while ((t=(struct psdp_tuple *)ipt_hash_traverse(src_ip->tuple_hash_tab,&t_loc)) != NULL)
+	{
+		ASSERT_PSDP_MAGIC(t);
+
+		make_ip_name(t->t.daddr,dstip);
+
+		sprintf(line,"-  %15s %15s %2u %5u %d %6u\n",
+			srcip,
+			dstip,
+			(__u32)t->t.protocol,
+			(__u32)ntohs(t->t.port),
+			t->weight,
+			(__u32)(t->expire_time > now ? (t->expire_time - now) : 0)
+			);
+		add_line(page,count,&curr_len,line);
+	}
+	psdp_unlock(psdp,flags);
+
+	vfree(line);
+	return(curr_len);
+}
+
+
+STATIC struct psdp_src_ip *psdp_create_src_ip(
+	struct psdp_state   *psdp,
+	__u32               addr
+	)
+{
+	struct psdp_src_ip *src_ip;
+
+	if (!(src_ip = (struct psdp_src_ip *)ipt_hash_create_entry(psdp->src_ip_hash_tab,&addr)))
+	{
+		return(src_ip);
+	}
+
+	/*
+	 * This will create a hash table that is the least power of 2
+	 * in size that is >= psdp->info->weight_threshold.
+	 */
+	src_ip->tuple_hash_tab =
+		ipt_hash_create_table(
+		psdp->info->weight_threshold,
+		psdp_tuple_hashfunc,
+		sizeof(struct psdp_tuple),
+		sizeof(struct psdp_tuple_t)
+		);
+
+	if (!src_ip->tuple_hash_tab)
+	{
+		ipt_hash_delete_entry(psdp->src_ip_hash_tab,&addr);
+		return(NULL);
+	}
+
+	src_ip->magic = PSDP_MAGIC;
+	src_ip->state = psdp;
+	src_ip->saddr = addr;
+	src_ip->cumulative_weight = 0;
+
+	make_ip_name(src_ip->saddr,src_ip->name);
+	IPT_DBG_ASSERT(strlen(src_ip->name) < PSDP_SIP_NAME_LEN);
+
+	return(src_ip);
+}
+
+STATIC_INLINE struct psdp_src_ip *psdp_find_src_ip(
+	struct psdp_state   *psdp,
+	__u32               addr
+	)
+{
+	return((struct psdp_src_ip *)ipt_hash_find_entry(psdp->src_ip_hash_tab,&addr));
+}
+
+/*
+ * Net filter match function.
+ */
+STATIC int ipt_psdp_match(
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
+	unsigned long           flags;
+	struct iphdr            *ip_hdr;
+	struct psdp_tuple_t     tk;
+	struct psdp_src_ip      *src_ip;
+	struct psdp_tuple       *t;
+	__u16                   port;
+	void					*payload;
+
+	/*
+	 * Parameters from userspace 
+	 */
+	const struct ipt_psdp_info  *info = matchinfo;
+	struct psdp_state           *psdp = info->psdp;
+
+	IPT_DBG_ASSERT(psdp);
+	ASSERT_PSDP_MAGIC(psdp);
+	IPT_DBG_ASSERT(psdp->info == info);
+
+	IPT_DBG("psdp %08x\n",(unsigned int)psdp);
+
+	ip_hdr = pskb->nh.iph;
+
+	/*
+	 * Sanity check.
+	 */
+	if (ntohs(ip_hdr->frag_off) & IP_OFFSET)
+	{
+		return(0);
+	}
+	/*
+	 * Ignore DHCP requests.
+	 */
+	if (!ip_hdr->saddr)
+	{
+		return(0);
+	}
+
+	psdp_lock(psdp,&flags);
+
+	if (!(src_ip = psdp_find_src_ip(psdp,ip_hdr->saddr)))
+	{
+		if (!(src_ip = psdp_create_src_ip(psdp,ip_hdr->saddr)))
+		{
+			DBG_PRINT("Could not create src IP %08x\n",ntohl(ip_hdr->saddr));
+			goto out_no_match;
+		}
+		IPT_DBG("Created src IP %08x\n",ntohl(ip_hdr->saddr));
+	}
+
+	ASSERT_PSDP_MAGIC(src_ip);
+
+	/*
+	 * If blacklist is set and this source IP is overweight, then
+	 * match all packets.
+	 */
+	if (psdp->info->blacklist)
+	{
+		if (src_ip->cumulative_weight >= info->weight_threshold)
+		{
+			goto out_match;
+		}
+	}
+
+	/*
+	 * Extract the destination tuple information.
+	 */
+	payload = (((__u8 *)ip_hdr)+(ip_hdr->ihl*4));
+
+	switch (ip_hdr->protocol)
+	{
+	case IPPROTO_TCP:
+		{
+		port = ntohs(((struct tcphdr *)payload)->dest);
+		break;
+		}
+	case IPPROTO_UDP:
+		{
+		port = ntohs(((struct udphdr *)payload)->dest);
+		break;
+		}
+	case IPPROTO_ICMP:
+		{
+		port = (__u16)((struct icmphdr *)payload)->type;
+		break;
+		}
+	default:
+		goto out_no_match;
+	}
+
+	make_tuple(&tk,ip_hdr->daddr,port,ip_hdr->protocol);
+
+	/*
+	 * If the destination tuple exists, then a side effect of searching is that the
+	 * decay time is updated.
+	 */
+	if ((t=psdp_find_tuple(src_ip,&tk)) != NULL)
+	{
+		ASSERT_PSDP_MAGIC(t);
+
+		/*
+		 * Invalidate the session whenever a FIN packet is seen. The garbage collector
+		 * will cleanup when the tuple expires.
+		 */
+		if ((ip_hdr->protocol==IPPROTO_TCP) && ((struct tcphdr *)payload)->fin)
+		{
+			src_ip->cumulative_weight -= t->weight;
+			t->weight = 0;
+		}
+		goto out_no_match;
+	}
+
+	/*
+	 * If this source IP is already overweight, then match.
+	 */
+	if (src_ip->cumulative_weight >= info->weight_threshold)
+	{
+		goto out_match;
+	}
+
+	psdp_create_tuple(src_ip,&tk);
+
+out_no_match:
+	psdp_unlock(psdp,flags);
+	return(0);
+
+out_match:
+	psdp_unlock(psdp,flags);
+	return(1);
+}
+
+/*
+ * Destroy a filter context.
+ */
+STATIC void ipt_psdp_destroy_state(
+	void *matchinfo,
+	unsigned int matchinfosize
+	)
+{
+	unsigned long               flags;
+	struct ipt_psdp_info        *info = (struct ipt_psdp_info *)matchinfo;
+	struct psdp_state           *psdp;
+	struct ipt_hash_location   loc;
+	struct psdp_src_ip          *src_ip;
+	wait_queue_head_t           wait_q;
+
+	IPT_DBG_ASSERT(matchinfosize == IPT_ALIGN(sizeof(struct ipt_psdp_info)))
+
+	if (!info->psdp)
+	{
+		return;
+	}
+	psdp = info->psdp;
+	ASSERT_PSDP_MAGIC(psdp);
+
+	IPT_DBG("%s %08x\n",__FUNCTION__,(unsigned int)psdp);
+
+	init_waitqueue_head(&wait_q);
+	del_timer(&psdp->decay_timer);
+	psdp->exiting = 1;
+
+	while (!psdp->decay_worker_exited)
+	{
+		schedule_work(&psdp->decay_worker);
+		sleep_on_timeout(&wait_q,2);
+	}
+
+	psdp_lock(psdp,&flags);
+
+	ipt_hash_traverse_init(&loc);
+	while ((src_ip=(struct psdp_src_ip *)ipt_hash_traverse(psdp->src_ip_hash_tab,&loc)) != NULL)
+	{
+		psdp_destroy_src_ip(src_ip);
+	}
+	ipt_hash_delete_table(psdp->src_ip_hash_tab);
+	psdp_unlock(psdp,flags);
+
+	if (psdp->pde)
+	{
+		if (psdp->overweight)
+		{
+			remove_proc_entry(OVERWEIGHT_NAME,psdp->pde);
+		}
+		remove_proc_entry(info->name,proc_net);
+	}
+
+	/*
+	 * Get this context off of the global list.
+	 */
+	del_psdp(psdp);
+
+	kfree(psdp);
+	info->psdp = NULL;
+}
+
+STATIC void psdp_decay_worker(void *context);
+
+STATIC void psdp_decay_timer(
+	unsigned long context
+	)
+{
+	struct psdp_state *psdp = (struct psdp_state *)context;
+	schedule_work(&psdp->decay_worker);
+}
+
+/*
+ * The decay timer expiration time is a function of how many source IP address
+ * entries are in the hash table and how long the decay time is.
+ */
+STATIC void psdp_add_timer(
+	struct psdp_state *psdp
+	)
+{
+	if (ipt_hash_num_entries(psdp->src_ip_hash_tab))
+	{
+		psdp->decay_timer.expires = msec_to_jiffies(psdp->info->decay_msec / ipt_hash_num_entries(psdp->src_ip_hash_tab));
+	}
+	else
+	{
+		psdp->decay_timer.expires = msec_to_jiffies(psdp->info->decay_msec);
+	}
+
+	if (psdp->decay_timer.expires > HZ)
+	{
+		psdp->decay_timer.expires = HZ;
+	}
+
+	if (!psdp->decay_timer.expires)
+	{
+		psdp->decay_timer.expires = jiffies + 1;
+	}
+	else
+	{
+		psdp->decay_timer.expires += jiffies;
+	}
+
+	add_timer(&psdp->decay_timer);
+}
+
+/*
+ * The decay worker thread looks at the next source IP hash table entry
+ * and grooms the destination tuples list.
+ */
+STATIC void psdp_decay_worker(
+	void *context
+	)
+{
+	unsigned long               flags;
+	struct psdp_state           *psdp = (struct psdp_state *)context;
+	struct psdp_src_ip          *src_ip;
+	struct psdp_tuple           *t;
+	struct ipt_hash_location   t_loc;
+
+	psdp_lock(psdp,&flags);
+
+	/*
+	 * Only handle one SRC IP per invocation.
+	 */
+	if ((src_ip=(struct psdp_src_ip *)ipt_hash_traverse(psdp->src_ip_hash_tab,&psdp->decay_loc)) != NULL)
+	{
+		ASSERT_PSDP_MAGIC(src_ip);
+
+		/*
+		 * At most, there can be only cumulative_weight number of entries. Set --psdp-weight-threshold
+		 * accordingly as it affects the search order of magnitude.
+		 */
+		ipt_hash_traverse_init(&t_loc);
+		while ((t=(struct psdp_tuple *)ipt_hash_traverse(src_ip->tuple_hash_tab,&t_loc)) != NULL)
+		{
+			ASSERT_PSDP_MAGIC(t);
+
+			if ((!t->weight) || (time_after(jiffies,t->expire_time)))
+			{
+				psdp_destroy_tuple(src_ip,t);
+			}
+		}
+
+		if (!ipt_hash_num_entries(src_ip->tuple_hash_tab))
+		{
+			psdp_destroy_src_ip(src_ip);
+		}
+		/*
+		 * This was postponed from match time since it runs under interrupt
+		 * context on 2.4. If create_proc_read_entry() has to extend the slab,
+		 * then croakage happens.
+		 */
+		else if (psdp->pde && (!src_ip->pde))
+		{
+			struct proc_dir_entry       *pde;
+			psdp_unlock(psdp,flags);
+			pde = create_proc_read_entry(src_ip->name,0444,psdp->pde,psdp_read_proc,src_ip);
+			psdp_lock(psdp,&flags);
+			if (!src_ip->pde)
+			{
+				src_ip->pde = pde;
+			}
+			else
+			{
+				psdp_unlock(psdp,flags);
+				printk(KERN_ERR "PSDP: created a bogus proc entry %s/%s\n",psdp->info->name,src_ip->name);
+				remove_proc_entry(src_ip->name,psdp->pde);
+				psdp_lock(psdp,&flags);
+			}
+		}
+	}
+	else
+	{
+		/*
+		 * End of the source IP's list, so start over on the next pass.
+		 */
+		ipt_hash_traverse_init(&psdp->decay_loc);
+	}
+
+	if (psdp->exiting)
+	{
+		psdp->decay_worker_exited = 1;
+	}
+	else
+	{
+		psdp_add_timer(psdp);
+	}
+
+	psdp_unlock(psdp,flags);
+}
+
+/*
+ * Discover and output all of the source IP entries that have exceeded the weight
+ * threshold.
+ */
+STATIC int psdp_read_overweight(
+	char *page,
+	char **start,
+	off_t off,
+	int count,
+	int *eof,
+	void *data
+	)
+{
+	unsigned long               flags;
+	struct psdp_state           *psdp=(struct psdp_state *)data;
+	struct psdp_src_ip          *src_ip;
+	struct ipt_hash_location   loc;
+	char                        *line;
+	__u32                       line_len=256;
+	int                         curr_len=0;
+
+	ASSERT_PSDP_MAGIC(psdp);
+
+	if (!(line = vmalloc(line_len)))
+	{
+		return(0);
+	}
+
+	psdp_lock(psdp,&flags);
+
+	ipt_hash_traverse_init(&loc);
+	while ((src_ip=(struct psdp_src_ip *)ipt_hash_traverse(psdp->src_ip_hash_tab,&loc)) != NULL)
+	{
+		if (src_ip->cumulative_weight > psdp->info->weight_threshold)
+		{
+			sprintf(line,"%s\n",src_ip->name);
+			add_line(page,count,&curr_len,line);
+		}
+	}
+
+	psdp_unlock(psdp,flags);
+
+	vfree(line);
+	return(curr_len);
+}
+
+/*
+ * Initialize a new filter context.
+ */
+STATIC int ipt_psdp_init_state(
+	struct ipt_psdp_info *info
+	)
+{
+	struct psdp_state       *psdp=NULL;
+
+	IPT_DBG("name %s weight_threshold %u decay_msec %u lo_ports_weight %u hi_ports_weight %u\n",
+		info->name,
+		info->weight_threshold,
+		info->decay_msec,
+		info->lo_ports_weight,
+		info->hi_ports_weight
+		);
+
+	info->psdp = kmalloc(sizeof(struct psdp_state),GFP_KERNEL);
+	if (!info->psdp)
+	{
+		DBG_PRINT("Failed to kmalloc(struct psdp_state)\n");
+		goto ipt_psdp_init_state_err;
+	}
+	psdp = info->psdp;
+	memset(psdp,0,sizeof(struct psdp_state));
+
+	psdp->info = info;
+	psdp->magic = PSDP_MAGIC;
+
+	/*
+	 * All source IP addresses will get an entry in this directory, e.g., /proc/net/psdp
+	 */
+	if (!(psdp->pde = proc_mkdir(info->name,proc_net)))
+	{
+		DBG_PRINT("Could not create proc directory '%s'\n",info->name);
+		goto ipt_psdp_init_state_err;
+	}
+
+	/*
+	 * All source IP connections that have exceeded their weight will be listed in this file.
+	 */
+	if (!(psdp->overweight = create_proc_read_entry(OVERWEIGHT_NAME,0444,psdp->pde,psdp_read_overweight,psdp)))
+	{
+		DBG_PRINT("Could not create overweight entry.\n");
+		goto ipt_psdp_init_state_err;
+	}
+
+	/*
+	 * Remove destination tuples after decay_msec of inactivity.
+	 */
+	psdp->decay_jiffies = msec_to_jiffies(info->decay_msec);
+
+	/*
+	 * The hash table size really should be an input variable.
+	 */
+	psdp->src_ip_hash_tab =
+		ipt_hash_create_table(
+		PSDP_SRC_IP_HASH_LEN,
+		psdp_src_ip_hashfunc,
+		sizeof(struct psdp_src_ip),
+		sizeof(__u32)
+		);
+
+	if (!psdp->src_ip_hash_tab)
+	{
+		DBG_PRINT("Couldn't create src IP hash table.\n");
+		goto ipt_psdp_init_state_err;
+	}
+
+	/*
+	 * Used by psdp_decay_worker to remember where to start its next pass.
+	 */
+	ipt_hash_traverse_init(&psdp->decay_loc);
+	INIT_WORK(&psdp->decay_worker,psdp_decay_worker,psdp);
+
+	psdp_init_lock(psdp);
+
+	init_timer(&psdp->decay_timer);
+	psdp->decay_timer.data = (unsigned long)psdp;
+	psdp->decay_timer.function = psdp_decay_timer;
+
+	/*
+	 * Add this context to a global list.
+	 */
+	add_psdp(psdp);
+
+	/*
+	 * start the decay timer.
+	 */
+	psdp_add_timer(psdp);
+
+	IPT_DBG("psdp %08x\n",(unsigned int)psdp);
+
+	return(1);
+
+	ipt_psdp_init_state_err:
+	if (psdp)
+	{
+		if (psdp->overweight)
+		{
+			remove_proc_entry(OVERWEIGHT_NAME,psdp->pde);
+		}
+		if (psdp->pde)
+		{
+			remove_proc_entry(psdp->info->name,proc_net);
+		}
+		if (psdp->src_ip_hash_tab)
+		{
+			ipt_hash_delete_table(psdp->src_ip_hash_tab);
+		}
+	}
+	if (info->psdp)
+	{
+		kfree(info->psdp);
+		info->psdp = NULL;
+	}
+
+	return(0);
+}
+
+STATIC void remove_all_proc_entries(
+	struct psdp_state *psdp
+	)
+{
+	unsigned long               flags;
+	struct psdp_src_ip          *src_ip;
+	struct ipt_hash_location   loc;
+
+	psdp_lock(psdp,&flags);
+
+	if (psdp->pde)
+	{
+		ipt_hash_traverse_init(&loc);
+		while ((src_ip=(struct psdp_src_ip *)ipt_hash_traverse(psdp->src_ip_hash_tab,&loc)) != NULL)
+		{
+			if (src_ip->pde)
+			{
+				remove_proc_entry(src_ip->name,psdp->pde);
+				src_ip->pde = NULL;
+			}
+		}
+		if (psdp->overweight)
+		{
+			remove_proc_entry(OVERWEIGHT_NAME,psdp->pde);
+		}
+		remove_proc_entry(psdp->info->name,proc_net);
+		psdp->pde = NULL;
+	}
+
+	psdp_unlock(psdp,flags);
+}
+
+STATIC int ipt_psdp_checkentry(
+	const char           *tablename,
+	const struct ipt_ip  *e,
+	void                 *matchinfo,
+	unsigned int         matchsize,
+	unsigned int         hook_mask
+	)
+{
+	struct ipt_psdp_info    *psdpinfo = (struct ipt_psdp_info *)matchinfo;
+	struct psdp_state       *psdp;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_psdp_info)))
+	{
+		printk(KERN_ERR "PSDP: matchsize %u != %u\n",
+			matchsize,
+			IPT_ALIGN(sizeof(struct ipt_psdp_info))
+			);
+		return(0);
+	}
+
+	/*
+	 * The netfilter subsystem recreates all filters of the same type each 
+	 * time a new filter of that type is added.to a table. However, it adds
+	 * the new filters before deleteting the old filters. Since the /proc/net entries
+	 * will create conflicts, just delete them before the new filter is created
+	 * (which will recreate the same names anyway).
+	 */
+	if ((psdp=check_for_existing_psdp_name(psdpinfo)) != NULL)
+	{
+		/*
+		 * This context is about to get deleted.
+		 */
+		remove_all_proc_entries(psdp);
+	}
+
+	return(ipt_psdp_init_state(psdpinfo));
+}
+
+static struct ipt_match ipt_psdp_reg = { 
+	.name       = "psdp",
+	.match      = ipt_psdp_match,
+	.checkentry = ipt_psdp_checkentry,
+	.destroy    = ipt_psdp_destroy_state,
+	.me         = THIS_MODULE
+};
+
+static int __init init(void)
+{
+	if (ipt_register_match(&ipt_psdp_reg))
+		return(-EINVAL);
+
+	INIT_LIST_HEAD(&psdps_list);
+	spin_lock_init(&psdp_lock);
+
+	printk("netfilter PSDP loaded\n");
+	return(0);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&ipt_psdp_reg);
+	printk("netfilter PSDP unloaded\n");
+}
+
+module_init(init);
+module_exit(fini);
diff -r -u --new-file patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Kconfig.ladd patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Kconfig.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Kconfig.ladd	2004-01-01 20:02:09.000000000 -0700
@@ -0,0 +1,6 @@
+config IP_NF_PSDP
+	tristate "PSD Plus match filter support"
+	help
+	  Allows Port Scan Detection of multiple destinations from
+	  one source address.
+
diff -r -u --new-file patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng/psdp/linux/net/ipv4/netfilter/Makefile.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/psdp/linux/net/ipv4/netfilter/Makefile.ladd	2004-03-17 14:39:08.000000000 -0700
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
+obj-$(CONFIG_IP_NF_PSDP) += ipt_psdp.o


--------------Boundary-00=_VURQGG39ZVGVUOI7EHI0--
