From: pablo@netfilter.org
Subject: [PATCH 2/3] input: add nfacct plugin
Date: Wed, 22 Feb 2012 13:33:32 +0100
Message-ID: <1329914013-2132-3-git-send-email-pablo@netfilter.org>
References: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50065 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab2BVMdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:33:53 -0500
In-Reply-To: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds the nfacct plugin.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac                             |    4 +
 include/Makefile.am                      |    2 +-
 include/linux/Makefile.am                |    2 +
 include/linux/netfilter/Makefile.am      |    2 +
 include/linux/netfilter/nfnetlink_acct.h |   36 ++++
 input/Makefile.am                        |    2 +-
 input/sum/Makefile.am                    |    8 +
 input/sum/ulogd_inpflow_NFACCT.c         |  265 ++++++++++++++++++++++++++++++
 ulogd.conf.in                            |    7 +
 9 files changed, 326 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/Makefile.am
 create mode 100644 include/linux/netfilter/Makefile.am
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 input/sum/Makefile.am
 create mode 100644 input/sum/ulogd_inpflow_NFACCT.c

diff --git a/configure.ac b/configure.ac
index 132cdbf..89fc338 100644
--- a/configure.ac
+++ b/configure.ac
@@ -41,6 +41,8 @@ AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.39])
+PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.0])
+PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.0])
 PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.0.95])
 PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
 
@@ -74,8 +76,10 @@ dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
 dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
 
 AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
+	  include/linux/Makefile include/linux/netfilter/Makefile \
 	  libipulog/Makefile \
 	  input/Makefile input/packet/Makefile input/flow/Makefile \
+	  input/sum/Makefile \
 	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
 	  output/dbi/Makefile \
diff --git a/include/Makefile.am b/include/Makefile.am
index fa34473..c62b497 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1 +1 @@
-SUBDIRS = ulogd libipulog
+SUBDIRS = ulogd libipulog linux
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
new file mode 100644
index 0000000..ca80d0d
--- /dev/null
+++ b/include/linux/Makefile.am
@@ -0,0 +1,2 @@
+
+SUBDIRS = netfilter
diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
new file mode 100644
index 0000000..fc05a9c
--- /dev/null
+++ b/include/linux/netfilter/Makefile.am
@@ -0,0 +1,2 @@
+
+noinst_HEADERS = nfnetlink_acct.h
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
new file mode 100644
index 0000000..7c4279b
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -0,0 +1,36 @@
+#ifndef _NFNL_ACCT_H_
+#define _NFNL_ACCT_H_
+
+#ifndef NFACCT_NAME_MAX
+#define NFACCT_NAME_MAX		32
+#endif
+
+enum nfnl_acct_msg_types {
+	NFNL_MSG_ACCT_NEW,
+	NFNL_MSG_ACCT_GET,
+	NFNL_MSG_ACCT_GET_CTRZERO,
+	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_MAX
+};
+
+enum nfnl_acct_type {
+	NFACCT_UNSPEC,
+	NFACCT_NAME,
+	NFACCT_PKTS,
+	NFACCT_BYTES,
+	NFACCT_USE,
+	__NFACCT_MAX
+};
+#define NFACCT_MAX (__NFACCT_MAX - 1)
+
+#ifdef __KERNEL__
+
+struct nf_acct;
+
+extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
+extern void nfnl_acct_put(struct nf_acct *acct);
+extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
+
+#endif /* __KERNEL__ */
+
+#endif /* _NFNL_ACCT_H */
diff --git a/input/Makefile.am b/input/Makefile.am
index 77f2838..5ffef1b 100644
--- a/input/Makefile.am
+++ b/input/Makefile.am
@@ -1,2 +1,2 @@
 
-SUBDIRS = packet flow
+SUBDIRS = packet flow sum
diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
new file mode 100644
index 0000000..04051b4
--- /dev/null
+++ b/input/sum/Makefile.am
@@ -0,0 +1,8 @@
+AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
+
+pkglibexec_LTLIBRARIES = ulogd_inpflow_NFACCT.la
+
+ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
+ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
+ulogd_inpflow_NFACCT_la_CFLAGS = $(AM_CFLAGS) $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_CFLAGS)
diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NFACCT.c
new file mode 100644
index 0000000..152cd48
--- /dev/null
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -0,0 +1,265 @@
+/* ulogd_input_NFACCT.c
+ *
+ * ulogd input plugin for nfacct
+ *
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012 by Intra2net AG <http://www.intra2net.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+#include <sys/time.h>
+#include <time.h>
+#include <netinet/in.h>
+
+#include <ulogd/ulogd.h>
+#include <ulogd/timer.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_acct/libnetfilter_acct.h>
+
+struct nfacct_pluginstance {
+	struct mnl_socket	*nl;
+	uint32_t		portid;
+	uint32_t		seq;
+	struct ulogd_fd		ufd;
+	struct ulogd_timer	timer;
+};
+
+static struct config_keyset nfacct_kset = {
+	.ces = {
+		{
+			.key	 = "pollinterval",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+	},
+	.num_ces = 1,
+};
+#define pollint_ce(x)	(x->ces[0])
+
+enum ulogd_nfacct_keys {
+	ULOGD_NFACCT_NAME,
+	ULOGD_NFACCT_PKTS,
+	ULOGD_NFACCT_BYTES,
+};
+
+static struct ulogd_key nfacct_okeys[] = {
+	[ULOGD_NFACCT_NAME] = {
+		.type	= ULOGD_RET_STRING,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "sum.name",
+	},
+	[ULOGD_NFACCT_PKTS] = {
+		.type	= ULOGD_RET_UINT64,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "sum.pkts",
+	},
+	[ULOGD_NFACCT_BYTES] = {
+		.type	= ULOGD_RET_UINT64,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "sum.bytes",
+	},
+};
+
+static void
+propagate_nfacct(struct ulogd_pluginstance *upi, struct nfacct *nfacct)
+{
+	struct ulogd_key *ret = upi->output.keys;
+
+	okey_set_ptr(&ret[ULOGD_NFACCT_NAME],
+			(void *)nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+	okey_set_u64(&ret[ULOGD_NFACCT_PKTS],
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
+	okey_set_u64(&ret[ULOGD_NFACCT_BYTES],
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
+
+	ulogd_propagate_results(upi);
+}
+
+static void
+do_propagate_nfacct(struct ulogd_pluginstance *upi, struct nfacct *nfacct)
+{
+	struct ulogd_pluginstance *npi = NULL;
+
+	llist_for_each_entry(npi, &upi->plist, plist)
+		propagate_nfacct(npi, nfacct);
+
+	propagate_nfacct(upi, nfacct);
+}
+
+static int nfacct_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfacct *nfacct;
+	struct ulogd_pluginstance *upi = data;
+
+	nfacct = nfacct_alloc();
+	if (nfacct == NULL) {
+		ulogd_log(ULOGD_ERROR, "OOM");
+		goto err;
+	}
+
+	if (nfacct_nlmsg_parse_payload(nlh, nfacct) < 0) {
+		ulogd_log(ULOGD_ERROR, "Error parsing nfacct message");
+		goto err_free;
+	}
+
+	do_propagate_nfacct(upi, nfacct);
+
+err_free:
+	nfacct_free(nfacct);
+err:
+	return MNL_CB_OK;
+}
+
+static int nfacct_read_cb(int fd, unsigned int what, void *param)
+{
+	int ret;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct ulogd_pluginstance *upi = param;
+	struct nfacct_pluginstance *cpi =
+		(struct nfacct_pluginstance *) upi->private;
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	ret = mnl_socket_recvfrom(cpi->nl, buf, sizeof(buf));
+	if (ret > 0) {
+		ret = mnl_cb_run(buf, ret, cpi->seq,
+				 cpi->portid, nfacct_cb, upi);
+	}
+	return ret;
+}
+
+static int nfacct_send_request(struct nfacct_pluginstance *cpi)
+{
+	struct nlmsghdr *nlh;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+
+	cpi->seq = time(NULL);
+	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_GET_CTRZERO,
+				     NLM_F_DUMP, cpi->seq);
+
+	if (mnl_socket_sendto(cpi->nl, nlh, nlh->nlmsg_len) < 0) {
+		ulogd_log(ULOGD_ERROR, "Cannot send netlink message\n");
+		return -1;
+	}
+	return 0;
+}
+
+static void polling_timer_cb(struct ulogd_timer *t, void *data)
+{
+	struct ulogd_pluginstance *upi = data;
+	struct nfacct_pluginstance *cpi =
+		(struct nfacct_pluginstance *)upi->private;
+
+	nfacct_send_request(cpi);
+
+	ulogd_add_timer(&cpi->timer, pollint_ce(upi->config_kset).u.value);
+}
+
+static int configure_nfacct(struct ulogd_pluginstance *upi,
+			    struct ulogd_pluginstance_stack *stack)
+{
+	int ret;
+
+	ret = config_parse_file(upi->id, upi->config_kset);
+	if (ret < 0)
+		return ret;
+
+	if (pollint_ce(upi->config_kset).u.value <= 0) {
+		ulogd_log(ULOGD_FATAL, "You have to set pollint\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int constructor_nfacct(struct ulogd_pluginstance *upi)
+{
+	struct nfacct_pluginstance *cpi =
+		(struct nfacct_pluginstance *)upi->private;
+
+	if (pollint_ce(upi->config_kset).u.value == 0)
+		return -1;
+
+	cpi->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (cpi->nl == NULL) {
+		ulogd_log(ULOGD_FATAL, "cannot open netlink socket\n");
+		return -1;
+	}
+
+	if (mnl_socket_bind(cpi->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		ulogd_log(ULOGD_FATAL, "cannot bind netlink socket\n");
+		return -1;
+	}
+	cpi->portid = mnl_socket_get_portid(cpi->nl);
+
+	cpi->ufd.fd = mnl_socket_get_fd(cpi->nl);
+	cpi->ufd.cb = &nfacct_read_cb;
+	cpi->ufd.data = upi;
+	cpi->ufd.when = ULOGD_FD_READ;
+
+	ulogd_register_fd(&cpi->ufd);
+	ulogd_init_timer(&cpi->timer, upi, polling_timer_cb);
+	ulogd_add_timer(&cpi->timer,
+			 pollint_ce(upi->config_kset).u.value);
+
+	return 0;
+}
+
+static int destructor_nfacct(struct ulogd_pluginstance *upi)
+{
+	struct nfacct_pluginstance *cpi = (void *)upi->private;
+
+	ulogd_del_timer(&cpi->timer);
+	ulogd_unregister_fd(&cpi->ufd);
+	mnl_socket_close(cpi->nl);
+
+	return 0;
+}
+
+static void signal_nfacct(struct ulogd_pluginstance *upi, int signal)
+{
+	struct nfacct_pluginstance *cpi =
+		(struct nfacct_pluginstance *)upi->private;
+
+	switch (signal) {
+	case SIGUSR2:
+		nfacct_send_request(cpi);
+		break;
+	}
+}
+
+static struct ulogd_plugin nfacct_plugin = {
+	.name = "NFACCT",
+	.input = {
+		.type = ULOGD_DTYPE_SOURCE,
+	},
+	.output = {
+		.keys = nfacct_okeys,
+		.num_keys = ARRAY_SIZE(nfacct_okeys),
+		.type = ULOGD_DTYPE_FLOW,
+	},
+	.config_kset	= &nfacct_kset,
+	.interp		= NULL,
+	.configure	= &configure_nfacct,
+	.start		= &constructor_nfacct,
+	.stop		= &destructor_nfacct,
+	.signal		= &signal_nfacct,
+	.priv_size	= sizeof(struct nfacct_pluginstance),
+	.version	= ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&nfacct_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index c0c8559..71e8255 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -49,6 +49,7 @@ plugin="@pkglibexecdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibexecdir@/ulogd_output_MYSQL.so"
 #plugin="@pkglibexecdir@/ulogd_output_DBI.so"
 plugin="@pkglibexecdir@/ulogd_raw2packet_BASE.so"
+plugin="@pkglibexecdir@/ulogd_inpflow_NFACCT.so"
 
 # this is a stack for logging packet send by system via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
@@ -107,6 +108,9 @@ plugin="@pkglibexecdir@/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging in NACCT compatible format
 #stack=ct1:NFCT,ip2str1:IP2STR,nacct1:NACCT
 
+# this is a stack for accounting-based logging via GPRINT
+#stack=acct1:NFACCT,gp1:GPRINT
+
 [ct1]
 #netlink_socket_buffer_size=217088
 #netlink_socket_buffer_maxsize=1085440
@@ -250,3 +254,6 @@ sync = 1
 
 [mark1]
 mark = 1
+
+[acct1]
+pollinterval = 2
-- 
1.7.7.3

