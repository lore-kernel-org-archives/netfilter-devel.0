Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BEAC33C9E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57AE207FF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgAFMDn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:03:43 -0500
Received: from correo.us.es ([193.147.175.20]:39384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgAFMDn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:03:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37227F2DE3
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:03:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2952CDA701
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:03:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F029DA703; Mon,  6 Jan 2020 13:03:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1DE5DA701
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:03:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:03:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D03F041E4800
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:03:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: refresh flow if hardware offload fails
Date:   Mon,  6 Jan 2020 13:03:37 +0100
Message-Id: <20200106120337.13626-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nf_flow_offload_add() fails to add the flow to hardware, then the
NF_FLOW_HW flag bit is unset and the flow remains in the flowtable
software path.

If flowtable hardware offload is enabled, this patch enqueues a new
request to offload this flow to hardware.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c    |  4 +++-
 net/netfilter/nf_flow_table_ip.c      | 10 ++++++++++
 net/netfilter/nf_flow_table_offload.c |  3 +--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9f134f44d139..388e87b06a00 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,8 +243,10 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD)
+	if (flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) {
+		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index f4ccb5f5008b..6e0a5bacfe2e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -259,6 +259,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	if (unlikely((flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) &&
+		     !test_and_set_bit(NF_FLOW_HW, &flow->flags)))
+		nf_flow_offload_add(flow_table, flow);
+
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
 	outdev = rt->dst.dev;
 
@@ -488,6 +493,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
+	if (unlikely((flow_table->flags & NF_FLOWTABLE_HW_OFFLOAD) &&
+		     !test_and_set_bit(NF_FLOW_HW, &flow->flags)))
+		nf_flow_offload_add(flow_table, flow);
+
 	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
 	outdev = rt->dst.dev;
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8a1fe391666e..e7b766b3f731 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -723,7 +723,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 		case FLOW_CLS_REPLACE:
 			ret = flow_offload_work_add(offload);
 			if (ret < 0)
-				__clear_bit(NF_FLOW_HW, &offload->flow->flags);
+				clear_bit(NF_FLOW_HW, &offload->flow->flags);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
@@ -776,7 +776,6 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
-	__set_bit(NF_FLOW_HW, &flow->flags);
 	flow_offload_queue_work(offload);
 }
 
-- 
2.11.0

