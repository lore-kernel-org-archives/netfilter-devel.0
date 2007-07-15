From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: [PATCH] tcpmss match for IPv6 (libip6t_tcpmss)
Date: Sun, 15 Jul 2007 22:05:11 +0200
Message-ID: <469A7DF7.30607@plouf.fr.eu.org>
References: <4696A0C6.6040905@plouf.fr.eu.org>
	<46977A73.5040200@trash.net>	<4697ACCF.9090808@plouf.fr.eu.org>
	<4698E86A.4070301@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070806090801060009050003"
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4698E86A.4070301@trash.net>
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

This is a multi-part message in MIME format.
--------------070806090801060009050003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Patrick McHardy a =E9crit :
> Pascal Hambourg wrote:
>=20
>>I just made libip6t_tcpmss.c, ip6t_tcpmss.h and libip6t_tcpmss.man from
>>the existing corresponding IPv4 files in iptables 1.3.8, roughly by
>>replacing all occurrences of 'ip' with 'ip6'. It builds and seems to
>>work on my x86 box. Shall I post a diff -ruN against the original
>>iptables 1.3.8 tree here for review ?
>=20
> ip6_tables ports for x_tables matches and targets should ideally alread=
y
> use the xt_ structures and constants. If you send a patch for tcpmss
> I'll happily add it to SVN.

As I explained before, my patch is directly adapted from libipt_tcpmss=20
and does not use the xtables definitions.

> BTW, Yasuyuki, whats the current state of your x_tables userspace
> patches? I recall they we're almost finished when you posted them
> a couple of month ago.

Now Yasuyuki has posted his x_tables patches including the porting=20
tcpmss to x_tables, mine seems superfluous. However I post it for those=20
who might want to try it with the current stable iptables. I am glad=20
that my proposal indirectly triggered the posting of the x_tables=20
patches. :-)

--------------070806090801060009050003
Content-Type: text/plain;
 name="libip6t_tcpmss.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libip6t_tcpmss.patch"

diff -ruN iptables-1.3.8-orig/extensions/Makefile iptables-1.3.8/extensions/Makefile
--- iptables-1.3.8-orig/extensions/Makefile	2007-03-22 01:04:36.000000000 +0100
+++ iptables-1.3.8/extensions/Makefile	2007-07-12 16:23:12.000000000 +0200
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype comment connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE NOTRACK REDIRECT REJECT SAME SNAT TCPMSS TOS TTL ULOG
-PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS
+PF6_EXT_SLIB:=connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp tcpmss udp CONNMARK HL LOG NFQUEUE MARK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff -ruN iptables-1.3.8-orig/extensions/libip6t_tcpmss.c iptables-1.3.8/extensions/libip6t_tcpmss.c
--- iptables-1.3.8-orig/extensions/libip6t_tcpmss.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.8/extensions/libip6t_tcpmss.c	2007-07-12 21:22:26.000000000 +0200
@@ -0,0 +1,152 @@
+/* Shared library add-on to ip6tables to add tcp MSS matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_tcpmss.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"tcpmss match v%s options:\n"
+"[!] --mss value[:value]	Match TCP MSS range.\n"
+"				(only valid for TCP SYN or SYN/ACK packets)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mss", 1, 0, '1' },
+	{0}
+};
+
+static u_int16_t
+parse_tcp_mssvalue(const char *mssvalue)
+{
+	unsigned int mssvaluenum;
+
+	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
+		return (u_int16_t)mssvaluenum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "Invalid mss `%s' specified", mssvalue);
+}
+
+static void
+parse_tcp_mssvalues(const char *mssvaluestring,
+		    u_int16_t *mss_min, u_int16_t *mss_max)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(mssvaluestring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		*mss_min = *mss_max = parse_tcp_mssvalue(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		*mss_min = buffer[0] ? parse_tcp_mssvalue(buffer) : 0;
+		*mss_max = cp[0] ? parse_tcp_mssvalue(cp) : 0xFFFF;
+	}
+	free(buffer);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_tcpmss_match_info *mssinfo =
+		(struct ip6t_tcpmss_match_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--mss' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_mssvalues(argv[optind-1],
+				    &mssinfo->mss_min, &mssinfo->mss_max);
+		if (invert)
+			mssinfo->invert = 1;
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, int invert, int numeric)
+{
+	if (invert)
+		printf("! ");
+
+	if (mss_min == mss_max)
+		printf("%u ", mss_min);
+	else
+		printf("%u:%u ", mss_min, mss_max);
+}
+
+/* Final check; must have specified --mss. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "tcpmss match: You must specify `--mss'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	const struct ip6t_tcpmss_match_info *mssinfo =
+		(const struct ip6t_tcpmss_match_info *)match->data;
+
+	printf("tcpmss match ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, numeric);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	const struct ip6t_tcpmss_match_info *mssinfo =
+		(const struct ip6t_tcpmss_match_info *)match->data;
+
+	printf("--mss ");
+	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
+		     mssinfo->invert, 0);
+}
+
+static struct ip6tables_match tcpmss = {
+	.next		= NULL,
+	.name		= "tcpmss",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_match_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcpmss_match_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match6(&tcpmss);
+}
diff -ruN iptables-1.3.8-orig/extensions/libip6t_tcpmss.man iptables-1.3.8/extensions/libip6t_tcpmss.man
--- iptables-1.3.8-orig/extensions/libip6t_tcpmss.man	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.8/extensions/libip6t_tcpmss.man	2007-07-12 15:55:12.000000000 +0200
@@ -0,0 +1,4 @@
+This matches the TCP MSS (maximum segment size) field of the TCP header.  You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.
+.TP
+.BI "[!] "--mss " value[:value]"
+Match a given TCP MSS value or range.
diff -ruN iptables-1.3.8-orig/include/linux/netfilter_ipv6/ip6t_tcpmss.h iptables-1.3.8/include/linux/netfilter_ipv6/ip6t_tcpmss.h
--- iptables-1.3.8-orig/include/linux/netfilter_ipv6/ip6t_tcpmss.h	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.8/include/linux/netfilter_ipv6/ip6t_tcpmss.h	2007-07-12 16:20:51.000000000 +0200
@@ -0,0 +1,9 @@
+#ifndef _IP6T_TCPMSS_MATCH_H
+#define _IP6T_TCPMSS_MATCH_H
+
+struct ip6t_tcpmss_match_info {
+    u_int16_t mss_min, mss_max;
+    u_int8_t invert;
+};
+
+#endif /*_IP6T_TCPMSS_MATCH_H*/

--------------070806090801060009050003--
