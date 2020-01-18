Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4519DC32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23B182469D
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgARUO3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:14:29 -0500
Received: from correo.us.es ([193.147.175.20]:48400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgARUO0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B3AE02EFEAE
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4251DA710
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:14:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99DD0DA707; Sat, 18 Jan 2020 21:14:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94E4EDA701;
        Sat, 18 Jan 2020 21:14:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6DB3C41E4800;
        Sat, 18 Jan 2020 21:14:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/21] netfilter: flowtable: fetch stats only if flow is still alive
Date:   Sat, 18 Jan 2020 21:13:58 +0100
Message-Id: <20200118201417.334111-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not fetch statistics if flow has expired since it might not in
hardware anymore. After this update, remove the FLOW_OFFLOAD_HW_DYING
check from nf_flow_offload_stats() since this flag is never set on.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_core.c    | 5 ++---
 net/netfilter/nf_flow_table_offload.c | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e33a73cb1f42..9e6de2bbeccb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -348,9 +348,6 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
-	if (flow->flags & FLOW_OFFLOAD_HW)
-		nf_flow_offload_stats(flow_table, flow);
-
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
 	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))) {
 		if (flow->flags & FLOW_OFFLOAD_HW) {
@@ -361,6 +358,8 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
+	} else if (flow->flags & FLOW_OFFLOAD_HW) {
+		nf_flow_offload_stats(flow_table, flow);
 	}
 }
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d06969af1085..4d1e81e2880f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -784,8 +784,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	__s32 delta;
 
 	delta = nf_flow_timeout_delta(flow->timeout);
-	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10) ||
-	    flow->flags & FLOW_OFFLOAD_HW_DYING)
+	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
 		return;
 
 	offload = kzalloc(sizeof(struct flow_offload_work), GFP_ATOMIC);
-- 
2.11.0

