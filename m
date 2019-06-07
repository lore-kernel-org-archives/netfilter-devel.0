Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1A7C28CC3
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21D420B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfFGJM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 05:12:57 -0400
Received: from mail.us.es ([193.147.175.20]:36914 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfFGJM5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 05:12:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5326BAE8B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 11:12:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C65E2DA70B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 11:12:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BC16DDA708; Fri,  7 Jun 2019 11:12:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9577DDA70E;
        Fri,  7 Jun 2019 11:12:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 11:12:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6952E4265A5B;
        Fri,  7 Jun 2019 11:12:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 1/2] src: generation ID is 32-bit long
Date:   Fri,  7 Jun 2019 11:12:48 +0200
Message-Id: <20190607091249.12276-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update mnl_genid_get() to return 32-bit long generation ID. Add
nft_genid_u16() which allows us to catch ruleset updates from the
netlink dump path via 16-bit long nfnetlink resource ID field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h      |  2 +-
 include/nftables.h |  2 +-
 src/mnl.c          | 11 ++++++++---
 src/rule.c         |  5 ++---
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 9f50c3da0f3a..eeba7379706f 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -10,7 +10,7 @@ struct mnl_socket *nft_mnl_socket_open(void);
 struct mnl_socket *nft_mnl_socket_reopen(struct mnl_socket *nf_sock);
 
 uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
-uint16_t mnl_genid_get(struct netlink_ctx *ctx);
+uint32_t mnl_genid_get(struct netlink_ctx *ctx);
 
 struct mnl_err {
 	struct list_head	head;
diff --git a/include/nftables.h b/include/nftables.h
index af2c1ea16cfb..b7c78572da77 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -78,7 +78,7 @@ static inline bool nft_output_numeric_symbol(const struct output_ctx *octx)
 }
 
 struct nft_cache {
-	uint16_t		genid;
+	uint32_t		genid;
 	struct list_head	list;
 	uint32_t		seqnum;
 	uint32_t		cmd;
diff --git a/src/mnl.c b/src/mnl.c
index c0df2c941d88..e0856493909d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -108,7 +108,7 @@ nft_mnl_talk(struct netlink_ctx *ctx, const void *data, unsigned int len,
 /*
  * Rule-set consistency check across several netlink dumps
  */
-static uint16_t nft_genid;
+static uint32_t nft_genid;
 
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -119,7 +119,7 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-uint16_t mnl_genid_get(struct netlink_ctx *ctx)
+uint32_t mnl_genid_get(struct netlink_ctx *ctx)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -131,11 +131,16 @@ uint16_t mnl_genid_get(struct netlink_ctx *ctx)
 	return nft_genid;
 }
 
+static uint16_t nft_genid_u16(uint32_t nft_genid)
+{
+	return nft_genid & 0xffff;
+}
+
 static int check_genid(const struct nlmsghdr *nlh)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 
-	if (nft_genid != ntohs(nfh->res_id)) {
+	if (nft_genid_u16(nft_genid) != ntohs(nfh->res_id)) {
 		errno = EINTR;
 		return -1;
 	}
diff --git a/src/rule.c b/src/rule.c
index 1e081c8fe862..651454733bed 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -244,8 +244,6 @@ static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 
 int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 {
-	uint16_t genid;
-	int ret;
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
 		.nft		= nft,
@@ -253,7 +251,8 @@ int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 		.nft		= nft,
 	};
 	struct nft_cache *cache = &nft->cache;
-
+	uint32_t genid;
+	int ret;
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-- 
2.11.0

