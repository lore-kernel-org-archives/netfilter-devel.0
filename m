From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] u32 match ported to 2.6 and ipv6
Date: Tue, 12 Apr 2005 16:25:34 +0000
Message-ID: <425BF67E.4040903@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080601080408010402050604"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	Anatoly Pugachev <mator@rootshell.ru>, Pablo Neira <pablo@eurodev.net>
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
--------------080601080408010402050604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Here goes, it compiles, haven't tested it. :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCW/Z8xyF48ZTvn+4RAuvoAKDQSX9BA5jPd1ezjt4nY+fIy1mDeACaAxco
/Ux4xJlDPrVpQ9KQHQN34HM=
=wZ42
-----END PGP SIGNATURE-----

--------------080601080408010402050604
Content-Type: text/x-patch;
 name="u32-2.6-ipv6-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="u32-2.6-ipv6-1.patch"

Index: pom-all/u32/iptables.patch
===================================================================
--- pom-all/u32/iptables.patch	(revision 0)
+++ pom-all/u32/iptables.patch	(revision 0)
@@ -0,0 +1,239 @@
+diff -Np -ur orig-iptables-1.3.1/extensions/libipt_u32.c iptables-1.3.1/extensions/libipt_u32.c
+--- orig-iptables-1.3.1/extensions/libipt_u32.c	2005-03-26 17:32:11.000000000 +0200
++++ iptables-1.3.1/extensions/libipt_u32.c	2005-04-12 19:11:37.000000000 +0300
+@@ -8,222 +8,19 @@
+  * Released under the terms of GNU GPL v2
+  */
+ #include <stdio.h>
+-#include <netdb.h>
+-#include <string.h>
+-#include <stdlib.h>
+-#include <getopt.h>
+ #include <iptables.h>
+ #include <linux/netfilter_ipv4/ipt_u32.h>
+-#include <errno.h>
+-#include <ctype.h>
+ 
+-/* Function which prints out usage message. */
+-static void
+-help(void)
+-{
+-	printf( "u32 v%s options:\n"
+-		" --u32 tests\n"
+-		" tests := location = value | tests && location = value\n"
+-		" value := range | value , range\n"
+-		" range := number | number : number\n"
+-		" location := number | location operator number\n"
+-		" operator := & | << | >> | @\n"
+-		,IPTABLES_VERSION);
+-}
+-
+-/* defined in /usr/include/getopt.h maybe in man getopt */
+-static struct option opts[] = {
+-	{ "u32", 1, 0, '1' },
+-	{ 0 }
+-};
+-
+-/* shared printing code */
+-static void print_u32(struct ipt_u32 *data)
+-{
+-	unsigned int testind;
+-
+-	for (testind=0; testind < data->ntests; testind++) {
+-		if (testind) printf("&&");
+-		{
+-			unsigned int i;
+-
+-			printf("0x%x", data->tests[testind].location[0].number);
+-			for (i = 1; i < data->tests[testind].nnums; i++) {
+-				switch (data->tests[testind].location[i].nextop) {
+-				case IPT_U32_AND: printf("&"); break;
+-				case IPT_U32_LEFTSH: printf("<<"); break;
+-				case IPT_U32_RIGHTSH: printf(">>"); break;
+-				case IPT_U32_AT: printf("@"); break;
+-				}
+-				printf("0x%x", data->tests[testind].location[i].number);
+-			}
+-			printf("=");
+-			for (i = 0; i < data->tests[testind].nvalues; i++) {
+-				if (i) printf(",");
+-				if (data->tests[testind].value[i].min
+-				    == data->tests[testind].value[i].max)
+-					printf("0x%x", data->tests[testind].value[i].min);
+-				else printf("0x%x:0x%x", data->tests[testind].value[i].min,
+-					    data->tests[testind].value[i].max);
+-			}
+-		}
+-	}
+-	printf(" ");
+-}
++#include "libipt_u32_helper.c"
+ 
+-/* string_to_number is not quite what we need here ... */
+-u_int32_t parse_number(char **s, int pos)
+-{
+-	u_int32_t number;
+-	char *end;
+-	errno = 0;
+-
+-	number = strtoul(*s, &end, 0);
+-	if (end == *s)
+-		exit_error(PARAMETER_PROBLEM, 
+-			   "u32: at char %d expected number", pos);
+-	if (errno)
+-		exit_error(PARAMETER_PROBLEM, 
+-			   "u32: at char %d error reading number", pos);
+-	*s = end;
+-	return number;
+-}
+-
+-/* Function which parses command options; returns true if it ate an option */
+ static int
+-parse(int c, char **argv, int invert, unsigned int *flags,
++parse_v4(int c, char **argv, int invert, unsigned int *flags,
+       const struct ipt_entry *entry,
+       unsigned int *nfcache,
+       struct ipt_entry_match **match)
+ {
+-	struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
+-	char *arg = argv[optind-1]; /* the argument string */
+-	char *start = arg;
+-	int state=0, testind=0, locind=0, valind=0;
+-
+-	if (c != '1') return 0;
+-	/* states: 0 = looking for numbers and operations, 1 = looking for ranges */
+-	while (1) { /* read next operand/number or range */
+-		while (isspace(*arg)) 
+-			arg++;  /* skip white space */
+-		if (! *arg) { /* end of argument found */
+-			if (state == 0)
+-				exit_error(PARAMETER_PROBLEM, 
+-					   "u32: input ended in location spec");
+-			if (valind == 0)
+-				exit_error(PARAMETER_PROBLEM, 
+-					   "u32: test ended with no value spec");
+-			data->tests[testind].nnums = locind;
+-			data->tests[testind].nvalues = valind;
+-			testind++;
+-			data->ntests=testind;
+-			if (testind > U32MAXSIZE)
+-				exit_error(PARAMETER_PROBLEM, 
+-					   "u32: at char %d too many &&'s",
+-					   arg-start);
+-			/* debugging 
+-			   print_u32(data);printf("\n");
+-			   exit_error(PARAMETER_PROBLEM, "debugging output done"); */
+-			return 1;
+-		}
+-		if (state == 0) {
+-			/* reading location: read a number if nothing read yet,
+-			   otherwise either op number or = to end location spec */	 
+-			if (*arg == '=') {
+-				if (locind == 0)
+-					exit_error(PARAMETER_PROBLEM,
+-						   "u32: at char %d location spec missing", arg-start);
+-				else {
+-					arg++; 
+-					state=1;
+-				}
+-			}
+-			else {
+-				if (locind) { /* need op before number */
+-					if (*arg == '&') {
+-						data->tests[testind].location[locind].nextop = IPT_U32_AND;
+-					}
+-					else if (*arg == '<') {
+-						arg++;
+-						if (*arg != '<')
+-							exit_error(PARAMETER_PROBLEM,
+-								   "u32: at char %d a second < expected", arg-start);
+-						data->tests[testind].location[locind].nextop = IPT_U32_LEFTSH;
+-					}
+-					else if (*arg == '>') {
+-						arg++;
+-						if (*arg != '>')
+-							exit_error(PARAMETER_PROBLEM,
+-								   "u32: at char %d a second > expected", arg-start);
+-						data->tests[testind].location[locind].nextop = IPT_U32_RIGHTSH;
+-					}
+-					else if (*arg == '@') {
+-						data->tests[testind].location[locind].nextop = IPT_U32_AT;
+-					}
+-					else exit_error(PARAMETER_PROBLEM,
+-							"u32: at char %d operator expected", arg-start);
+-					arg++;
+-				}
+-				/* now a number; string_to_number skips white space? */
+-				data->tests[testind].location[locind].number =
+-					parse_number(&arg, arg-start);
+-				locind++;
+-				if (locind > U32MAXSIZE)
+-					exit_error(PARAMETER_PROBLEM,
+-						   "u32: at char %d too many operators", arg-start);
+-			}
+-		}
+-		else {
+-			/* state 1 - reading values: read a range if nothing read yet,
+-			   otherwise either ,range or && to end test spec */
+-			if (*arg == '&') {
+-				arg++;
+-				if (*arg != '&')
+-					exit_error(PARAMETER_PROBLEM,
+-						   "u32: at char %d a second & expected", arg-start);
+-				if (valind == 0)
+-					exit_error(PARAMETER_PROBLEM,
+-						   "u32: at char %d value spec missing", arg-start);
+-				else {
+-					data->tests[testind].nnums = locind;
+-					data->tests[testind].nvalues = valind;
+-					testind++;
+-					if (testind > U32MAXSIZE)
+-						exit_error(PARAMETER_PROBLEM,
+-							   "u32: at char %d too many &&'s", arg-start);
+-					arg++; state=0; locind=0; valind=0;
+-				}
+-			}
+-			else { /* read value range */
+-				if (valind) { /* need , before number */
+-					if (*arg != ',')
+-						exit_error(PARAMETER_PROBLEM,
+-							   "u32: at char %d expected , or &&", arg-start);
+-					arg++;
+-				}
+-				data->tests[testind].value[valind].min = parse_number(&arg, arg-start);
+-				while (isspace(*arg)) 
+-					arg++;  /* another place white space could be */
+-				if (*arg==':') {
+-					arg++;
+-					data->tests[testind].value[valind].max
+-						= parse_number(&arg, arg-start);
+-				}
+-				else data->tests[testind].value[valind].max
+-					     = data->tests[testind].value[valind].min;
+-				valind++;
+-				if (valind > U32MAXSIZE)
+-					exit_error(PARAMETER_PROBLEM,
+-						   "u32: at char %d too many ,'s", arg-start);
+-			}
+-		}
+-	}
+-}
+-
+-/* Final check; must specify something. */
+-static void
+-final_check(unsigned int flags)
+-{
++   struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
++   return parse(c, argv, data);
+ }
+ 
+ /* Prints out the matchinfo. */
+@@ -250,7 +47,7 @@
+ 	.size		= IPT_ALIGN(sizeof(struct ipt_u32)),
+ 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_u32)),
+ 	.help		= &help,
+-	.parse		= &parse,
++	.parse		= &parse_v4,
+ 	.final_check	= &final_check,
+ 	.print		= &print,
+ 	.save		= &save,
Index: pom-all/u32/linux-2.6/include/linux/netfilter_ipv4/ipt_u32.h
===================================================================
--- pom-all/u32/linux-2.6/include/linux/netfilter_ipv4/ipt_u32.h	(revision 0)
+++ pom-all/u32/linux-2.6/include/linux/netfilter_ipv4/ipt_u32.h	(revision 0)
@@ -0,0 +1,40 @@
+#ifndef _IPT_U32_H
+#define _IPT_U32_H
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+enum ipt_u32_ops
+{
+	IPT_U32_AND,
+	IPT_U32_LEFTSH,
+	IPT_U32_RIGHTSH,
+	IPT_U32_AT
+};
+
+struct ipt_u32_location_element
+{
+	u_int32_t number;
+	u_int8_t nextop;
+};
+struct ipt_u32_value_element
+{
+	u_int32_t min;
+	u_int32_t max;
+};
+/* *** any way to allow for an arbitrary number of elements?
+   for now I settle for a limit of 10 of each */
+#define U32MAXSIZE 10
+struct ipt_u32_test
+{
+	u_int8_t nnums;
+	struct ipt_u32_location_element location[U32MAXSIZE+1];
+	u_int8_t nvalues;
+	struct ipt_u32_value_element value[U32MAXSIZE+1];
+};
+
+struct ipt_u32
+{
+	u_int8_t ntests;
+	struct ipt_u32_test tests[U32MAXSIZE+1];
+};
+
+#endif /*_IPT_U32_H*/
Index: pom-all/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd
===================================================================
--- pom-all/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv4/netfilter/Makefile.ladd	(revision 0)
@@ -0,0 +1,4 @@
+obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o
+
+obj-$(CONFIG_IP_NF_MATCH_U32) += ipt_u32.o
+
Index: pom-all/u32/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
===================================================================
--- pom-all/u32/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	(revision 0)
@@ -0,0 +1,12 @@
+config IP_NF_MATCH_U32
+	tristate  'U32 match support'
+	depends on IP_NF_IPTABLES
+	help
+	  U32 allows you to extract quantities of up to 4 bytes from a packet,
+	  AND them with specified masks, shift them by specified amounts and
+	  test whether the results are in any of a set of specified ranges.
+	  The specification of what to extract is general enough to skip over
+	  headers with lengths stored in the packet, as in IP or TCP header
+	  lengths.
+	
+	  Details and examples are in the kernel module source.
Index: pom-all/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c
===================================================================
--- pom-all/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(revision 0)
@@ -0,0 +1,215 @@
+/* Kernel module to match u32 packet content. */
+
+/* 
+U32 tests whether quantities of up to 4 bytes extracted from a packet 
+have specified values.  The specification of what to extract is general 
+enough to find data at given offsets from tcp headers or payloads.
+
+ --u32 tests
+ The argument amounts to a program in a small language described below.
+ tests := location = value |  tests && location = value
+ value := range | value , range
+ range := number | number : number
+  a single number, n, is interpreted the same as n:n
+  n:m is interpreted as the range of numbers >=n and <=m
+ location := number | location operator number
+ operator := & | << | >> | @
+
+ The operators &, <<, >>, && mean the same as in c.  The = is really a set
+ membership operator and the value syntax describes a set.  The @ operator
+ is what allows moving to the next header and is described further below.
+
+ *** Until I can find out how to avoid it, there are some artificial limits
+ on the size of the tests:
+ - no more than 10 ='s (and 9 &&'s) in the u32 argument
+ - no more than 10 ranges (and 9 commas) per value
+ - no more than 10 numbers (and 9 operators) per location
+
+ To describe the meaning of location, imagine the following machine that
+ interprets it.  There are three registers:
+  A is of type char*, initially the address of the IP header
+  B and C are unsigned 32 bit integers, initially zero
+
+  The instructions are:
+   number	B = number;
+   		C = (*(A+B)<<24)+(*(A+B+1)<<16)+(*(A+B+2)<<8)+*(A+B+3)
+   &number	C = C&number
+   <<number	C = C<<number
+   >>number	C = C>>number
+   @number	A = A+C; then do the instruction number
+  Any access of memory outside [skb->head,skb->end] causes the match to fail.
+  Otherwise the result of the computation is the final value of C.
+
+ Whitespace is allowed but not required in the tests.
+ However the characters that do occur there are likely to require
+ shell quoting, so it's a good idea to enclose the arguments in quotes.
+
+Example:
+ match IP packets with total length >= 256
+ The IP header contains a total length field in bytes 2-3.
+ --u32 "0&0xFFFF=0x100:0xFFFF" 
+ read bytes 0-3
+ AND that with FFFF (giving bytes 2-3),
+ and test whether that's in the range [0x100:0xFFFF]
+
+Example: (more realistic, hence more complicated)
+ match icmp packets with icmp type 0
+ First test that it's an icmp packet, true iff byte 9 (protocol) = 1
+ --u32 "6&0xFF=1 && ...
+ read bytes 6-9, use & to throw away bytes 6-8 and compare the result to 1
+ Next test that it's not a fragment.
+  (If so it might be part of such a packet but we can't always tell.)
+  n.b. This test is generally needed if you want to match anything
+  beyond the IP header.
+ The last 6 bits of byte 6 and all of byte 7 are 0 iff this is a complete
+ packet (not a fragment).  Alternatively, you can allow first fragments
+ by only testing the last 5 bits of byte 6.
+ ... 4&0x3FFF=0 && ...
+ Last test: the first byte past the IP header (the type) is 0
+ This is where we have to use the @syntax.  The length of the IP header
+ (IHL) in 32 bit words is stored in the right half of byte 0 of the
+ IP header itself.
+ ... 0>>22&0x3C@0>>24=0"
+ The first 0 means read bytes 0-3,
+ >>22 means shift that 22 bits to the right.  Shifting 24 bits would give
+   the first byte, so only 22 bits is four times that plus a few more bits.
+ &3C then eliminates the two extra bits on the right and the first four 
+ bits of the first byte.
+ For instance, if IHL=5 then the IP header is 20 (4 x 5) bytes long.
+ In this case bytes 0-1 are (in binary) xxxx0101 yyzzzzzz, 
+ >>22 gives the 10 bit value xxxx0101yy and &3C gives 010100.
+ @ means to use this number as a new offset into the packet, and read
+ four bytes starting from there.  This is the first 4 bytes of the icmp
+ payload, of which byte 0 is the icmp type.  Therefore we simply shift
+ the value 24 to the right to throw out all but the first byte and compare
+ the result with 0.
+
+Example: 
+ tcp payload bytes 8-12 is any of 1, 2, 5 or 8
+ First we test that the packet is a tcp packet (similar to icmp).
+ --u32 "6&0xFF=6 && ...
+ Next, test that it's not a fragment (same as above).
+ ... 0>>22&0x3C@12>>26&0x3C@8=1,2,5,8"
+ 0>>22&3C as above computes the number of bytes in the IP header.
+ @ makes this the new offset into the packet, which is the start of the
+ tcp header.  The length of the tcp header (again in 32 bit words) is
+ the left half of byte 12 of the tcp header.  The 12>>26&3C
+ computes this length in bytes (similar to the IP header before).
+ @ makes this the new offset, which is the start of the tcp payload.
+ Finally 8 reads bytes 8-12 of the payload and = checks whether the
+ result is any of 1, 2, 5 or 8
+*/
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv4/ipt_u32.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+/* #include <asm-i386/timex.h> for timing */
+
+MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
+MODULE_DESCRIPTION("IP tables u32 matching module");
+MODULE_LICENSE("GPL");
+
+int
+ipt_u32_match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_u32 *data = matchinfo;
+	int testind, i;
+	unsigned char* origbase = (char*)skb->nh.iph;
+	unsigned char* base = origbase;
+	unsigned char* head = skb->head;
+	unsigned char* end = skb->end;
+	int nnums, nvals;
+	u_int32_t pos, val;
+	/* unsigned long long cycles1, cycles2, cycles3, cycles4;
+	   cycles1 = get_cycles(); */
+
+	for (testind=0; testind < data->ntests; testind++) {
+		base = origbase; /* reset for each test */
+		pos = data->tests[testind].location[0].number;
+		if (base+pos+3 > end || base+pos < head) 
+			return 0;
+		val = (base[pos]<<24) + (base[pos+1]<<16) +
+			(base[pos+2]<<8) + base[pos+3];
+		nnums = data->tests[testind].nnums;
+		for (i=1; i < nnums; i++) {
+			u_int32_t number = data->tests[testind].location[i].number;
+			switch (data->tests[testind].location[i].nextop) {
+			case IPT_U32_AND: 
+				val = val & number; 
+				break;
+			case IPT_U32_LEFTSH: 
+				val = val << number;
+				break;
+			case IPT_U32_RIGHTSH: 
+				val = val >> number; 
+				break;
+			case IPT_U32_AT:
+				base = base + val;
+				pos = number;
+				if (base+pos+3 > end || base+pos < head) 
+					return 0;
+				val = (base[pos]<<24) + (base[pos+1]<<16) +
+					(base[pos+2]<<8) + base[pos+3];
+				break;
+			}
+		}
+		nvals = data->tests[testind].nvalues;
+		for (i=0; i < nvals; i++) {
+			if ((data->tests[testind].value[i].min <= val) &&
+			    (val <= data->tests[testind].value[i].max))	{
+				break;
+			}
+		}
+		if (i >= data->tests[testind].nvalues) {
+			/* cycles2 = get_cycles(); 
+			   printk("failed %d in %d cycles\n", testind, 
+				  cycles2-cycles1); */
+			return 0;
+		}
+	}
+	/* cycles2 = get_cycles();
+	   printk("succeeded in %d cycles\n", cycles2-cycles1); */
+	return 1;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_u32)))
+		return 0;
+	return 1;
+}
+
+static struct ipt_match u32_match = {
+	.name		= "u32",
+	.match		= &ipt_u32_match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+   
+static int __init init(void)
+{
+	return ipt_register_match(&u32_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&u32_match);
+}
+
+module_init(init);
+module_exit(fini);
+
+EXPORT_SYMBOL(ipt_u32_match);
Index: pom-all/u32/linux-2.6/net/ipv6/netfilter/Makefile.ladd
===================================================================
--- pom-all/u32/linux-2.6/net/ipv6/netfilter/Makefile.ladd	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv6/netfilter/Makefile.ladd	(revision 0)
@@ -0,0 +1,4 @@
+obj-$(CONFIG_IP6_NF_MATCH_LENGTH) += ip6t_length.o
+
+obj-$(CONFIG_IP6_NF_MATCH_U32) += ip6t_u32.o
+
Index: pom-all/u32/linux-2.6/net/ipv6/netfilter/Kconfig.ladd
===================================================================
--- pom-all/u32/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv6/netfilter/Kconfig.ladd	(revision 0)
@@ -0,0 +1,15 @@
+config IP6_NF_MATCH_U32
+	tristate  'U32 match support'
+	depends on IP6_NF_IPTABLES && IP_NF_MATCH_U32
+	help
+	  U32 allows you to extract quantities of up to 4 bytes from a packet,
+	  AND them with specified masks, shift them by specified amounts and
+	  test whether the results are in any of a set of specified ranges.
+	  The specification of what to extract is general enough to skip over
+	  headers with lengths stored in the packet, as in IP or TCP header
+	  lengths.
+
+	  Note: This requires the on the ipv4 equivalent of the u32
+		match to be enabled.
+	
+	  Details and examples are in the kernel module ipv4 source.
Index: pom-all/u32/linux-2.6/net/ipv6/netfilter/ip6t_u32.c
===================================================================
--- pom-all/u32/linux-2.6/net/ipv6/netfilter/ip6t_u32.c	(revision 0)
+++ pom-all/u32/linux-2.6/net/ipv6/netfilter/ip6t_u32.c	(revision 0)
@@ -0,0 +1,64 @@
+/* Kernel module to match u32 packet content. */
+
+/* See ipt_u32.c for more info */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv4/ipt_u32.h>
+
+MODULE_AUTHOR("Jonas Berlin <xkr47@outerspace.dyndns.org>");
+MODULE_DESCRIPTION("ip6tables u32 matching module");
+MODULE_LICENSE("GPL");
+
+// from ipt_u32.c
+int
+ipt_u32_match(const struct sk_buff *skb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      const void *matchinfo,
+	      int offset,
+	      int *hotdrop);
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	return ipt_u32_match(skb, in, out, matchinfo, offset, hotdrop);
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ip6t_ip6 *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	if (matchsize != IP6T_ALIGN(sizeof(struct ipt_u32)))
+		return 0;
+	return 1;
+}
+
+static struct ip6t_match u32_match = {
+	.name		= "u32",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ip6t_register_match(&u32_match);
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_match(&u32_match);
+}
+
+module_init(init);
+module_exit(fini);
Index: pom-all/u32/iptables/extensions/libip6t_u32.c
===================================================================
--- pom-all/u32/iptables/extensions/libip6t_u32.c	(revision 0)
+++ pom-all/u32/iptables/extensions/libip6t_u32.c	(revision 0)
@@ -0,0 +1,61 @@
+/* Shared library add-on to ip6tables to add u32 matching,
+ * generalized matching on values found at packet offsets
+ *
+ * Detailed doc is in the kernel module source
+ * net/ipv4/netfilter/ipt_u32.c
+ *
+ * (C) 2002 by Don Cohen <don-netf@isis.cs3-inc.com>
+ * Released under the terms of GNU GPL v2
+ */
+#include <stdio.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv4/ipt_u32.h>
+
+#include "libipt_u32_helper.c"
+
+static int
+parse_v6(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+   struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
+   return parse(c, argv, data);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	printf("u32 ");
+	print_u32((struct ipt_u32 *)match->data);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	printf("--u32 ");
+	print_u32((struct ipt_u32 *)match->data);
+}
+
+struct ip6tables_match u32 = {
+	.next		= NULL,
+	.name		= "u32",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ipt_u32)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ipt_u32)),
+	.help		= &help,
+	.parse		= &parse_v6,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	register_match6(&u32);
+}
Index: pom-all/u32/iptables/extensions/.u32-test6
===================================================================
--- pom-all/u32/iptables/extensions/.u32-test6	(revision 0)
+++ pom-all/u32/iptables/extensions/.u32-test6	(revision 0)
@@ -0,0 +1,4 @@
+#!/bin/sh
+# True if u32 is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_u32.h -a \
+  -f $KERNEL_DIR/net/ipv6/netfilter/ip6t_u32.c ] && echo u32
Index: pom-all/u32/iptables/extensions/libip6t_u32.man
===================================================================
--- pom-all/u32/iptables/extensions/libip6t_u32.man	(revision 0)
+++ pom-all/u32/iptables/extensions/libip6t_u32.man	(revision 0)
@@ -0,0 +1,8 @@
+U32 allows you to extract quantities of up to 4 bytes from a packet,
+AND them with specified masks, shift them by specified amounts and
+test whether the results are in any of a set of specified ranges.
+The specification of what to extract is general enough to skip over
+headers with lengths stored in the packet, as in IP or TCP header
+lengths.
+
+Details and examples are in the kernel module source.
Index: pom-all/u32/iptables/extensions/libipt_u32_helper.c
===================================================================
--- pom-all/u32/iptables/extensions/libipt_u32_helper.c	(revision 0)
+++ pom-all/u32/iptables/extensions/libipt_u32_helper.c	(revision 0)
@@ -0,0 +1,213 @@
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <errno.h>
+#include <ctype.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf( "u32 v%s options:\n"
+		" --u32 tests\n"
+		" tests := location = value | tests && location = value\n"
+		" value := range | value , range\n"
+		" range := number | number : number\n"
+		" location := number | location operator number\n"
+		" operator := & | << | >> | @\n"
+		,IPTABLES_VERSION);
+}
+
+/* defined in /usr/include/getopt.h maybe in man getopt */
+static struct option opts[] = {
+	{ "u32", 1, 0, '1' },
+	{ 0 }
+};
+
+/* shared printing code */
+static void print_u32(struct ipt_u32 *data)
+{
+	unsigned int testind;
+
+	for (testind=0; testind < data->ntests; testind++) {
+		if (testind) printf("&&");
+		{
+			unsigned int i;
+
+			printf("0x%x", data->tests[testind].location[0].number);
+			for (i = 1; i < data->tests[testind].nnums; i++) {
+				switch (data->tests[testind].location[i].nextop) {
+				case IPT_U32_AND: printf("&"); break;
+				case IPT_U32_LEFTSH: printf("<<"); break;
+				case IPT_U32_RIGHTSH: printf(">>"); break;
+				case IPT_U32_AT: printf("@"); break;
+				}
+				printf("0x%x", data->tests[testind].location[i].number);
+			}
+			printf("=");
+			for (i = 0; i < data->tests[testind].nvalues; i++) {
+				if (i) printf(",");
+				if (data->tests[testind].value[i].min
+				    == data->tests[testind].value[i].max)
+					printf("0x%x", data->tests[testind].value[i].min);
+				else printf("0x%x:0x%x", data->tests[testind].value[i].min,
+					    data->tests[testind].value[i].max);
+			}
+		}
+	}
+	printf(" ");
+}
+
+/* string_to_number is not quite what we need here ... */
+u_int32_t parse_number(char **s, int pos)
+{
+	u_int32_t number;
+	char *end;
+	errno = 0;
+
+	number = strtoul(*s, &end, 0);
+	if (end == *s)
+		exit_error(PARAMETER_PROBLEM, 
+			   "u32: at char %d expected number", pos);
+	if (errno)
+		exit_error(PARAMETER_PROBLEM, 
+			   "u32: at char %d error reading number", pos);
+	*s = end;
+	return number;
+}
+
+
+/* Function which parses command options; returns true if it ate an option */
+static int
+parse(int c, char **argv, struct ipt_u32 *data)
+{
+	char *arg = argv[optind-1]; /* the argument string */
+	char *start = arg;
+	int state=0, testind=0, locind=0, valind=0;
+
+	if (c != '1') return 0;
+	/* states: 0 = looking for numbers and operations, 1 = looking for ranges */
+	while (1) { /* read next operand/number or range */
+		while (isspace(*arg)) 
+			arg++;  /* skip white space */
+		if (! *arg) { /* end of argument found */
+			if (state == 0)
+				exit_error(PARAMETER_PROBLEM, 
+					   "u32: input ended in location spec");
+			if (valind == 0)
+				exit_error(PARAMETER_PROBLEM, 
+					   "u32: test ended with no value spec");
+			data->tests[testind].nnums = locind;
+			data->tests[testind].nvalues = valind;
+			testind++;
+			data->ntests=testind;
+			if (testind > U32MAXSIZE)
+				exit_error(PARAMETER_PROBLEM, 
+					   "u32: at char %zd too many &&'s",
+					   arg-start);
+			/* debugging 
+			   print_u32(data);printf("\n");
+			   exit_error(PARAMETER_PROBLEM, "debugging output done"); */
+			return 1;
+		}
+		if (state == 0) {
+			/* reading location: read a number if nothing read yet,
+			   otherwise either op number or = to end location spec */	 
+			if (*arg == '=') {
+				if (locind == 0)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %zd location spec missing", arg-start);
+				else {
+					arg++; 
+					state=1;
+				}
+			}
+			else {
+				if (locind) { /* need op before number */
+					if (*arg == '&') {
+						data->tests[testind].location[locind].nextop = IPT_U32_AND;
+					}
+					else if (*arg == '<') {
+						arg++;
+						if (*arg != '<')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %zd a second < expected", arg-start);
+						data->tests[testind].location[locind].nextop = IPT_U32_LEFTSH;
+					}
+					else if (*arg == '>') {
+						arg++;
+						if (*arg != '>')
+							exit_error(PARAMETER_PROBLEM,
+								   "u32: at char %zd a second > expected", arg-start);
+						data->tests[testind].location[locind].nextop = IPT_U32_RIGHTSH;
+					}
+					else if (*arg == '@') {
+						data->tests[testind].location[locind].nextop = IPT_U32_AT;
+					}
+					else exit_error(PARAMETER_PROBLEM,
+							"u32: at char %zd operator expected", arg-start);
+					arg++;
+				}
+				/* now a number; string_to_number skips white space? */
+				data->tests[testind].location[locind].number =
+					parse_number(&arg, arg-start);
+				locind++;
+				if (locind > U32MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %zd too many operators", arg-start);
+			}
+		}
+		else {
+			/* state 1 - reading values: read a range if nothing read yet,
+			   otherwise either ,range or && to end test spec */
+			if (*arg == '&') {
+				arg++;
+				if (*arg != '&')
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %zd a second & expected", arg-start);
+				if (valind == 0)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %zd value spec missing", arg-start);
+				else {
+					data->tests[testind].nnums = locind;
+					data->tests[testind].nvalues = valind;
+					testind++;
+					if (testind > U32MAXSIZE)
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %zd too many &&'s", arg-start);
+					arg++; state=0; locind=0; valind=0;
+				}
+			}
+			else { /* read value range */
+				if (valind) { /* need , before number */
+					if (*arg != ',')
+						exit_error(PARAMETER_PROBLEM,
+							   "u32: at char %zd expected , or &&", arg-start);
+					arg++;
+				}
+				data->tests[testind].value[valind].min = parse_number(&arg, arg-start);
+				while (isspace(*arg)) 
+					arg++;  /* another place white space could be */
+				if (*arg==':') {
+					arg++;
+					data->tests[testind].value[valind].max
+						= parse_number(&arg, arg-start);
+				}
+				else data->tests[testind].value[valind].max
+					     = data->tests[testind].value[valind].min;
+				valind++;
+				if (valind > U32MAXSIZE)
+					exit_error(PARAMETER_PROBLEM,
+						   "u32: at char %zd too many ,'s", arg-start);
+			}
+		}
+	}
+}
+
+/* Final check; must specify something. */
+static void
+final_check(unsigned int flags)
+{
+}
+
Index: pom-all/u32/info
===================================================================
--- pom-all/u32/info	(revision 3858)
+++ pom-all/u32/info	(working copy)
@@ -2,4 +2,3 @@
 Author: Don Cohen <don@isis.cs3-inc.com>
 Status: Tested locally, seems to work.
 Repository: base
-Requires: linux < 2.6.0

--------------080601080408010402050604--
