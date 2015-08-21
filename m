From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log PATCHv2 2/3] utils: take a example from libmnl and use new
 functions
Date: Fri, 21 Aug 2015 09:27:40 +0900
Message-ID: <20150821002739.GC11754@gmail.com>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
 <20150820181613.GA4227@salvia>
 <20150821002306.GA11754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34450 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbHUA1p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 20:27:45 -0400
Received: by pdbfa8 with SMTP id fa8so19826077pdb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 17:27:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150821002306.GA11754@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 utils/.gitignore  |   1 +
 utils/Makefile.am |   6 ++-
 utils/nf-log.c    | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 utils/nf-log.c

diff --git a/utils/.gitignore b/utils/.gitignore
index 64e4588..01fa66d 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -1,2 +1,3 @@
 /nfulnl_test
 /ulog_test
+/nf-log
diff --git a/utils/Makefile.am b/utils/Makefile.am
index f961b6c..dfe5f34 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,11 +1,15 @@
 include ${top_srcdir}/Make_global.am
 
-check_PROGRAMS = nfulnl_test
+check_PROGRAMS = nfulnl_test nf-log
 
 nfulnl_test_SOURCES = nfulnl_test.c
 nfulnl_test_LDADD = ../src/libnetfilter_log.la
 nfulnl_test_LDFLAGS = -dynamic
 
+nf_log_SOURCES = nf-log.c
+nf_log_LDADD = ../src/libnetfilter_log.la
+nf_log_LDFLAGS = -dynamic -lmnl
+
 if BUILD_IPULOG
 check_PROGRAMS += ulog_test
 
diff --git a/utils/nf-log.c b/utils/nf-log.c
new file mode 100644
index 0000000..d575b77
--- /dev/null
+++ b/utils/nf-log.c
@@ -0,0 +1,131 @@
+/* This example is placed in the public domain. */
+#include <stdio.h>
+#include <stdlib.h>
+#include <arpa/inet.h>
+
+#include <linux/netfilter/nfnetlink_log.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+
+static int log_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *attrs[NFULA_MAX + 1] = { NULL };
+	struct nfulnl_msg_packet_hdr *ph = NULL;
+	const char *prefix = NULL;
+	uint32_t mark = 0;
+	int ret;
+
+	ret = nflog_nlmsg_parse(nlh, attrs);
+	if (ret != MNL_CB_OK)
+		return ret;
+
+	if (attrs[NFULA_PACKET_HDR])
+		ph = mnl_attr_get_payload(attrs[NFULA_PACKET_HDR]);
+	if (attrs[NFULA_PREFIX])
+		prefix = mnl_attr_get_str(attrs[NFULA_PREFIX]);
+	if (attrs[NFULA_MARK])
+		mark = ntohl(mnl_attr_get_u32(attrs[NFULA_MARK]));
+
+	printf("log received (prefix=\"%s\" hw=0x%04x hook=%u mark=%u)\n",
+		prefix ? prefix : "", ntohs(ph->hw_protocol), ph->hook,
+		mark);
+
+	return MNL_CB_OK;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+	unsigned int portid, qnum;
+
+	if (argc != 2) {
+		printf("Usage: %s [queue_num]\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	qnum = atoi(argv[1]);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	/* kernels 3.8 and later is required to omit PF_(UN)BIND */
+
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_INET, 0);
+	if (nflog_attr_put_cfg_cmd(nlh, NFULNL_CFG_CMD_PF_UNBIND) < 0) {
+		perror("nflog_attr_put_cfg_cmd");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_INET, 0);
+	if (nflog_attr_put_cfg_cmd(nlh, NFULNL_CFG_CMD_PF_BIND) < 0) {
+		perror("nflog_attr_put_cfg_cmd");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_INET, qnum);
+	if (nflog_attr_put_cfg_cmd(nlh, NFULNL_CFG_CMD_BIND) < 0) {
+		perror("nflog_attr_put_cfg_cmd");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_UNSPEC, qnum);
+	if (nflog_attr_put_cfg_mode(nlh, NFULNL_COPY_PACKET, 0xffff) < 0) {
+		perror("nflog_attr_put_cfg_mode");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, 0, portid, log_cb, NULL);
+		if (ret < 0){
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		}
+
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	mnl_socket_close(nl);
+
+	return 0;
+}
-- 
2.1.4

