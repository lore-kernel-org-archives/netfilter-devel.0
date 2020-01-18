Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A47C32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7CC124683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgARUOc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:32 -0500
Received: from correo.us.es ([193.147.175.20]:48444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgARUOb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4AD22EFEB3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4D14DA712
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA4CADA703; Sat, 18 Jan 2020 21:14:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4F5EDA707;
        Sat, 18 Jan 2020 21:14:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8EE5141E4800;
        Sat, 18 Jan 2020 21:14:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/21] netfilter: flowtable: add nf_flow_offload_tuple() helper
Date:   Sat, 18 Jan 2020 21:14:06 +0100
Message-Id: <20200118201417.334111-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Consolidate code to configure the flow_cls_offload structure into one
helper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 47 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 77b129f196c6..3cd8dc8714e3 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -592,23 +592,25 @@ static void nf_flow_offload_init(struct flow_cls_offload *cls_flow,
 	cls_flow->cookie = (unsigned long)tuple;
 }
 
-static int flow_offload_tuple_add(struct flow_offload_work *offload,
-				  struct nf_flow_rule *flow_rule,
-				  enum flow_offload_tuple_dir dir)
+static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
+				 struct flow_offload *flow,
+				 struct nf_flow_rule *flow_rule,
+				 enum flow_offload_tuple_dir dir,
+				 int priority, int cmd,
+				 struct list_head *block_cb_list)
 {
-	struct nf_flowtable *flowtable = offload->flowtable;
 	struct flow_cls_offload cls_flow = {};
 	struct flow_block_cb *block_cb;
 	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 	int err, i = 0;
 
-	nf_flow_offload_init(&cls_flow, proto, offload->priority,
-			     FLOW_CLS_REPLACE,
-			     &offload->flow->tuplehash[dir].tuple, &extack);
-	cls_flow.rule = flow_rule->rule;
+	nf_flow_offload_init(&cls_flow, proto, priority, cmd,
+			     &flow->tuplehash[dir].tuple, &extack);
+	if (cmd == FLOW_CLS_REPLACE)
+		cls_flow.rule = flow_rule->rule;
 
-	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list) {
+	list_for_each_entry(block_cb, block_cb_list, list) {
 		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
 		if (err < 0)
@@ -620,23 +622,22 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
 	return i;
 }
 
+static int flow_offload_tuple_add(struct flow_offload_work *offload,
+				  struct nf_flow_rule *flow_rule,
+				  enum flow_offload_tuple_dir dir)
+{
+	return nf_flow_offload_tuple(offload->flowtable, offload->flow,
+				     flow_rule, dir, offload->priority,
+				     FLOW_CLS_REPLACE,
+				     &offload->flowtable->flow_block.cb_list);
+}
+
 static void flow_offload_tuple_del(struct flow_offload_work *offload,
 				   enum flow_offload_tuple_dir dir)
 {
-	struct nf_flowtable *flowtable = offload->flowtable;
-	struct flow_cls_offload cls_flow = {};
-	struct flow_block_cb *block_cb;
-	struct netlink_ext_ack extack;
-	__be16 proto = ETH_P_ALL;
-
-	nf_flow_offload_init(&cls_flow, proto, offload->priority,
-			     FLOW_CLS_DESTROY,
-			     &offload->flow->tuplehash[dir].tuple, &extack);
-
-	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
-		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
-
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
+			      offload->priority, FLOW_CLS_DESTROY,
+			      &offload->flowtable->flow_block.cb_list);
 }
 
 static int flow_offload_rule_add(struct flow_offload_work *offload,
-- 
2.11.0

