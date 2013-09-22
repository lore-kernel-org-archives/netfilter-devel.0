From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 7/7] ipset: Add new userspace set revisions for comment support
Date: Sun, 22 Sep 2013 20:56:36 +0200
Message-ID: <1379876196-46929-7-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55789 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab3IVS7R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:59:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 777ADA0D37
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 19:59:16 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Oc_iGv2-3eDv for <netfilter-devel@vger.kernel.org>;
	Sun, 22 Sep 2013 19:58:47 +0100 (BST)
In-Reply-To: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This introduces new revisions of all hash and bitmap ipsets to
complement the comment functionality introduced into the kernel modules.

Currently all sets have a compile-time limit of 255 characters including
\0. This can otherwise be arbitrarily modified.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 lib/ipset_bitmap_ip.c      | 114 ++++++++++++++++++++++++++
 lib/ipset_bitmap_ipmac.c   | 118 +++++++++++++++++++++++++++
 lib/ipset_bitmap_port.c    | 107 +++++++++++++++++++++++++
 lib/ipset_hash_ip.c        | 138 ++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipport.c    | 161 +++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipportnet.c | 195 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_net.c       | 145 +++++++++++++++++++++++++++++++++
 lib/ipset_hash_netnet.c    |  14 +++-
 lib/ipset_hash_netport.c   | 158 ++++++++++++++++++++++++++++++++++++
 lib/ipset_list_set.c       | 108 +++++++++++++++++++++++++
 src/ipset.8                |  71 +++++++++++------
 11 files changed, 1303 insertions(+), 26 deletions(-)

diff --git a/lib/ipset_bitmap_ip.c b/lib/ipset_bitmap_ip.c
index a4726db..af63c99 100644
--- a/lib/ipset_bitmap_ip.c
+++ b/lib/ipset_bitmap_ip.c
@@ -201,9 +201,123 @@ static struct ipset_type ipset_bitmap_ip1 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg bitmap_ip_create_args2[] = {
+	{ .name = { "range", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_netrange,	.print = ipset_print_ip,
+	},
+	{ .name = { "netmask", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NETMASK,
+	  .parse = ipset_parse_netmask,		.print = ipset_print_number,
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
+	/* Backward compatibility */
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_single_ip,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
+	  .parse = ipset_parse_single_ip,
+	},
+	{ .name = { "network", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_net,
+	},
+	{ },
+};
+
+static const struct ipset_arg bitmap_ip_add_args2[] = {
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
+	{ },
+};
+
+static const char bitmap_ip_usage2[] =
+"create SETNAME bitmap:ip range IP/CIDR|FROM-TO\n"
+"               [netmask CIDR] [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP|IP/CIDR|FROM-TO [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP|IP/CIDR|FROM-TO\n"
+"test   SETNAME IP\n\n"
+"where IP, FROM and TO are IPv4 addresses (or hostnames),\n"
+"      CIDR is a valid IPv4 CIDR prefix.\n";
+
+static struct ipset_type ipset_bitmap_ip2 = {
+	.name = "bitmap:ip",
+	.alias = { "ipmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPV4,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_ip_create_args2,
+		[IPSET_ADD] = bitmap_ip_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_NETMASK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = bitmap_ip_usage2,
+	.description = "comment support",
+};
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_bitmap_ip0);
 	ipset_type_add(&ipset_bitmap_ip1);
+	ipset_type_add(&ipset_bitmap_ip2);
 }
diff --git a/lib/ipset_bitmap_ipmac.c b/lib/ipset_bitmap_ipmac.c
index 67217a9..084f2fc 100644
--- a/lib/ipset_bitmap_ipmac.c
+++ b/lib/ipset_bitmap_ipmac.c
@@ -207,9 +207,127 @@ static struct ipset_type ipset_bitmap_ipmac1 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg bitmap_ipmac_create_args2[] = {
+	{ .name = { "range", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_netrange,	.print = ipset_print_ip,
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
+	/* Backward compatibility */
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_single_ip,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
+	  .parse = ipset_parse_single_ip,
+	},
+	{ .name = { "network", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_net,
+	},
+	{ },
+};
+
+static const struct ipset_arg bitmap_ipmac_add_args2[] = {
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const char bitmap_ipmac_usage2[] =
+"create SETNAME bitmap:ip,mac range IP/CIDR|FROM-TO\n"
+"               [matchunset] [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP[,MAC] [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[,MAC]\n"
+"test   SETNAME IP[,MAC]\n\n"
+"where IP, FROM and TO are IPv4 addresses (or hostnames),\n"
+"      CIDR is a valid IPv4 CIDR prefix,\n"
+"      MAC is a valid MAC address.\n";
+
+static struct ipset_type ipset_bitmap_ipmac2 = {
+	.name = "bitmap:ip,mac",
+	.alias = { "macipmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPV4,
+	.dimension = IPSET_DIM_TWO,
+	.last_elem_optional = true,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_single_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ether,
+			.print = ipset_print_ether,
+			.opt = IPSET_OPT_ETHER
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_ipmac_create_args2,
+		[IPSET_ADD] = bitmap_ipmac_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+	},
+
+	.usage = bitmap_ipmac_usage2,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_bitmap_ipmac0);
 	ipset_type_add(&ipset_bitmap_ipmac1);
+	ipset_type_add(&ipset_bitmap_ipmac2);
 }
diff --git a/lib/ipset_bitmap_port.c b/lib/ipset_bitmap_port.c
index a706d80..26b2023 100644
--- a/lib/ipset_bitmap_port.c
+++ b/lib/ipset_bitmap_port.c
@@ -185,9 +185,116 @@ static struct ipset_type ipset_bitmap_port1 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg bitmap_port_create_args2[] = {
+	{ .name = { "range", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PORT,
+	  .parse = ipset_parse_tcp_udp_port,	.print = ipset_print_port,
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
+	/* Backward compatibility */
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PORT,
+	  .parse = ipset_parse_single_tcp_port,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PORT_TO,
+	  .parse = ipset_parse_single_tcp_port,
+	},
+	{ },
+};
+
+static const struct ipset_arg bitmap_port_add_args2[] = {
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
+	{ },
+};
+
+static const char bitmap_port_usage2[] =
+"create SETNAME bitmap:port range [PROTO:]FROM-TO\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME [PROTO:]PORT|FROM-TO [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME [PROTO:]PORT|FROM-TO\n"
+"test   SETNAME [PROTO:]PORT\n\n"
+"where PORT, FROM and TO are port numbers or port names from /etc/services.\n"
+"PROTO is only needed if a service name is used and it does not exist as a TCP service;\n"
+"it isn't used otherwise with the bitmap.\n";
+
+static struct ipset_type ipset_bitmap_port2 = {
+	.name = "bitmap:port",
+	.alias = { "portmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_UNSPEC,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_tcp_udp_port,
+			.print = ipset_print_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_port_create_args2,
+		[IPSET_ADD] = bitmap_port_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_PORT),
+	},
+
+	.usage = bitmap_port_usage2,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_bitmap_port0);
 	ipset_type_add(&ipset_bitmap_port1);
+	ipset_type_add(&ipset_bitmap_port2);
 }
diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
index 19688db..45185ec 100644
--- a/lib/ipset_hash_ip.c
+++ b/lib/ipset_hash_ip.c
@@ -246,9 +246,147 @@ static struct ipset_type ipset_hash_ip1 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ip_create_args2[] = {
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NETMASK,
+	  .parse = ipset_parse_netmask,		.print = ipset_print_number,
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
+static const struct ipset_arg hash_ip_add_args2[] = {
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
+	{ },
+};
+
+static const char hash_ip_usage2[] =
+"create SETNAME hash:ip\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [netmask CIDR] [timeout VALUE]\n"
+"               [counters] [comment]\n"
+"add    SETNAME IP [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP\n"
+"test   SETNAME IP\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      is supported for IPv4.\n";
+
+static struct ipset_type ipset_hash_ip2 = {
+	.name = "hash:ip",
+	.alias = { "iphash", NULL },
+	.revision = 2,
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
+		[IPSET_CREATE] = hash_ip_create_args2,
+		[IPSET_ADD] = hash_ip_add_args2,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = hash_ip_usage2,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ip0);
 	ipset_type_add(&ipset_hash_ip1);
+	ipset_type_add(&ipset_hash_ip2);
 }
diff --git a/lib/ipset_hash_ipport.c b/lib/ipset_hash_ipport.c
index b1c9f72..c9dc4c1 100644
--- a/lib/ipset_hash_ipport.c
+++ b/lib/ipset_hash_ipport.c
@@ -294,9 +294,170 @@ static struct ipset_type ipset_hash_ipport2 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipport_create_args3[] = {
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
+	/* Backward compatibility */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "network", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_ipport_add_args3[] = {
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
+	{ },
+};
+
+static const char hash_ipport_usage3[] =
+"create SETNAME hash:ip,port\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP,PROTO:PORT [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP,PROTO:PORT\n"
+"test   SETNAME IP,PROTO:PORT\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname).\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      is supported for IPv4.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_ipport3 = {
+	.name = "hash:ip,port",
+	.alias = { "ipporthash", NULL },
+	.revision = 3,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipport_create_args3,
+		[IPSET_ADD] = hash_ipport_add_args3,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+	},
+
+	.usage = hash_ipport_usage3,
+	.usagefn = ipset_port_usage,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ipport1);
 	ipset_type_add(&ipset_hash_ipport2);
+	ipset_type_add(&ipset_hash_ipport3);
 }
diff --git a/lib/ipset_hash_ipportnet.c b/lib/ipset_hash_ipportnet.c
index 2c2e014..4baabe5 100644
--- a/lib/ipset_hash_ipportnet.c
+++ b/lib/ipset_hash_ipportnet.c
@@ -544,6 +544,200 @@ static struct ipset_type ipset_hash_ipportnet4 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipportnet_create_args5[] = {
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
+	/* Backward compatibility */
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "from", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "to", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
+	  .parse = ipset_parse_ignored,
+	},
+	{ .name = { "network", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
+	  .parse = ipset_parse_ignored,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_ipportnet_add_args5[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
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
+	{ },
+};
+
+static const struct ipset_arg hash_ipportnet_test_args5[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_ipportnet_usage5[] =
+"create SETNAME hash:ip,port,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP,PROTO:PORT,IP[/CIDR] [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP,PROTO:PORT,IP[/CIDR]\n"
+"test   SETNAME IP,PROTO:PORT,IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP are valid IPv4 or IPv6 addresses (or hostnames),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      in both IP components are supported for IPv4.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_ipportnet5 = {
+	.name = "hash:ip,port,net",
+	.alias = { "ipportnethash", NULL },
+	.revision = 5,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_THREE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+		[IPSET_DIM_THREE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipportnet_create_args5,
+		[IPSET_ADD] = hash_ipportnet_add_args5,
+		[IPSET_TEST] = hash_ipportnet_test_args5,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_ipportnet_usage5,
+	.usagefn = ipset_port_usage,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -551,4 +745,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_ipportnet2);
 	ipset_type_add(&ipset_hash_ipportnet3);
 	ipset_type_add(&ipset_hash_ipportnet4);
+	ipset_type_add(&ipset_hash_ipportnet5);
 }
diff --git a/lib/ipset_hash_net.c b/lib/ipset_hash_net.c
index a80d732..99ffc1f 100644
--- a/lib/ipset_hash_net.c
+++ b/lib/ipset_hash_net.c
@@ -366,6 +366,150 @@ static struct ipset_type ipset_hash_net3 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_net_create_args4[] = {
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
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "counters", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	/* Ignored options: backward compatibilty */
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "probes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ .name = { "resize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
+	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_net_add_args4[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
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
+	{ },
+};
+
+static const struct ipset_arg hash_net_test_args4[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_net_usage4[] =
+"create SETNAME hash:net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_net4 = {
+	.name = "hash:net",
+	.alias = { "nethash", NULL },
+	.revision = 4,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_net_create_args4,
+		[IPSET_ADD] = hash_net_add_args4,
+		[IPSET_TEST] = hash_net_test_args4,
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
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_net_usage4,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -373,4 +517,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_net1);
 	ipset_type_add(&ipset_hash_net2);
 	ipset_type_add(&ipset_hash_net3);
+	ipset_type_add(&ipset_hash_net4);
 }
diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
index ea65c8f..0e617af 100644
--- a/lib/ipset_hash_netnet.c
+++ b/lib/ipset_hash_netnet.c
@@ -42,6 +42,10 @@ static const struct ipset_arg hash_netnet_create_args0[] = {
 	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
 	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
 	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
 	{ },
 };
 
@@ -62,6 +66,10 @@ static const struct ipset_arg hash_netnet_add_args0[] = {
 	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
 	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
 	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_ADT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
 	{ },
 };
 
@@ -123,7 +131,8 @@ static struct ipset_type ipset_hash_netnet0 = {
 		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
 			| IPSET_FLAG(IPSET_OPT_MAXELEM)
 			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
-			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
 		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
 			| IPSET_FLAG(IPSET_OPT_CIDR)
 			| IPSET_FLAG(IPSET_OPT_IP_TO)
@@ -133,7 +142,8 @@ static struct ipset_type ipset_hash_netnet0 = {
 			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
 			| IPSET_FLAG(IPSET_OPT_NOMATCH)
 			| IPSET_FLAG(IPSET_OPT_PACKETS)
-			| IPSET_FLAG(IPSET_OPT_BYTES),
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
 		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
 			| IPSET_FLAG(IPSET_OPT_CIDR)
 			| IPSET_FLAG(IPSET_OPT_IP_TO)
diff --git a/lib/ipset_hash_netport.c b/lib/ipset_hash_netport.c
index 2b26cf2..3a41456 100644
--- a/lib/ipset_hash_netport.c
+++ b/lib/ipset_hash_netport.c
@@ -437,6 +437,163 @@ static struct ipset_type ipset_hash_netport4 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netport_create_args5[] = {
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
+	{ },
+};
+
+static const struct ipset_arg hash_netport_add_args5[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
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
+	{ },
+};
+
+static const struct ipset_arg hash_netport_test_args5[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_netport_usage5[] =
+"create SETNAME hash:net,port\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO,PROTO:PORT [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO,PROTO:PORT\n"
+"test   SETNAME IP[/CIDR],PROTO:PORT\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements with IPv4 is supported.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_netport5 = {
+	.name = "hash:net,port",
+	.alias = { "netporthash", NULL },
+	.revision = 5,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netport_create_args5,
+		[IPSET_ADD] = hash_netport_add_args5,
+		[IPSET_TEST] = hash_netport_test_args5,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netport_usage5,
+	.usagefn = ipset_port_usage,
+	.description = "comment support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -444,4 +601,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netport2);
 	ipset_type_add(&ipset_hash_netport3);
 	ipset_type_add(&ipset_hash_netport4);
+	ipset_type_add(&ipset_hash_netport5);
 }
diff --git a/lib/ipset_list_set.c b/lib/ipset_list_set.c
index 6cec67c..9da3204 100644
--- a/lib/ipset_list_set.c
+++ b/lib/ipset_list_set.c
@@ -189,9 +189,117 @@ static struct ipset_type ipset_list_set1 = {
 	.description = "counters support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg list_set_create_args2[] = {
+	{ .name = { "size", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
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
+	{ },
+};
+
+static const struct ipset_arg list_set_adt_args2[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "before", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NAMEREF,
+	  .parse = ipset_parse_before,
+	},
+	{ .name = { "after", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NAMEREF,
+	  .parse = ipset_parse_after,
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
+	{ },
+};
+
+static const char list_set_usage2[] =
+"create SETNAME list:set\n"
+"               [size VALUE] [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME NAME [before|after NAME] [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment STRING]\n"
+"del    SETNAME NAME [before|after NAME]\n"
+"test   SETNAME NAME [before|after NAME]\n\n"
+"where NAME are existing set names.\n";
+
+static struct ipset_type ipset_list_set2 = {
+	.name = "list:set",
+	.alias = { "setlist", NULL },
+	.revision = 2,
+	.family = NFPROTO_UNSPEC,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_setname,
+			.print = ipset_print_name,
+			.opt = IPSET_OPT_NAME
+		},
+	},
+	.compat_parse_elem = ipset_parse_name_compat,
+	.args = {
+		[IPSET_CREATE] = list_set_create_args2,
+		[IPSET_ADD] = list_set_adt_args2,
+		[IPSET_DEL] = list_set_adt_args2,
+		[IPSET_TEST] = list_set_adt_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_NAME),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_NAME),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_NAME),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_SIZE)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_NAME)
+			| IPSET_FLAG(IPSET_OPT_BEFORE)
+			| IPSET_FLAG(IPSET_OPT_NAMEREF)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_NAME)
+			| IPSET_FLAG(IPSET_OPT_BEFORE)
+			| IPSET_FLAG(IPSET_OPT_NAMEREF),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_NAME)
+			| IPSET_FLAG(IPSET_OPT_BEFORE)
+			| IPSET_FLAG(IPSET_OPT_NAMEREF),
+	},
+
+	.usage = list_set_usage2,
+	.description = "comment support",
+};
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_list_set0);
 	ipset_type_add(&ipset_list_set1);
+	ipset_type_add(&ipset_list_set2);
 }
diff --git a/src/ipset.8 b/src/ipset.8
index b53e94d..20fb4d4 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -304,17 +304,40 @@ ipset create foo hash:ip counters
 .IP 
 ipset add foo 192.168.1.1 packets 42 bytes 1024
 .PP 
+.SS comment
+All set types support the optional \fBcomment\fR extension.
+Enabling this extension on an ipset enables you to annotate an ipset entry with
+an arbitrary string. This string is completely ignored by both the kernel and ipset
+itself and is purely for providing a convenient means to document the reason for an
+entry's existence. Comments must not contain any quotation marks and the usual escape
+character (\\) has no meaning. For example, the following shell command is illegal:
+.IP
+ipset add foo 1.1.1.1 comment "this comment is \\"bad\\""
+.PP
+In the above, your shell will of course escape the quotation marks and ipset will see
+the quote marks in the argument for the comment, which will result in a parse error.
+If you are writing your own system, you should avoid creating comments containing a
+quotation mark if you do not want to break "ipset save" and "ipset restore",
+nonetheless, the kernel will not stop you from doing so. The following is perfectly
+acceptable:
+.IP
+ipset create foo hash:ip comment
+.IP
+ipset add foo 192.168.1.1/24 comment "allow access to SMB share on \\\\\\\\fileserv\\\\"
+.IP
+the above would appear as: "allow access to SMB share on \\\\fileserv\\"
+.PP
 .SH "SET TYPES"
 .SS bitmap:ip
 The \fBbitmap:ip\fR set type uses a memory range to store either IPv4 host
 (default) or IPv4 network addresses. A \fBbitmap:ip\fR type of set can store up
 to 65536 entries.
 .PP 
-\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromip\fP\-\fItoip\fR|\fIip\fR/\fIcidr\fR [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromip\fP\-\fItoip\fR|\fIip\fR/\fIcidr\fR [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := { \fIip\fR | \fIfromip\fR\-\fItoip\fR | \fIip\fR/\fIcidr\fR }
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := { \fIip\fR | \fIfromip\fR\-\fItoip\fR | \fIip\fR/\fIcidr\fR }
 .PP 
@@ -349,11 +372,11 @@ ipset test foo 192.168.1.1
 .SS bitmap:ip,mac
 The \fBbitmap:ip,mac\fR set type uses a memory range to store IPv4 and a MAC address pairs. A \fBbitmap:ip,mac\fR type of set can store up to 65536 entries.
 .PP 
-\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromip\fP\-\fItoip\fR|\fIip\fR/\fIcidr\fR [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromip\fP\-\fItoip\fR|\fIip\fR/\fIcidr\fR [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIip\fR[,\fImacaddr\fR]
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIip\fR[,\fImacaddr\fR]
 .PP 
@@ -389,11 +412,11 @@ ipset test foo 192.168.1.1
 The \fBbitmap:port\fR set type uses a memory range to store port numbers
 and such a set can store up to 65536 ports.
 .PP 
-\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromport\fP\-\fItoport [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := \fBrange\fP \fIfromport\fP\-\fItoport [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := { \fI[proto:]port\fR | \fI[proto:]fromport\fR\-\fItoport\fR }
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := { \fI[proto:]port\fR | \fI[proto:]fromport\fR\-\fItoport\fR }
 .PP 
@@ -424,11 +447,11 @@ The \fBhash:ip\fR set type uses a hash to store IP host addresses (default) or
 network addresses. Zero valued IP address cannot be stored in a \fBhash:ip\fR
 type of set.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIipaddr\fR
 .PP 
@@ -471,11 +494,11 @@ ipset test foo 192.168.1.2
 The \fBhash:net\fR set type uses a hash to store different sized IP network addresses.
 Network address with zero prefix size cannot be stored in this type of sets.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fInetaddr\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fInetaddr\fR
 .PP 
@@ -541,11 +564,11 @@ over the second, so a nomatch entry could be potentially be ineffective if a mor
 first parameter existed with a suitable second parameter.
 Network address with zero prefix size cannot be stored in this type of set.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
 .PP
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP
 \fIDEL\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
 .PP
@@ -613,11 +636,11 @@ The \fBhash:ip,port\fR set type uses a hash to store IP address and port number
 The port number is interpreted together with a protocol (default TCP) and zero
 protocol number cannot be used.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP 
@@ -689,11 +712,11 @@ address and port pairs. The port number is interpreted together with a protocol
 (default TCP) and zero protocol number cannot be used. Network
 address with zero prefix size is not accepted either.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fInetaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fInetaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP 
@@ -753,11 +776,11 @@ The \fBhash:ip,port,ip\fR set type uses a hash to store IP address, port number
 and a second IP address triples. The port number is interpreted together with a
 protocol (default TCP) and zero protocol number cannot be used.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fIip\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fIip\fR
 .PP 
@@ -799,11 +822,11 @@ and IP network address triples. The port number is interpreted together with a
 protocol (default TCP) and zero protocol number cannot be used. Network
 address with zero prefix size cannot be stored either.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fInetaddr\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fInetaddr\fR
 .PP 
@@ -859,11 +882,11 @@ ipset test foo 192.168.1,80.10.0.0/24
 The \fBhash:net,iface\fR set type uses a hash to store different sized IP network
 address and interface name pairs.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fInetaddr\fR,[\fBphysdev\fR:]\fIiface\fR
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fInetaddr\fR,[\fBphysdev\fR:]\fIiface\fR
 .PP 
@@ -930,11 +953,11 @@ ipset test foo 192.168.0/24,eth0
 The \fBlist:set\fR type uses a simple list in which you can store
 set names.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBsize\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBsize\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP 
 \fIADD\-ENTRY\fR := \fIsetname\fR [ { \fBbefore\fR | \fBafter\fR } \fIsetname\fR ]
 .PP 
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
 .PP 
 \fIDEL\-ENTRY\fR := \fIsetname\fR [ { \fBbefore\fR | \fBafter\fR } \fIsetname\fR ]
 .PP 
-- 
1.8.3.2

