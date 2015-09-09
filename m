From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-queue] examples: attaching a conntrack information
Date: Wed, 9 Sep 2015 18:58:51 +0900
Message-ID: <20150909095851.GD11843@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32959 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbIIJ65 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 05:58:57 -0400
Received: by pacex6 with SMTP id ex6so5972081pac.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2015 02:58:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150909095042.GA11843@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables nf-queue in examples directory to show conntrack
information if --enable-nfct configure option is specified.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 configure.ac         |   8 ++++
 examples/Makefile.am |   3 ++
 examples/nf-queue.c  | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 289868f..a11c1ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -28,6 +28,14 @@ esac
 dnl Dependencies
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.41])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
+AC_ARG_ENABLE(nfct,
+       AS_HELP_STRING([--enable-nfct], [Enable nfct integration in examples [default=no]]),
+       [enable_nfct=$enableval],[enable_nfct=no])
+AS_IF([test "x$enable_nfct" = "xyes"], [
+    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
+    AC_DEFINE([BUILD_NFCT], [1], [building nfct integration example])
+])
+AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
 
 dnl Output the makefiles
 AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
diff --git a/examples/Makefile.am b/examples/Makefile.am
index 1906697..5fa16dd 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -5,3 +5,6 @@ check_PROGRAMS = nf-queue
 nf_queue_SOURCES = nf-queue.c
 nf_queue_LDADD = ../src/libnetfilter_queue.la
 nf_queue_LDFLAGS = -dynamic -lmnl
+if BUILD_NFCT
+nf_queue_LDFLAGS += $(LIBNETFILTER_CONNTRACK_LIBS)
+endif
diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index d6c4b63..0cf86e7 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -15,6 +15,12 @@
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
+#include "../config.h"
+#ifdef BUILD_NFCT
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#endif
+
 static struct mnl_socket *nl;
 
 static struct nlmsghdr *
@@ -47,6 +53,91 @@ nfq_send_verdict(int queue_num, uint32_t id)
 	}
 }
 
+#ifdef BUILD_NFCT
+static int print_ctinfo(const struct nlattr *const attr)
+{
+	char *s = NULL;
+
+	if (attr == NULL)
+		return MNL_CB_OK;
+	attr->nla_len = 12;
+	switch (ntohl(mnl_attr_get_u32(attr))) {
+	case IP_CT_ESTABLISHED:
+		s = "IP_CT_ESTABLISHED";
+		break;
+	case IP_CT_RELATED:
+		s = "IP_CT_RELATED";
+		break;
+	case IP_CT_NEW:
+		s = "IP_CT_NEW";
+		break;
+	case IP_CT_IS_REPLY:
+		s = "IP_CT_IS_REPLY";
+		break;
+	/* case IP_CT_ESTABLISHED_REPLY: == IP_CT_IS_REPLY
+	 *	s = "IP_CT_ESTABLISHED_REPLY";
+	 *	break;
+	 */
+	case IP_CT_RELATED_REPLY:
+		s = "IP_CT_RELATED_REPLY";
+		break;
+	case IP_CT_NEW_REPLY:
+		s = "IP_CT_NEW_REPLY";
+		break;
+	/* case IP_CT_NUMBER: == IP_CT_NEW_REPLY
+	 *	s ="IP_CT_NUMBER";
+	 *	break;
+	 */
+	default:
+		return MNL_CB_ERROR;
+	}
+
+	printf("  ip_conntrack_info: %s\n", s);
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
 static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
@@ -98,6 +189,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 		printf(", checksum not ready");
 	puts(")");
 
+	print_nfct(nfg->nfgen_family, attr[NFQA_CT_INFO], attr[NFQA_CT]);
+
 	nfq_send_verdict(ntohs(nfg->res_id), id);
 
 	return MNL_CB_OK;
@@ -111,6 +204,7 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	int ret;
 	unsigned int portid, queue_num;
+	uint32_t flags = NFQA_CFG_F_GSO;
 
 	if (argc != 2) {
 		printf("Usage: %s [queue_num]\n", argv[0]);
@@ -164,8 +258,11 @@ int main(int argc, char *argv[])
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_params(nlh, NFQNL_COPY_PACKET, 0xffff);
 
-	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(NFQA_CFG_F_GSO));
-	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(NFQA_CFG_F_GSO));
+#ifdef BUILD_NFCT
+	flags |= NFQA_CFG_F_CONNTRACK;
+#endif
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
 		perror("mnl_socket_send");
-- 
2.1.4

