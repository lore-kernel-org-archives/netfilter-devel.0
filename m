From: Alex Davis <alex14641@yahoo.com>
Subject: [RFC][2/2] New netfilter match module : iptables patch
Date: Tue, 30 May 2006 18:51:50 -0700 (PDT)
Message-ID: <20060531015150.13721.qmail@web50201.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This patch is against  iptables 1.3.5

Binary files iptables-1.3.5/extensions/.Makefile.swp and
iptables-1.3.5-ipisforif/extensions/.Makefile.swp differ
Binary files iptables-1.3.5/extensions/.libipt_ipisforif.c.swp and
iptables-1.3.5-ipisforif/extensions/.libipt_ipisforif.c.swp differ
diff -rPu iptables-1.3.5/extensions/Makefile iptables-1.3.5-ipisforif/extensions/Makefile
--- iptables-1.3.5/extensions/Makefile	2006-02-01 07:14:31.000000000 -0500
+++ iptables-1.3.5-ipisforif/extensions/Makefile	2006-05-30 01:52:07.000000000 -0400
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp
iprange length limit mac mark multiport owner physdev pkttype policy realm rpc sctp standard state
tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP
NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp ipisforif hashlimit
helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm rpc sctp
standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE
MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=connmark eui64 hl icmpv6 length limit mac mark multiport owner physdev policy
standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TRACE
 
 # Optionals
diff -rPu iptables-1.3.5/extensions/libipt_ipisforif.c
iptables-1.3.5-ipisforif/extensions/libipt_ipisforif.c
--- iptables-1.3.5/extensions/libipt_ipisforif.c	1969-12-31 19:00:00.000000000 -0500
+++ iptables-1.3.5-ipisforif/extensions/libipt_ipisforif.c	2006-05-30 09:36:32.000000000 -0400
@@ -0,0 +1,129 @@
+/* Shared library add-on to iptables to add network interface IP matching support.
+ *
+ * (C) 2006 Alex Davis
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_ipisforif.h>
+
+// Parameter names.
+#define SRC "srcip"
+#define DST "dstip"
+
+/* Function which prints out usage message. */
+static void help(void) 
+{
+	printf("ipisforif v%s options:\n [!]  --%s|--%s ifname\n"
+	       "Packet source or destination address matches interface.\n"
+	       "\n", SRC, DST, IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ SRC, 1, 0, '1' },
+	{ DST, 1, 0, '2' },
+	{0}
+};
+
+/* Initialize the match. */
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const struct ipt_entry *entry, unsigned int *nfcache,
+		 struct ipt_entry_match **match)
+{
+	struct ipt_ipisforif_info *info =
+		(struct ipt_ipisforif_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		info->invert = invert;
+		info->type = TYPE_SRC;
+		strcpy(info->ifname, argv[optind - 1]);
+		*flags = 1;
+		break;
+
+	case '2':
+		check_inverse(optarg, &invert, &optind, 0);
+		info->invert = invert;
+		info->type = TYPE_DST;
+		strcpy(info->ifname, argv[optind - 1]);
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
+	if ( ! flags ) {
+		exit_error(PARAMETER_PROBLEM,
+			   "You must specify `--%s' or '--%s'", SRC, DST);
+	}
+}
+
+/* Prints out the matchinfo. */
+static void print(const struct ipt_ip *ip,
+		  const struct ipt_entry_match *match,
+      		  int numeric) 
+{
+	struct ipt_ipisforif_info *info = (struct ipt_ipisforif_info *)match->data;
+
+	if ( info->type == TYPE_SRC ) {
+		printf("%s %s ", SRC, info->ifname);
+	}
+	else if ( info->type == TYPE_DST ) {
+		printf("%s %s ", DST, info->ifname);
+	}
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match) 
+{
+	struct ipt_ipisforif_info *info = (struct ipt_ipisforif_info *)match->data;
+
+	if ( info->type == TYPE_SRC ) {
+		printf("--%s %s ", SRC, info->ifname);
+	}
+	else if ( info->type == TYPE_DST ) {
+		printf("--%s %s ", DST, info->ifname);
+	}
+}
+
+static struct iptables_match ipisforif = { 
+	.next		= NULL,
+	.name		= "ipisforif",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_ipisforif_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ipisforif_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.init		= &init,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void) 
+{
+	register_match(&ipisforif);
+}


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
