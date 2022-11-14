Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C8AC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 16:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbiKNQzV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 11:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238005AbiKNQzL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 11:55:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 924EC2FFC5
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 08:55:02 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] nft: replace nftnl_.*_nlmsg_build_hdr() by nftnl_nlmsg_build_hdr()
Date:   Mon, 14 Nov 2022 17:54:42 +0100
Message-Id: <20221114165442.72214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace alias to real nftnl_nlmsg_build_hdr() function call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-cache.c       | 16 ++++++++--------
 iptables/nft.c             | 12 ++++++------
 iptables/xtables-monitor.c |  2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 608e42a7aa01..d1e576553d98 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -141,8 +141,8 @@ static int fetch_table_cache(struct nft_handle *h)
 	char buf[16536];
 	int i, ret;
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
-					NLM_F_DUMP, h->seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
+				    NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nftnl_table_list_cb, h);
 	if (ret < 0 && errno == EINTR)
@@ -453,8 +453,8 @@ static int fetch_set_cache(struct nft_handle *h,
 		}
 	}
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
-					h->family, flags, h->seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
+				    h->family, flags, h->seq);
 
 	if (s) {
 		nftnl_set_nlmsg_build_payload(nlh, s);
@@ -496,8 +496,8 @@ static int __fetch_chain_cache(struct nft_handle *h,
 	struct nlmsghdr *nlh;
 	int ret;
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
-					  c ? NLM_F_ACK : NLM_F_DUMP, h->seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+				    c ? NLM_F_ACK : NLM_F_DUMP, h->seq);
 	if (c)
 		nftnl_chain_nlmsg_build_payload(nlh, c);
 
@@ -591,8 +591,8 @@ static int nft_rule_list_update(struct nft_chain *nc, void *data)
 	nftnl_rule_set_str(rule, NFTNL_RULE_CHAIN,
 			   nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
-					NLM_F_DUMP, h->seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
+				    NLM_F_DUMP, h->seq);
 	nftnl_rule_nlmsg_build_payload(nlh, rule);
 
 	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, &rld);
diff --git a/iptables/nft.c b/iptables/nft.c
index 09cb19c98732..1afd368b0a8b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2891,8 +2891,8 @@ static void nft_compat_table_batch_add(struct nft_handle *h, uint16_t type,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nftnl_table_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
-					type, h->family, flags, seq);
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
+				    type, h->family, flags, seq);
 	nftnl_table_nlmsg_build_payload(nlh, table);
 	nft_table_print_debug(h, table, nlh);
 }
@@ -2936,8 +2936,8 @@ static void nft_compat_chain_batch_add(struct nft_handle *h, uint16_t type,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nftnl_chain_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
-					type, h->family, flags, seq);
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
+				    type, h->family, flags, seq);
 	nftnl_chain_nlmsg_build_payload(nlh, chain);
 	nft_chain_print_debug(h, chain, nlh);
 }
@@ -2948,8 +2948,8 @@ static void nft_compat_rule_batch_add(struct nft_handle *h, uint16_t type,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nftnl_rule_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
-				       type, h->family, flags, seq);
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
+				    type, h->family, flags, seq);
 	nftnl_rule_nlmsg_build_payload(nlh, rule);
 	nft_rule_print_debug(h, rule, nlh);
 }
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index a1eba2f43407..cf2729d87968 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -227,7 +227,7 @@ static void trace_print_rule(const struct nftnl_trace *nlt, struct cb_arg *args)
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, 0, 0);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, 0, 0);
 
         nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
-- 
2.30.2

