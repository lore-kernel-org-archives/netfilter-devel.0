From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 04/13] Unifies libip[6]t_hashlimit into libxt_hashlimit
Date: Tue, 24 Jul 2007 15:58:16 +0900 (JST)
Message-ID: <200707240658.l6O6wH9Y019449@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
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


 extensions/.hashlimit-test6                        |    3 -
 extensions/Makefile                                |    4 +-
 extensions/libipt_hashlimit.c                      |  369 ------------=
--------
 .../{libip6t_hashlimit.c =3D> libxt_hashlimit.c}     |   37 ++-
 .../ipt_hashlimit.h =3D> netfilter/xt_hashlimit.h}   |   24 +-
 5 files changed, 41 insertions(+), 396 deletions(-)
 delete mode 100755 extensions/.hashlimit-test6
 delete mode 100644 extensions/libipt_hashlimit.c
 rename extensions/{libip6t_hashlimit.c =3D> libxt_hashlimit.c} (92%)
 rename include/linux/{netfilter_ipv4/ipt_hashlimit.h =3D> netfilter/xt=
_hashlimit.h} (65%)

diff --git a/extensions/.hashlimit-test6 b/extensions/.hashlimit-test6
deleted file mode 100755
index 9a2a465..0000000
--- a/extensions/.hashlimit-test6
+++ /dev/null
@@ -1,3 +0,0 @@
-#!/bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter/xt_hashlimit.h ] && echo hash=
limit
-
diff --git a/extensions/Makefile b/extensions/Makefile
index 904803e..6918759 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this ipta=
bles
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah addrtype connlimit connmark conntrack ecn hashlimit =
helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY D=
NAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS=
 TTL TRACE ULOG
+PF_EXT_SLIB:=3Dah addrtype connlimit connmark conntrack ecn helper icm=
p iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP E=
CN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE=
 ULOG
 PF6_EXT_SLIB:=3Dconnlimit connmark eui64 hl icmp6 owner policy state H=
L LOG TRACE
-PFX_EXT_SLIB:=3Dcomment dscp esp length limit mac mark multiport physd=
ev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK T=
CPMSS
+PFX_EXT_SLIB:=3Dcomment dscp esp hashlimit length limit mac mark multi=
port physdev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE=
 NOTRACK TCPMSS
 =

 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=3D
diff --git a/extensions/libipt_hashlimit.c b/extensions/libipt_hashlimi=
t.c
deleted file mode 100644
index 552d3bf..0000000
--- a/extensions/libipt_hashlimit.c
+++ /dev/null
@@ -1,369 +0,0 @@
-/* iptables match extension for limiting packets per destination
- *
- * (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
- *
- * Development of this code was funded by Astaro AG, http://www.astaro=
.com/
- *
- * Based on ipt_limit.c by
- * J=E9r=F4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne    <rv@wallfire.org>
- * =

- * Error corections by nmalykh@bilim.com (22.01.2005)
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-#include <stddef.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_hashlimit.h>
-
-#define IPT_HASHLIMIT_BURST	5
-
-/* miliseconds */
-#define IPT_HASHLIMIT_GCINTERVAL	1000
-#define IPT_HASHLIMIT_EXPIRE	10000
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"hashlimit v%s options:\n"
-"--hashlimit <avg>		max average match rate\n"
-"                                [Packets per second unless followed b=
y \n"
-"                                /sec /minute /hour /day postfixes]\n"=

-"--hashlimit-mode <mode>		mode is a comma-separated list of\n"
-"					dstip,srcip,dstport,srcport\n"
-"--hashlimit-name <name>		name for /proc/net/ipt_hashlimit/\n"
-"[--hashlimit-burst <num>]	number to match in a burst, default %u\n"
-"[--hashlimit-htable-size <num>]	number of hashtable buckets\n"
-"[--hashlimit-htable-max <num>]	number of hashtable entries\n"
-"[--hashlimit-htable-gcinterval]	interval between garbage collection r=
uns\n"
-"[--hashlimit-htable-expire]	after which time are idle entries expired=
?\n"
-"\n", IPTABLES_VERSION, IPT_HASHLIMIT_BURST);
-}
-
-static struct option opts[] =3D {
-	{ "hashlimit", 1, 0, '%' },
-	{ "hashlimit-burst", 1, 0, '$' },
-	{ "hashlimit-htable-size", 1, 0, '&' },
-	{ "hashlimit-htable-max", 1, 0, '*' },
-	{ "hashlimit-htable-gcinterval", 1, 0, '(' },
-	{ "hashlimit-htable-expire", 1, 0, ')' },
-	{ "hashlimit-mode", 1, 0, '_' },
-	{ "hashlimit-name", 1, 0, '"' },
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
-	if (r / mult > IPT_HASHLIMIT_SCALE)
-		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
-
-	*val =3D IPT_HASHLIMIT_SCALE * mult / r;
-	return 1;
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ipt_hashlimit_info *r =3D (struct ipt_hashlimit_info *)m->data=
;
-
-	r->cfg.burst =3D IPT_HASHLIMIT_BURST;
-	r->cfg.gc_interval =3D IPT_HASHLIMIT_GCINTERVAL;
-	r->cfg.expire =3D IPT_HASHLIMIT_EXPIRE;
-
-}
-
-
-/* Parse a 'mode' parameter into the required bitmask */
-static int parse_mode(struct ipt_hashlimit_info *r, char *optarg)
-{
-	char *tok;
-	char *arg =3D strdup(optarg);
-
-	if (!arg)
-		return -1;
-
-	r->cfg.mode =3D 0;
-
-	for (tok =3D strtok(arg, ",|");
-	     tok;
-	     tok =3D strtok(NULL, ",|")) {
-		if (!strcmp(tok, "dstip"))
-			r->cfg.mode |=3D IPT_HASHLIMIT_HASH_DIP;
-		else if (!strcmp(tok, "srcip"))
-			r->cfg.mode |=3D IPT_HASHLIMIT_HASH_SIP;
-		else if (!strcmp(tok, "srcport"))
-			r->cfg.mode |=3D IPT_HASHLIMIT_HASH_SPT;
-		else if (!strcmp(tok, "dstport"))
-			r->cfg.mode |=3D IPT_HASHLIMIT_HASH_DPT;
-		else {
-			free(arg);
-			return -1;
-		}
-	}
-	free(arg);
-	return 0;
-}
-
-#define PARAM_LIMIT		0x00000001
-#define PARAM_BURST		0x00000002
-#define PARAM_MODE		0x00000004
-#define PARAM_NAME		0x00000008
-#define PARAM_SIZE		0x00000010
-#define PARAM_MAX		0x00000020
-#define PARAM_GCINTERVAL	0x00000040
-#define PARAM_EXPIRE		0x00000080
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_hashlimit_info *r =3D =

-			(struct ipt_hashlimit_info *)(*match)->data;
-	unsigned int num;
-
-	switch(c) {
-	case '%':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (!parse_rate(optarg, &r->cfg.avg))
-			exit_error(PARAMETER_PROBLEM,
-				   "bad rate `%s'", optarg);
-		*flags |=3D PARAM_LIMIT;
-		break;
-
-	case '$':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 10000, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				   "bad --hashlimit-burst `%s'", optarg);
-		r->cfg.burst =3D num;
-		*flags |=3D PARAM_BURST;
-		break;
-	case '&':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-size: `%s'", optarg);
-		r->cfg.size =3D num;
-		*flags |=3D PARAM_SIZE;
-		break;
-	case '*':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-max: `%s'", optarg);
-		r->cfg.max =3D num;
-		*flags |=3D PARAM_MAX;
-		break;
-	case '(':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-gcinterval: `%s'", =

-				optarg);
-		/* FIXME: not HZ dependent!! */
-		r->cfg.gc_interval =3D num;
-		*flags |=3D PARAM_GCINTERVAL;
-		break;
-	case ')':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) =3D=3D -1)
-			exit_error(PARAMETER_PROBLEM,
-				"bad --hashlimit-htable-expire: `%s'", optarg);
-		/* FIXME: not HZ dependent */
-		r->cfg.expire =3D num;
-		*flags |=3D PARAM_EXPIRE;
-		break;
-	case '_':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (parse_mode(r, optarg) < 0)
-			exit_error(PARAMETER_PROBLEM, =

-				   "bad --hashlimit-mode: `%s'\n", optarg);
-		*flags |=3D PARAM_MODE;
-		break;
-	case '"':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (strlen(optarg) =3D=3D 0)
-			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
-		strncpy(r->name, optarg, sizeof(r->name));
-		*flags |=3D PARAM_NAME;
-		break;
-	default:
-		return 0;
-	}
-
-	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "hashlimit does not support invert");
-
-	return 1;
-}
-
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-	if (!(flags & PARAM_LIMIT))
-		exit_error(PARAMETER_PROBLEM,
-				"You have to specify --hashlimit");
-	if (!(flags & PARAM_MODE))
-		exit_error(PARAMETER_PROBLEM,
-				"You have to specify --hashlimit-mode");
-	if (!(flags & PARAM_NAME))
-		exit_error(PARAMETER_PROBLEM,
-				"You have to specify --hashlimit-name");
-}
-
-static struct rates
-{
-	const char *name;
-	u_int32_t mult;
-} rates[] =3D { { "day", IPT_HASHLIMIT_SCALE*24*60*60 },
-	      { "hour", IPT_HASHLIMIT_SCALE*60*60 },
-	      { "min", IPT_HASHLIMIT_SCALE*60 },
-	      { "sec", IPT_HASHLIMIT_SCALE } };
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
-static void print_mode(const struct ipt_hashlimit_info *r, char separa=
tor)
-{
-	int prevmode =3D 0;
-
-	if (r->cfg.mode & IPT_HASHLIMIT_HASH_SIP) {
-		if (prevmode)
-			putchar(separator);
-		fputs("srcip", stdout);
-		prevmode =3D 1;
-	}
-	if (r->cfg.mode & IPT_HASHLIMIT_HASH_SPT) {
-		if (prevmode)
-			putchar(separator);
-		fputs("srcport", stdout);
-		prevmode =3D 1;
-	}
-	if (r->cfg.mode & IPT_HASHLIMIT_HASH_DIP) {
-		if (prevmode)
-			putchar(separator);
-		fputs("dstip", stdout);
-		prevmode =3D 1;
-	}
-	if (r->cfg.mode & IPT_HASHLIMIT_HASH_DPT) {
-		if (prevmode)
-			putchar(separator);
-		fputs("dstport", stdout);
-	}
-	putchar(' ');
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ipt_hashlimit_info *r =3D =

-		(struct ipt_hashlimit_info *)match->data;
-	fputs("limit: avg ", stdout); print_rate(r->cfg.avg);
-	printf("burst %u ", r->cfg.burst);
-	fputs("mode ", stdout);
-	print_mode(r, '-');
-	if (r->cfg.size)
-		printf("htable-size %u ", r->cfg.size);
-	if (r->cfg.max)
-		printf("htable-max %u ", r->cfg.max);
-	if (r->cfg.gc_interval !=3D IPT_HASHLIMIT_GCINTERVAL)
-		printf("htable-gcinterval %u ", r->cfg.gc_interval);
-	if (r->cfg.expire !=3D IPT_HASHLIMIT_EXPIRE)
-		printf("htable-expire %u ", r->cfg.expire);
-}
-
-/* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_hashlimit_info *r =3D =

-		(struct ipt_hashlimit_info *)match->data;
-
-	fputs("--hashlimit ", stdout); print_rate(r->cfg.avg);
-	if (r->cfg.burst !=3D IPT_HASHLIMIT_BURST)
-		printf("--hashlimit-burst %u ", r->cfg.burst);
-
-	fputs("--hashlimit-mode ", stdout);
-	print_mode(r, ',');
-	=

-	printf("--hashlimit-name %s ", r->name);
-
-	if (r->cfg.size)
-		printf("--hashlimit-htable-size %u ", r->cfg.size);
-	if (r->cfg.max)
-		printf("--hashlimit-htable-max %u ", r->cfg.max);
-	if (r->cfg.gc_interval !=3D IPT_HASHLIMIT_GCINTERVAL)
-		printf("--hashlimit-htable-gcinterval %u", r->cfg.gc_interval);
-	if (r->cfg.expire !=3D IPT_HASHLIMIT_EXPIRE)
-		printf("--hashlimit-htable-expire %u ", r->cfg.expire);
-}
-
-static struct iptables_match hashlimit =3D { NULL,
-	.name		=3D "hashlimit",
-	.version	=3D IPTABLES_VERSION,
-	.size		=3D IPT_ALIGN(sizeof(struct ipt_hashlimit_info)),
-	.userspacesize	=3D offsetof(struct ipt_hashlimit_info, hinfo),
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
-	register_match(&hashlimit);
-}
diff --git a/extensions/libip6t_hashlimit.c b/extensions/libxt_hashlimi=
t.c
similarity index 92%
rename from extensions/libip6t_hashlimit.c
rename to extensions/libxt_hashlimit.c
index 9f820fc..442dc0a 100644
--- a/extensions/libip6t_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -15,9 +15,9 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <ip6tables.h>
+#include <xtables.h>
 #include <stddef.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_hashlimit.h>
 =

 #define XT_HASHLIMIT_BURST	5
@@ -96,7 +96,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 =

 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct xt_hashlimit_info *r =3D (struct xt_hashlimit_info *)m->data;
 =

@@ -153,7 +153,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct xt_hashlimit_info *r =3D =

 			(struct xt_hashlimit_info *)(*match)->data;
@@ -305,7 +305,7 @@ static void print_mode(const struct xt_hashlimit_in=
fo *r, char separator)
 /* Prints out the matchinfo. */
 static void
 print(const void *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct xt_hashlimit_info *r =3D =

@@ -325,7 +325,7 @@ print(const void *ip,
 }
 =

 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct ip6t_entry_match *match)=

+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_hashlimit_info *r =3D =

 		(struct xt_hashlimit_info *)match->data;
@@ -349,10 +349,11 @@ static void save(const void *ip, const struct ip6=
t_entry_match *match)
 		printf("--hashlimit-htable-expire %u ", r->cfg.expire);
 }
 =

-static struct ip6tables_match hashlimit =3D { NULL,
+static struct xtables_match hashlimit =3D {
+	.family		=3D AF_INET,
 	.name		=3D "hashlimit",
 	.version	=3D IPTABLES_VERSION,
-	.size		=3D IP6T_ALIGN(sizeof(struct xt_hashlimit_info)),
+	.size		=3D XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	=3D offsetof(struct xt_hashlimit_info, hinfo),
 	.help		=3D &help,
 	.init		=3D &init,
@@ -360,10 +361,26 @@ static struct ip6tables_match hashlimit =3D { NUL=
L,
 	.final_check	=3D &final_check,
 	.print		=3D &print,
 	.save		=3D &save,
-	.extra_opts	=3D opts
+	.extra_opts	=3D opts,
+};
+
+static struct xtables_match hashlimit6 =3D {
+	.family		=3D AF_INET6,
+	.name		=3D "hashlimit",
+	.version	=3D IPTABLES_VERSION,
+	.size		=3D XT_ALIGN(sizeof(struct xt_hashlimit_info)),
+	.userspacesize	=3D offsetof(struct xt_hashlimit_info, hinfo),
+	.help		=3D &help,
+	.init		=3D &init,
+	.parse		=3D &parse,
+	.final_check	=3D &final_check,
+	.print		=3D &print,
+	.save		=3D &save,
+	.extra_opts	=3D opts,
 };
 =

 void _init(void)
 {
-	register_match6(&hashlimit);
+	xtables_register_match(&hashlimit);
+	xtables_register_match(&hashlimit6);
 }
diff --git a/include/linux/netfilter_ipv4/ipt_hashlimit.h b/include/lin=
ux/netfilter/xt_hashlimit.h
similarity index 65%
rename from include/linux/netfilter_ipv4/ipt_hashlimit.h
rename to include/linux/netfilter/xt_hashlimit.h
index ac2cb64..b4556b8 100644
--- a/include/linux/netfilter_ipv4/ipt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -1,18 +1,18 @@
-#ifndef _IPT_HASHLIMIT_H
-#define _IPT_HASHLIMIT_H
+#ifndef _XT_HASHLIMIT_H
+#define _XT_HASHLIMIT_H
 =

 /* timings are in milliseconds. */
-#define IPT_HASHLIMIT_SCALE 10000
+#define XT_HASHLIMIT_SCALE 10000
 /* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 42949=
0
    seconds, or one every 59 hours. */
 =

 /* details of this structure hidden by the implementation */
-struct ipt_hashlimit_htable;
+struct xt_hashlimit_htable;
 =

-#define IPT_HASHLIMIT_HASH_DIP	0x0001
-#define IPT_HASHLIMIT_HASH_DPT	0x0002
-#define IPT_HASHLIMIT_HASH_SIP	0x0004
-#define IPT_HASHLIMIT_HASH_SPT	0x0008
+#define XT_HASHLIMIT_HASH_DIP	0x0001
+#define XT_HASHLIMIT_HASH_DPT	0x0002
+#define XT_HASHLIMIT_HASH_SIP	0x0004
+#define XT_HASHLIMIT_HASH_SPT	0x0008
 =

 struct hashlimit_cfg {
 	u_int32_t mode;	  /* bitmask of IPT_HASHLIMIT_HASH_* */
@@ -26,15 +26,15 @@ struct hashlimit_cfg {
 	u_int32_t expire;	/* when do entries expire? */
 };
 =

-struct ipt_hashlimit_info {
+struct xt_hashlimit_info {
 	char name [IFNAMSIZ];		/* name */
 	struct hashlimit_cfg cfg;
-	struct ipt_hashlimit_htable *hinfo;
+	struct xt_hashlimit_htable *hinfo;
 =

 	/* Used internally by the kernel */
 	union {
 		void *ptr;
-		struct ipt_hashlimit_info *master;
+		struct xt_hashlimit_info *master;
 	} u;
 };
-#endif /*_IPT_HASHLIMIT_H*/
+#endif /*_XT_HASHLIMIT_H*/
-- =

1.5.2.2
