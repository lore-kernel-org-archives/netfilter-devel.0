Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FFEC04AB4
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3A6520989
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfEMJ44 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 05:56:56 -0400
Received: from mail.us.es ([193.147.175.20]:34212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEMJ4p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 05:56:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BEF524DE72D
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA3B3DA707
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9FAB6DA711; Mon, 13 May 2019 11:56:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E6E7DA701;
        Mon, 13 May 2019 11:56:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6F51E4265A31;
        Mon, 13 May 2019 11:56:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/13] netfilter: nf_flow_table: do not flow offload deleted conntrack entries
Date:   Mon, 13 May 2019 11:56:27 +0200
Message-Id: <20190513095630.32443-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

Conntrack entries can be deleted by the masquerade module. In that case,
flow offload should be deleted too, but GC and data-path of flow offload
do not check for conntrack status bits, hence flow offload entries will
be removed only by the timeout.

Update garbage collector and data-path to check for ct->status. If
IPS_DYING_BIT is set, garbage collector removes flow offload entries and
data-path routine ignores them.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a9e4f74b1ff6..4469519a4879 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -243,6 +243,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload *flow;
+	struct flow_offload_entry *e;
 	int dir;
 
 	tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
@@ -255,6 +256,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
 		return NULL;
 
+	e = container_of(flow, struct flow_offload_entry, flow);
+	if (unlikely(nf_ct_is_dying(e->ct)))
+		return NULL;
+
 	return tuplehash;
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
@@ -301,8 +306,10 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
+	struct flow_offload_entry *e;
 
-	if (nf_flow_has_expired(flow) ||
+	e = container_of(flow, struct flow_offload_entry, flow);
+	if (nf_flow_has_expired(flow) || nf_ct_is_dying(e->ct) ||
 	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
 		flow_offload_del(flow_table, flow);
 }
-- 
2.11.0

