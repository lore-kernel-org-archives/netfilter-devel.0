Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BC9C43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 13:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC4A222CD
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 13:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKMNIN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:08:13 -0500
Received: from correo.us.es ([193.147.175.20]:33742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfKMNIN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 08:08:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65BAD1694DB
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2019 14:08:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56588B7FF2
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2019 14:08:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4BE63B7FF6; Wed, 13 Nov 2019 14:08:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E133A8271;
        Wed, 13 Nov 2019 14:08:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 Nov 2019 14:08:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0952142EE38E;
        Wed, 13 Nov 2019 14:08:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ozsh@mellanox.com, paulb@mellanox.com
Subject: [PATCH nf-next 1/2] netfilter: nf_flow_table_offload: add flow_action_entry_next() and use it
Date:   Wed, 13 Nov 2019 14:08:00 +0100
Message-Id: <20191113130801.27288-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function retrieves a spare action entry from the array of actions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 76 +++++++++++++++++------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9be61f47303a..b9f669c80713 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -112,13 +112,22 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 	memcpy(&entry->mangle.val, value, sizeof(u32));
 }
 
+static inline struct flow_action_entry *
+flow_action_entry_next(struct nf_flow_rule *flow_rule)
+{
+	int i = flow_rule->rule->action.num_entries++;
+
+	return &flow_rule->rule->action.entries[i];
+}
+
 static int flow_offload_eth_src(struct net *net,
 				const struct flow_offload *flow,
 				enum flow_offload_tuple_dir dir,
-				struct flow_action_entry *entry0,
-				struct flow_action_entry *entry1)
+				struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
+	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
+	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	struct net_device *dev;
 	u32 mask, val;
 	u16 val16;
@@ -145,10 +154,11 @@ static int flow_offload_eth_src(struct net *net,
 static int flow_offload_eth_dst(struct net *net,
 				const struct flow_offload *flow,
 				enum flow_offload_tuple_dir dir,
-				struct flow_action_entry *entry0,
-				struct flow_action_entry *entry1)
+				struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
+	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	struct neighbour *n;
 	u32 mask, val;
 	u16 val16;
@@ -175,8 +185,9 @@ static int flow_offload_eth_dst(struct net *net,
 static void flow_offload_ipv4_snat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
@@ -201,8 +212,9 @@ static void flow_offload_ipv4_snat(struct net *net,
 static void flow_offload_ipv4_dnat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
@@ -246,8 +258,9 @@ static int flow_offload_l4proto(const struct flow_offload *flow)
 static void flow_offload_port_snat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffff0000);
 	__be16 port;
 	u32 offset;
@@ -272,8 +285,9 @@ static void flow_offload_port_snat(struct net *net,
 static void flow_offload_port_dnat(struct net *net,
 				   const struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
-				   struct flow_action_entry *entry)
+				   struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffff);
 	__be16 port;
 	u32 offset;
@@ -297,9 +311,10 @@ static void flow_offload_port_dnat(struct net *net,
 
 static void flow_offload_ipv4_checksum(struct net *net,
 				       const struct flow_offload *flow,
-				       struct flow_action_entry *entry)
+				       struct nf_flow_rule *flow_rule)
 {
 	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 
 	entry->id = FLOW_ACTION_CSUM;
 	entry->csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR;
@@ -316,8 +331,9 @@ static void flow_offload_ipv4_checksum(struct net *net,
 
 static void flow_offload_redirect(const struct flow_offload *flow,
 				  enum flow_offload_tuple_dir dir,
-				  struct flow_action_entry *entry)
+				  struct nf_flow_rule *flow_rule)
 {
+	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	struct rtable *rt;
 
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
@@ -330,39 +346,25 @@ int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
 		       enum flow_offload_tuple_dir dir,
 		       struct nf_flow_rule *flow_rule)
 {
-	int i;
-
-	if (flow_offload_eth_src(net, flow, dir,
-				 &flow_rule->rule->action.entries[0],
-				 &flow_rule->rule->action.entries[1]) < 0)
+	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
+	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
-	if (flow_offload_eth_dst(net, flow, dir,
-				 &flow_rule->rule->action.entries[2],
-				 &flow_rule->rule->action.entries[3]) < 0)
-		return -1;
-
-	i = 4;
 	if (flow->flags & FLOW_OFFLOAD_SNAT) {
-		flow_offload_ipv4_snat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
-		flow_offload_port_snat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
+		flow_offload_port_snat(net, flow, dir, flow_rule);
 	}
 	if (flow->flags & FLOW_OFFLOAD_DNAT) {
-		flow_offload_ipv4_dnat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
-		flow_offload_port_dnat(net, flow, dir,
-				       &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_dnat(net, flow, dir, flow_rule);
+		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 	if (flow->flags & FLOW_OFFLOAD_SNAT ||
 	    flow->flags & FLOW_OFFLOAD_DNAT)
-		flow_offload_ipv4_checksum(net, flow,
-					   &flow_rule->rule->action.entries[i++]);
+		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
-	flow_offload_redirect(flow, dir, &flow_rule->rule->action.entries[i++]);
+	flow_offload_redirect(flow, dir, flow_rule);
 
-	return i;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route);
 
@@ -375,7 +377,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 	const struct flow_offload *flow = offload->flow;
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
-	int err = -ENOMEM, num_actions;
+	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
 	if (!flow_rule)
@@ -394,12 +396,10 @@ nf_flow_offload_rule_alloc(struct net *net,
 	if (err < 0)
 		goto err_flow_match;
 
-	num_actions = flowtable->type->action(net, flow, dir, flow_rule);
-	if (num_actions < 0)
+	flow_rule->rule->action.num_entries = 0;
+	if (flowtable->type->action(net, flow, dir, flow_rule) < 0)
 		goto err_flow_match;
 
-	flow_rule->rule->action.num_entries = num_actions;
-
 	return flow_rule;
 
 err_flow_match:
-- 
2.11.0

