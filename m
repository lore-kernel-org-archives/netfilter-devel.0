From: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] adds ebtables nflog
	support	to	ulogd
Date: Mon, 25 Feb 2008 14:55:35 +0100
Message-ID: <47C2C8D7.5060605@endian.com>
References: <20080211220753.796791654@endian.com>	
	<1202846691.2901.16.camel@localhost.localdomain>	
	<47B201F6.3000607@endian.com>
	<1203632611.2902.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050407010204000906060503"
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1203632611.2902.6.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050407010204000906060503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bart

Bart De Schuymer wrote:
> I had a look at those posts (through your links), the patches seem fine.
> However, the lines are truncated around 80 characters. Can you resend or
> point me to newer patches?

I resend as attachment.
This is the patch for the ebtables userland tool.

The kernel module follows later as i rebased it to net-2.2.26 and test 
it currently.

peter

--------------050407010204000906060503
Content-Type: text/x-patch;
 name="ulogd-ebt_nflog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ulogd-ebt_nflog.patch"

This patch adds ebt_nflog watcher extension to the ebtables
userland tool.
It's based on xt_NFLOG, so options are basically the same.

Signed-off-by: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
---
 ebtables2/ebtables.8             |   35 +++++++
 ebtables2/extensions/Makefile    |    2 
 ebtables2/extensions/ebt_nflog.c |  179 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+), 1 deletion(-)

Index: ebtables2/extensions/Makefile
===================================================================
--- ebtables2/extensions/Makefile.orig	2008-02-05 17:43:28.000000000 +0100
+++ ebtables2/extensions/Makefile	2008-02-05 18:27:26.000000000 +0100
@@ -1,7 +1,7 @@
 #! /usr/bin/make
 
 EXT_FUNC+=802_3 nat arp arpreply ip standard log redirect vlan mark_m mark \
-          pkttype stp among limit ulog
+          pkttype stp among limit ulog nflog
 EXT_TABLES+=filter nat broute
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/ebt_$(T).o)
 EXT_OBJS+=$(foreach T,$(EXT_TABLES), extensions/ebtable_$(T).o)
Index: ebtables2/extensions/ebt_nflog.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ebtables2/extensions/ebt_nflog.c	2008-02-05 18:27:26.000000000 +0100
@@ -0,0 +1,179 @@
+/* ebt_nflog
+ *
+ * Authors:
+ * Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
+ *
+ *  February, 2008
+ *
+ * Based on:
+ *  ebt_ulog.c, (C) 2004, Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
+ *  libxt_NFLOG.c
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include "../include/ebtables_u.h"
+#include <linux/netfilter_bridge/ebt_nflog.h>
+
+enum {
+	NFLOG_GROUP = 0x1,
+	NFLOG_PREFIX = 0x2,
+	NFLOG_RANGE = 0x4,
+	NFLOG_THRESHOLD = 0x8,
+	NFLOG_NFLOG = 0x16,
+};
+
+static struct option nflog_opts[] = {
+	{"nflog-group", required_argument, NULL, NFLOG_GROUP},
+	{"nflog-prefix", required_argument, NULL, NFLOG_PREFIX},
+	{"nflog-range", required_argument, NULL, NFLOG_RANGE},
+	{"nflog-threshold", required_argument, NULL, NFLOG_THRESHOLD},
+	{"nflog", no_argument, NULL, NFLOG_NFLOG},
+	{.name = NULL}
+};
+
+static void nflog_help()
+{
+	printf("nflog options:\n"
+	       "--nflog               : use the default nflog parameters\n"
+	       "--nflog-prefix prefix : Prefix string for log message\n"
+	       "--nflog-group group   : NETLINK group used for logging\n"
+	       "--nflog-range range   : Number of byte to copy\n"
+	       "--nflog-threshold     : Message threshold of"
+	       "in-kernel queue\n");
+}
+
+static void nflog_init(struct ebt_entry_watcher *watcher)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)watcher->data;
+
+	info->prefix[0] = '\0';
+	info->group = EBT_NFLOG_DEFAULT_GROUP;
+	info->threshold = EBT_NFLOG_DEFAULT_THRESHOLD;
+}
+
+static int nflog_parse(int c, char **argv, int argc,
+		       const struct ebt_u_entry *entry, unsigned int *flags,
+		       struct ebt_entry_watcher **watcher)
+{
+	struct ebt_nflog_info *info;
+	unsigned int i;
+	char *end;
+
+	info = (struct ebt_nflog_info *)(*watcher)->data;
+	switch (c) {
+	case NFLOG_PREFIX:
+		if (ebt_check_inverse2(optarg))
+			goto inverse_invalid;
+		ebt_check_option2(flags, NFLOG_PREFIX);
+		if (strlen(optarg) > EBT_NFLOG_PREFIX_SIZE - 1)
+			ebt_print_error("Prefix too long for nflog-prefix");
+		strcpy(info->prefix, optarg);
+		break;
+
+	case NFLOG_GROUP:
+		if (ebt_check_inverse2(optarg))
+			goto inverse_invalid;
+		ebt_check_option2(flags, NFLOG_GROUP);
+		i = strtoul(optarg, &end, 10);
+		if (*end != '\0')
+			ebt_print_error2("--nflog-group must be a number!");
+		if (i < 0)
+			ebt_print_error2("--nflog-group can not be negative");
+		info->group = i;
+		break;
+
+	case NFLOG_RANGE:
+		if (ebt_check_inverse2(optarg))
+			goto inverse_invalid;
+		ebt_check_option2(flags, NFLOG_RANGE);
+		i = strtoul(optarg, &end, 10);
+		if (*end != '\0')
+			ebt_print_error2("--nflog-range must be a number!");
+		if (i < 0)
+			ebt_print_error2("--nflog-range can not be negative");
+		info->len = i;
+		break;
+
+	case NFLOG_THRESHOLD:
+		if (ebt_check_inverse2(optarg))
+			goto inverse_invalid;
+		ebt_check_option2(flags, NFLOG_THRESHOLD);
+		i = strtoul(optarg, &end, 10);
+		if (*end != '\0')
+			ebt_print_error2("--nflog-threshold must be a number!");
+		if (i < 0)
+			ebt_print_error2
+			    ("--nflog-threshold can not be negative");
+		info->threshold = i;
+		break;
+	case NFLOG_NFLOG:
+		if (ebt_check_inverse(optarg))
+			goto inverse_invalid;
+		ebt_check_option2(flags, NFLOG_NFLOG);
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+
+ inverse_invalid:
+	ebt_print_error("The use of '!' makes no sense for the nflog watcher");
+	return 1;
+}
+
+static void nflog_final_check(const struct ebt_u_entry *entry,
+			      const struct ebt_entry_watcher *watcher,
+			      const char *name, unsigned int hookmask,
+			      unsigned int time)
+{
+}
+
+static void nflog_print(const struct ebt_u_entry *entry,
+			const struct ebt_entry_watcher *watcher)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)watcher->data;
+
+	if (info->prefix[0] != '\0')
+		printf("--nflog-prefix \"%s\"", info->prefix);
+	if (info->group)
+		printf("--nflog-group %d ", info->group);
+	if (info->len)
+		printf("--nflog-range %d", info->len);
+	if (info->threshold != EBT_NFLOG_DEFAULT_THRESHOLD)
+		printf(" --nflog-threshold %d ", info->threshold);
+}
+
+static int nflog_compare(const struct ebt_entry_watcher *w1,
+			 const struct ebt_entry_watcher *w2)
+{
+	struct ebt_nflog_info *info1 = (struct ebt_nflog_info *)w1->data;
+	struct ebt_nflog_info *info2 = (struct ebt_nflog_info *)w2->data;
+
+	if (info1->group != info2->group ||
+	    info1->len != info2->len ||
+	    info1->threshold != info2->threshold ||
+	    strcmp(info1->prefix, info2->prefix))
+		return 0;
+	return 1;
+}
+
+static struct ebt_u_watcher nflog_watcher = {
+	.name = "nflog",
+	.size = sizeof(struct ebt_nflog_info),
+	.help = nflog_help,
+	.init = nflog_init,
+	.parse = nflog_parse,
+	.final_check = nflog_final_check,
+	.print = nflog_print,
+	.compare = nflog_compare,
+	.extra_ops = nflog_opts,
+};
+
+void _init(void)
+{
+	ebt_register_watcher(&nflog_watcher);
+}
Index: ebtables2/ebtables.8
===================================================================
--- ebtables2/ebtables.8.orig	2008-02-05 18:27:08.000000000 +0100
+++ ebtables2/ebtables.8	2008-02-05 18:27:26.000000000 +0100
@@ -804,6 +804,41 @@
 .br
 Will log the (r)arp information when a frame made by the (r)arp protocols
 matches the rule. The default is no (r)arp information logging.
+.SS nflog
+The nflog watcher passes the packet to the loaded logging backend
+in order to log the packet. This is usually used in combination with
+nfnetlink_log as logging backend, which will multicast the packet
+through a
+.IR netlink
+socket to the specified multicast group. One or more userspace processes
+may subscribe to the group to receive the packets.
+.TP
+.B "--nflog"
+.br
+Log with the default logging options
+.TP
+.B --nflog-group "\fInlgroup\fP"
+.br
+The netlink group (1 - 2^32-1) to which packets are (only applicable for
+nfnetlink_log). The default value is 1.
+.TP
+.B --nflog-prefix "\fIprefix\fP"
+.br
+A prefix string to include in the log message, up to 30 characters
+long, useful for distinguishing messages in the logs.
+.TP
+.B --nflog-range "\fIsize\fP"
+.br
+The number of bytes to be copied to userspace (only applicable for
+nfnetlink_log). nfnetlink_log instances may specify their own
+range, this option overrides it.
+.TP
+.B --nflog-threshold "\fIsize\fP"
+.br
+Number of packets to queue inside the kernel before sending them
+to userspace (only applicable for nfnetlink_log). Higher values
+result in less overhead per packet, but increase delay until the
+packets reach userspace. The default value is 1.
 .SS ulog
 The ulog watcher passes the packet to a userspace
 logging daemon using netlink multicast sockets. This differs


--------------050407010204000906060503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
--------------050407010204000906060503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ebtables-devel mailing list
Ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/ebtables-devel

--------------050407010204000906060503--
