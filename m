Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FC9C3F68F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51ECC207E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 18:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgAMSQJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:16:09 -0500
Received: from correo.us.es ([193.147.175.20]:34762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMSQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 13:16:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4601515AEA8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36C84DA712
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B6C3DA722; Mon, 13 Jan 2020 19:16:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08532DA71A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 19:16:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D98AD42EF52A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 19:16:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 7/9] netfilter: flowtable: refresh flow if hardware offload fails
Date:   Mon, 13 Jan 2020 19:15:52 +0100
Message-Id: <20200113181554.52612-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200113181554.52612-1-pablo@netfilter.org>
References: <20200113181554.52612-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nf_flow_offload_add() fails to add the flow to hardware, then the
NF_FLOW_HW_REFRESH flag bit is set and the flow remains in the flowtable
software path.

If flowtable hardware offload is enabled, this patch enqueues a new
request to offload this flow to hardware.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebase on top of nf-next.

 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    |  4 +++-
 net/netfilter/nf_flow_table_ip.c      | 13 +++++++++++++
 net/netfilter/nf_flow_table_offload.c | 14 +++++---------
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 9ee1eaeaab04..e0f709d9d547 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -95,6 +95,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
+	NF_FLOW_HW_REFRESH,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e919bafd68d1..7e91989a1b55 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,8 +243,10 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	if (nf_flowtable_hw_offload(flow_table))
+	if (nf_flowtable_hw_offload(flow_table)) {
+		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index f4ccb5f5008b..9e563fd3da0f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -232,6 +232,13 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static bool nf_flow_offload_refresh(struct nf_flowtable *flow_table,
+				    struct flow_offload *flow)
+{
+	return nf_flowtable_hw_offload(flow_table) &&
+	       test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags);
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -272,6 +279,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (unlikely(nf_flow_offload_refresh(flow_table, flow)))
+		nf_flow_offload_add(flow_table, flow);
+
 	if (nf_flow_offload_dst_check(&rt->dst)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
@@ -498,6 +508,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
+	if (unlikely(nf_flow_offload_refresh(flow_table, flow)))
+		nf_flow_offload_add(flow_table, flow);
+
 	if (nf_flow_offload_dst_check(&rt->dst)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b4c79fbb2d82..77b129f196c6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -654,20 +654,20 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 	return 0;
 }
 
-static int flow_offload_work_add(struct flow_offload_work *offload)
+static void flow_offload_work_add(struct flow_offload_work *offload)
 {
 	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
 	int err;
 
 	err = nf_flow_offload_alloc(offload, flow_rule);
 	if (err < 0)
-		return -ENOMEM;
+		return;
 
 	err = flow_offload_rule_add(offload, flow_rule);
+	if (err < 0)
+		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
 
 	nf_flow_offload_destroy(flow_rule);
-
-	return err;
 }
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
@@ -712,7 +712,6 @@ static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload, *next;
 	LIST_HEAD(offload_pending_list);
-	int ret;
 
 	spin_lock_bh(&flow_offload_pending_list_lock);
 	list_replace_init(&flow_offload_pending_list, &offload_pending_list);
@@ -721,9 +720,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
 		switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
-			ret = flow_offload_work_add(offload);
-			if (ret < 0)
-				__clear_bit(NF_FLOW_HW, &offload->flow->flags);
+			flow_offload_work_add(offload);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
@@ -776,7 +773,6 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
-	__set_bit(NF_FLOW_HW, &flow->flags);
 	flow_offload_queue_work(offload);
 }
 
-- 
2.11.0

