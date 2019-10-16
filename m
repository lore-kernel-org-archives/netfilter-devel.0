Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86CAFA372B
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6B9205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 12:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393162AbfJPMkn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:40:43 -0400
Received: from correo.us.es ([193.147.175.20]:55120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393144AbfJPMkn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 08:40:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABF651BFA8F
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:40:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E584123945
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:40:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 942F012394C; Wed, 16 Oct 2019 14:40:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5B42123945
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:40:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 16 Oct 2019 14:40:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0BDC42EE393
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 14:40:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/5] netfilter: nf_tables_offload: Pass callback list to nft_setup_cb_call()
Date:   Wed, 16 Oct 2019 14:40:31 +0200
Message-Id: <20191016124034.9847-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191016124034.9847-1-pablo@netfilter.org>
References: <20191016124034.9847-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to reuse nft_setup_cb_call() from callback unbind path.

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

