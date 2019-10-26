Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB26CA9EBE
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D2C206DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfJZLsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:48:14 -0400
Received: from correo.us.es ([193.147.175.20]:46606 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfJZLr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A5858C3C66
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E9B4FF13B
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 053E7B8009; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 196D3A7E24;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DF32A42EE393;
        Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/31] netfilter: nf_tables_offload: Pass callback list to nft_setup_cb_call()
Date:   Sat, 26 Oct 2019 13:47:26 +0200
Message-Id: <20191026114733.28111-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to reuse nft_setup_cb_call() from the callback unbind path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 4554bc661817..b85ea768ca80 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -132,13 +132,13 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
 	common->extack = extack;
 }
 
-static int nft_setup_cb_call(struct nft_base_chain *basechain,
-			     enum tc_setup_type type, void *type_data)
+static int nft_setup_cb_call(enum tc_setup_type type, void *type_data,
+			     struct list_head *cb_list)
 {
 	struct flow_block_cb *block_cb;
 	int err;
 
-	list_for_each_entry(block_cb, &basechain->flow_block.cb_list, list) {
+	list_for_each_entry(block_cb, cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err < 0)
 			return err;
@@ -180,7 +180,8 @@ static int nft_flow_offload_rule(struct nft_chain *chain,
 	if (flow)
 		cls_flow.rule = flow->rule;
 
-	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
+	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
+				 &basechain->flow_block.cb_list);
 }
 
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
-- 
2.11.0

