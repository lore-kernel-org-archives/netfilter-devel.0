From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 6/6] ipset: Add new userspace set revisions for comment support
Date: Tue, 17 Sep 2013 15:13:25 +0200
Message-ID: <1379423605-22777-7-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60546 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3IQNPv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:15:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 43839A32BB
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 14:15:50 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id vA_f5v3Drwsn for <netfilter-devel@vger.kernel.org>;
	Tue, 17 Sep 2013 14:15:10 +0100 (BST)
In-Reply-To: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
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
 9 files changed, 1148 insertions(+), 2 deletions(-)

diff --git a/lib/ipset_bitmap_ip.c b/lib/ipset_bitmap_ip.c
index a4726db..3b58661 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const char bitmap_ip_usage2[] =
+"create SETNAME bitmap:ip range IP/CIDR|FROM-TO\n"
+"               [netmask CIDR] [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = bitmap_ip_usage2,
+	.description = "comments support",
+};
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_bitmap_ip0);
 	ipset_type_add(&ipset_bitmap_ip1);
+	ipset_type_add(&ipset_bitmap_ip2);
 }
diff --git a/lib/ipset_bitmap_ipmac.c b/lib/ipset_bitmap_ipmac.c
index 67217a9..34f9b24 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+"               [matchunset] [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+	},
+
+	.usage = bitmap_ipmac_usage2,
+	.description = "comments support",
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
index a706d80..f42a3d2 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const char bitmap_port_usage2[] =
+"create SETNAME bitmap:port range [PROTO:]FROM-TO\n"
+"               [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_PORT),
+	},
+
+	.usage = bitmap_port_usage2,
+	.description = "comments support",
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
index 19688db..d910d1f 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
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
+"               [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = hash_ip_usage2,
+	.description = "comments support",
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
index b1c9f72..61848d5 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const char hash_ipport_usage3[] =
+"create SETNAME hash:ip,port\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
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
+	.description = "comments support",
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
index 2c2e014..0ea1f96 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
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
+"               [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
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
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
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
+	.description = "comments support",
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
index a80d732..0b13304 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
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
+"               [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_net_usage4,
+	.description = "comments support",
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
index 5cc5a40..fff7909 100644
--- a/lib/ipset_hash_netnet.c
+++ b/lib/ipset_hash_netnet.c
@@ -42,6 +42,10 @@ static const struct ipset_arg hash_netnet_create_args0[] = {
 	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
 	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
 	},
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
 	{ },
 };
 
@@ -62,6 +66,10 @@ static const struct ipset_arg hash_netnet_add_args0[] = {
 	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
 	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
 	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
 		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
 			| IPSET_FLAG(IPSET_OPT_CIDR)
 			| IPSET_FLAG(IPSET_OPT_IP_TO)
@@ -133,7 +142,8 @@ static struct ipset_type ipset_hash_netnet0 = {
 			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
 			| IPSET_FLAG(IPSET_OPT_NOMATCH)
 			| IPSET_FLAG(IPSET_OPT_PACKETS)
-			| IPSET_FLAG(IPSET_OPT_BYTES),
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
 		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
 			| IPSET_FLAG(IPSET_OPT_CIDR)
 			| IPSET_FLAG(IPSET_OPT_IP_TO)
diff --git a/lib/ipset_hash_netport.c b/lib/ipset_hash_netport.c
index 2b26cf2..a9fe4eb 100644
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
+	{ .name = { "comments", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COMMENTS,
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
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_COMMENT,
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
+"               [timeout VALUE] [counters] [comments]\n"
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
+			| IPSET_FLAG(IPSET_OPT_COMMENTS),
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
+			| IPSET_FLAG(IPSET_OPT_COMMENT),
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
+	.description = "comments support",
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
-- 
1.8.3.2


