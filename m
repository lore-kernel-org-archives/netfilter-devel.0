From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: u32 extension
Date: Mon, 10 Sep 2007 12:28:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>
References: <46E50BE5.80401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46E50BE5.80401@trash.net>
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


On Sep 10 2007 11:18, Patrick McHardy wrote:
>Hi Jan,
>
>I just noticed the u32 extension is missing from iptables.
>Could you send me your latest version please.
>


Adds u32 to iptables.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---

 symlink extensions/libip6t_u32.man -> extensions/libipt_u32.man

 extensions/Makefile              |    2=20
 extensions/libipt_u32.man        |  129 ++++++++++++++++
 extensions/libxt_u32.c           |  307 ++++++++++++++++++++++++++++++++=
+++++++
 include/linux/netfilter/xt_u32.h |   40 +++++
 4 files changed, 477 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=3Dah addrtype conntrack ecn icmp iprange owner policy realm=
 recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP R=
EDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=3Dah dst eui64 frag hbh hl icmp6 ipv6header mh owner polic=
y rt HL LOG REJECT
-PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashl=
imit helper length limit mac mark multiport physdev pkttype quota sctp st=
ate statistic standard string tcp tcpmss udp CLASSIFY CONNMARK DSCP MARK =
NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=3Dconnbytes connmark connlimit comment dccp dscp esp hashl=
imit helper length limit mac mark multiport physdev pkttype quota sctp st=
ate statistic standard string tcp tcpmss u32 udp CLASSIFY CONNMARK DSCP M=
ARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
=20
 PF_EXT_SELINUX_SLIB:=3D
 PF6_EXT_SELINUX_SLIB:=3D
Index: iptables/extensions/libipt_u32.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libipt_u32.man
@@ -0,0 +1,129 @@
+U32 tests whether quantities of up to 4 bytes extracted from a packet ha=
ve
+specified values. The specification of what to extract is general enough=
 to
+find data at given offsets from tcp headers or payloads.
+.TP
+[\fB!\fR]\fB --u32 \fItests\fR
+The argument amounts to a program in a small language described below.
+.IP
+tests :=3D location "=3D" value | tests "&&" location "=3D" value
+.IP
+value :=3D range | value "," range
+.IP
+range :=3D number | number ":" number
+.PP
+a single number, \fIn\fR, is interpreted the same as \fIn:n\fR. \fIn:m\f=
R is
+interpreted as the range of numbers \fB>=3Dn\fR and \fB<=3Dm\fR.
+.IP "" 4
+location :=3D number | location operator number
+.IP "" 4
+operator :=3D "&" | "<<" | ">>" | "@"
+.PP
+The operators \fB&\fR, \fB<<\fR, \fB>>\fR and \fB&&\fR mean the same as =
in C.
+The \fB=3D\fR is really a set membership operator and the value syntax d=
escribes
+a set. The \fB@\fR operator is what allows moving to the next header and=
 is
+described further below.
+.PP
+There are currently some artificial implementation limits on the size of=
 the
+tests:
+.IP "    *"
+no more than 10 of "\fB=3D\fR" (and 9 "\fB&&\fR"s) in the u32 argument
+.IP "    *"
+no more than 10 ranges (and 9 commas) per value
+.IP "    *"
+no more than 10 numbers (and 9 operators) per location
+.PP
+To describe the meaning of location, imagine the following machine that
+interprets it. There are three registers:
+.IP
+A is of type \fBchar *\fR, initially the address of the IP header
+.IP
+B and C are unsigned 32 bit integers, initially zero
+.PP
+The instructions are:
+.IP
+number B =3D number;
+.IP
+C =3D (*(A+B)<<24) + (*(A+B+1)<<16) + (*(A+B+2)<<8) + *(A+B+3)
+.IP
+&number C =3D C & number
+.IP
+<< number C =3D C << number
+.IP
+>> number C =3D C >> number
+.IP
+@number A =3D A + C; then do the instruction number
+.PP
+Any access of memory outside [skb->data,skb->end] causes the match to fa=
il.
+Otherwise the result of the computation is the final value of C.
+.PP
+Whitespace is allowed but not required in the tests. However, the charac=
ters
+that do occur there are likely to require shell quoting, so it is a good=
 idea
+to enclose the arguments in quotes.
+.PP
+Example:
+.IP
+match IP packets with total length >=3D 256
+.IP
+The IP header contains a total length field in bytes 2-3.
+.IP
+--u32 "\fB0 & 0xFFFF =3D 0x100:0xFFFF\fR"
+.IP
+read bytes 0-3
+.IP
+AND that with 0xFFFF (giving bytes 2-3), and test whether that is in the=
 range
+[0x100:0xFFFF]
+.PP
+Example: (more realistic, hence more complicated)
+.IP
+match ICMP packets with icmp type 0
+.IP
+First test that it is an ICMP packet, true iff byte 9 (protocol) =3D 1
+.IP
+--u32 "\fB6 & 0xFF =3D 1 &&\fR ...
+.IP
+read bytes 6-9, use \fB&\fR to throw away bytes 6-8 and compare the resu=
lt to
+1. Next test that it is not a fragment. (If so, it might be part of such=
 a
+packet but we cannot always tell.) N.B.: This test is generally needed i=
f you
+want to match anything beyond the IP header. The last 6 bits of byte 6 a=
nd all
+of byte 7 are 0 iff this is a complete packet (not a fragment). Alternat=
ively,
+you can allow first fragments by only testing the last 5 bits of byte 6.
+.IP
+ ... \fB4 & 0x3FFF =3D 0 &&\fR ...
+.IP
+Last test: the first byte past the IP header (the type) is 0. This is wh=
ere we
+have to use the @syntax. The length of the IP header (IHL) in 32 bit wor=
ds is
+stored in the right half of byte 0 of the IP header itself.
+.IP
+ ... \fB0 >> 22 & 0x3C @ 0 >> 24 =3D 0\fR"
+.IP
+The first 0 means read bytes 0-3, \fB>>22\fR means shift that 22 bits to=
 the
+right. Shifting 24 bits would give the first byte, so only 22 bits is fo=
ur
+times that plus a few more bits. \fB&3C\fR then eliminates the two extra=
 bits
+on the right and the first four bits of the first byte. For instance, if=
 IHL=3D5,
+then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0-1 are=
 (in
+binary) xxxx0101 yyzzzzzz, \fB>>22\fR gives the 10 bit value xxxx0101yy =
and
+\fB&3C\fR gives 010100. \fB@\fR means to use this number as a new offset=
 into
+the packet, and read four bytes starting from there. This is the first 4=
 bytes
+of the ICMP payload, of which byte 0 is the ICMP type. Therefore, we sim=
ply
+shift the value 24 to the right to throw out all but the first byte and =
compare
+the result with 0.
+.PP
+Example:
+.IP
+TCP payload bytes 8-12 is any of 1, 2, 5 or 8
+.IP
+First we test that the packet is a tcp packet (similar to ICMP).
+.IP
+--u32 "\fB6 & 0xFF =3D 6 &&\fR ...
+.IP
+Next, test that it is not a fragment (same as above).
+.IP
+ ... \fB0 >> 22 & 0x3C @ 12 >> 26 & 0x3C @ 8 =3D 1,2,5,8\fR"
+.IP
+\fB0>>22&3C\fR as above computes the number of bytes in the IP header. \=
fB@\fR
+makes this the new offset into the packet, which is the start of the TCP
+header. The length of the TCP header (again in 32 bit words) is the left=
 half
+of byte 12 of the TCP header. The \fB12>>26&3C\fR computes this length i=
n bytes
+(similar to the IP header before). "@" makes this the new offset, which =
is the
+start of the TCP payload. Finally, 8 reads bytes 8-12 of the payload and
+\fB=3D\fR checks whether the result is any of 1, 2, 5 or 8.
Index: iptables/extensions/libxt_u32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/libxt_u32.c
@@ -0,0 +1,307 @@
+/* Shared library add-on to iptables to add u32 matching,
+ * generalized matching on values found at packet offsets
+ *
+ * Detailed doc is in the kernel module source
+ * net/netfilter/xt_u32.c
+ *
+ * (C) 2002 by Don Cohen <don-netf@isis.cs3-inc.com>
+ * Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ * Released under the terms of GNU GPL v2
+ */
+#include <sys/types.h>
+#include <ctype.h>
+#include <errno.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <xtables.h>
+#include "../include/linux/netfilter/xt_u32.h"
+
+static const struct option u32_opts[] =3D {
+	{"u32", 1, NULL, 'u'},
+	{NULL},
+};
+
+static void u32_help(void)
+{
+	printf(
+		"u32 v%s options:\n"
+		"[!] --u32 tests\n"
+		"\t\t""tests :=3D location \"=3D\" value | tests \"&&\" location \"=3D=
\" value\n"
+		"\t\t""value :=3D range | value \",\" range\n"
+		"\t\t""range :=3D number | number \":\" number\n"
+		"\t\t""location :=3D number | location operator number\n"
+		"\t\t""operator :=3D \"&\" | \"<<\" | \">>\" | \"@\"\n",
+		IPTABLES_VERSION);
+	return;
+}
+
+static void u32_dump(const struct xt_u32 *data)
+{
+	const struct xt_u32_test *ct;
+	unsigned int testind, i;
+
+	for (testind =3D 0; testind < data->ntests; ++testind) {
+		ct =3D &data->tests[testind];
+
+		if (testind > 0)
+			printf("&&");
+
+		printf("0x%x", ct->location[0].number);
+		for (i =3D 1; i < ct->nnums; ++i) {
+			switch (ct->location[i].nextop) {
+			case XT_U32_AND:
+				printf("&");
+				break;
+			case XT_U32_LEFTSH:
+				printf("<<");
+				break;
+			case XT_U32_RIGHTSH:
+				printf(">>");
+				break;
+			case XT_U32_AT:
+				printf("@");
+				break;
+			}
+			printf("0x%x", ct->location[i].number);
+		}
+
+		printf("=3D");
+		for (i =3D 0; i < ct->nvalues; ++i) {
+			if (i > 0)
+				printf(",");
+			if (ct->value[i].min =3D=3D ct->value[i].max)
+				printf("0x%x", ct->value[i].min);
+			else
+				printf("0x%x:0x%x", ct->value[i].min,
+				       ct->value[i].max);
+		}
+	}
+	printf(" ");
+}
+
+/* string_to_number() is not quite what we need here ... */
+static u_int32_t parse_number(char **s, int pos)
+{
+	u_int32_t number;
+	char *end;
+
+	errno  =3D 0;
+	number =3D strtoul(*s, &end, 0);
+	if (end =3D=3D *s)
+		exit_error(PARAMETER_PROBLEM,
+			   "u32: at char %d: expected number", pos);
+	if (errno !=3D 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "u32: at char %d: error reading number", pos);
+	*s =3D end;
+	return number;
+}
+
+/* Function which parses command options; returns true if it ate an opti=
on */
+static int u32_parse(int c, char **argv, int invert, unsigned int *flags=
,
+		     const void *entry, struct xt_entry_match **match)
+{
+	struct xt_u32 *data =3D (void *)(*match)->data;
+	unsigned int testind =3D 0, locind =3D 0, valind =3D 0;
+	struct xt_u32_test *ct =3D &data->tests[testind]; /* current test */
+	char *arg =3D argv[optind-1]; /* the argument string */
+	char *start =3D arg;
+	int state =3D 0;
+
+	if (c !=3D 'u')
+		return 0;
+
+	data->invert =3D invert;
+
+	/*
+	 * states:
+	 * 0 =3D looking for numbers and operations,
+	 * 1 =3D looking for ranges
+	 */
+	while (1) {
+		/* read next operand/number or range */
+		while (isspace(*arg))
+			++arg;
+
+		if (*arg =3D=3D '\0') {
+			/* end of argument found */
+			if (state =3D=3D 0)
+				exit_error(PARAMETER_PROBLEM,
+					   "u32: abrupt end of input after location specifier");
+			if (valind =3D=3D 0)
+				exit_error(PARAMETER_PROBLEM,
+					   "u32: test ended with no value specified");
+
+			ct->nnums    =3D locind;
+			ct->nvalues  =3D valind;
+			data->ntests =3D ++testind;
+
+			if (testind > XT_U32_MAXSIZE)
+				exit_error(PARAMETER_PROBLEM,
+				           "u32: at char %u: too many \"&&\"s",
+				           arg - start);
+			return 1;
+		}
+
+		if (state =3D=3D 0) {
+			/*
+			 * reading location: read a number if nothing read yet,
+			 * otherwise either op number or =3D to end location spec
+			 */
+			if (*arg =3D=3D '=3D') {
+				if (locind =3D=3D 0) {
+					exit_error(PARAMETER_PROBLEM,
+					           "u32: at char %u: "
+					           "location spec missing",
+					           arg - start);
+				} else {
+					++arg;
+					state =3D 1;
+				}
+			} else {
+				if (locind !=3D 0) {
+					/* need op before number */
+					if (*arg =3D=3D '&') {
+						ct->location[locind].nextop =3D XT_U32_AND;
+					} else if (*arg =3D=3D '<') {
+						if (*++arg !=3D '<')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %u: a second < expected", arg - start);
+						ct->location[locind].nextop =3D XT_U32_LEFTSH;
+					} else if (*arg =3D=3D '>') {
+						if (*++arg !=3D '>')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %u: a second > expected", arg - start);
+						ct->location[locind].nextop =3D XT_U32_RIGHTSH;
+					} else if (*arg =3D=3D '@') {
+						ct->location[locind].nextop =3D XT_U32_AT;
+					} else {
+						exit_error(PARAMETER_PROBLEM,
+							"u32: at char %u: operator expected", arg - start);
+					}
+					++arg;
+				}
+				/* now a number; string_to_number skips white space? */
+				ct->location[locind].number =3D
+					parse_number(&arg, arg - start);
+				if (++locind > XT_U32_MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %u: too many operators", arg - start);
+			}
+		} else {
+			/*
+			 * state 1 - reading values: read a range if nothing
+			 * read yet, otherwise either ,range or && to end
+			 * test spec
+			 */
+			if (*arg =3D=3D '&') {
+				if (*++arg !=3D '&')
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %u: a second & was expected", arg - start);
+				if (valind =3D=3D 0) {
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %u: value spec missing", arg - start);
+				} else {
+					ct->nnums   =3D locind;
+					ct->nvalues =3D valind;
+					ct =3D &data->tests[++testind];
+					if (testind > XT_U32_MAXSIZE)
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %u: too many \"&&\"s", arg - start);
+					++arg;
+					state  =3D 0;
+					locind =3D 0;
+					valind =3D 0;
+				}
+			} else { /* read value range */
+				if (valind > 0) { /* need , before number */
+					if (*arg !=3D ',')
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %u: expected , or &&", arg - start);
+					++arg;
+				}
+				ct->value[valind].min =3D
+					parse_number(&arg, arg - start);
+
+				while (isspace(*arg))
+					++arg;
+
+				if (*arg =3D=3D ':') {
+					++arg;
+					ct->value[valind].max =3D
+						parse_number(&arg, arg-start);
+				} else {
+					ct->value[valind].max =3D
+						ct->value[valind].min;
+				}
+
+				if (++valind > XT_U32_MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %u: too many \",\"s", arg - start);
+			}
+		}
+	}
+}
+
+static void u32_check(unsigned int flags)
+{
+}
+
+static void u32_print(const void *ip, const struct xt_entry_match *match=
,
+                      int numeric)
+{
+	const struct xt_u32 *data =3D (const void *)match->data;
+	printf("u32 ");
+	if (data->invert)
+		printf("! ");
+	u32_dump(data);
+	return;
+}
+
+static void u32_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_u32 *data =3D (const void *)match->data;
+	if (data->invert)
+		printf("! ");
+	printf("--u32 ");
+	u32_dump(data);
+	return;
+}
+
+static struct xtables_match u32_reg =3D {
+	.name          =3D "u32",
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_u32)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_u32)),
+	.help          =3D u32_help,
+	.parse         =3D u32_parse,
+	.final_check   =3D u32_check,
+	.print         =3D u32_print,
+	.save          =3D u32_save,
+	.extra_opts    =3D u32_opts,
+};
+
+static struct xtables_match u32_reg6 =3D {
+	.name          =3D "u32",
+	.family        =3D AF_INET6,
+	.version       =3D IPTABLES_VERSION,
+	.size          =3D XT_ALIGN(sizeof(struct xt_u32)),
+	.userspacesize =3D XT_ALIGN(sizeof(struct xt_u32)),
+	.help          =3D u32_help,
+	.parse         =3D u32_parse,
+	.final_check   =3D u32_check,
+	.print         =3D u32_print,
+	.save          =3D u32_save,
+	.extra_opts    =3D u32_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&u32_reg);
+	xtables_register_match(&u32_reg6);
+	return;
+}
Index: iptables/include/linux/netfilter/xt_u32.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/include/linux/netfilter/xt_u32.h
@@ -0,0 +1,40 @@
+#ifndef _XT_U32_H
+#define _XT_U32_H 1
+
+enum xt_u32_ops {
+	XT_U32_AND,
+	XT_U32_LEFTSH,
+	XT_U32_RIGHTSH,
+	XT_U32_AT,
+};
+
+struct xt_u32_location_element {
+	u_int32_t number;
+	u_int8_t nextop;
+};
+
+struct xt_u32_value_element {
+	u_int32_t min;
+	u_int32_t max;
+};
+
+/*
+ * Any way to allow for an arbitrary number of elements?
+ * For now, I settle with a limit of 10 each.
+ */
+#define XT_U32_MAXSIZE 10
+
+struct xt_u32_test {
+	struct xt_u32_location_element location[XT_U32_MAXSIZE+1];
+	struct xt_u32_value_element value[XT_U32_MAXSIZE+1];
+	u_int8_t nnums;
+	u_int8_t nvalues;
+};
+
+struct xt_u32 {
+	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
+	u_int8_t ntests;
+	u_int8_t invert;
+};
+
+#endif /* _XT_U32_H */
