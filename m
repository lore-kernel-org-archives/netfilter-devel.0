From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070707 kernel
Date: Mon, 9 Jul 2007 17:38:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707091737550.2887@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
	<46891C50.1020904@trash.net>
	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
	<468A2F91.3040002@trash.net>
	<Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>
	<468A3446.9050505@trash.net>
	<Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>
	<468BB421.3090801@trash.net>
	<Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
	<46924678.9010909@trash.net>
	<Pine.LNX.4.64.0707091700160.2887@fbirervta.pbzchgretzou.qr>
	<4692524B.3060403@trash.net> <4692545F.2020101@trash.net>
	<Pine.LNX.4.64.0707091731400.2887@fbirervta.pbzchgretzou.qr>
	<46925543.6060205@trash.net> <46925580.9030608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46925580.9030608@trash.net>
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


On Jul 9 2007 17:34, Patrick McHardy wrote:
>>>Does it still make it into 2.6.23-rc1?
>
>> Yes, unless it fails during testing :)
>
>Speaking of which, could you resend the latest version of the
>corresponding iptables patch please?
>
At your service!

(Note the symlink, or how [sw]ould this be done?)


Thanks,
	Jan
===

Subject: Add connlimit to iptables.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---

 symlink libip6t_connlimit.man -> libipt_connlimit.man

 extensions/Makefile                    |    4 
 extensions/libip6t_connlimit.c         |  151 +++++++++++++++++++++++++++++++++
 extensions/libipt_connlimit.c          |  128 +++++++++++++++++++++++++++
 extensions/libipt_connlimit.man        |   27 +++++
 include/linux/netfilter/xt_connlimit.h |   17 +++
 5 files changed, 325 insertions(+), 2 deletions(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -5,8 +5,8 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
Index: iptables/extensions/libip6t_connlimit.c
===================================================================
--- /dev/null
+++ iptables/extensions/libip6t_connlimit.c
@@ -0,0 +1,151 @@
+/* Shared library add-on to iptables to add connection limit support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include "../include/linux/netfilter/xt_connlimit.h"
+
+/* Function which prints out usage message. */
+static void connlimit_help(void)
+{
+	printf(
+"connlimit v%s options:\n"
+"[!] --connlimit-above n        match if the number of existing "
+"                               connections is (not) above n\n"
+"    --connlimit-mask n         group hosts using mask\n"
+"\n", IPTABLES_VERSION);
+}
+
+static const struct option connlimit_opts[] = {
+	{"connlimit-above", 1, NULL, 1},
+	{"connlimit-mask",  1, NULL, 2},
+	{NULL},
+};
+
+static void connlimit_init(struct ip6t_entry_match *match, unsigned int *nfc)
+{
+	struct xt_connlimit_info *info = (void *)match->data;
+	info->v6_mask[0] =
+	info->v6_mask[1] =
+	info->v6_mask[2] =
+	info->v6_mask[3] = 0xFFFFFFFF;
+}
+
+static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
+{
+	if (prefix_len == 0) {
+		mask[0] = mask[1] = mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 32) {
+		mask[0] <<= 32 - prefix_len;
+		mask[1] = mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 64) {
+		mask[1] <<= 32 - (prefix_len - 32);
+		mask[2] = mask[3] = 0;
+	} else if (prefix_len <= 96) {
+		mask[2] <<= 32 - (prefix_len - 64);
+		mask[3] = 0;
+	} else if (prefix_len <= 128) {
+		mask[3] <<= 32 - (prefix_len - 96);
+	}
+	mask[0] = htonl(mask[0]);
+	mask[1] = htonl(mask[1]);
+	mask[2] = htonl(mask[2]);
+	mask[3] = htonl(mask[3]);
+}
+
+static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const struct ip6t_entry *entry,
+                           unsigned int *nfcache,
+                           struct ip6t_entry_match **match)
+{
+	struct xt_connlimit_info *info = (void *)(*match)->data;
+	char *err;
+	int i;
+
+	if (*flags & c)
+		exit_error(PARAMETER_PROBLEM,
+		           "--connlimit-above and/or --connlimit-mask may "
+			   "only be given once");
+
+	switch (c) {
+	case 1:
+		check_inverse(optarg, &invert, &optind, 0);
+		info->limit   = strtoul(argv[optind-1], NULL, 0);
+		info->inverse = invert;
+		break;
+	case 2:
+		i = strtoul(argv[optind-1], &err, 0);
+		if (i > 128 || *err != '\0')
+			exit_error(PARAMETER_PROBLEM,
+				"--connlimit-mask must be between 0 and 128");
+		prefix_to_netmask(info->v6_mask, i);
+		break;
+	default:
+		return 0;
+	}
+
+	*flags |= c;
+	return 1;
+}
+
+/* Final check */
+static void connlimit_check(unsigned int flags)
+{
+	if (!(flags & 1))
+		exit_error(PARAMETER_PROBLEM,
+		           "You must specify \"--connlimit-above\"");
+}
+
+static unsigned int count_bits(const u_int32_t *mask)
+{
+	unsigned int bits = 0, i;
+	u_int32_t tmp[4];
+
+	for (i = 0; i < 4; ++i)
+		for (tmp[i] = ~ntohl(mask[i]); tmp[i] != 0; tmp[i] >>= 1)
+			++bits;
+	return 128 - bits;
+}
+
+/* Prints out the matchinfo. */
+static void connlimit_print(const struct ip6t_ip6 *ip,
+                            const struct ip6t_entry_match *match, int numeric)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("#conn/%u %s %u ", count_bits(info->v6_mask),
+	       info->inverse ? "<" : ">", info->limit);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void connlimit_save(const struct ip6t_ip6 *ip,
+                           const struct ip6t_entry_match *match)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("%s--connlimit-above %u --connlimit-mask %u ",
+	       info->inverse ? "! " : "", info->limit,
+	       count_bits(info->v6_mask));
+}
+
+static struct ip6tables_match connlimit_reg = {
+	.name          = "connlimit",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct xt_connlimit_info)),
+	.userspacesize = offsetof(struct xt_connlimit_info, data),
+	.help          = connlimit_help,
+	.init          = connlimit_init,
+	.parse         = connlimit_parse,
+	.final_check   = connlimit_check,
+	.print         = connlimit_print,
+	.save          = connlimit_save,
+	.extra_opts    = connlimit_opts,
+};
+
+static __attribute__((constructor)) void libipt_connlimit_init(void)
+{
+	register_match6(&connlimit_reg);
+}
Index: iptables/extensions/libipt_connlimit.c
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_connlimit.c
@@ -0,0 +1,128 @@
+/* Shared library add-on to iptables to add connection limit support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <getopt.h>
+#include <iptables.h>
+#include "../include/linux/netfilter/xt_connlimit.h"
+
+/* Function which prints out usage message. */
+static void connlimit_help(void)
+{
+	printf(
+"connlimit v%s options:\n"
+"[!] --connlimit-above n        match if the number of existing "
+"                               connections is (not) above n\n"
+"    --connlimit-mask n         group hosts using mask\n"
+"\n", IPTABLES_VERSION);
+}
+
+static const struct option connlimit_opts[] = {
+	{"connlimit-above", 1, NULL, 1},
+	{"connlimit-mask",  1, NULL, 2},
+	{NULL},
+};
+
+static void connlimit_init(struct ipt_entry_match *match, unsigned int *nfc)
+{
+	struct xt_connlimit_info *info = (void *)match->data;
+	info->v4_mask = 0xFFFFFFFF;
+}
+
+static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const struct ipt_entry *entry,
+                           unsigned int *nfcache,
+                           struct ipt_entry_match **match)
+{
+	struct xt_connlimit_info *info = (void *)(*match)->data;
+	char *err;
+	int i;
+
+	if (*flags & c)
+		exit_error(PARAMETER_PROBLEM,
+		           "--connlimit-above and/or --connlimit-mask may "
+			   "only be given once");
+
+	switch (c) {
+	case 1:
+		check_inverse(optarg, &invert, &optind, 0);
+		info->limit   = strtoul(argv[optind-1], NULL, 0);
+		info->inverse = invert;
+		break;
+	case 2:
+		i = strtoul(argv[optind-1], &err, 0);
+		if (i > 32 || *err != '\0')
+			exit_error(PARAMETER_PROBLEM,
+				"--connlimit-mask must be between 0 and 32");
+		if (i == 0)
+			info->v4_mask = 0;
+		else
+			info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
+		break;
+	default:
+		return 0;
+	}
+
+	*flags |= c;
+	return 1;
+}
+
+/* Final check */
+static void connlimit_check(unsigned int flags)
+{
+	if (!(flags & 1))
+		exit_error(PARAMETER_PROBLEM,
+		           "You must specify \"--connlimit-above\"");
+}
+
+static unsigned int count_bits(u_int32_t mask)
+{
+	unsigned int bits = 0;
+
+	for (mask = ~ntohl(mask); mask != 0; mask >>= 1)
+		++bits;
+
+	return 32 - bits;
+}
+
+/* Prints out the matchinfo. */
+static void connlimit_print(const struct ipt_ip *ip,
+                            const struct ipt_entry_match *match, int numeric)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("#conn/%u %s %u ", count_bits(info->v4_mask),
+	       info->inverse ? "<" : ">", info->limit);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void connlimit_save(const struct ipt_ip *ip,
+                           const struct ipt_entry_match *match)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("%s--connlimit-above %u --connlimit-mask %u ",
+	       info->inverse ? "! " : "", info->limit,
+	       count_bits(info->v4_mask));
+}
+
+static struct iptables_match connlimit_reg = {
+	.name          = "connlimit",
+	.version       = IPTABLES_VERSION,
+	.size          = IPT_ALIGN(sizeof(struct xt_connlimit_info)),
+	.userspacesize = offsetof(struct xt_connlimit_info, data),
+	.help          = connlimit_help,
+	.init          = connlimit_init,
+	.parse         = connlimit_parse,
+	.final_check   = connlimit_check,
+	.print         = connlimit_print,
+	.save          = connlimit_save,
+	.extra_opts    = connlimit_opts,
+};
+
+static __attribute__((constructor)) void libipt_connlimit_init(void)
+{
+	register_match(&connlimit_reg);
+}
Index: iptables/extensions/libipt_connlimit.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_connlimit.man
@@ -0,0 +1,27 @@
+Allows you to restrict the number of parallel connections to a server per
+client IP address (or client address block).
+.TP
+[\fB!\fR] \fB--connlimit-above \fIn\fR
+Match if the number of existing connections is (not) above \fIn\fR.
+.TP
+\fB--connlimit-mask\fR \fIprefix_length\fR
+Group hosts using the prefix length. For IPv4, this must be a number between
+(including) 0 and 32. For IPv6, between 0 and 128.
+.P
+Examples:
+.TP
+# allow 2 telnet connections per client host
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+.TP
+# you can also match the other way around:
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+.TP
+# limit the number of parallel HTTP requests to 16 per class C sized \
+network (24 bit netmask)
+iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
+--connlimit-mask 24 -j REJECT
+.TP
+# limit the number of parallel HTTP requests to 16 for the link local network \
+(ipv6)
+ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
+16 --connlimit-mask 64 -j REJECT
Index: iptables/include/linux/netfilter/xt_connlimit.h
===================================================================
--- /dev/null
+++ iptables/include/linux/netfilter/xt_connlimit.h
@@ -0,0 +1,17 @@
+#ifndef _XT_CONNLIMIT_H
+#define _XT_CONNLIMIT_H
+
+struct xt_connlimit_data;
+
+struct xt_connlimit_info {
+	union {
+		u_int32_t v4_mask;
+		u_int32_t v6_mask[4];
+	};
+	unsigned int limit, inverse;
+
+	/* this needs to be at the end */
+	struct xt_connlimit_data *data __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CONNLIMIT_H */
