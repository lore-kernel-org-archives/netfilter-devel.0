From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] common: get rid of nftnl_batch_build_hdr()
Date: Wed, 15 Feb 2017 11:43:34 +0100
Message-ID: <1487155416-7337-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbdBOKnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 05:43:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30044170D33
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F437DA801
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01DBDDA84F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:45 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add __nftnl_nlmsg_build_hdr() so nftnl_batch_build_hdr() and
nftnl_nlmsg_build_hdr() share the same code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/common.h |  4 ++--
 src/common.c              | 41 ++++++++++++++++++-----------------------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index b9c6ff3e2e54..f67f1866560f 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -41,8 +41,8 @@ enum nftnl_parse_type {
 
 struct nftnl_parse_err;
 
-struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-				     uint16_t type, uint32_t seq);
+struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t type, uint16_t family,
+				       uint16_t flags, uint32_t seq);
 
 struct nftnl_parse_err *nftnl_parse_err_alloc(void);
 void nftnl_parse_err_free(struct nftnl_parse_err *);
diff --git a/src/common.c b/src/common.c
index 8b001fe8da97..0f23785e05d3 100644
--- a/src/common.c
+++ b/src/common.c
@@ -22,24 +22,33 @@
 #include <errno.h>
 #include "internal.h"
 
-struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
-				     uint16_t type, uint32_t seq)
+static struct nlmsghdr *__nftnl_nlmsg_build_hdr(char *buf, uint16_t type,
+						uint16_t family,
+						uint16_t flags, uint32_t seq,
+						uint16_t res_id)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
 
 	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | cmd;
-	nlh->nlmsg_flags = NLM_F_REQUEST | type;
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
 	nlh->nlmsg_seq = seq;
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
 	nfh->nfgen_family = family;
 	nfh->version = NFNETLINK_V0;
-	nfh->res_id = 0;
+	nfh->res_id = res_id;
 
 	return nlh;
 }
+
+struct nlmsghdr *nftnl_nlmsg_build_hdr(char *buf, uint16_t type, uint16_t family,
+				       uint16_t flags, uint32_t seq)
+{
+	return __nftnl_nlmsg_build_hdr(buf, (NFNL_SUBSYS_NFTABLES << 8) | type,
+				       family, flags, seq, 0);
+}
 EXPORT_SYMBOL(nftnl_nlmsg_build_hdr);
 
 struct nftnl_parse_err *nftnl_parse_err_alloc(void)
@@ -156,31 +165,17 @@ int nftnl_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
 			   nftnl_cmd_footer_fprintf_cb);
 }
 
-static void nftnl_batch_build_hdr(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_UNSPEC;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
 void nftnl_batch_begin(char *buf, uint32_t seq)
 {
-	nftnl_batch_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, seq);
+	__nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, AF_UNSPEC, 0, seq,
+				NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL(nftnl_batch_begin);
 
 void nftnl_batch_end(char *buf, uint32_t seq)
 {
-	nftnl_batch_build_hdr(buf, NFNL_MSG_BATCH_END, seq);
+	__nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_END, AF_UNSPEC, 0, seq,
+				NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL(nftnl_batch_end);
 
-- 
2.1.4

