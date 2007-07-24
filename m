From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/**] Move connlimit to xt
Date: Tue, 24 Jul 2007 12:46:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241246160.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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



Moves libip{,6}t_connlimit to libxt.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/Makefile              |    6 -
 extensions/libip6t_connlimit.c   |  151 ---------------------------
 extensions/libip6t_connlimit.man |   27 ----
 extensions/libipt_connlimit.c    |  128 -----------------------
 extensions/libipt_connlimit.man  |   27 ----
 extensions/libxt_connlimit.c     |  217 +++++++++++++++++++++++++++++++++++++++
 extensions/libxt_connlimit.man   |   27 ++++
 7 files changed, 247 insertions(+), 336 deletions(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG MARK TRACE
-PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG MARK TRACE
+PFX_EXT_SLIB:=comment connlimit dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=CONNSECMARK
Index: iptables/extensions/libip6t_connlimit.c
===================================================================
--- iptables.orig/extensions/libip6t_connlimit.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/* Shared library add-on to iptables to add connection limit support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include "../include/linux/netfilter/xt_connlimit.h"
-
-/* Function which prints out usage message. */
-static void connlimit_help(void)
-{
-	printf(
-"connlimit v%s options:\n"
-"[!] --connlimit-above n        match if the number of existing "
-"                               connections is (not) above n\n"
-"    --connlimit-mask n         group hosts using mask\n"
-"\n", IPTABLES_VERSION);
-}
-
-static const struct option connlimit_opts[] = {
-	{"connlimit-above", 1, NULL, 1},
-	{"connlimit-mask",  1, NULL, 2},
-	{NULL},
-};
-
-static void connlimit_init(struct ip6t_entry_match *match, unsigned int *nfc)
-{
-	struct xt_connlimit_info *info = (void *)match->data;
-	info->v6_mask[0] =
-	info->v6_mask[1] =
-	info->v6_mask[2] =
-	info->v6_mask[3] = 0xFFFFFFFF;
-}
-
-static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
-{
-	if (prefix_len == 0) {
-		mask[0] = mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 32) {
-		mask[0] <<= 32 - prefix_len;
-		mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 64) {
-		mask[1] <<= 32 - (prefix_len - 32);
-		mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 96) {
-		mask[2] <<= 32 - (prefix_len - 64);
-		mask[3] = 0;
-	} else if (prefix_len <= 128) {
-		mask[3] <<= 32 - (prefix_len - 96);
-	}
-	mask[0] = htonl(mask[0]);
-	mask[1] = htonl(mask[1]);
-	mask[2] = htonl(mask[2]);
-	mask[3] = htonl(mask[3]);
-}
-
-static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const struct ip6t_entry *entry,
-                           unsigned int *nfcache,
-                           struct ip6t_entry_match **match)
-{
-	struct xt_connlimit_info *info = (void *)(*match)->data;
-	char *err;
-	int i;
-
-	if (*flags & c)
-		exit_error(PARAMETER_PROBLEM,
-		           "--connlimit-above and/or --connlimit-mask may "
-			   "only be given once");
-
-	switch (c) {
-	case 1:
-		check_inverse(optarg, &invert, &optind, 0);
-		info->limit   = strtoul(argv[optind-1], NULL, 0);
-		info->inverse = invert;
-		break;
-	case 2:
-		i = strtoul(argv[optind-1], &err, 0);
-		if (i > 128 || *err != '\0')
-			exit_error(PARAMETER_PROBLEM,
-				"--connlimit-mask must be between 0 and 128");
-		prefix_to_netmask(info->v6_mask, i);
-		break;
-	default:
-		return 0;
-	}
-
-	*flags |= c;
-	return 1;
-}
-
-/* Final check */
-static void connlimit_check(unsigned int flags)
-{
-	if (!(flags & 1))
-		exit_error(PARAMETER_PROBLEM,
-		           "You must specify \"--connlimit-above\"");
-}
-
-static unsigned int count_bits(const u_int32_t *mask)
-{
-	unsigned int bits = 0, i;
-	u_int32_t tmp[4];
-
-	for (i = 0; i < 4; ++i)
-		for (tmp[i] = ~ntohl(mask[i]); tmp[i] != 0; tmp[i] >>= 1)
-			++bits;
-	return 128 - bits;
-}
-
-/* Prints out the matchinfo. */
-static void connlimit_print(const struct ip6t_ip6 *ip,
-                            const struct ip6t_entry_match *match, int numeric)
-{
-	const struct xt_connlimit_info *info = (const void *)match->data;
-
-	printf("#conn/%u %s %u ", count_bits(info->v6_mask),
-	       info->inverse ? "<" : ">", info->limit);
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void connlimit_save(const struct ip6t_ip6 *ip,
-                           const struct ip6t_entry_match *match)
-{
-	const struct xt_connlimit_info *info = (const void *)match->data;
-
-	printf("%s--connlimit-above %u --connlimit-mask %u ",
-	       info->inverse ? "! " : "", info->limit,
-	       count_bits(info->v6_mask));
-}
-
-static struct ip6tables_match connlimit_reg = {
-	.name          = "connlimit",
-	.version       = IPTABLES_VERSION,
-	.size          = IP6T_ALIGN(sizeof(struct xt_connlimit_info)),
-	.userspacesize = offsetof(struct xt_connlimit_info, data),
-	.help          = connlimit_help,
-	.init          = connlimit_init,
-	.parse         = connlimit_parse,
-	.final_check   = connlimit_check,
-	.print         = connlimit_print,
-	.save          = connlimit_save,
-	.extra_opts    = connlimit_opts,
-};
-
-void _init(void)
-{
-	register_match6(&connlimit_reg);
-}
Index: iptables/extensions/libip6t_connlimit.man
===================================================================
--- iptables.orig/extensions/libip6t_connlimit.man
+++ /dev/null
@@ -1,27 +0,0 @@
-Allows you to restrict the number of parallel connections to a server per
-client IP address (or client address block).
-.TP
-[\fB!\fR] \fB--connlimit-above \fIn\fR
-Match if the number of existing connections is (not) above \fIn\fR.
-.TP
-\fB--connlimit-mask\fR \fIprefix_length\fR
-Group hosts using the prefix length. For IPv4, this must be a number between
-(including) 0 and 32. For IPv6, between 0 and 128.
-.P
-Examples:
-.TP
-# allow 2 telnet connections per client host
-ip6tables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
-.TP
-# you can also match the other way around:
-ip6tables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
-.TP
-# limit the number of parallel HTTP requests to 16 per class C sized \
-network (24 bit netmask)
-ip6tables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
---connlimit-mask 24 -j REJECT
-.TP
-# limit the number of parallel HTTP requests to 16 for the link local network \
-(ipv6)
-ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
-16 --connlimit-mask 64 -j REJECT
Index: iptables/extensions/libipt_connlimit.c
===================================================================
--- iptables.orig/extensions/libipt_connlimit.c
+++ /dev/null
@@ -1,128 +0,0 @@
-/* Shared library add-on to iptables to add connection limit support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
-#include <iptables.h>
-#include "../include/linux/netfilter/xt_connlimit.h"
-
-/* Function which prints out usage message. */
-static void connlimit_help(void)
-{
-	printf(
-"connlimit v%s options:\n"
-"[!] --connlimit-above n        match if the number of existing "
-"                               connections is (not) above n\n"
-"    --connlimit-mask n         group hosts using mask\n"
-"\n", IPTABLES_VERSION);
-}
-
-static const struct option connlimit_opts[] = {
-	{"connlimit-above", 1, NULL, 1},
-	{"connlimit-mask",  1, NULL, 2},
-	{NULL},
-};
-
-static void connlimit_init(struct ipt_entry_match *match, unsigned int *nfc)
-{
-	struct xt_connlimit_info *info = (void *)match->data;
-	info->v4_mask = 0xFFFFFFFF;
-}
-
-static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const struct ipt_entry *entry,
-                           unsigned int *nfcache,
-                           struct ipt_entry_match **match)
-{
-	struct xt_connlimit_info *info = (void *)(*match)->data;
-	char *err;
-	int i;
-
-	if (*flags & c)
-		exit_error(PARAMETER_PROBLEM,
-		           "--connlimit-above and/or --connlimit-mask may "
-			   "only be given once");
-
-	switch (c) {
-	case 1:
-		check_inverse(optarg, &invert, &optind, 0);
-		info->limit   = strtoul(argv[optind-1], NULL, 0);
-		info->inverse = invert;
-		break;
-	case 2:
-		i = strtoul(argv[optind-1], &err, 0);
-		if (i > 32 || *err != '\0')
-			exit_error(PARAMETER_PROBLEM,
-				"--connlimit-mask must be between 0 and 32");
-		if (i == 0)
-			info->v4_mask = 0;
-		else
-			info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
-		break;
-	default:
-		return 0;
-	}
-
-	*flags |= c;
-	return 1;
-}
-
-/* Final check */
-static void connlimit_check(unsigned int flags)
-{
-	if (!(flags & 1))
-		exit_error(PARAMETER_PROBLEM,
-		           "You must specify \"--connlimit-above\"");
-}
-
-static unsigned int count_bits(u_int32_t mask)
-{
-	unsigned int bits = 0;
-
-	for (mask = ~ntohl(mask); mask != 0; mask >>= 1)
-		++bits;
-
-	return 32 - bits;
-}
-
-/* Prints out the matchinfo. */
-static void connlimit_print(const struct ipt_ip *ip,
-                            const struct ipt_entry_match *match, int numeric)
-{
-	const struct xt_connlimit_info *info = (const void *)match->data;
-
-	printf("#conn/%u %s %u ", count_bits(info->v4_mask),
-	       info->inverse ? "<" : ">", info->limit);
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void connlimit_save(const struct ipt_ip *ip,
-                           const struct ipt_entry_match *match)
-{
-	const struct xt_connlimit_info *info = (const void *)match->data;
-
-	printf("%s--connlimit-above %u --connlimit-mask %u ",
-	       info->inverse ? "! " : "", info->limit,
-	       count_bits(info->v4_mask));
-}
-
-static struct iptables_match connlimit_reg = {
-	.name          = "connlimit",
-	.version       = IPTABLES_VERSION,
-	.size          = IPT_ALIGN(sizeof(struct xt_connlimit_info)),
-	.userspacesize = offsetof(struct xt_connlimit_info, data),
-	.help          = connlimit_help,
-	.init          = connlimit_init,
-	.parse         = connlimit_parse,
-	.final_check   = connlimit_check,
-	.print         = connlimit_print,
-	.save          = connlimit_save,
-	.extra_opts    = connlimit_opts,
-};
-
-void _init(void)
-{
-	register_match(&connlimit_reg);
-}
Index: iptables/extensions/libipt_connlimit.man
===================================================================
--- iptables.orig/extensions/libipt_connlimit.man
+++ /dev/null
@@ -1,27 +0,0 @@
-Allows you to restrict the number of parallel connections to a server per
-client IP address (or client address block).
-.TP
-[\fB!\fR] \fB--connlimit-above \fIn\fR
-Match if the number of existing connections is (not) above \fIn\fR.
-.TP
-\fB--connlimit-mask\fR \fIprefix_length\fR
-Group hosts using the prefix length. For IPv4, this must be a number between
-(including) 0 and 32. For IPv6, between 0 and 128.
-.P
-Examples:
-.TP
-# allow 2 telnet connections per client host
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
-.TP
-# you can also match the other way around:
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
-.TP
-# limit the number of parallel HTTP requests to 16 per class C sized \
-network (24 bit netmask)
-iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
---connlimit-mask 24 -j REJECT
-.TP
-# limit the number of parallel HTTP requests to 16 for the link local network \
-(ipv6)
-ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
-16 --connlimit-mask 64 -j REJECT
Index: iptables/extensions/libxt_connlimit.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_connlimit.c
@@ -0,0 +1,217 @@
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
+	{"connlimit-above", 1, NULL, 'A'},
+	{"connlimit-mask",  1, NULL, 'M'},
+	{NULL},
+};
+
+static void connlimit_init(struct ipt_entry_match *match, unsigned int *nfc)
+{
+	struct xt_connlimit_info *info = (void *)match->data;
+	info->v4_mask = 0xFFFFFFFFUL;
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
+                           struct xt_connlimit_info *info, unsigned int family)
+{
+	char *err;
+	int i;
+
+	switch (c) {
+	case 'A':
+		if (*flags & 0x1)
+			exit_error(PARAMETER_PROBLEM,
+				"--connlimit-above may be given only once");
+		*flags |= 0x1;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->limit   = strtoul(argv[optind-1], NULL, 0);
+		info->inverse = invert;
+		break;
+	case 'M':
+		if (*flags & 0x2)
+			exit_error(PARAMETER_PROBLEM,
+				"--connlimit-mask may be given only once");
+
+		*flags |= 0x2;
+		i = strtoul(argv[optind-1], &err, 0);
+		if (family == AF_INET6) {
+			if (i > 128 || *err != '\0')
+				exit_error(PARAMETER_PROBLEM,
+					"--connlimit-mask must be between "
+					"0 and 128");
+			prefix_to_netmask(info->v6_mask, i);
+		} else {
+			if (i > 32 || *err != '\0')
+				exit_error(PARAMETER_PROBLEM,
+					"--connlimit-mask must be between "
+					"0 and 32");
+			if (i == 0)
+				info->v4_mask = 0;
+			else
+				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
+		}
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static int connlimit_parse4(int c, char **argv, int invert,
+                            unsigned int *flags, const void *entry,
+                            unsigned int *nfcache,
+                            struct xt_entry_match **match)
+{
+	return connlimit_parse(c, argv, invert, flags,
+	       (void *)(*match)->data, AF_INET);
+}
+
+static int connlimit_parse6(int c, char **argv, int invert,
+                            unsigned int *flags, const void *entry,
+                            unsigned int *nfcache,
+                            struct xt_entry_match **match)
+{
+	return connlimit_parse(c, argv, invert, flags,
+	       (void *)(*match)->data, AF_INET6);
+}
+
+static void connlimit_check(unsigned int flags)
+{
+	if (!(flags & 0x1))
+		exit_error(PARAMETER_PROBLEM,
+			"You must specify \"--connlimit-above\"");
+}
+
+static unsigned int count_bits4(u_int32_t mask)
+{
+	unsigned int bits = 0;
+
+	for (mask = ~ntohl(mask); mask != 0; mask >>= 1)
+		++bits;
+
+	return 32 - bits;
+}
+
+static unsigned int count_bits6(const u_int32_t *mask)
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
+static void connlimit_print4(const void *ip,
+                             const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("#conn/%u %s %u ", count_bits4(info->v4_mask),
+	       info->inverse ? "<" : ">", info->limit);
+}
+
+static void connlimit_print6(const void *ip,
+                             const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+	printf("#conn/%u %s %u ", count_bits6(info->v6_mask),
+	       info->inverse ? "<" : ">", info->limit);
+}
+
+static void connlimit_save4(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("%s--connlimit-above %u --connlimit-mask %u ",
+	       info->inverse ? "! " : "", info->limit,
+	       count_bits4(info->v4_mask));
+}
+
+static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_connlimit_info *info = (const void *)match->data;
+
+	printf("%s--connlimit-above %u --connlimit-mask %u ",
+	       info->inverse ? "! " : "", info->limit,
+	       count_bits6(info->v6_mask));
+}
+
+static struct xtables_match connlimit_reg4 = {
+	.name          = "connlimit",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+	.userspacesize = offsetof(struct xt_connlimit_info, data),
+	.help          = connlimit_help,
+	.init          = connlimit_init,
+	.parse         = connlimit_parse4,
+	.final_check   = connlimit_check,
+	.print         = connlimit_print4,
+	.save          = connlimit_save4,
+	.extra_opts    = connlimit_opts,
+};
+
+static struct xtables_match connlimit_reg6 = {
+	.name          = "connlimit",
+	.family        = AF_INET6,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+	.userspacesize = offsetof(struct xt_connlimit_info, data),
+	.help          = connlimit_help,
+	.init          = connlimit_init,
+	.parse         = connlimit_parse6,
+	.final_check   = connlimit_check,
+	.print         = connlimit_print6,
+	.save          = connlimit_save6,
+	.extra_opts    = connlimit_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&connlimit_reg4);
+	xtables_register_match(&connlimit_reg6);
+}
Index: iptables/extensions/libxt_connlimit.man
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_connlimit.man
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
