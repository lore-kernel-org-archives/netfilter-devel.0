From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: consistency checks across several netlink dumps
Date: Tue,  9 Sep 2014 19:00:15 +0200
Message-ID: <1410282015-12773-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59024 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbaIIQ7b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:59:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Obtain the generation ID before dumping the object lists. Then,
check for generation ID updates when dumping the several lists that
this needs. In case of interference, nft has to remove the stale
objects and retry from scratch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |    2 ++
 include/mnl.h                       |    1 +
 include/netlink.h                   |    1 +
 src/main.c                          |    1 +
 src/mnl.c                           |   51 +++++++++++++++++++++++++++++++++++
 src/netlink.c                       |    5 ++++
 6 files changed, 61 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e8b9d19..9f11558 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -50,6 +50,7 @@ enum nft_verdicts {
  * @NFT_MSG_NEWSETELEM: create a new set element (enum nft_set_elem_attributes)
  * @NFT_MSG_GETSETELEM: get a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_GENID: get the rule-set generation ID (no attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -67,6 +68,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_GENID,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/mnl.h b/include/mnl.h
index ed5a718..03d1876 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -6,6 +6,7 @@
 struct mnl_socket;
 
 uint32_t mnl_seqnum_alloc(void);
+void mnl_genid_get(struct mnl_socket *nf_sock);
 
 struct mnl_err {
 	struct list_head	head;
diff --git a/include/netlink.h b/include/netlink.h
index f611452..7f99370 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -139,6 +139,7 @@ extern void netlink_dump_set(struct nft_set *nls);
 extern int netlink_batch_send(struct list_head *err_list);
 
 extern void netlink_restart(void);
+extern void netlink_genid_get(void);
 extern void netlink_abi_error(void) __noreturn;
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
diff --git a/src/main.c b/src/main.c
index 04a98e3..2685b0d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -173,6 +173,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
+	netlink_genid_get();
 	mnl_batch_init();
 
 	batch_seqnum = mnl_batch_begin();
diff --git a/src/mnl.c b/src/mnl.c
index febf7c2..b01f517 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -22,6 +22,7 @@
 
 #include <mnl.h>
 #include <string.h>
+#include <arpa/inet.h>
 #include <errno.h>
 #include <utils.h>
 #include <nftables.h>
@@ -81,6 +82,41 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 }
 
 /*
+ * Rule-set consistency across several netlink dumps
+ */
+static uint16_t nft_genid;
+
+static int genid_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
+
+	nft_genid = ntohs(nfh->res_id);
+
+	return MNL_CB_OK;
+}
+
+void mnl_genid_get(struct mnl_socket *nf_sock)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_nlmsg_build_hdr(buf, NFT_MSG_GENID, AF_UNSPEC, 0, seq);
+	/* Skip error checking, old kernels sets res_id field to zero. */
+	nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, genid_cb, NULL);
+}
+
+static int check_genid(const struct nlmsghdr *nlh)
+{
+	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
+
+	if (nft_genid != ntohs(nfh->res_id)) {
+		errno = EINTR;
+		return -1;
+	}
+	return 0;
+}
+
+/*
  * Batching
  */
 
@@ -387,6 +423,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_rule_list *nlr_list = data;
 	struct nft_rule *r;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	r = nft_rule_alloc();
 	if (r == NULL)
 		memory_allocation_error();
@@ -494,6 +533,9 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_chain_list *nlc_list = data;
 	struct nft_chain *c;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	c = nft_chain_alloc();
 	if (c == NULL)
 		memory_allocation_error();
@@ -619,6 +661,9 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_table_list *nlt_list = data;
 	struct nft_table *t;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	t = nft_table_alloc();
 	if (t == NULL)
 		memory_allocation_error();
@@ -750,6 +795,9 @@ static int set_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_set_list *nls_list = data;
 	struct nft_set *s;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	s = nft_set_alloc();
 	if (s == NULL)
 		memory_allocation_error();
@@ -864,6 +912,9 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 {
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	nft_set_elems_nlmsg_parse(nlh, data);
 	return MNL_CB_OK;
 }
diff --git a/src/netlink.c b/src/netlink.c
index 7d3e71f..06c97e8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -75,6 +75,11 @@ void netlink_restart(void)
 	netlink_open_sock();
 }
 
+void netlink_genid_get(void)
+{
+	mnl_genid_get(nf_sock);
+}
+
 static void netlink_open_mon_sock(void)
 {
 	nf_mon_sock = nfsock_open();
-- 
1.7.10.4

