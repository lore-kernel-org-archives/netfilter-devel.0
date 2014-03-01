From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v3 2/2] ipset: add userspace support for forceadd
Date: Fri, 28 Feb 2014 22:14:58 -0500
Message-ID: <1393643698-6603-3-git-send-email-johunt@akamai.com>
References: <1393643698-6603-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:64828 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbaCADPB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:15:01 -0500
In-Reply-To: <1393643698-6603-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The userspace side of the forceadd changes.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 Make_global.am                  |    2 +-
 include/libipset/data.h         |    4 +-
 include/libipset/linux_ip_set.h |    7 +-
 lib/data.c                      |    5 ++
 lib/ipset_hash_ip.c             |  123 ++++++++++++++++++++++++++++
 lib/ipset_hash_ipmark.c         |  142 ++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipport.c         |  147 ++++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipportip.c       |  158 ++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipportnet.c      |  169 +++++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_net.c            |  119 +++++++++++++++++++++++++++
 lib/ipset_hash_netiface.c       |  125 +++++++++++++++++++++++++++++
 lib/ipset_hash_netnet.c         |  125 +++++++++++++++++++++++++++++
 lib/ipset_hash_netport.c        |  132 ++++++++++++++++++++++++++++++
 lib/ipset_hash_netportnet.c     |  149 ++++++++++++++++++++++++++++++++++
 src/ipset.8                     |    7 ++
 15 files changed, 1410 insertions(+), 4 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index f931618..a5b5788 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface. 
 
 #            curr:rev:age
-LIBVERSION = 5:0:3
+LIBVERSION = 6:0:4
 
 AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
 	-I/usr/local/include
diff --git a/include/libipset/data.h b/include/libipset/data.h
index 3a26b1e..06ece1e 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -36,6 +36,7 @@ enum ipset_opt {
 	IPSET_OPT_PROBES,
 	IPSET_OPT_RESIZE,
 	IPSET_OPT_SIZE,
+	IPSET_OPT_FORCEADD,
 	/* Create-specific options, filled out by the kernel */
 	IPSET_OPT_ELEMENTS,
 	IPSET_OPT_REFERENCES,
@@ -94,7 +95,8 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_RESIZE)	\
 	| IPSET_FLAG(IPSET_OPT_SIZE)	\
 	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
-	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT))
+	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)\
+	| IPSET_FLAG(IPSET_OPT_FORCEADD))
 
 #define IPSET_ADT_FLAGS			\
 	(IPSET_FLAG(IPSET_OPT_IP)	\
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index b8cc493..7272b2b 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -186,13 +186,16 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
 	IPSET_FLAG_BIT_WITH_COMMENT = 4,
 	IPSET_FLAG_WITH_COMMENT = (1 << IPSET_FLAG_BIT_WITH_COMMENT),
+	IPSET_FLAG_BIT_WITH_FORCEADD = 5,
+	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
 /* The flag bits which correspond to the non-extension create flags */
 enum ipset_create_flags {
-	IPSET_CREATE_FLAG_NONE = 0,
-	IPSET_CREATE_FLAG_MAX = 7,
+	IPSET_CREATE_FLAG_BIT_FORCEADD = 0,
+	IPSET_CREATE_FLAG_FORCEADD = (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
+	IPSET_CREATE_FLAG_BIT_MAX = 7,
 };
 
 /* Commands with settype-specific attributes */
diff --git a/lib/data.c b/lib/data.c
index 48ec98a..e9f417c 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -309,6 +309,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_CREATE_COMMENT:
 		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_COMMENT);
 		break;
+        case IPSET_OPT_FORCEADD:
+		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_FORCEADD);
+		break;
 	/* Create-specific options, filled out by the kernel */
 	case IPSET_OPT_ELEMENTS:
 		data->create.elements = *(const uint32_t *) value;
@@ -529,6 +532,7 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
 	case IPSET_OPT_CREATE_COMMENT:
+	case IPSET_OPT_FORCEADD:
 		return &data->cadt_flags;
 	default:
 		return NULL;
@@ -590,6 +594,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_PHYSDEV:
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
+	case IPSET_OPT_FORCEADD:
 		return sizeof(uint32_t);
 	case IPSET_OPT_ADT_COMMENT:
 		return IPSET_MAX_COMMENT_SIZE + 1;
diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
index 45185ec..70f297f 100644
--- a/lib/ipset_hash_ip.c
+++ b/lib/ipset_hash_ip.c
@@ -383,10 +383,133 @@ static struct ipset_type ipset_hash_ip2 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ip_create_args3[] = {
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
+	{ .name = { "forceadd", NULL },
+	  .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+	  .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
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
+static const char hash_ip_usage3[] =
+"create SETNAME hash:ip\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [netmask CIDR] [timeout VALUE]\n"
+"               [counters] [comment] [forceadd]\n"
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
+static struct ipset_type ipset_hash_ip3 = {
+	.name = "hash:ip",
+	.alias = { "iphash", NULL },
+	.revision = 3,
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
+		[IPSET_CREATE] = hash_ip_create_args3,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+	.usage = hash_ip_usage3,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ip0);
 	ipset_type_add(&ipset_hash_ip1);
 	ipset_type_add(&ipset_hash_ip2);
+	ipset_type_add(&ipset_hash_ip3);
 }
diff --git a/lib/ipset_hash_ipmark.c b/lib/ipset_hash_ipmark.c
index 922e6c0..e96e51b 100644
--- a/lib/ipset_hash_ipmark.c
+++ b/lib/ipset_hash_ipmark.c
@@ -166,8 +166,150 @@ static struct ipset_type ipset_hash_ipmark0 = {
 	.description = "initial revision",
 };
 
+static const struct ipset_arg hash_ipmark_create_args1[] = {
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
+	{ .name = { "markmask", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MARKMASK,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_mark,
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
+	{ .name = { "forceadd", NULL },
+	  .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+	  .parse = ipset_parse_flag,	        .print = ipset_print_flag,
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
+static const char hash_ipmark_usage1[] =
+"create SETNAME hash:ip,mark\n"
+"		[family inet|inet6] [markmask VALUE]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
+"add    SETNAME IP,MARK [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP,MARK\n"
+"test   SETNAME IP,MARK\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname).\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      is supported for IPv4.\n"
+"      Adding/deleting single mark element\n"
+"      is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_ipmark1 = {
+	.name = "hash:ip,mark",
+	.alias = { "ipmarkhash", NULL },
+	.revision = 1,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_mark,
+			.print = ipset_print_mark,
+			.opt = IPSET_OPT_MARK
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipmark_create_args1,
+		[IPSET_ADD] = hash_ipmark_add_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_MARKMASK)
+			| IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_MARK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_MARK),
+	},
+
+	.usage = hash_ipmark_usage1,
+	.description = "forceadd support"
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ipmark0);
+	ipset_type_add(&ipset_hash_ipmark1);
 }
diff --git a/lib/ipset_hash_ipport.c b/lib/ipset_hash_ipport.c
index c9dc4c1..5741cc6 100644
--- a/lib/ipset_hash_ipport.c
+++ b/lib/ipset_hash_ipport.c
@@ -454,10 +454,157 @@ static struct ipset_type ipset_hash_ipport3 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipport_create_args4[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
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
+static const char hash_ipport_usage4[] =
+"create SETNAME hash:ip,port\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
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
+static struct ipset_type ipset_hash_ipport4 = {
+	.name = "hash:ip,port",
+	.alias = { "ipporthash", NULL },
+	.revision = 4,
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
+		[IPSET_CREATE] = hash_ipport_create_args4,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+	.usage = hash_ipport_usage4,
+	.usagefn = ipset_port_usage,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ipport1);
 	ipset_type_add(&ipset_hash_ipport2);
 	ipset_type_add(&ipset_hash_ipport3);
+	ipset_type_add(&ipset_hash_ipport4);
 }
diff --git a/lib/ipset_hash_ipportip.c b/lib/ipset_hash_ipportip.c
index 9ae4f2d..d5c7e83 100644
--- a/lib/ipset_hash_ipportip.c
+++ b/lib/ipset_hash_ipportip.c
@@ -487,10 +487,168 @@ static struct ipset_type ipset_hash_ipportip3 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipportip_create_args4[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
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
+static const char hash_ipportip_usage4[] =
+"create SETNAME hash:ip,port,ip\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
+"add    SETNAME IP,PROTO:PORT,IP [timeout VALUE]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP,PROTO:PORT,IP\n"
+"test   SETNAME IP,PROTO:PORT,IP\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname).\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      in the first IP component is supported for IPv4.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_ipportip4 = {
+	.name = "hash:ip,port,ip",
+	.alias = { "ipportiphash", NULL },
+	.revision = 4,
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
+			.parse = ipset_parse_single_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipportip_create_args4,
+		[IPSET_ADD] = hash_ipportip_add_args3,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+
+	.usage = hash_ipportip_usage4,
+	.usagefn = ipset_port_usage,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_ipportip1);
 	ipset_type_add(&ipset_hash_ipportip2);
 	ipset_type_add(&ipset_hash_ipportip3);
+	ipset_type_add(&ipset_hash_ipportip4);
 }
diff --git a/lib/ipset_hash_ipportnet.c b/lib/ipset_hash_ipportnet.c
index 4baabe5..857bdea 100644
--- a/lib/ipset_hash_ipportnet.c
+++ b/lib/ipset_hash_ipportnet.c
@@ -738,6 +738,174 @@ static struct ipset_type ipset_hash_ipportnet5 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_ipportnet_create_args6[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
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
+static const char hash_ipportnet_usage6[] =
+"create SETNAME hash:ip,port,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
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
+static struct ipset_type ipset_hash_ipportnet6 = {
+	.name = "hash:ip,port,net",
+	.alias = { "ipportnethash", NULL },
+	.revision = 6,
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
+		[IPSET_CREATE] = hash_ipportnet_create_args6,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+	.usage = hash_ipportnet_usage6,
+	.usagefn = ipset_port_usage,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -746,4 +914,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_ipportnet3);
 	ipset_type_add(&ipset_hash_ipportnet4);
 	ipset_type_add(&ipset_hash_ipportnet5);
+	ipset_type_add(&ipset_hash_ipportnet6);
 }
diff --git a/lib/ipset_hash_net.c b/lib/ipset_hash_net.c
index 01da722..32b8315 100644
--- a/lib/ipset_hash_net.c
+++ b/lib/ipset_hash_net.c
@@ -510,6 +510,124 @@ static struct ipset_type ipset_hash_net4 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_net_create_args5[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
+	/* Ignored options: backward compatibilty */
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
+static const char hash_net_usage5[] =
+"create SETNAME hash:net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_net5 = {
+	.name = "hash:net",
+	.alias = { "nethash", NULL },
+	.revision = 5,
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
+		[IPSET_CREATE] = hash_net_create_args5,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+	.usage = hash_net_usage5,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -518,4 +636,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_net2);
 	ipset_type_add(&ipset_hash_net3);
 	ipset_type_add(&ipset_hash_net4);
+	ipset_type_add(&ipset_hash_net5);
 }
diff --git a/lib/ipset_hash_netiface.c b/lib/ipset_hash_netiface.c
index ed59a91..bac8326 100644
--- a/lib/ipset_hash_netiface.c
+++ b/lib/ipset_hash_netiface.c
@@ -550,6 +550,130 @@ static struct ipset_type ipset_hash_netiface4 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netiface_create_args5[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
+	{ },
+};
+
+static const char hash_netiface_usage5[] =
+"create SETNAME hash:net,iface\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO,[physdev:]IFACE [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO,[physdev:]IFACE\n"
+"test   SETNAME IP[/CIDR],[physdev:]IFACE\n\n"
+"where depending on the INET family\n"
+"      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements with IPv4 is supported.\n";
+
+static struct ipset_type ipset_hash_netiface5 = {
+	.name = "hash:net,iface",
+	.alias = { "netifacehash", NULL },
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
+			.parse = ipset_parse_iface,
+			.print = ipset_print_iface,
+			.opt = IPSET_OPT_IFACE
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netiface_create_args5,
+		[IPSET_ADD] = hash_netiface_add_args4,
+		[IPSET_TEST] = hash_netiface_test_args4,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netiface_usage5,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -558,4 +682,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netiface2);
 	ipset_type_add(&ipset_hash_netiface3);
 	ipset_type_add(&ipset_hash_netiface4);
+	ipset_type_add(&ipset_hash_netiface5);
 }
diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
index 0e617af..2232d3a 100644
--- a/lib/ipset_hash_netnet.c
+++ b/lib/ipset_hash_netnet.c
@@ -161,8 +161,133 @@ static struct ipset_type ipset_hash_netnet0 = {
 	.description = "initial revision",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netnet_create_args1[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
+	{ },
+};
+
+static const char hash_netnet_usage1[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [forceadd]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR],IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_netnet1 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 1,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args1,
+		[IPSET_ADD] = hash_netnet_add_args0,
+		[IPSET_TEST] = hash_netnet_test_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
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
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netnet_usage1,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_netnet0);
+	ipset_type_add(&ipset_hash_netnet1);
 }
diff --git a/lib/ipset_hash_netport.c b/lib/ipset_hash_netport.c
index 3a41456..be5612c 100644
--- a/lib/ipset_hash_netport.c
+++ b/lib/ipset_hash_netport.c
@@ -594,6 +594,137 @@ static struct ipset_type ipset_hash_netport5 = {
 	.description = "comment support",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netport_create_args6[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
+	{ },
+};
+
+static const char hash_netport_usage6[] =
+"create SETNAME hash:net,port\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
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
+static struct ipset_type ipset_hash_netport6 = {
+	.name = "hash:net,port",
+	.alias = { "netporthash", NULL },
+	.revision = 6,
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
+		[IPSET_CREATE] = hash_netport_create_args6,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+	.usage = hash_netport_usage6,
+	.usagefn = ipset_port_usage,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -602,4 +733,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netport3);
 	ipset_type_add(&ipset_hash_netport4);
 	ipset_type_add(&ipset_hash_netport5);
+	ipset_type_add(&ipset_hash_netport6);
 }
diff --git a/lib/ipset_hash_netportnet.c b/lib/ipset_hash_netportnet.c
index 728c4a3..6cc2b7e 100644
--- a/lib/ipset_hash_netportnet.c
+++ b/lib/ipset_hash_netportnet.c
@@ -184,8 +184,157 @@ static struct ipset_type ipset_hash_netportnet0 = {
 	.description = "initial revision",
 };
 
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netportnet_create_args1[] = {
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
+        { .name = { "forceadd", NULL },
+          .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
+          .parse = ipset_parse_flag,        	.print = ipset_print_flag,
+        },
+	{ },
+};
+
+static const char hash_netportnet_usage1[] =
+"create SETNAME hash:net,port,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"		[forceadd]\n"
+"add    SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR] [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR]\n"
+"test   SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP are valid IPv4 or IPv6 addresses (or hostnames),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      in both IP components are supported for IPv4.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_netportnet1 = {
+	.name = "hash:net,port,net",
+	.alias = { "netportnethash", NULL },
+	.revision = 1,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_THREE,
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
+		[IPSET_DIM_THREE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netportnet_create_args1,
+		[IPSET_ADD] = hash_netportnet_add_args0,
+		[IPSET_TEST] = hash_netportnet_test_args0,
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
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
+			| IPSET_FLAG(IPSET_OPT_FORCEADD),
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
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netportnet_usage1,
+	.usagefn = ipset_port_usage,
+	.description = "forceadd support",
+};
+
 void _init(void);
 void _init(void)
 {
 	ipset_type_add(&ipset_hash_netportnet0);
+	ipset_type_add(&ipset_hash_netportnet1);
 }
diff --git a/src/ipset.8 b/src/ipset.8
index eeda9e7..6c9a0f5 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -327,6 +327,13 @@ ipset add foo 192.168.1.1/24 comment "allow access to SMB share on \\\\\\\\files
 .IP
 the above would appear as: "allow access to SMB share on \\\\fileserv\\"
 .PP
+.SS forceadd
+All hash set types support the optional \fBforceadd\fR parameter when creating a set.
+When sets created with this option become full the next addition to the set may
+succeed and evict a random entry from the set.
+.IP
+ipset create foo hash:ip forceadd
+.PP
 .SH "SET TYPES"
 .SS bitmap:ip
 The \fBbitmap:ip\fR set type uses a memory range to store either IPv4 host
-- 
1.7.9.5

