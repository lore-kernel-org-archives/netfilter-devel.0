Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EACC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54662086A
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHIKn4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:43:56 -0400
Received: from correo.us.es ([193.147.175.20]:36084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfHIKn4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 06:43:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3912C3282
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5CECDA72F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB762DA730; Fri,  9 Aug 2019 12:43:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB80EDA72F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 12:43:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 328974265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_flow_table: conntrack picks up expired flows
Date:   Fri,  9 Aug 2019 12:42:36 +0200
Message-Id: <20190809104237.2553-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update conntrack entry to pick up expired flows, otherwise the conntrack
entry gets stuck with the internal offload timeout (one day). The TCP
state also needs to be adjusted to ESTABLISHED state and tracking is set
to liberal mode in order to give conntrack a chance to pick up the
expired flow.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e3d797252a98..68a24471ffee 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -111,7 +111,7 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int timeout;
@@ -208,6 +208,11 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+}
+
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
@@ -223,6 +228,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	e = container_of(flow, struct flow_offload_entry, flow);
 	clear_bit(IPS_OFFLOAD_BIT, &e->ct->status);
 
+	if (nf_flow_has_expired(flow))
+		flow_offload_fixup_ct(e->ct);
+
 	flow_offload_free(flow);
 }
 
@@ -233,7 +241,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct_state(e->ct);
+	flow_offload_fixup_ct(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -298,11 +306,6 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static inline bool nf_flow_has_expired(const struct flow_offload *flow)
-{
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
-}
-
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
-- 
2.11.0

