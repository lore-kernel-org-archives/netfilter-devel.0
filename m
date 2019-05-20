Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925E2C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 19:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC1720675
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 19:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfETTIf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 15:08:35 -0400
Received: from mail.us.es ([193.147.175.20]:38432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfETTIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 15:08:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BE28BAEE7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 21:08:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DB27DA70B
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 21:08:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4357CDA708; Mon, 20 May 2019 21:08:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 460DBDA702;
        Mon, 20 May 2019 21:08:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 21:08:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1D55D4265A32;
        Mon, 20 May 2019 21:08:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 5/6] nft: do not retry on EINTR
Date:   Mon, 20 May 2019 21:08:21 +0200
Message-Id: <20190520190822.18873-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520190822.18873-1-pablo@netfilter.org>
References: <20190520190822.18873-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch ab1cd3b510fa ("nft: ensure cache consistency") already handles
consistency via generation ID.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f6d407029892..9a3e9fdf4f12 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1383,7 +1383,6 @@ static int fetch_table_cache(struct nft_handle *h)
 	struct nftnl_table_list *list;
 	int ret;
 
-retry:
 	list = nftnl_table_list_alloc();
 	if (list == NULL)
 		return 0;
@@ -1392,11 +1391,9 @@ retry:
 					NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
-	if (ret < 0 && errno == EINTR) {
+	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
-		nftnl_table_list_free(list);
-		goto retry;
-	}
+
 	h->cache->tables = list;
 
 	return 1;
@@ -1408,7 +1405,6 @@ static int fetch_chain_cache(struct nft_handle *h)
 	struct nlmsghdr *nlh;
 	int i, ret;
 
-retry:
 	fetch_table_cache(h);
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
@@ -1426,11 +1422,8 @@ retry:
 					NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
-	if (ret < 0 && errno == EINTR) {
+	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
-		flush_chain_cache(h, NULL);
-		goto retry;
-	}
 
 	return ret;
 }
@@ -1551,22 +1544,13 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	nftnl_rule_set_str(rule, NFTNL_RULE_CHAIN,
 			   nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
 
-retry:
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
 					NLM_F_DUMP, h->seq);
 	nftnl_rule_nlmsg_build_payload(nlh, rule);
 
 	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, c);
-	if (ret < 0) {
-		flush_rule_cache(c);
-
-		if (errno == EINTR) {
-			assert(nft_restart(h) >= 0);
-			goto retry;
-		}
-		nftnl_rule_free(rule);
-		return -1;
-	}
+	if (ret < 0 && errno == EINTR)
+		assert(nft_restart(h) >= 0);
 
 	nftnl_rule_free(rule);
 
-- 
2.11.0

