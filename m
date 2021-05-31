Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F7DC47082
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2400D6135A
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEaWUF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 May 2021 18:20:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37722 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhEaWUF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 May 2021 18:20:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6943D64175;
        Tue,  1 Jun 2021 00:17:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH ipset 3/3] add ipset to nftables translation infrastructure
Date:   Tue,  1 Jun 2021 00:18:18 +0200
Message-Id: <20210531221818.24867-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531221818.24867-1-pablo@netfilter.org>
References: <20210531221818.24867-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch provides the ipset-translate utility which allows you to
translate your existing ipset file to nftables.

The ipset-translate utility is actually a symlink to ipset, which checks
for 'argv[0] == ipset-translate' to exercise the translation path.

You can translate your ipset file through:

	ipset-translate restore < sets.ipt

This patch reuses the existing parser and API to represent the sets and
the elements.

There is a new ipset_xlate_set dummy object that allows to store a
created set to fetch the type without interactions with the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac                 |   1 +
 include/libipset/Makefile.am |   3 +-
 include/libipset/xlate.h     |   6 +
 lib/ipset.c                  | 443 ++++++++++++++++++++++++++++++++++-
 src/Makefile.am              |   8 +-
 src/ipset-translate.8        |  86 +++++++
 src/ipset.c                  |   8 +-
 7 files changed, 551 insertions(+), 4 deletions(-)
 create mode 100644 include/libipset/xlate.h
 create mode 100644 src/ipset-translate.8

diff --git a/configure.ac b/configure.ac
index bd6116ca7f0a..3ba3e17137d3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,6 +7,7 @@ AC_CONFIG_HEADER([config.h])
 AM_INIT_AUTOMAKE([foreign subdir-objects tar-pax])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
+AC_PROG_LN_S
 AC_ENABLE_STATIC
 LT_INIT([dlopen])
 LT_CONFIG_LTDL_DIR([libltdl])
diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index c7f7b2bfce48..2c040291abc0 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -17,6 +17,7 @@ pkginclude_HEADERS = \
 	transport.h \
 	types.h \
 	ipset.h \
-	utils.h
+	utils.h \
+	xlate.h
 
 EXTRA_DIST = debug.h icmp.h icmpv6.h
diff --git a/include/libipset/xlate.h b/include/libipset/xlate.h
new file mode 100644
index 000000000000..65697682f722
--- /dev/null
+++ b/include/libipset/xlate.h
@@ -0,0 +1,6 @@
+#ifndef LIBIPSET_XLATE_H
+#define LIBIPSET_XLATE_H
+
+int ipset_xlate_argv(struct ipset *ipset, int argc, char *argv[]);
+
+#endif
diff --git a/lib/ipset.c b/lib/ipset.c
index 5232d8b76c46..1c5a65f54961 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -28,6 +28,7 @@
 #include <libipset/utils.h>			/* STREQ */
 #include <libipset/ipset.h>			/* prototypes */
 #include <libipset/ip_set_compiler.h>		/* compiler attributes */
+#include <libipset/list_sort.h>			/* lists */
 
 static char program_name[] = PACKAGE;
 static char program_version[] = PACKAGE_VERSION;
@@ -50,6 +51,14 @@ struct ipset {
 	char *newargv[MAX_ARGS];
 	int newargc;
 	const char *filename;			/* Input/output filename */
+	bool xlate;
+	struct list_head xlate_sets;
+};
+
+struct ipset_xlate_set {
+	struct list_head list;
+	char name[IPSET_MAXNAMELEN];
+	const struct ipset_type *type;
 };
 
 /* Commands and environment options */
@@ -923,6 +932,19 @@ static const char *cmd_prefix[] = {
 	[IPSET_TEST]   = "test   SETNAME",
 };
 
+static const struct ipset_type *ipset_xlate_type_get(struct ipset *ipset,
+						     const char *name)
+{
+	struct ipset_xlate_set *set;
+
+	list_for_each_entry(set, &ipset->xlate_sets, list) {
+		if (!strcmp(set->name, name))
+			return set->type;
+	}
+
+	return NULL;
+}
+
 static int
 ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 {
@@ -1241,7 +1263,11 @@ ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 		if (ret < 0)
 			return ipset->standard_error(ipset, p);
 
-		type = ipset_type_get(session, cmd);
+		if (!ipset->xlate) {
+			type = ipset_type_get(session, cmd);
+		} else {
+			type = ipset_xlate_type_get(ipset, arg0);
+		}
 		if (type == NULL)
 			return ipset->standard_error(ipset, p);
 
@@ -1474,6 +1500,12 @@ ipset_init(void)
 		return NULL;
 	}
 	ipset_custom_printf(ipset, NULL, NULL, NULL, NULL);
+
+	if (!strcmp(program_name, "ipset-translate"))
+		ipset->xlate = true;
+
+	INIT_LIST_HEAD(&ipset->xlate_sets);
+
 	return ipset;
 }
 
@@ -1488,6 +1520,8 @@ ipset_init(void)
 int
 ipset_fini(struct ipset *ipset)
 {
+	struct ipset_xlate_set *xlate_set, *next;
+
 	assert(ipset);
 
 	if (ipset->session)
@@ -1496,6 +1530,413 @@ ipset_fini(struct ipset *ipset)
 	if (ipset->newargv[0])
 		free(ipset->newargv[0]);
 
+	list_for_each_entry_safe(xlate_set, next, &ipset->xlate_sets, list)
+		free(xlate_set);
+
 	free(ipset);
 	return 0;
 }
+
+/* Ignore the set family, use inet. */
+static const char *ipset_xlate_family(uint8_t family)
+{
+	return "inet";
+}
+
+enum ipset_xlate_set_type {
+	IPSET_XLATE_TYPE_UNKNOWN	= 0,
+	IPSET_XLATE_TYPE_HASH_MAC,
+	IPSET_XLATE_TYPE_HASH_IP,
+	IPSET_XLATE_TYPE_HASH_IP_MAC,
+	IPSET_XLATE_TYPE_HASH_NET_IFACE,
+	IPSET_XLATE_TYPE_HASH_NET_PORT,
+	IPSET_XLATE_TYPE_HASH_NET_PORT_NET,
+	IPSET_XLATE_TYPE_HASH_NET_NET,
+	IPSET_XLATE_TYPE_HASH_NET,
+	IPSET_XLATE_TYPE_HASH_IP_PORT_NET,
+	IPSET_XLATE_TYPE_HASH_IP_PORT_IP,
+	IPSET_XLATE_TYPE_HASH_IP_MARK,
+	IPSET_XLATE_TYPE_HASH_IP_PORT,
+	IPSET_XLATE_TYPE_BITMAP_PORT,
+	IPSET_XLATE_TYPE_BITMAP_IP_MAC,
+	IPSET_XLATE_TYPE_BITMAP_IP,
+};
+
+static enum ipset_xlate_set_type ipset_xlate_set_type(const char *typename)
+{
+	if (!strcmp(typename, "hash:mac"))
+		return IPSET_XLATE_TYPE_HASH_MAC;
+	else if (!strcmp(typename, "hash:ip"))
+		return IPSET_XLATE_TYPE_HASH_IP;
+	else if (!strcmp(typename, "hash:ip,mac"))
+		return IPSET_XLATE_TYPE_HASH_IP_MAC;
+	else if (!strcmp(typename, "hash:net,iface"))
+		return IPSET_XLATE_TYPE_HASH_NET_IFACE;
+	else if (!strcmp(typename, "hash:net,port"))
+		return IPSET_XLATE_TYPE_HASH_NET_PORT;
+	else if (!strcmp(typename, "hash:net,port,net"))
+		return IPSET_XLATE_TYPE_HASH_NET_PORT_NET;
+	else if (!strcmp(typename, "hash:net,net"))
+		return IPSET_XLATE_TYPE_HASH_NET_NET;
+	else if (!strcmp(typename, "hash:net"))
+		return IPSET_XLATE_TYPE_HASH_NET;
+	else if (!strcmp(typename, "hash:ip,port,net"))
+		return IPSET_XLATE_TYPE_HASH_IP_PORT_NET;
+	else if (!strcmp(typename, "hash:ip,port,ip"))
+		return IPSET_XLATE_TYPE_HASH_IP_PORT_IP;
+	else if (!strcmp(typename, "hash:ip,mark"))
+		return IPSET_XLATE_TYPE_HASH_IP_MARK;
+	else if (!strcmp(typename, "hash:ip,port"))
+		return IPSET_XLATE_TYPE_HASH_IP_PORT;
+	else if (!strcmp(typename, "hash:ip"))
+		return IPSET_XLATE_TYPE_HASH_IP;
+	else if (!strcmp(typename, "bitmap:port"))
+		return IPSET_XLATE_TYPE_BITMAP_PORT;
+	else if (!strcmp(typename, "bitmap:ip,mac"))
+		return IPSET_XLATE_TYPE_BITMAP_IP_MAC;
+	else if (!strcmp(typename, "bitmap:ip"))
+		return IPSET_XLATE_TYPE_BITMAP_IP;
+
+	return IPSET_XLATE_TYPE_UNKNOWN;
+}
+
+#define NFT_SET_INTERVAL	(1 << 0)
+
+static const char *
+ipset_xlate_type_to_nftables(int family, enum ipset_xlate_set_type type,
+			     uint32_t *flags)
+{
+	switch (type) {
+	case IPSET_XLATE_TYPE_HASH_MAC:
+		return "ether_addr";
+	case IPSET_XLATE_TYPE_HASH_IP:
+		if (family == AF_INET)
+			return "ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_IP_MAC:
+		if (family == AF_INET)
+			return "ipv4_addr . ether_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . ether_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_NET_IFACE:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr . ether_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . ether_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_NET_PORT:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr . inet_proto . inet_service";
+		else if (family == AF_INET6)
+			return "ipv6_addr . inet_proto . inet_service";
+		break;
+	case IPSET_XLATE_TYPE_HASH_NET_PORT_NET:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr . inet_proto . inet_service . ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . inet_proto . inet_service . ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_NET_NET:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr . ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_NET:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_IP_PORT_NET:
+		*flags |= NFT_SET_INTERVAL;
+		if (family == AF_INET)
+			return "ipv4_addr . inet_proto . inet_service . ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . inet_proto . inet_service . ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_IP_PORT_IP:
+		if (family == AF_INET)
+			return "ipv4_addr . inet_proto . inet_service . ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . inet_proto . inet_service . ipv6_addr";
+		break;
+	case IPSET_XLATE_TYPE_HASH_IP_MARK:
+		if (family == AF_INET)
+			return "ipv4_addr . mark";
+		else if (family == AF_INET6)
+			return "ipv6_addr . mark";
+		break;
+	case IPSET_XLATE_TYPE_HASH_IP_PORT:
+		if (family == AF_INET)
+			return "ipv4_addr . inet_proto . inet_service";
+		else if (family == AF_INET6)
+			return "ipv6_addr . inet_proto . inet_service";
+		break;
+	case IPSET_XLATE_TYPE_BITMAP_PORT:
+		return "inet_proto . inet_service";
+	case IPSET_XLATE_TYPE_BITMAP_IP_MAC:
+		if (family == AF_INET)
+			return "ipv4_addr . ether_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr . ether_addr";
+		break;
+	case IPSET_XLATE_TYPE_BITMAP_IP:
+		if (family == AF_INET)
+			return "ipv4_addr";
+		else if (family == AF_INET6)
+			return "ipv6_addr";
+		break;
+	}
+	/* This should not ever happen. */
+	return "unknown";
+}
+
+static int ipset_xlate(struct ipset *ipset, enum ipset_cmd cmd,
+		       const char *table)
+{
+	const char *set, *typename, *nft_type;
+	const struct ipset_type *ipset_type;
+	struct ipset_xlate_set *xlate_set;
+	enum ipset_xlate_set_type type;
+	struct ipset_session *session;
+	const uint32_t *cadt_flags;
+	const uint32_t *timeout;
+	const uint32_t *maxelem;
+	struct ipset_data *data;
+	uint32_t flags = 0;
+	uint8_t family;
+	bool concat;
+	int i;
+
+	session = ipset_session(ipset);
+	data = ipset_session_data(session);
+
+	set = ipset_data_get(data, IPSET_SETNAME);
+	family = ipset_data_family(data);
+
+	switch (cmd) {
+	case IPSET_CMD_CREATE:
+		/* Not supported. */
+		if (ipset_data_get(data, IPSET_OPT_MARKMASK) ||
+		    ipset_data_get(data, IPSET_OPT_NETMASK)) {
+			printf("# %s", ipset->cmdline);
+			break;
+		}
+		cadt_flags = ipset_data_get(data, IPSET_OPT_CADT_FLAGS);
+
+		/* Ignore:
+		 * - IPSET_FLAG_WITH_COMMENT
+		 * - IPSET_FLAG_WITH_FORCEADD
+		 */
+		if (cadt_flags &&
+		    (*cadt_flags & (IPSET_FLAG_BEFORE |
+				   IPSET_FLAG_PHYSDEV |
+				   IPSET_FLAG_NOMATCH |
+				   IPSET_FLAG_WITH_SKBINFO |
+				   IPSET_FLAG_IFACE_WILDCARD))) {
+			printf("# %s", ipset->cmdline);
+			break;
+		}
+
+		typename = ipset_data_get(data, IPSET_OPT_TYPENAME);
+		type = ipset_xlate_set_type(typename);
+		nft_type = ipset_xlate_type_to_nftables(family, type, &flags);
+
+		printf("add set %s %s %s { type %s; ",
+		       ipset_xlate_family(family), table, set, nft_type);
+		if (cadt_flags) {
+			if (*cadt_flags & IPSET_FLAG_WITH_COUNTERS)
+				printf("counter; ");
+		}
+		timeout = ipset_data_get(data, IPSET_OPT_TIMEOUT);
+		if (timeout)
+			printf("timeout %us; ", *timeout);
+		maxelem = ipset_data_get(data, IPSET_OPT_MAXELEM);
+		if (maxelem)
+			printf("size %u; ", *maxelem);
+		if (flags & NFT_SET_INTERVAL)
+			printf("flags interval; ");
+
+		/* These create-specific options are safe to be ignored:
+		 * - IPSET_OPT_GC
+		 * - IPSET_OPT_HASHSIZE
+		 * - IPSET_OPT_PROBES
+		 * - IPSET_OPT_RESIZE
+		 * - IPSET_OPT_SIZE
+		 * - IPSET_OPT_FORCEADD
+		 */
+
+		printf("}\n");
+
+		xlate_set = malloc(sizeof(*xlate_set));
+		if (!xlate_set)
+			return -1;
+
+		snprintf(xlate_set->name, sizeof(xlate_set->name), "%s", set);
+		ipset_type = ipset_types();
+		while (ipset_type) {
+			if (!strcmp(ipset_type->name, typename))
+				break;
+			ipset_type = ipset_type->next;
+		}
+
+		xlate_set->type = ipset_type;
+		list_add_tail(&xlate_set->list, &ipset->xlate_sets);
+		break;
+	case IPSET_CMD_DESTROY:
+		printf("del set %s %s %s\n",
+		       ipset_xlate_family(family), table, set);
+		break;
+	case IPSET_CMD_FLUSH:
+		if (!set) {
+			printf("# %s", ipset->cmdline);
+		} else {
+			printf("flush set %s %s %s\n",
+			       ipset_xlate_family(family), table, set);
+		}
+		break;
+	case IPSET_CMD_RENAME:
+		printf("# %s", ipset->cmdline);
+		return -1;
+	case IPSET_CMD_SWAP:
+		printf("# %s", ipset->cmdline);
+		return -1;
+	case IPSET_CMD_LIST:
+		if (!set) {
+			printf("list sets %s\n",
+			       ipset_xlate_family(family), table);
+		} else {
+			printf("list set %s %s %s\n",
+			       ipset_xlate_family(family), table, set);
+		}
+		break;
+	case IPSET_CMD_SAVE:
+		printf("# %s", ipset->cmdline);
+		return -1;
+	case IPSET_CMD_ADD:
+		printf("add element %s %s %s { ",
+		       ipset_xlate_family(family), table, set);
+		goto next;
+	case IPSET_CMD_DEL:
+		printf("delete element %s %s %s { ",
+		       ipset_xlate_family(family), table, set);
+		goto next;
+	case IPSET_CMD_TEST:
+		printf("get element %s %s %s { ",
+		       ipset_xlate_family(family), table, set);
+next:
+		typename = ipset_data_get(data, IPSET_OPT_TYPENAME);
+		type = ipset_xlate_set_type(typename);
+
+		concat = false;
+		for (i = IPSET_OPT_IP; i <= IPSET_OPT_TIMEOUT; i++) {
+			if (ipset_data_test(data, i)) {
+				char buf[64];
+				char *term;
+
+				if (i == IPSET_OPT_PORT) {
+					ipset_print_proto_port(buf, sizeof(buf),
+							       data, i, 0);
+					term = strchr(buf, ':');
+					*term = '\0';
+					printf("%s%s ", concat ? ". " : "", buf);
+				}
+				ipset_print_data(buf, sizeof(buf), data, i, 0);
+				printf("%s%s ", concat ? ". " : "", buf);
+				concat = true;
+			}
+		}
+		printf("}\n");
+		break;
+	case IPSET_CMD_GET_BYNAME:
+		printf("# %s", ipset->cmdline);
+		return -1;
+	case IPSET_CMD_GET_BYINDEX:
+		printf("# %s", ipset->cmdline);
+		return -1;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int ipset_xlate_restore(struct ipset *ipset)
+{
+	struct ipset_session *session = ipset_session(ipset);
+	struct ipset_data *data = ipset_session_data(session);
+	void *p = ipset_session_printf_private(session);
+	const char *filename;
+	enum ipset_cmd cmd;
+	FILE *f = stdin;
+	int ret = 0;
+	char *c;
+
+	if (ipset->filename) {
+		f = fopen(ipset->filename, "r");
+		if (!f) {
+			fprintf(stderr, "cannot open file `%s'\n", filename);
+			return -1;
+		}
+	}
+
+	while (fgets(ipset->cmdline, sizeof(ipset->cmdline), f)) {
+		ipset->restore_line++;
+		c = ipset->cmdline;
+		while (isspace(c[0]))
+			c++;
+		if (c[0] == '\0' || c[0] == '#')
+			continue;
+		else if (STREQ(c, "COMMIT\n") || STREQ(c, "COMMIT\r\n"))
+			continue;
+
+		ret = build_argv(ipset, c);
+		if (ret < 0)
+			return ret;
+
+		cmd = ipset_parser(ipset, ipset->newargc, ipset->newargv);
+		if (cmd < 0)
+			ipset->standard_error(ipset, p);
+
+		/* TODO: Allow to specify the table name other than 'global'. */
+		ret = ipset_xlate(ipset, cmd, "global");
+		if (ret < 0)
+			break;
+
+		ipset_data_reset(data);
+	}
+
+	if (filename)
+		fclose(f);
+
+	return ret;
+}
+
+int ipset_xlate_argv(struct ipset *ipset, int argc, char *argv[])
+{
+	enum ipset_cmd cmd;
+	int ret;
+
+	cmd = ipset_parser(ipset, argc, argv);
+	if (cmd < 0)
+		return cmd;
+
+	if (cmd == IPSET_CMD_RESTORE) {
+		ret = ipset_xlate_restore(ipset);
+	} else {
+		fprintf(stderr, "This command is not supported, "
+				"use `ipset-translate restore < file'\n");
+		ret = -1;
+	}
+
+	return ret;
+}
diff --git a/src/Makefile.am b/src/Makefile.am
index 438fcec0f1f1..95dea0770139 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -12,10 +12,16 @@ AM_LDFLAGS	= -static
 endif
 endif
 
-dist_man_MANS = ipset.8
+dist_man_MANS = ipset.8 ipset-translate.8
 
 sparse-check: $(ipset_SOURCES:.c=.d)
 
 %.d: %.c
 	$(IPSET_AM_V_CHECK)\
 	$(SPARSE) -I.. $(SPARSE_FLAGS) $(AM_CFLAGS) $(AM_CPPFLAGS) $< || :
+
+install-exec-hook:
+	${LN_S} -f "${sbindir}/ipset" "${DESTDIR}${sbindir}/ipset-translate";
+
+uninstall-hook:
+	rm -f ${DESTDIR}${sbindir}/ipset-translate
diff --git a/src/ipset-translate.8 b/src/ipset-translate.8
new file mode 100644
index 000000000000..8e8615082338
--- /dev/null
+++ b/src/ipset-translate.8
@@ -0,0 +1,86 @@
+.\"
+.\" (C) Copyright 2021, Pablo Neira Ayuso <pablo@netfilter.org>
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.\"
+.TH IPSET-TRANSLATE 8 "May 31, 2021"
+
+.SH NAME
+ipset-translate \(em translation tool to migrate from ipset to nftables
+.SH DESCRIPTION
+This tool allows system administrators to translate a given IP sets file
+to \fBnftables(8)\fP.
+
+The only available command is:
+
+.IP \[bu] 2
+ipset-translate restores < file.ipt
+
+.SH USAGE
+The \fBipset-translate\fP tool reads an IP sets file in the syntax produced by
+\fBipset(8)\fP save. No set modifications occur, this tool is a text converter.
+
+.SH EXAMPLES
+Basic operation examples.
+
+Single command translation, assuming the original file:
+
+.nf
+create test1 hash:ip,port family inet counters timeout 300 hashsize 1024 maxelem 65536 bucketsize 12 initval 0xb5c4be5d
+add test1 1.1.1.1,udp:20
+add test1 1.1.1.1,21
+create test2 hash:ip,port family inet hashsize 1024 maxelem 65536 bucketsize 12 initval 0xb5c4be5d
+.fi
+
+which results in the following translation:
+
+.nf
+root@machine:~# ipset-translate restore < file.ipt
+add set inet global test1 { type ipv4_addr . inet_proto . inet_service; counter; timeout 300s; size 65536; }
+add element inet global test1 { 1.1.1.1 . udp . 20 }
+add element inet global test1 { 1.1.1.1 . tcp . 21 }
+add set inet global test2 { type ipv4_addr . inet_proto . inet_service; size 65536; }
+.fi
+
+.SH LIMITATIONS
+A few IP sets options may be not supported because they are not yet implemented
+in \fBnftables(8)\fP.
+
+Contrary to \fBnftables(8)\fP, IP sets are not attached to a specific table.
+The translation utility assumes that sets are created in a table whose name
+is \fBglobal\fP and family is \fBinet\fP. You might want to update the
+resulting translation to use a different table name and family for your sets.
+
+To get up-to-date information about this, please head to
+\fBhttps://wiki.nftables.org/\fP.
+
+.SH SEE ALSO
+\fBnft(8)\fP, \fBipset(8)\fP
+
+.SH AUTHORS
+The nftables framework has been written by the Netfilter Project
+(https://www.netfilter.org).
+
+This manual page was written by Pablo Neira Ayuso
+<pablo@netfilter.org>.
+
+This documentation is free/libre under the terms of the GPLv2+.
diff --git a/src/ipset.c b/src/ipset.c
index ee36a06e595d..6d42b60d2fe9 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -9,9 +9,11 @@
 #include <assert.h>			/* assert */
 #include <stdio.h>			/* fprintf */
 #include <stdlib.h>			/* exit */
+#include <string.h>			/* strcmp */
 
 #include <config.h>
 #include <libipset/ipset.h>		/* ipset library */
+#include <libipset/xlate.h>		/* translate to nftables */
 
 int
 main(int argc, char *argv[])
@@ -29,7 +31,11 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
-	ret = ipset_parse_argv(ipset, argc, argv);
+	if (!strcmp(argv[0], "ipset-translate")) {
+		ret = ipset_xlate_argv(ipset, argc, argv);
+	} else {
+		ret = ipset_parse_argv(ipset, argc, argv);
+	}
 
 	ipset_fini(ipset);
 
-- 
2.20.1

