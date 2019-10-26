Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF105C47E49
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA8082070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfJZLsR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:48:17 -0400
Received: from correo.us.es ([193.147.175.20]:46422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfJZLr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8FCE8C3C46
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABFB3A7EC6
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A19A7A7EC0; Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4B0EDA8E8;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 858FE42EE393;
        Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 25/31] netfilter: nf_tables_offload: add nft_flow_cls_offload_setup()
Date:   Sat, 26 Oct 2019 13:47:27 +0200
Message-Id: <20191026114733.28111-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to set up the flow_cls_offload object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b85ea768ca80..93363c7ab177 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -155,30 +155,41 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
+static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
+				       const struct nft_base_chain *basechain,
+				       const struct nft_rule *rule,
+				       const struct nft_flow_rule *flow,
+				       enum flow_cls_command command)
+{
+	struct netlink_ext_ack extack;
+	__be16 proto = ETH_P_ALL;
+
+	memset(cls_flow, 0, sizeof(*cls_flow));
+
+	if (flow)
+		proto = flow->proto;
+
+	nft_flow_offload_common_init(&cls_flow->common, proto,
+				     basechain->ops.priority, &extack);
+	cls_flow->command = command;
+	cls_flow->cookie = (unsigned long) rule;
+	if (flow)
+		cls_flow->rule = flow->rule;
+}
+
 static int nft_flow_offload_rule(struct nft_chain *chain,
 				 struct nft_rule *rule,
 				 struct nft_flow_rule *flow,
 				 enum flow_cls_command command)
 {
-	struct flow_cls_offload cls_flow = {};
+	struct flow_cls_offload cls_flow;
 	struct nft_base_chain *basechain;
-	struct netlink_ext_ack extack;
-	__be16 proto = ETH_P_ALL;
 
 	if (!nft_is_base_chain(chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(chain);
-
-	if (flow)
-		proto = flow->proto;
-
-	nft_flow_offload_common_init(&cls_flow.common, proto,
-				     basechain->ops.priority, &extack);
-	cls_flow.command = command;
-	cls_flow.cookie = (unsigned long) rule;
-	if (flow)
-		cls_flow.rule = flow->rule;
+	nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, command);
 
 	return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
 				 &basechain->flow_block.cb_list);
-- 
2.11.0

