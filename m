From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 35/43] Unifies libip[6]t_limit.c into libxt_limit.c.
Date: Sun, 15 Jul 2007 03:12:30 +0900 (JST)
Message-ID: <200707141812.l6EICULd000591@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
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


---
 extensions/Makefile                       |    6 +-
 extensions/libip6t_limit.c                |  195 ---------------------=
-----
 extensions/libipt_limit.c                 |  196 ---------------------=
-----
 extensions/libxt_limit.c                  |  214 +++++++++++++++++++++=
++++++++
 include/linux/netfilter/xt_limit.h        |   21 +++
 include/linux/netfilter_ipv4/ipt_limit.h  |   21 ---
 include/linux/netfilter_ipv6/ip6t_limit.h |   21 ---
 7 files changed, 238 insertions(+), 436 deletions(-)
 delete mode 100644 extensions/libip6t_limit.c
 delete mode 100644 extensions/libipt_limit.c
 create mode 100644 extensions/libxt_limit.c
 create mode 100644 include/linux/netfilter/xt_limit.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_limit.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_limit.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 3fbb1b4..b81d7d6 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this ipta=
bles
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah addrtype comment connlimit connmark conntrack dscp e=
cn esp hashlimit helper icmp iprange length limit owner policy realm st=
ate tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE=
 MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE U=
LOG
-PF6_EXT_SLIB:=3Dconnlimit connmark eui64 hl icmp6 length limit owner p=
olicy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=3Dmac mark multiport physdev pkttype sctp standard tcp t=
cpmss udp NOTRACK
+PF_EXT_SLIB:=3Dah addrtype comment connlimit connmark conntrack dscp e=
cn esp hashlimit helper icmp iprange length owner policy realm state to=
s ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRRO=
R NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=3Dconnlimit connmark eui64 hl icmp6 length owner policy =
state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dlimit mac mark multiport physdev pkttype sctp standard=
 tcp tcpmss udp NOTRACK
 =

 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=3DSECMARK CONNSECMARK
diff --git a/extensions/libip6t_limit.c b/extensions/libip6t_limit.c
deleted file mode 100644
index c1f7014..0000000
--- a/extensions/libip6t_limit.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/* Shared library add-on to iptables to add limit support.
- *
- * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne    <rv@wallfire.org>
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include <stddef.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv6/ip6t_limit.h"
-
-#define IP6T_LIMIT_AVG	"3/hour"
-#define IP6T_LIMIT_BURST	5
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"limit v%s options:\n"
-"--limit avg			max average match rate: default "IP6T_LIMIT_AVG"\n"
-"                                [Packets per second unless followed b=
y \n"
-"                                /sec /minute /hour /day postfixes]\n"=

-"--limit-burst number		number to match in a burst, default %u\n"
-"\n", IPTABLES_VERSION, IP6T_LIMIT_BURST);
-}
-
-static struct option opts[] =3D {
-	{ "limit", 1, 0, '%' },
-	{ "limit-burst", 1, 0, '$' },
-	{ 0 }
-};
-
-static
-int parse_rate(const char *rate, u_int32_t *val)
-{
-	const char *delim;
-	u_int32_t r;
-	u_int32_t mult =3D 1;  /* Seconds by default. */
-
-	delim =3D strchr(rate, '/');
-	if (delim) {
-		if (strlen(delim+1) =3D=3D 0)
-			return 0;
-
-		if (strncasecmp(delim+1, "second", strlen(delim+1)) =3D=3D 0)
-			mult =3D 1;
-		else if (strncasecmp(delim+1, "minute", strlen(delim+1)) =3D=3D 0)
-			mult =3D 60;
-		else if (strncasecmp(delim+1, "hour", strlen(delim+1)) =3D=3D 0)
-			mult =3D 60*60;
-		else if (strncasecmp(delim+1, "day", strlen(delim+1)) =3D=3D 0)
-			mult =3D 24*60*60;
-		else
-			return 0;
-	}
-	r =3D atoi(rate);
-	if (!r)
-		return 0;
-
-	/* This would get mapped to infinite (1/day is minimum they
-           can specify, so we're ok at that end). */
-	if (r / mult > IP6T_LIMIT_SCALE)
-		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
-
-	*val =3D IP6T_LIMIT_SCALE * mult / r;
-	return 1;
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ip6t_rateinfo *r =3D (struct ip6t_rateinfo *)m->data;
-
-	parse_rate(IP6T_LIMIT_AVG, &r->avg);
-	r->burst =3D IP6T_LIMIT_BURST;
-
-}
-
-/* FIXME: handle overflow:
-	if (r->avg*r->burst/r->burst !=3D r->avg)
-		exit_error(PARAMETER_PROBLEM,
-			   "Sorry: burst too large for that avg rate.\n");
-*/
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_rateinfo *r =3D (struct ip6t_rateinfo *)(*match)->data;
-	unsigned int num;
-
-	switch(c) {
-	case '%':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (!parse_rate(optarg, &r->avg))
-			exit_error(PARAMETER_PROBLEM,
-				   "bad rate `%s'", optarg);
-		break;
-
-	case '$':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 10000, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				   "bad --limit-burst `%s'", optarg);
-		r->burst =3D num;
-		break;
-
-	default:
-		return 0;
-	}
-
-	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "limit does not support invert");
-
-	return 1;
-}
-
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
-static struct rates
-{
-	const char *name;
-	u_int32_t mult;
-} rates[] =3D { { "day", IP6T_LIMIT_SCALE*24*60*60 },
-	      { "hour", IP6T_LIMIT_SCALE*60*60 },
-	      { "min", IP6T_LIMIT_SCALE*60 },
-	      { "sec", IP6T_LIMIT_SCALE } };
-
-static void print_rate(u_int32_t period)
-{
-	unsigned int i;
-
-	for (i =3D 1; i < sizeof(rates)/sizeof(struct rates); i++) {
-		if (period > rates[i].mult
-		    || rates[i].mult % period !=3D 0)
-			break;
-	}
-
-	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ip6t_rateinfo *r =3D (struct ip6t_rateinfo *)match->data;
-	printf("limit: avg "); print_rate(r->avg);
-	printf("burst %u ", r->burst);
-}
-
-/* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ip6t_rateinfo *r =3D (struct ip6t_rateinfo *)match->data;
-
-	printf("--limit "); print_rate(r->avg);
-	if (r->burst !=3D IP6T_LIMIT_BURST)
-		printf("--limit-burst %u ", r->burst);
-}
-
-static struct ip6tables_match limit =3D {
-	.name 		=3D "limit",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IP6T_ALIGN(sizeof(struct ip6t_rateinfo)),
-	.userspacesize	=3D offsetof(struct ip6t_rateinfo, prev),
-	.help		=3D &help,
-	.init		=3D &init,
-	.parse		=3D &parse,
-	.final_check	=3D &final_check,
-	.print		=3D &print,
-	.save		=3D &save,
-	.extra_opts	=3D opts,
-};
-
-void _init(void)
-{
-	register_match6(&limit);
-}
diff --git a/extensions/libipt_limit.c b/extensions/libipt_limit.c
deleted file mode 100644
index 92d47ae..0000000
--- a/extensions/libipt_limit.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/* Shared library add-on to iptables to add limit support.
- *
- * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne    <rv@wallfire.org>
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-#include <stddef.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_limit.h"
-
-#define IPT_LIMIT_AVG	"3/hour"
-#define IPT_LIMIT_BURST	5
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"limit v%s options:\n"
-"--limit avg			max average match rate: default "IPT_LIMIT_AVG"\n"
-"                                [Packets per second unless followed b=
y \n"
-"                                /sec /minute /hour /day postfixes]\n"=

-"--limit-burst number		number to match in a burst, default %u\n"
-"\n", IPTABLES_VERSION, IPT_LIMIT_BURST);
-}
-
-static struct option opts[] =3D {
-	{ "limit", 1, 0, '%' },
-	{ "limit-burst", 1, 0, '$' },
-	{ 0 }
-};
-
-static
-int parse_rate(const char *rate, u_int32_t *val)
-{
-	const char *delim;
-	u_int32_t r;
-	u_int32_t mult =3D 1;  /* Seconds by default. */
-
-	delim =3D strchr(rate, '/');
-	if (delim) {
-		if (strlen(delim+1) =3D=3D 0)
-			return 0;
-
-		if (strncasecmp(delim+1, "second", strlen(delim+1)) =3D=3D 0)
-			mult =3D 1;
-		else if (strncasecmp(delim+1, "minute", strlen(delim+1)) =3D=3D 0)
-			mult =3D 60;
-		else if (strncasecmp(delim+1, "hour", strlen(delim+1)) =3D=3D 0)
-			mult =3D 60*60;
-		else if (strncasecmp(delim+1, "day", strlen(delim+1)) =3D=3D 0)
-			mult =3D 24*60*60;
-		else
-			return 0;
-	}
-	r =3D atoi(rate);
-	if (!r)
-		return 0;
-
-	/* This would get mapped to infinite (1/day is minimum they
-           can specify, so we're ok at that end). */
-	if (r / mult > IPT_LIMIT_SCALE)
-		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
-
-	*val =3D IPT_LIMIT_SCALE * mult / r;
-	return 1;
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ipt_rateinfo *r =3D (struct ipt_rateinfo *)m->data;
-
-	parse_rate(IPT_LIMIT_AVG, &r->avg);
-	r->burst =3D IPT_LIMIT_BURST;
-
-}
-
-/* FIXME: handle overflow:
-	if (r->avg*r->burst/r->burst !=3D r->avg)
-		exit_error(PARAMETER_PROBLEM,
-			   "Sorry: burst too large for that avg rate.\n");
-*/
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_rateinfo *r =3D (struct ipt_rateinfo *)(*match)->data;
-	unsigned int num;
-
-	switch(c) {
-	case '%':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (!parse_rate(optarg, &r->avg))
-			exit_error(PARAMETER_PROBLEM,
-				   "bad rate `%s'", optarg);
-		break;
-
-	case '$':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 10000, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				   "bad --limit-burst `%s'", optarg);
-		r->burst =3D num;
-		break;
-
-	default:
-		return 0;
-	}
-
-	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "limit does not support invert");
-
-	return 1;
-}
-
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
-static struct rates
-{
-	const char *name;
-	u_int32_t mult;
-} rates[] =3D { { "day", IPT_LIMIT_SCALE*24*60*60 },
-	      { "hour", IPT_LIMIT_SCALE*60*60 },
-	      { "min", IPT_LIMIT_SCALE*60 },
-	      { "sec", IPT_LIMIT_SCALE } };
-
-static void print_rate(u_int32_t period)
-{
-	unsigned int i;
-
-	for (i =3D 1; i < sizeof(rates)/sizeof(struct rates); i++) {
-		if (period > rates[i].mult
-            || rates[i].mult/period < rates[i].mult%period)
-			break;
-	}
-
-	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ipt_rateinfo *r =3D (struct ipt_rateinfo *)match->data;
-	printf("limit: avg "); print_rate(r->avg);
-	printf("burst %u ", r->burst);
-}
-
-/* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_rateinfo *r =3D (struct ipt_rateinfo *)match->data;
-
-	printf("--limit "); print_rate(r->avg);
-	if (r->burst !=3D IPT_LIMIT_BURST)
-		printf("--limit-burst %u ", r->burst);
-}
-
-static struct iptables_match limit =3D { =

-	.next		=3D NULL,
-	.name		=3D "limit",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IPT_ALIGN(sizeof(struct ipt_rateinfo)),
-	.userspacesize	=3D offsetof(struct ipt_rateinfo, prev),
-	.help		=3D &help,
-	.init		=3D &init,
-	.parse		=3D &parse,
-	.final_check	=3D &final_check,
-	.print		=3D &print,
-	.save		=3D &save,
-	.extra_opts	=3D opts
-};
-
-void _init(void)
-{
-	register_match(&limit);
-}
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
new file mode 100644
index 0000000..aa7131d
--- /dev/null
+++ b/extensions/libxt_limit.c
@@ -0,0 +1,214 @@
+/* Shared library add-on to iptables to add limit support.
+ *
+ * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
+ * Herv=E9 Eychenne    <rv@wallfire.org>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <stddef.h>
+#include <linux/netfilter/x_tables.h>
+/* For 64bit kernel / 32bit userspace */
+#include "../include/linux/netfilter/xt_limit.h"
+
+#define XT_LIMIT_AVG	"3/hour"
+#define XT_LIMIT_BURST	5
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"limit v%s options:\n"
+"--limit avg			max average match rate: default "XT_LIMIT_AVG"\n"
+"                                [Packets per second unless followed b=
y \n"
+"                                /sec /minute /hour /day postfixes]\n"=

+"--limit-burst number		number to match in a burst, default %u\n"
+"\n", IPTABLES_VERSION, XT_LIMIT_BURST);
+}
+
+static struct option opts[] =3D {
+	{ "limit", 1, 0, '%' },
+	{ "limit-burst", 1, 0, '$' },
+	{ 0 }
+};
+
+static
+int parse_rate(const char *rate, u_int32_t *val)
+{
+	const char *delim;
+	u_int32_t r;
+	u_int32_t mult =3D 1;  /* Seconds by default. */
+
+	delim =3D strchr(rate, '/');
+	if (delim) {
+		if (strlen(delim+1) =3D=3D 0)
+			return 0;
+
+		if (strncasecmp(delim+1, "second", strlen(delim+1)) =3D=3D 0)
+			mult =3D 1;
+		else if (strncasecmp(delim+1, "minute", strlen(delim+1)) =3D=3D 0)
+			mult =3D 60;
+		else if (strncasecmp(delim+1, "hour", strlen(delim+1)) =3D=3D 0)
+			mult =3D 60*60;
+		else if (strncasecmp(delim+1, "day", strlen(delim+1)) =3D=3D 0)
+			mult =3D 24*60*60;
+		else
+			return 0;
+	}
+	r =3D atoi(rate);
+	if (!r)
+		return 0;
+
+	/* This would get mapped to infinite (1/day is minimum they
+           can specify, so we're ok at that end). */
+	if (r / mult > XT_LIMIT_SCALE)
+		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
+
+	*val =3D XT_LIMIT_SCALE * mult / r;
+	return 1;
+}
+
+/* Initialize the match. */
+static void
+init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+	struct xt_rateinfo *r =3D (struct xt_rateinfo *)m->data;
+
+	parse_rate(XT_LIMIT_AVG, &r->avg);
+	r->burst =3D XT_LIMIT_BURST;
+
+}
+
+/* FIXME: handle overflow:
+	if (r->avg*r->burst/r->burst !=3D r->avg)
+		exit_error(PARAMETER_PROBLEM,
+			   "Sorry: burst too large for that avg rate.\n");
+*/
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_rateinfo *r =3D (struct xt_rateinfo *)(*match)->data;
+	unsigned int num;
+
+	switch(c) {
+	case '%':
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (!parse_rate(optarg, &r->avg))
+			exit_error(PARAMETER_PROBLEM,
+				   "bad rate `%s'", optarg);
+		break;
+
+	case '$':
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (string_to_number(optarg, 0, 10000, &num) =3D=3D -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "bad --limit-burst `%s'", optarg);
+		r->burst =3D num;
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "limit does not support invert");
+
+	return 1;
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+static struct rates
+{
+	const char *name;
+	u_int32_t mult;
+} rates[] =3D { { "day", XT_LIMIT_SCALE*24*60*60 },
+	      { "hour", XT_LIMIT_SCALE*60*60 },
+	      { "min", XT_LIMIT_SCALE*60 },
+	      { "sec", XT_LIMIT_SCALE } };
+
+static void print_rate(u_int32_t period)
+{
+	unsigned int i;
+
+	for (i =3D 1; i < sizeof(rates)/sizeof(struct rates); i++) {
+		if (period > rates[i].mult
+            || rates[i].mult/period < rates[i].mult%period)
+			break;
+	}
+
+	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	struct xt_rateinfo *r =3D (struct xt_rateinfo *)match->data;
+	printf("limit: avg "); print_rate(r->avg);
+	printf("burst %u ", r->burst);
+}
+
+/* FIXME: Make minimalist: only print rate if not default --RR */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_rateinfo *r =3D (struct xt_rateinfo *)match->data;
+
+	printf("--limit "); print_rate(r->avg);
+	if (r->burst !=3D XT_LIMIT_BURST)
+		printf("--limit-burst %u ", r->burst);
+}
+
+static struct xtables_match limit =3D { =

+	.next		=3D NULL,
+	.family		=3D AF_INET,
+	.name		=3D "limit",
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_rateinfo)),
+	.userspacesize	=3D offsetof(struct xt_rateinfo, prev),
+	.help		=3D &help,
+	.init		=3D &init,
+	.parse		=3D &parse,
+	.final_check	=3D &final_check,
+	.print		=3D &print,
+	.save		=3D &save,
+	.extra_opts	=3D opts
+};
+
+static struct xtables_match limit6 =3D { =

+	.next		=3D NULL,
+	.family		=3D AF_INET6,
+	.name		=3D "limit",
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_rateinfo)),
+	.userspacesize	=3D offsetof(struct xt_rateinfo, prev),
+	.help		=3D &help,
+	.init		=3D &init,
+	.parse		=3D &parse,
+	.final_check	=3D &final_check,
+	.print		=3D &print,
+	.save		=3D &save,
+	.extra_opts	=3D opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&limit);
+	xtables_register_match(&limit6);
+}
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilt=
er/xt_limit.h
new file mode 100644
index 0000000..c0aa6d9
--- /dev/null
+++ b/include/linux/netfilter/xt_limit.h
@@ -0,0 +1,21 @@
+#ifndef _XT_RATE_H
+#define _XT_RATE_H
+
+/* timings are in milliseconds. */
+#define XT_LIMIT_SCALE 10000
+
+/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 42949=
0
+   seconds, or one every 59 hours. */
+struct xt_rateinfo {
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	/* Used internally by the kernel */
+	unsigned long prev;
+	/* Ugly, ugly fucker. */
+	struct xt_rateinfo *master;
+
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+};
+#endif /*_XT_RATE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_limit.h b/include/linux/n=
etfilter_ipv4/ipt_limit.h
deleted file mode 100644
index f46d4b4..0000000
--- a/include/linux/netfilter_ipv4/ipt_limit.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef _IPT_RATE_H
-#define _IPT_RATE_H
-
-/* timings are in milliseconds. */
-#define IPT_LIMIT_SCALE 10000
-
-/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 42949=
0
-   seconds, or one every 59 hours. */
-struct ipt_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* Used internally by the kernel */
-	unsigned long prev;
-	/* Ugly, ugly fucker. */
-	struct ipt_rateinfo *master;
-
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
-};
-#endif /*_IPT_RATE_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_limit.h b/include/linux/=
netfilter_ipv6/ip6t_limit.h
deleted file mode 100644
index 6e17a67..0000000
--- a/include/linux/netfilter_ipv6/ip6t_limit.h
+++ /dev/null
@@ -1,21 +0,0 @@
-#ifndef _IP6T_RATE_H
-#define _IP6T_RATE_H
-
-/* timings are in milliseconds. */
-#define IP6T_LIMIT_SCALE 10000
-
-/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 42949=
0
-   seconds, or one every 59 hours. */
-struct ip6t_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* Used internally by the kernel */
-	unsigned long prev;
-	/* Ugly, ugly fucker. */
-	struct ip6t_rateinfo *master;
-
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
-};
-#endif /*_IPT_RATE_H*/
-- =

1.5.2.2
