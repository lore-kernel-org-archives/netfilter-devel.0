Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FBAC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7815C214AE
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbfETM07 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:26:59 -0400
Received: from mail.us.es ([193.147.175.20]:34242 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389359AbfETM07 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:26:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 83CFCDA707
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73BF6DA704
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 69412DA702; Mon, 20 May 2019 14:26:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FCB6DA70F;
        Mon, 20 May 2019 14:26:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 14:26:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 44BBC4265A5B;
        Mon, 20 May 2019 14:26:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 6/6] nft: ensure cache consistency
Date:   Mon, 20 May 2019 14:26:46 +0200
Message-Id: <20190520122646.17788-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520122646.17788-1-pablo@netfilter.org>
References: <20190520122646.17788-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for generation ID before and after fetching the cache to ensure
consistency.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 063637e22fb8..172beec9ae27 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -63,7 +63,7 @@ static void *nft_fn;
 
 static int genid_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_handle *h = data;
+	uint32_t *genid = data;
 	struct nftnl_gen *gen;
 
 	gen = nftnl_gen_alloc();
@@ -73,7 +73,7 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_gen_nlmsg_parse(nlh, gen) < 0)
 		goto out;
 
-	h->nft_genid = nftnl_gen_get_u32(gen, NFTNL_GEN_ID);
+	*genid = nftnl_gen_get_u32(gen, NFTNL_GEN_ID);
 
 	nftnl_gen_free(gen);
 	return MNL_CB_STOP;
@@ -82,13 +82,13 @@ out:
 	return MNL_CB_ERROR;
 }
 
-static int mnl_genid_get(struct nft_handle *h)
+static int mnl_genid_get(struct nft_handle *h, uint32_t *genid)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, 0, 0, h->seq);
-	return mnl_talk(h, nlh, genid_cb, h);
+	return mnl_talk(h, nlh, genid_cb, genid);
 }
 
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
@@ -1595,12 +1595,22 @@ static int fetch_rule_cache(struct nft_handle *h)
 
 static void __nft_build_cache(struct nft_handle *h)
 {
-	mnl_genid_get(h);
+	uint32_t genid_start, genid_stop;
+
+retry:
+	mnl_genid_get(h, &genid_start);
 	fetch_chain_cache(h);
 	fetch_rule_cache(h);
 	h->have_cache = true;
-}
+	mnl_genid_get(h, &genid_stop);
 
+	if (genid_start != genid_stop) {
+		flush_chain_cache(h, NULL);
+		goto retry;
+	}
+
+	h->nft_genid = genid_start;
+}
 
 void nft_build_cache(struct nft_handle *h)
 {
-- 
2.11.0

