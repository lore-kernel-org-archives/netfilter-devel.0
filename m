From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 2/2] xt_connlimit (iptables) - connection limiting
Date: Sun, 3 Jun 2007 13:23:54 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031323160.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312570.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031312570.10578@yvahk01.tjqt.qr>
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


Previous patch had a wrong #include line, this one seems better :)

================

Adds connlimit to iptables.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/.connlimit-test      |    2 
 extensions/libipt_connlimit.c   |  129 ++++++++++++++++++++++++++++++++++++++++
 extensions/libipt_connlimit.man |   21 ++++++
 3 files changed, 152 insertions(+)

Index: iptables/extensions/.connlimit-test
===================================================================
--- /dev/null
+++ iptables/extensions/.connlimit-test
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_connlimit.h" ] && echo connlimit
Index: iptables/extensions/libipt_connlimit.c
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_connlimit.c
@@ -0,0 +1,129 @@
+/* Shared library add-on to iptables to add connection limit support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/xt_connlimit.h>
+
+/* Function which prints out usage message. */
+static void help(void)
+{
+	printf(
+"connlimit v%s options:\n"
+"[!] --connlimit-above n		match if the number of existing tcp connections is (not) above n\n"
+" --connlimit-mask n		group hosts using mask\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{"connlimit-above", 1, NULL, '1'},
+	{"connlimit-mask",  1, NULL, '2'},
+	{NULL},
+};
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ipt_entry *entry, unsigned int *nfcache,
+		 struct ipt_entry_match **match)
+{
+	struct xt_connlimit_info *info = (void *)(*match)->data;
+	int i;
+
+	if (!(*flags & 2))
+		/*
+		 * set default mask unless we have already seen a mask option
+		 */
+		info->mask = htonl(0xFFFFFFFF);
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		info->limit   = strtoul(argv[optind-1], NULL, 0);
+		info->inverse = invert;
+		*flags |= 1;
+		break;
+
+	case '2':
+		i = strtol(argv[optind-1], NULL, 0);
+		if (i < 0 || i > 32)
+			exit_error(PARAMETER_PROBLEM,
+				"--connlimit-mask must be between 0 and 32");
+
+		if (i == 0)
+			info->mask = 0;
+		else
+			info->mask = htonl(0xFFFFFFFF << (32 - i));
+
+		*flags |= 2;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check */
+static void final_check(unsigned int flags)
+{
+	if (!(flags & 1))
+		exit_error(PARAMETER_PROBLEM, "You must specify `--connlimit-above'");
+}
+
+static int count_bits(u_int32_t mask)
+{
+	int i, bits;
+
+	for (bits = 0, i = 31; i >= 0; i--) {
+		if (mask & htonl((u_int32_t)1 << i)) {
+			bits++;
+			continue;
+		}
+		break;
+	}
+	return bits;
+}
+
+/* Prints out the matchinfo. */
+static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match,
+		  int numeric)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("#conn/%d %s %d ", count_bits(info->mask),
+	       info->inverse ? "<" : ">", info->limit);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("%s--connlimit-above %u --connlimit-mask %u ",
+	       info->inverse ? "! " : "", info->limit,
+	       count_bits(info->mask));
+}
+
+static struct iptables_match connlimit = {
+	.name		= "connlimit",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct xt_connlimit_info)),
+	.userspacesize 	= offsetof(struct xt_connlimit_info, data),
+	.help		= help,
+	.parse 		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts,
+};
+
+static __attribute__((constructor)) void libipt_connlimit_init(void)
+{
+	register_match(&connlimit);
+}
Index: iptables/extensions/libipt_connlimit.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_connlimit.man
@@ -0,0 +1,21 @@
+Allows you to restrict the number of parallel TCP connections to a
+server per client IP address (or address block).
+.TP
+[\fB!\fR] \fB--connlimit-above \fIn\fR
+match if the number of existing tcp connections is (not) above n
+.TP
+.BI "--connlimit-mask " "bits"
+group hosts using mask
+.P
+Examples:
+.TP
+# allow 2 telnet connections per client host
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+.TP
+# you can also match the other way around:
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+.TP
+# limit the nr of parallel http requests to 16 per class C sized \
+network (24 bit netmask)
+iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
+--connlimit-mask 24 -j REJECT
