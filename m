From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log RFC PATCH 1/2] introduce new functions to use without
 nflog_handle
Date: Mon, 10 Aug 2015 17:15:54 +0900
Message-ID: <20150810081553.GC25169@gmail.com>
References: <20150810081342.GB25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36483 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbHJIP7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 04:15:59 -0400
Received: by pacrr5 with SMTP id rr5so98651978pac.3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2015 01:15:58 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id fk7sm4301143pdb.75.2015.08.10.01.15.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2015 01:15:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150810081342.GB25169@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 Make_global.am                              |  2 +-
 configure.ac                                |  1 +
 include/libnetfilter_log/libnetfilter_log.h |  6 ++
 src/Makefile.am                             |  4 +-
 src/libnetfilter_log.c                      | 43 ++++++++++++++
 src/nlmsg.c                                 | 89 +++++++++++++++++++++++++++++
 6 files changed, 142 insertions(+), 3 deletions(-)
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
index 7812877..044f406 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -11,6 +11,7 @@
 
 #include <stdint.h>
 #include <sys/types.h>
+#include <linux/netlink.h>
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
 struct nflog_handle;
@@ -82,4 +83,9 @@ enum {
 
 extern int nflog_snprintf_xml(char *buf, size_t len, struct nflog_data *tb, int flags);
 
+extern struct nflog_data *nflog_data_alloc(void);
+extern void nflog_data_free(struct nflog_data *nfad);
+extern int nflog_nlmsg_parse_attrs(const struct nlmsghdr *nlh, struct nlattr **attr);
+extern int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nflog_data *nfad);
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
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index e92576b..422c550 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -26,6 +26,7 @@
 #include <errno.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
+#include <linux/netlink.h>
 
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
@@ -1067,5 +1068,47 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
 }
 
 /**
+ * nflog_data_alloc - allocate a new nflog data
+ *
+ * In case of success, this function returns a valid pointer to a memory blob,
+ * otherwise NULL is returned and errno is set appropiately.
+ */
+struct nflog_data *nflog_data_alloc(void)
+{
+	struct nflog_data *nfad = calloc(1, sizeof(struct nflog_data));
+	if (nfad == NULL)
+		return NULL;
+	nfad->nfa = (struct nfattr **)calloc(NFULA_MAX + 1,
+					     sizeof(struct nlattr *));
+	if (nfad->nfa == NULL) {
+		free(nfad);
+		return NULL;
+	}
+	return nfad;
+}
+
+/**
+ * nflog_data_free - release a nflog data
+ * \param nfad pointer to the nflog data
+ */
+void nflog_data_free(struct nflog_data *nfad)
+{
+	free(nfad->nfa);
+	free(nfad);
+}
+
+/**
+ * nflog_nlmsg_parse - set packet attributes from netlink message
+ * \param nlh netlink message that you want to read.
+ * \param attr pointer to the nflog_data which is allocate by nflog_data_alloc
+ *
+ * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
+ * success.
+ */
+int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nflog_data *nfad)
+{
+	return nflog_nlmsg_parse_attrs(nlh, (struct nlattr **)&nfad->nfa[-1]);
+}
+/**
  * @}
  */
diff --git a/src/nlmsg.c b/src/nlmsg.c
new file mode 100644
index 0000000..8611b9d
--- /dev/null
+++ b/src/nlmsg.c
@@ -0,0 +1,89 @@
+/*
+ * (C) 2015 by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/netfilter/nfnetlink_log.h>
+#include <libmnl/libmnl.h>
+
+/**
+ * \defgroup nlmsg Netlink message helper functions
+ * @{
+ */
+
+static int nflog_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
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
+ * nflog_nlmsg_parse_attrs - set nlattrs from netlink message
+ * \param nlh netlink message that you want to read.
+ * \param attr pointer to the array of nlattr which size is NFULA_MAX + 1
+ *
+ * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
+ * success.
+ */
+int nflog_nlmsg_parse_attrs(const struct nlmsghdr *nlh, struct nlattr **attr)
+{
+	return mnl_attr_parse(nlh, sizeof(struct nfgenmsg),
+			      nflog_pkt_parse_attr_cb, attr);
+}
+/**
+ * @}
+ */
-- 
2.1.4

