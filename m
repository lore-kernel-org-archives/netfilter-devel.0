From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/3] common: return nlmsghdr in nftnl_batch_{begin,end}()
Date: Wed, 15 Feb 2017 11:43:35 +0100
Message-ID: <1487155416-7337-2-git-send-email-pablo@netfilter.org>
References: <1487155416-7337-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751609AbdBOKnv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 05:43:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47F89170D23
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D9A8DA801
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ADE2DA84B
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:46 +0100 (CET)
In-Reply-To: <1487155416-7337-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Useful to append netlink attributes after the batch headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/common.h |  4 ++--
 src/common.c              | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/libnftnl/common.h b/include/libnftnl/common.h
index f67f1866560f..62c8f6b5e0a3 100644
--- a/include/libnftnl/common.h
+++ b/include/libnftnl/common.h
@@ -49,7 +49,7 @@ void nftnl_parse_err_free(struct nftnl_parse_err *);
 int nftnl_parse_perror(const char *str, struct nftnl_parse_err *err);
 
 int nftnl_batch_is_supported(void);
-void nftnl_batch_begin(char *buf, uint32_t seq);
-void nftnl_batch_end(char *buf, uint32_t seq);
+struct nlmsghdr *nftnl_batch_begin(char *buf, uint32_t seq);
+struct nlmsghdr *nftnl_batch_end(char *buf, uint32_t seq);
 
 #endif
diff --git a/src/common.c b/src/common.c
index 0f23785e05d3..a95883c19080 100644
--- a/src/common.c
+++ b/src/common.c
@@ -165,17 +165,17 @@ int nftnl_cmd_footer_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
 			   nftnl_cmd_footer_fprintf_cb);
 }
 
-void nftnl_batch_begin(char *buf, uint32_t seq)
+struct nlmsghdr *nftnl_batch_begin(char *buf, uint32_t seq)
 {
-	__nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, AF_UNSPEC, 0, seq,
-				NFNL_SUBSYS_NFTABLES);
+	return __nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_BEGIN, AF_UNSPEC,
+				       0, seq, NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL(nftnl_batch_begin);
 
-void nftnl_batch_end(char *buf, uint32_t seq)
+struct nlmsghdr *nftnl_batch_end(char *buf, uint32_t seq)
 {
-	__nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_END, AF_UNSPEC, 0, seq,
-				NFNL_SUBSYS_NFTABLES);
+	return __nftnl_nlmsg_build_hdr(buf, NFNL_MSG_BATCH_END, AF_UNSPEC,
+				       0, seq, NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL(nftnl_batch_end);
 
-- 
2.1.4

