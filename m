From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  libip6t_icmpv6.c
Date: Sun, 07 Sep 2003 14:30:37 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5B794D.2020005@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_5G2I45VjVCDNwglkZz/avg)"
Cc: Netfilter Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_5G2I45VjVCDNwglkZz/avg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   the following patch does:

1- #include <linux/icmpv6.h>
2- C99 initializers,
3- replace numeric ICMP constants with their defines.

I don't understand why ICMPv6 types 133 and up are not defined in 
linux/icmpv6.h.   Are they implemented in the kernel ???

Please apply.

Stephane Ouellette.


--Boundary_(ID_5G2I45VjVCDNwglkZz/avg)
Content-type: text/plain; name=libip6t_icmpv6.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_icmpv6.c.patch

--- netfilter.orig/userspace/extensions/libip6t_icmpv6.c	Wed May 29 09:08:16 2002
+++ netfilter/userspace/extensions/libip6t_icmpv6.c	Sun Sep  7 14:18:47 2003
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <linux/icmpv6.h>
 #include <ip6tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
@@ -14,42 +15,156 @@
 };
 
 static const struct icmpv6_names icmpv6_codes[] = {
-	{ "destination-unreachable", 1, 0, 0xFF },
-	{   "no-route", 1, 0, 0 },
-	{   "communication-prohibited", 1, 1, 1 },
-	{   "address-unreachable", 1, 3, 3 },
-	{   "port-unreachable", 1, 4, 4 },
-
-	{ "packet-too-big", 2, 0, 0xFF },
-
-	{ "time-exceeded", 3, 0, 0xFF },
-	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
-	{   "ttl-zero-during-transit", 3, 0, 0 },
-	{   "ttl-zero-during-reassembly", 3, 1, 1 },
-
-	{ "parameter-problem", 4, 0, 0xFF },
-	{   "bad-header", 4, 0, 0 },
-	{   "unknown-header-type", 4, 1, 1 },
-	{   "unknown-option", 4, 2, 2 },
-
-	{ "echo-request", 128, 0, 0xFF },
-	/* Alias */ { "ping", 128, 0, 0xFF },
-
-	{ "echo-reply", 129, 0, 0xFF },
-	/* Alias */ { "pong", 129, 0, 0xFF },
-
-	{ "router-solicitation", 133, 0, 0xFF },
-
-	{ "router-advertisement", 134, 0, 0xFF },
-
-	{ "neighbour-solicitation", 135, 0, 0xFF },
-	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
-
-	{ "neighbour-advertisement", 136, 0, 0xFF },
-	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
-
-	{ "redirect", 137, 0, 0xFF },
-
+	{
+		.name     = "destination-unreachable",
+		.type     = ICMPV6_DEST_UNREACH,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "no-route",
+		.type     = ICMPV6_DEST_UNREACH,
+		.code_min = ICMPV6_NOROUTE,
+		.code_max = ICMPV6_NOROUTE
+	},
+	{
+		.name     = "communication-prohibited",
+		.type     = ICMPV6_DEST_UNREACH,
+		.code_min = ICMPV6_ADM_PROHIBITED,
+		.code_max = ICMPV6_ADM_PROHIBITED
+	},
+	{
+		.name     = "address-unreachable",
+		.type     = ICMPV6_DEST_UNREACH,
+		.code_min = ICMPV6_ADDR_UNREACH,
+		.code_max = ICMPV6_ADDR_UNREACH
+	},
+	{
+		.name     = "port-unreachable",
+		.type     = ICMPV6_DEST_UNREACH,
+		.code_min = ICMPV6_PORT_UNREACH,
+		.code_max = ICMPV6_PORT_UNREACH
+	},
+	{
+		.name     = "packet-too-big",
+		.type     = ICMPV6_PKT_TOOBIG,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "time-exceeded",
+		.type     = ICMPV6_TIME_EXCEED,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{	/* Alias to time-exceeded */
+		.name     = "ttl-exceeded",
+		.type     = ICMPV6_TIME_EXCEED,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "ttl-zero-during-transit",
+		.type     = ICMPV6_TIME_EXCEED,
+		.code_min = ICMPV6_EXC_HOPLIMIT,
+		.code_max = ICMPV6_EXC_HOPLIMIT
+	},
+	{
+		.name     = "ttl-zero-during-reassembly",
+		.type     = ICMPV6_TIME_EXCEED,
+		.code_min = ICMPV6_EXC_FRAGTIME,
+		.code_max = ICMPV6_EXC_FRAGTIME
+	},
+	{
+		.name     = "parameter-problem",
+		.type     = ICMPV6_PARAMPROB,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "bad-header",
+		.type     = ICMPV6_PARAMPROB,
+		.code_min = ICMPV6_HDR_FIELD,
+		.code_max = ICMPV6_HDR_FIELD
+	},
+	{
+		.name     = "unknown-header-type",
+		.type     = ICMPV6_PARAMPROB,
+		.code_min = ICMPV6_UNK_NEXTHDR,
+		.code_max = ICMPV6_UNK_NEXTHDR
+	},
+	{
+		.name     = "unknown-option",
+		.type     = ICMPV6_PARAMPROB,
+		.code_min = ICMPV6_UNK_OPTION,
+		.code_max = ICMPV6_UNK_OPTION
+	},
+	{
+		.name     = "echo-request",
+		.type     = ICMPV6_ECHO_REQUEST,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{	/* Alias to echo-request */
+		.name     = "ping",
+		.type     = ICMPV6_ECHO_REQUEST,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "echo-reply",
+		.type     = ICMPV6_ECHO_REPLY,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{	/* Alias to echo-reply */
+		.name     = "pong",
+		.type     = ICMPV6_ECHO_REPLY,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "router-solicitation",
+		.type     = 133,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "router-advertisement",
+		.type     = 134,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "neighbour-solicitation",
+		.type     = 135,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{	/* Alias tp neighbour-solicitation */
+		.name     = "neighbor-solicitation",
+		.type     = 135,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "neighbour-advertisement",
+		.type     = 136,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{	/* Alias to neighbour-advertisement */
+		.name     = "neighbor-advertisement",
+		.type     = 136,
+		.code_min = 0,
+		.code_max = 0xFF
+	},
+	{
+		.name     = "redirect",
+		.type     = 137,
+		.code_min = 0,
+		.code_max = 0xFF
+	}
 };
 
 static void
@@ -86,8 +201,8 @@
 }
 
 static struct option opts[] = {
-	{ "icmpv6-type", 1, 0, '1' },
-	{0}
+	{ .name = "icmpv6-type", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = 0 }
 };
 
 static unsigned int
@@ -257,19 +372,18 @@
 {
 }
 
-static struct ip6tables_match icmpv6
-= { NULL,
-    "icmp6",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_icmp)),
-    IP6T_ALIGN(sizeof(struct ip6t_icmp)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+static struct ip6tables_match icmpv6 = {
+	.name          = "icmp6",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_icmp)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_icmp)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_5G2I45VjVCDNwglkZz/avg)--
