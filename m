From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and use
 nflog_nlmsg_parse
Date: Mon, 10 Aug 2015 17:17:53 +0900
Message-ID: <20150810081752.GD25169@gmail.com>
References: <20150810081342.GB25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34607 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbbHJIR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 04:17:58 -0400
Received: by pawu10 with SMTP id u10so135283812paw.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2015 01:17:57 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id cr4sm18990191pac.10.2015.08.10.01.17.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2015 01:17:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150810081342.GB25169@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 utils/Makefile.am |   6 +-
 utils/nf-log.c    | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 utils/nf-log.c

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
index 0000000..ab9ac70
--- /dev/null
+++ b/utils/nf-log.c
@@ -0,0 +1,178 @@
+/* This example is placed in the public domain. */
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+#include <arpa/inet.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_log.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+
+static int log_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nflog_data *nfad;
+	struct nfulnl_msg_packet_hdr *ph = NULL;
+	const char *prefix = NULL;
+	uint32_t mark = 0;
+	int ret;
+
+	nfad = nflog_data_alloc();
+	if (nfad == NULL)
+		return MNL_CB_ERROR;
+	ret = nflog_nlmsg_parse(nlh, nfad);
+	if (ret != MNL_CB_OK)
+		return ret;
+
+	ph = nflog_get_msg_packet_hdr(nfad);
+	prefix = nflog_get_prefix(nfad);
+	mark = nflog_get_nfmark(nfad);
+
+	printf("log received (prefix=\"%s\" hw=0x%04x hook=%u mark=%u)\n",
+		prefix ? prefix : "", ntohs(ph->hw_protocol), ph->hook,
+		mark);
+
+	return MNL_CB_OK;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_pf_request(char *buf, uint8_t command)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+
+	struct nfulnl_msg_config_cmd cmd = {
+		.command = command,
+	};
+	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_request(char *buf, uint8_t command, int qnum)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(qnum);
+
+	struct nfulnl_msg_config_cmd cmd = {
+		.command = command,
+	};
+	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
+nflog_build_cfg_params(char *buf, uint8_t mode, int range, int qnum)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(qnum);
+
+	struct nfulnl_msg_config_mode params = {
+		.copy_range = htonl(range),
+		.copy_mode = mode,
+	};
+	mnl_attr_put(nlh, NFULA_CFG_MODE, sizeof(params), &params);
+
+	return nlh;
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
+	nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_UNBIND);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_build_cfg_pf_request(buf, NFULNL_CFG_CMD_PF_BIND);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_build_cfg_request(buf, NFULNL_CFG_CMD_BIND, qnum);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = nflog_build_cfg_params(buf, NFULNL_COPY_PACKET, 0xFFFF, qnum);
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

