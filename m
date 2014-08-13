From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 libnftnl] common: add batching interfaces
Date: Wed, 13 Aug 2014 18:54:56 +0200
Message-ID: <1407948898-8495-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaHMQyl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:54:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the following new interfaces:

 int nft_batch_is_supported(void);
 void nft_batch_begin(char *buf, uint32_t seq);
 void nft_batch_end(char *buf, uint32_t seq);

Quite likely this is going to be reused by third party applications
requiring to put things in the batch. We already have potential clients
for this code in nft and iptables-compat.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/common.h |    7 ++++
 src/common.c              |   89 +++++++++++++++++++++++++++++++++++++++++++++
 src/libnftnl.map          |    3 ++
 3 files changed, 99 insertions(+)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index 04d2906..2b498d4 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -36,4 +36,11 @@ struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 struct nft_parse_err *nft_parse_err_alloc(void);
 void nft_parse_err_free(struct nft_parse_err *);
 int nft_parse_perror(const char *str, struct nft_parse_err *err);
+
+struct mnl_socket;
+
+int nft_batch_is_supported(void);
+void nft_batch_begin(char *buf, uint32_t seq);
+void nft_batch_end(char *buf, uint32_t seq);
+
 #endif
diff --git a/src/common.c b/src/common.c
index 1b600f1..a571fe7 100644
--- a/src/common.c
+++ b/src/common.c
@@ -9,12 +9,15 @@
 
 #include <stdlib.h>
 #include <sys/socket.h>
+#include <time.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
+#include <libnftnl/set.h>
 
+#include <errno.h>
 #include "internal.h"
 
 struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
@@ -137,6 +140,34 @@ int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
 	}
 }
 
+static void nft_batch_build_hdr(char *buf, uint16_t type, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = seq;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+}
+
+void nft_batch_begin(char *buf, uint32_t seq)
+{
+	nft_batch_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, seq);
+}
+EXPORT_SYMBOL(nft_batch_begin);
+
+void nft_batch_end(char *buf, uint32_t seq)
+{
+	nft_batch_build_hdr(buf, NFNL_MSG_BATCH_END, seq);
+}
+EXPORT_SYMBOL(nft_batch_end);
+
 int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 {
 	char buf[32]; /* enough for the maximum string length above */
@@ -146,3 +177,61 @@ int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 
 	return fprintf(fp, "%s", buf);
 }
+
+int nft_batch_is_supported(void)
+{
+	struct mnl_socket *nl;
+	struct mnl_nlmsg_batch *b;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL)
+		return -1;
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		return -1;
+
+	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_batch_begin(mnl_nlmsg_batch_current(b), seq++);
+	mnl_nlmsg_batch_next(b);
+
+	nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(b),
+				NFT_MSG_NEWSET, AF_INET,
+				NLM_F_ACK, seq++);
+	mnl_nlmsg_batch_next(b);
+
+	nft_batch_end(mnl_nlmsg_batch_current(b), seq++);
+	mnl_nlmsg_batch_next(b);
+
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(b),
+				mnl_nlmsg_batch_size(b));
+	if (ret < 0)
+		goto err;
+
+	mnl_nlmsg_batch_stop(b);
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl),
+				 NULL, NULL);
+		if (ret <= 0)
+			break;
+
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	mnl_socket_close(nl);
+
+	/* We're sending an incomplete message to see if the kernel supports
+	 * set messages in batches. EINVAL means that we sent an incomplete
+	 * message with missing attributes. The kernel just ignores messages
+	 * that we cannot include in the batch.
+	 */
+	return (ret == -1 && errno == EINVAL) ? 1 : 0;
+err:
+	mnl_nlmsg_batch_stop(b);
+	return -1;
+}
+EXPORT_SYMBOL(nft_batch_is_supported);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index e8c634f..d8dcf8e 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -209,4 +209,7 @@ LIBNFTNL_1.1 {
 
 LIBNFTNL_1.2 {
   nft_set_elems_nlmsg_build_payload_iter;
+  nft_batch_is_supported;
+  nft_batch_begin;
+  nft_batch_end;
 } LIBNFTNL_1.1;
-- 
1.7.10.4

