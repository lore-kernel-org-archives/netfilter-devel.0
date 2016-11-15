From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCHv2 lnf-log] utils: nf-log: attaching a conntrack
 information
Date: Tue, 15 Nov 2016 16:38:16 +0900
Message-ID: <20161115073815.GB10113@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
 <20151015043544.GA18814@gmail.com>
 <20151015043925.GB18814@gmail.com>
 <20151016165908.GA5588@salvia>
 <20161115073602.GA10113@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35469 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbcKOHiV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 02:38:21 -0500
Received: by mail-pg0-f67.google.com with SMTP id p66so11151493pga.2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:38:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161115073602.GA10113@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables nf-log in utils directory to show conntrack
information if libnetfilter_conntrack exists.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>

diff --git a/configure.ac b/configure.ac
index ead9399..c914e00 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,7 +19,7 @@ AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-case "$host" in 
+case "$host" in
 *-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
@@ -31,6 +31,9 @@ AM_CONDITIONAL([BUILD_IPULOG], [test "x$with_ipulog" != xno])
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
+PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
+		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
+AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
 
 dnl Output the makefile
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
diff --git a/utils/Makefile.am b/utils/Makefile.am
index dfe5f34..a848b10 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -9,6 +9,10 @@ nfulnl_test_LDFLAGS = -dynamic
 nf_log_SOURCES = nf-log.c
 nf_log_LDADD = ../src/libnetfilter_log.la
 nf_log_LDFLAGS = -dynamic -lmnl
+if BUILD_NFCT
+nf_log_LDFLAGS += $(LIBNETFILTER_CONNTRACK_LIBS)
+nf_log_CFLAGS = -DBUILD_NFCT
+endif
 
 if BUILD_IPULOG
 check_PROGRAMS += ulog_test
diff --git a/utils/nf-log.c b/utils/nf-log.c
index 5f2a192..ad8369c 100644
--- a/utils/nf-log.c
+++ b/utils/nf-log.c
@@ -3,15 +3,108 @@
 #include <stdlib.h>
 #include <arpa/inet.h>
 
-#include <linux/netfilter/nfnetlink_log.h>
+#include <libnetfilter_log/linux_nfnetlink_log.h>
 
 #include <libmnl/libmnl.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 
+#ifdef BUILD_NFCT
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#endif
+
+#ifdef BUILD_NFCT
+static int print_ctinfo(const struct nlattr *const attr)
+{
+	uint32_t ctinfo;
+
+	if (attr == NULL)
+		return MNL_CB_OK;
+
+	ctinfo = ntohl(mnl_attr_get_u32(attr));
+	printf("  ip_conntrack_info:");
+
+	switch (CTINFO2DIR(ctinfo)) {
+	case IP_CT_DIR_ORIGINAL:
+		printf(" ORIGINAL /");
+		break;
+	case IP_CT_DIR_REPLY:
+		printf(" REPLY /");
+		break;
+	default:
+		printf(" unknown dir: %d\n", CTINFO2DIR(ctinfo));
+		return MNL_CB_ERROR;
+	}
+
+	switch (ctinfo) {
+	case IP_CT_ESTABLISHED:
+	case IP_CT_ESTABLISHED_REPLY:
+		printf(" ESTABLISHED\n");
+		break;
+	case IP_CT_RELATED:
+	case IP_CT_RELATED_REPLY:
+		printf(" RELATED\n");
+		break;
+	case IP_CT_NEW:
+	case IP_CT_NEW_REPLY:
+		printf(" NEW\n");
+		break;
+	default:
+		printf(" unknown ctinfo: %d\n", ctinfo);
+		return MNL_CB_ERROR;
+	}
+
+	return MNL_CB_OK;
+}
+
+static int print_nfct(uint8_t family,
+		      const struct nlattr *const info_attr,
+		      const struct nlattr *const ct_attr)
+{
+	char buf[4096];
+	struct nf_conntrack *ct = NULL;
+
+	if (info_attr != NULL)
+		print_ctinfo(info_attr);
+
+	if (ct_attr == NULL)
+		return MNL_CB_OK;
+
+	ct = nfct_new();
+	if (ct == NULL) {
+		perror("nfct_new");
+		return MNL_CB_ERROR;
+	}
+
+	if (nfct_payload_parse(mnl_attr_get_payload(ct_attr),
+			       mnl_attr_get_payload_len(ct_attr),
+			       family, ct) < 0) {
+		perror("nfct_payload_parse");
+		nfct_destroy(ct);
+		return MNL_CB_ERROR;
+	}
+
+	nfct_snprintf(buf, sizeof(buf), ct, 0, NFCT_O_DEFAULT, 0);
+	printf("  %s\n", buf);
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+#else
+static int print_nfct(uint8_t family,
+		      const struct nlattr *const info_attr,
+		      const struct nlattr *const ct_attr)
+{
+	return MNL_CB_OK;
+}
+#endif
+
 static int log_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *attrs[NFULA_MAX + 1] = { NULL };
 	struct nfulnl_msg_packet_hdr *ph = NULL;
+	struct nfgenmsg *nfg;
 	const char *prefix = NULL;
 	uint32_t mark = 0;
 	char buf[4096];
@@ -21,6 +114,8 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 	if (ret != MNL_CB_OK)
 		return ret;
 
+	nfg = mnl_nlmsg_get_payload(nlh);
+
 	if (attrs[NFULA_PACKET_HDR])
 		ph = mnl_attr_get_payload(attrs[NFULA_PACKET_HDR]);
 	if (attrs[NFULA_PREFIX])
@@ -38,6 +133,8 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 		return MNL_CB_ERROR;
 	printf("%s (ret=%d)\n", buf, ret);
 
+	print_nfct(nfg->nfgen_family, attrs[NFULA_CT_INFO], attrs[NFULA_CT]);
+
 	return MNL_CB_OK;
 }
 
@@ -108,6 +205,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+#ifdef BUILD_NFCT
+	mnl_attr_put_u16(nlh, NFULA_CFG_FLAGS, htons(NFULNL_CFG_F_CONNTRACK));
+#endif
+
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
 		perror("mnl_socket_sendto");
 		exit(EXIT_FAILURE);
-- 
2.1.4

