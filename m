Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5437C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Mar 2022 22:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350950AbiCHWSV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 17:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350740AbiCHWRj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 17:17:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FBE058803
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2022 14:16:24 -0800 (PST)
Received: from localhost.localdomain (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4DAB86300F;
        Tue,  8 Mar 2022 23:14:29 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH conntrack-tools] nfct: remove lazy binding
Date:   Tue,  8 Mar 2022 23:16:20 +0100
Message-Id: <20220308221620.128180-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since cd5135377ac4 ("conntrackd: cthelper: Set up userspace helpers when
daemon starts"), userspace conntrack helpers do not depend on a previous
invocation of nfct to set up the userspace helpers.

Move helper definitions to nfct-extensions/helper.c since existing
deployments might still invoke nfct, even if not required anymore.

This patch was motivated by the removal of the lazy binding.

Phil Sutter says:

"For security purposes, distributions might want to pass -Wl,-z,now
linker flags to all builds, thereby disabling lazy binding globally.

In the past, nfct relied upon lazy binding: It uses the helper objects'
parsing functions without but doesn't provide all symbols the objects
use."

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac                 |   5 +-
 include/Makefile.am          |   2 +-
 include/helper.h             |   1 +
 include/helpers/Makefile.am  |   1 +
 include/helpers/ftp.h        |  14 +++
 include/helpers/rpc.h        |  15 +++
 include/helpers/sane.h       |  13 +++
 include/helpers/tns.h        |   9 ++
 src/Makefile.am              |   2 -
 src/helpers.c                |   3 +-
 src/helpers/Makefile.am      |   2 +-
 src/helpers/ftp.c            |  12 +--
 src/helpers/rpc.c            |  13 +--
 src/helpers/sane.c           |  10 +-
 src/helpers/tns.c            |   7 +-
 src/nfct-extensions/helper.c | 184 ++++++++++++++++++++++++++++++++++-
 16 files changed, 246 insertions(+), 47 deletions(-)
 create mode 100644 include/helpers/Makefile.am
 create mode 100644 include/helpers/ftp.h
 create mode 100644 include/helpers/rpc.h
 create mode 100644 include/helpers/sane.h
 create mode 100644 include/helpers/tns.h

diff --git a/configure.ac b/configure.ac
index b12b722a3396..d9d351bde9be 100644
--- a/configure.ac
+++ b/configure.ac
@@ -77,15 +77,12 @@ AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabib
 AC_CHECK_HEADERS(arpa/inet.h)
 AC_CHECK_FUNCS(inet_pton)
 
-# Let nfct use dlopen() on helper libraries without resolving all symbols.
-AX_CHECK_LINK_FLAG([-Wl,-z,lazy], [AC_SUBST([LAZY_LDFLAGS], [-Wl,-z,lazy])])
-
 if test ! -z "$libdir"; then
 	MODULE_DIR="\\\"$libdir/conntrack-tools/\\\""
 	CFLAGS="$CFLAGS -DCONNTRACKD_LIB_DIR=$MODULE_DIR"
 fi
 
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/linux/Makefile include/linux/netfilter/Makefile extensions/Makefile src/helpers/Makefile])
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/helpers/Makefile include/linux/Makefile include/linux/netfilter/Makefile extensions/Makefile src/helpers/Makefile])
 AC_OUTPUT
 
 echo "
diff --git a/include/Makefile.am b/include/Makefile.am
index 352054e9135b..4741b50228eb 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS = linux
+SUBDIRS = linux helpers
 
 noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
 		 sync.h conntrackd.h local.h udp.h tcp.h \
diff --git a/include/helper.h b/include/helper.h
index d5406674cb13..08d4cf464280 100644
--- a/include/helper.h
+++ b/include/helper.h
@@ -56,6 +56,7 @@ extern int in4_pton(const char *src, int srclen, uint8_t *dst, int delim, const
 extern int in6_pton(const char *src, int srclen, uint8_t *dst, int delim, const char **end);
 
 extern void helper_register(struct ctd_helper *helper);
+struct ctd_helper *__helper_find(const char *helper_name, uint8_t l4proto);
 struct ctd_helper *helper_find(const char *libdir_path, const char *name, uint8_t l4proto, int flags);
 
 #define min_t(type, x, y) ({			\
diff --git a/include/helpers/Makefile.am b/include/helpers/Makefile.am
new file mode 100644
index 000000000000..99a4257d2d06
--- /dev/null
+++ b/include/helpers/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS = ftp.h  rpc.h  sane.h  tns.h
diff --git a/include/helpers/ftp.h b/include/helpers/ftp.h
new file mode 100644
index 000000000000..50e2d0c97946
--- /dev/null
+++ b/include/helpers/ftp.h
@@ -0,0 +1,14 @@
+#ifndef _CTD_FTP_H
+#define _CTD_FTP_H
+
+#define NUM_SEQ_TO_REMEMBER 2
+
+/* This structure exists only once per master */
+struct ftp_info {
+	/* Valid seq positions for cmd matching after newline */
+	uint32_t seq_aft_nl[MYCT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
+	/* 0 means seq_match_aft_nl not set */
+	int seq_aft_nl_num[MYCT_DIR_MAX];
+};
+
+#endif
diff --git a/include/helpers/rpc.h b/include/helpers/rpc.h
new file mode 100644
index 000000000000..b0b8d176fb54
--- /dev/null
+++ b/include/helpers/rpc.h
@@ -0,0 +1,15 @@
+#ifndef _CTD_RPC_H
+#define _CTD_RPC_H
+
+struct rpc_info {
+	/* XID */
+	uint32_t xid;
+	/* program */
+	uint32_t pm_prog;
+	/* program version */
+	uint32_t pm_vers;
+	/* transport protocol: TCP|UDP */
+	uint32_t pm_prot;
+};
+
+#endif
diff --git a/include/helpers/sane.h b/include/helpers/sane.h
new file mode 100644
index 000000000000..1e70ff636d60
--- /dev/null
+++ b/include/helpers/sane.h
@@ -0,0 +1,13 @@
+#ifndef _CTD_SANE_H
+#define _CTD_SANE_H
+
+enum sane_state {
+	SANE_STATE_NORMAL,
+	SANE_STATE_START_REQUESTED,
+};
+
+struct nf_ct_sane_master {
+	enum sane_state state;
+};
+
+#endif
diff --git a/include/helpers/tns.h b/include/helpers/tns.h
new file mode 100644
index 000000000000..60dcf253657f
--- /dev/null
+++ b/include/helpers/tns.h
@@ -0,0 +1,9 @@
+#ifndef _CTD_TNS_H
+#define _CTD_TNS_H
+
+struct tns_info {
+	/* Scan next DATA|REDIRECT packet */
+	bool parse;
+};
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 1d56394698a6..a1a91a0c8df6 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -35,8 +35,6 @@ if HAVE_CTHELPER
 nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
 endif
 
-nfct_LDFLAGS = -export-dynamic ${LAZY_LDFLAGS}
-
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
 		    filter.c fds.c event.c process.c origin.c date.c \
diff --git a/src/helpers.c b/src/helpers.c
index 3e4e6c8553b8..8ca78dc113fb 100644
--- a/src/helpers.c
+++ b/src/helpers.c
@@ -26,8 +26,7 @@ void helper_register(struct ctd_helper *helper)
 	list_add(&helper->head, &helper_list);
 }
 
-static struct ctd_helper *
-__helper_find(const char *helper_name, uint8_t l4proto)
+struct ctd_helper *__helper_find(const char *helper_name, uint8_t l4proto)
 {
 	struct ctd_helper *cur, *helper = NULL;
 
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index e4f10c974bb0..e458ab467bb7 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -11,7 +11,7 @@ pkglib_LTLIBRARIES = ct_helper_amanda.la \
 		     ct_helper_slp.la	\
 		     ct_helper_ssdp.la
 
-HELPER_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS) $(LAZY_LDFLAGS)
+HELPER_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
 HELPER_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 
 ct_helper_amanda_la_SOURCES = amanda.c
diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 2505c7124f71..29ac55c23650 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -36,17 +36,9 @@
 #include <libnetfilter_queue/pktbuff.h>
 #include <linux/netfilter.h>
 
-static bool loose; /* XXX: export this as config option. */
-
-#define NUM_SEQ_TO_REMEMBER 2
+#include "helpers/ftp.h"
 
-/* This structure exists only once per master */
-struct ftp_info {
-	/* Valid seq positions for cmd matching after newline */
-	uint32_t seq_aft_nl[MYCT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
-	/* 0 means seq_match_aft_nl not set */
-	int seq_aft_nl_num[MYCT_DIR_MAX];
-};
+static bool loose; /* XXX: export this as config option. */
 
 enum nf_ct_ftp_type {
 	/* PORT command from client */
diff --git a/src/helpers/rpc.c b/src/helpers/rpc.c
index 3b3d0a7c2df4..732e9ba41271 100644
--- a/src/helpers/rpc.c
+++ b/src/helpers/rpc.c
@@ -41,21 +41,12 @@
 #include <libnetfilter_queue/pktbuff.h>
 #include <linux/netfilter.h>
 
+#include "helpers/rpc.h"
+
 /* RFC 1050: RPC: Remote Procedure Call Protocol Specification Version 2 */
 /* RFC 1014: XDR: External Data Representation Standard */
 #define SUPPORTED_RPC_VERSION	2
 
-struct rpc_info {
-	/* XID */
-	uint32_t xid;
-	/* program */
-	uint32_t pm_prog;
-	/* program version */
-	uint32_t pm_vers;
-	/* transport protocol: TCP|UDP */
-	uint32_t pm_prot;
-};
-
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int
diff --git a/src/helpers/sane.c b/src/helpers/sane.c
index 2c07099e80ae..ebcb24cc9ec7 100644
--- a/src/helpers/sane.c
+++ b/src/helpers/sane.c
@@ -39,11 +39,7 @@
 #include <libnetfilter_queue/libnetfilter_queue_tcp.h>
 #include <libnetfilter_queue/pktbuff.h>
 #include <linux/netfilter.h>
-
-enum sane_state {
-	SANE_STATE_NORMAL,
-	SANE_STATE_START_REQUESTED,
-};
+#include "helpers/sane.h"
 
 struct sane_request {
 	uint32_t RPC_code;
@@ -61,10 +57,6 @@ struct sane_reply_net_start {
 	/* other fields aren't interesting for conntrack */
 };
 
-struct nf_ct_sane_master {
-	enum sane_state state;
-};
-
 static int
 sane_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 		 struct myct *myct, uint32_t ctinfo)
diff --git a/src/helpers/tns.c b/src/helpers/tns.c
index 803f40a0ce1a..5692f2993321 100644
--- a/src/helpers/tns.c
+++ b/src/helpers/tns.c
@@ -29,6 +29,8 @@
 #include <libnetfilter_queue/pktbuff.h>
 #include <linux/netfilter.h>
 
+#include "helpers/tns.h"
+
 /* TNS SQL*Net Version 2 */
 enum tns_types {
        TNS_TYPE_CONNECT        = 1,
@@ -58,11 +60,6 @@ struct tns_redirect {
        uint16_t data_len;
 };
 
-struct tns_info {
-       /* Scan next DATA|REDIRECT packet */
-       bool parse;
-};
-
 static int try_number(const char *data, size_t dlen, uint32_t array[],
 		      int array_size, char sep, char term)
 {
diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index e5d8d0a905df..894bf269ad2b 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -180,7 +180,7 @@ static int nfct_cmd_helper_add(struct mnl_socket *nl, int argc, char *argv[])
 		return -1;
 	}
 
-	helper = helper_find(CONNTRACKD_LIB_DIR, argv[3], l4proto, RTLD_LAZY);
+	helper = __helper_find(argv[3], l4proto);
 	if (helper == NULL) {
 		nfct_perror("that helper is not supported");
 		return -1;
@@ -430,7 +430,7 @@ nfct_cmd_helper_disable(struct mnl_socket *nl, int argc, char *argv[])
 		return -1;
 	}
 
-	helper = helper_find(CONNTRACKD_LIB_DIR, argv[3], l4proto, RTLD_LAZY);
+	helper = __helper_find(argv[3], l4proto);
 	if (helper == NULL) {
 		nfct_perror("that helper is not supported");
 		return -1;
@@ -468,7 +468,187 @@ static struct nfct_extension helper = {
 	.parse_params	= nfct_helper_parse_params,
 };
 
+/*
+ * supported helpers: to set up helpers via nfct, the following definitions are
+ * provided for backward compatibility reasons since conntrackd does not depend
+ * on nfct anymore to set up the userspace helpers.
+ */
+
+static struct ctd_helper amanda_helper = {
+	.name		= "amanda",
+	.l4proto	= IPPROTO_UDP,
+	.policy		= {
+		[0] = {
+			.name			= "amanda",
+			.expect_max		= 3,
+			.expect_timeout		= 180,
+		},
+	},
+};
+
+static struct ctd_helper dhcpv6_helper = {
+	.name		= "dhcpv6",
+	.l4proto	= IPPROTO_UDP,
+	.policy		= {
+		[0] = {
+			.name			= "dhcpv6",
+			.expect_max		= 1,
+			.expect_timeout		= 300,
+		},
+	},
+};
+
+#include "helpers/ftp.h"
+
+static struct ctd_helper ftp_helper = {
+	.name		= "ftp",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= sizeof(struct ftp_info),
+	.policy		= {
+		[0] = {
+			.name			= "ftp",
+			.expect_max		= 1,
+			.expect_timeout		= 300,
+		},
+	},
+};
+
+static struct ctd_helper mdns_helper = {
+	.name		= "mdns",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= 0,
+	.policy		= {
+		[0] = {
+			.name		= "mdns",
+			.expect_max	= 8,
+			.expect_timeout = 30,
+		},
+	},
+};
+
+#include "helpers/rpc.h"
+
+static struct ctd_helper rpc_helper_tcp = {
+	.name		= "rpc",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= sizeof(struct rpc_info),
+	.policy		= {
+		{
+			.name			= "rpc",
+			.expect_max		= 1,
+			.expect_timeout		= 300,
+		},
+	},
+};
+
+static struct ctd_helper rpc_helper_udp = {
+	.name		= "rpc",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= sizeof(struct rpc_info),
+	.policy		= {
+		{
+			.name			= "rpc",
+			.expect_max		= 1,
+			.expect_timeout		= 300,
+		},
+	},
+};
+
+#include "helpers/sane.h"
+
+static struct ctd_helper sane_helper = {
+	.name		= "sane",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= sizeof(struct nf_ct_sane_master),
+	.policy		= {
+		[0] = {
+			.name			= "sane",
+			.expect_max		= 1,
+			.expect_timeout		= 5 * 60,
+		},
+	},
+};
+
+static struct ctd_helper slp_helper = {
+	.name		= "slp",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= 0,
+	.policy		= {
+		[0] = {
+			.name		= "slp",
+			.expect_max	= 8,
+			.expect_timeout = 16, /* default CONFIG_MC_MAX + 1 */
+		},
+	},
+};
+
+static struct ctd_helper ssdp_helper_udp = {
+	.name		= "ssdp",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= 0,
+	.policy		= {
+		[0] = {
+			.name		= "ssdp",
+			.expect_max	= 8,
+			.expect_timeout = 5 * 60,
+		},
+	},
+};
+
+static struct ctd_helper ssdp_helper_tcp = {
+	.name		= "ssdp",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= 0,
+	.policy		= {
+		[0] = {
+			.name		= "ssdp",
+			.expect_max	= 8,
+			.expect_timeout = 5 * 60,
+		},
+	},
+};
+
+static struct ctd_helper tftp_helper = {
+	.name		= "tftp",
+	.l4proto	= IPPROTO_UDP,
+	.policy		= {
+		[0] = {
+			.name			= "tftp",
+			.expect_max		= 1,
+			.expect_timeout		= 5 * 60,
+		},
+	},
+};
+
+#include "helpers/tns.h"
+
+static struct ctd_helper tns_helper = {
+	.name		= "tns",
+	.l4proto	= IPPROTO_TCP,
+	.priv_data_len	= sizeof(struct tns_info),
+	.policy		= {
+		[0] = {
+			.name		= "tns",
+			.expect_max	= 1,
+			.expect_timeout = 300,
+		},
+	},
+};
+
 static void __init helper_init(void)
 {
+	helper_register(&amanda_helper);
+	helper_register(&dhcpv6_helper);
+	helper_register(&ftp_helper);
+	helper_register(&mdns_helper);
+	helper_register(&rpc_helper_tcp);
+	helper_register(&rpc_helper_udp);
+	helper_register(&sane_helper);
+	helper_register(&slp_helper);
+	helper_register(&ssdp_helper_udp);
+	helper_register(&ssdp_helper_tcp);
+	helper_register(&tftp_helper);
+	helper_register(&tns_helper);
+
 	nfct_extension_register(&helper);
 }
-- 
2.30.2

