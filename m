From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/5] ipset: hash:ip: add support for new netmask types
Date: Tue, 21 Mar 2017 14:39:54 -0400
Message-ID: <1490121597-2140-3-git-send-email-johunt@akamai.com>
References: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([23.79.238.175]:36231 "EHLO
        prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933305AbdCUSus (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:50:48 -0400
In-Reply-To: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Uses new netmask support added in previous commit to allow user to
specify cidr, netmask, or wildcard mask as arguments to the netmask
parameter at creation time.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 lib/ipset_hash_ip.c | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)

diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
index 2bff34f..36afc59 100644
--- a/lib/ipset_hash_ip.c
+++ b/lib/ipset_hash_ip.c
@@ -669,6 +669,171 @@ static struct ipset_type ipset_hash_ip4 = {
 	.description = "skbinfo support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ip_create_args5[] = {
+	{ .name = { "family", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,		.print = ipset_print_family,
+	},
+	/* Alias: family inet */
+	{ .name = { "-4", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	/* Alias: family inet6 */
+	{ .name = { "-6", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	{ .name = { "hashsize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "maxelem", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "netmask", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NETMASK_MASK,
+	  .parse = ipset_parse_netmask,		.print = ipset_print_netmask,
+	},
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "counters", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "forceadd", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FORCEADD,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "skbinfo", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_SKBINFO,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	/* Ignored options: backward compatibilty */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "gc", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_GC,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_ip_add_args5[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "packets", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "bytes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_ADT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ .name = { "skbmark", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBMARK,
+	  .parse = ipset_parse_skbmark,		.print = ipset_print_skbmark,
+	},
+	{ .name = { "skbprio", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBPRIO,
+	  .parse = ipset_parse_skbprio,		.print = ipset_print_skbprio,
+	},
+	{ .name = { "skbqueue", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBQUEUE,
+	  .parse = ipset_parse_uint16,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+
+static const char hash_ip_usage5[] =
+"create SETNAME hash:ip\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [netmask CIDR or MASK] [timeout VALUE]\n"
+"               [counters] [comment] [forceadd] [skbinfo]\n"
+"add    SETNAME IP [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"		[skbmark VALUE] [skbprio VALUE] [skbqueue VALUE]\n"
+"del    SETNAME IP\n"
+"test   SETNAME IP\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      is supported for IPv4.\n";
+
+static struct ipset_type ipset_hash_ip5 = {
+	.name = "hash:ip",
+	.alias = { "iphash", NULL },
+	.revision = 5,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ip_create_args5,
+		[IPSET_ADD] = hash_ip_add_args5,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_NETMASK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD)
+			| IPSET_FLAG(IPSET_OPT_SKBINFO)
+			| IPSET_FLAG(IPSET_OPT_NETMASK_MASK),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_SKBMARK)
+			| IPSET_FLAG(IPSET_OPT_SKBPRIO)
+			| IPSET_FLAG(IPSET_OPT_SKBQUEUE),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = hash_ip_usage5,
+	.description = "netmask wildcardmask support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -677,4 +842,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_ip2);
 	ipset_type_add(&ipset_hash_ip3);
 	ipset_type_add(&ipset_hash_ip4);
+	ipset_type_add(&ipset_hash_ip5);
 }
-- 
1.9.1

