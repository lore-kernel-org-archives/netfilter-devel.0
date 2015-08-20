From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log PATCH 1/2] introduce new functions independent from
 libnfnetlink
Date: Thu, 20 Aug 2015 16:29:25 +0900
Message-ID: <20150820072925.GB3916@gmail.com>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34887 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbHTH3b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 03:29:31 -0400
Received: by pacdd16 with SMTP id dd16so13703623pac.2
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 00:29:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150820072645.GA3916@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libnetfilter_log.c file contains the old API, its use is
discouraged since it depends on libnfnetlink.

The idea is to provide a set of helper functions that we can use in
conjunction with libmnl, similar to what we have in
libnetfilter_queue/nlmsg.c

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 Make_global.am                              |   2 +-
 configure.ac                                |   1 +
 include/libnetfilter_log/libnetfilter_log.h |   7 ++
 src/Makefile.am                             |   4 +-
 src/nlmsg.c                                 | 161 ++++++++++++++++++++++++++++
 5 files changed, 172 insertions(+), 3 deletions(-)
 create mode 100644 src/nlmsg.c

diff --git a/Make_global.am b/Make_global.am
index a4e9bd9..9bc8ea1 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
-AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS}
+AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
 AM_CFLAGS = -Wall
diff --git a/configure.ac b/configure.ac
index cdcbc90..ead9399 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,6 +30,7 @@ AM_CONDITIONAL([BUILD_IPULOG], [test "x$with_ipulog" != xno])
 
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
+PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 dnl Output the makefile
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 7812877..723d812 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -11,6 +11,7 @@
 
 #include <stdint.h>
 #include <sys/types.h>
+#include <linux/netlink.h>
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
 struct nflog_handle;
@@ -82,4 +83,10 @@ enum {
 
 extern int nflog_snprintf_xml(char *buf, size_t len, struct nflog_data *tb, int flags);
 
+extern struct nlmsghdr *
+nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum);
+extern int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range);
+extern int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd);
+extern int nfnl_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
+
 #endif	/* __LIBNETFILTER_LOG_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 33933a4..aa56152 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -26,8 +26,8 @@ lib_LTLIBRARIES = libnetfilter_log.la
 
 libnetfilter_log_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink	\
 			      -version-info $(LIBVERSION)
-libnetfilter_log_la_SOURCES = libnetfilter_log.c 
-libnetfilter_log_la_LIBADD  = ${LIBNFNETLINK_LIBS}
+libnetfilter_log_la_SOURCES = libnetfilter_log.c nlmsg.c
+libnetfilter_log_la_LIBADD  = ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
 
 if BUILD_IPULOG
 lib_LTLIBRARIES += libnetfilter_log_libipulog.la
diff --git a/src/nlmsg.c b/src/nlmsg.c
new file mode 100644
index 0000000..5c133fa
--- /dev/null
+++ b/src/nlmsg.c
@@ -0,0 +1,161 @@
+/*
+ * (C) 2015 by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <arpa/inet.h>
+#include <linux/netfilter/nfnetlink_log.h>
+#include <libmnl/libmnl.h>
+
+/**
+ * \defgroup nlmsg Netlink message helper functions
+ * @{
+ */
+
+/**
+ * nfnl_nlmsg_put_header - reserve and prepare room for nflog Netlink header
+ * \param buf memory already allocated to store the Netlink header
+ * \param type message type one of the enum nfulnl_msg_types
+ * \param family protocol family to be an object of
+ * \param qnum queue number to be an object of
+ *
+ * This function creates Netlink header in the memory buffer passed
+ * as parameter that will send to nfnetlink log. This function
+ * returns a pointer to the Netlink header structure.
+ */
+struct nlmsghdr *
+nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	struct nfgenmsg *nfg;
+
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = family;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(qnum);
+
+	return nlh;
+}
+
+/**
+ * nfnl_attr_put_cfg_mode - add a mode attribute to nflog netlink message
+ * \param nlh pointer to the netlink message
+ * \param mode copy mode defined in linux/netfilter/nfnetlink_log.h
+ * \param range copy range
+ *
+ * this function returns -1 and errno is explicitly set. On success, this
+ * function returns 1.
+ */
+int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
+{
+	struct nfulnl_msg_config_mode nfmode = {
+		.copy_mode = mode,
+		.copy_range = htonl(range)
+	};
+
+	mnl_attr_put(nlh, NFULA_CFG_MODE, sizeof(nfmode), &nfmode);
+
+	/* it may returns -1 in future */
+	return 1;
+}
+
+/**
+ * nfnl_attr_put_cfg_cmd - add a cmd attribute to nflog netlink message
+ * \param nlh pointer to the netlink message
+ * \param cmd command one of the enum nfulnl_msg_config_cmds
+ *
+ * this function returns -1 and errno is explicitly set. On success, this
+ * function returns 1.
+ */
+int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd)
+{
+	struct nfulnl_msg_config_cmd nfcmd = {
+		.command = cmd
+	};
+
+	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(nfcmd), &nfcmd);
+
+	/* it may returns -1 in future */
+	return 1;
+}
+
+static int nfnl_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	/* skip unsupported attribute in user-space */
+	if (mnl_attr_type_valid(attr, NFULA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFULA_HWTYPE:		/* hardware type */
+	case NFULA_HWLEN:		/* hardware header length */
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NFULA_MARK:		/* __u32 nfmark */
+	case NFULA_IFINDEX_INDEV:	/* __u32 ifindex */
+	case NFULA_IFINDEX_OUTDEV:	/* __u32 ifindex */
+	case NFULA_IFINDEX_PHYSINDEV:	/* __u32 ifindex */
+	case NFULA_IFINDEX_PHYSOUTDEV:	/* __u32 ifindex */
+	case NFULA_UID:			/* user id of socket */
+	case NFULA_SEQ:			/* instance-local sequence number */
+	case NFULA_SEQ_GLOBAL:		/* global sequence number */
+	case NFULA_GID:			/* group id of socket */
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NFULA_PACKET_HDR:
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfulnl_msg_packet_hdr)) < 0) {
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_TIMESTAMP:		/* nfulnl_msg_packet_timestamp */
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfulnl_msg_packet_timestamp)) < 0) {
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_HWADDR:		/* nfulnl_msg_packet_hw */
+		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
+		    sizeof(struct nfulnl_msg_packet_hw)) < 0) {
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFULA_PREFIX:		/* string prefix */
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			return MNL_CB_ERROR;
+		break;
+	case NFULA_HWHEADER:		/* hardware header */
+	case NFULA_PAYLOAD:		/* opaque data payload */
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+/**
+ * nfnl_nlmsg_parse - set nlattrs from netlink message
+ * \param nlh netlink message that you want to read.
+ * \param attr pointer to the array of nlattr which size is NFULA_MAX + 1
+ *
+ * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
+ * success.
+ */
+int nfnl_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
+{
+	return mnl_attr_parse(nlh, sizeof(struct nfgenmsg),
+			      nfnl_parse_attr_cb, attr);
+}
+
+/**
+ * @}
+ */
-- 
2.1.4

