Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516B8C33C9A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 20:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2719F206E6
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 20:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgAEUXz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 15:23:55 -0500
Received: from correo.us.es ([193.147.175.20]:49512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgAEUXz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 15:23:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01AE211EB30
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 21:23:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E804EDA702
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 21:23:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DDA55DA701; Sun,  5 Jan 2020 21:23:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA72EDA707
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 21:23:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Jan 2020 21:23:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C836E41E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 21:23:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/3] netfilter: flowtable: remove dying bit, use teardown bit instead
Date:   Sun,  5 Jan 2020 21:23:45 +0100
Message-Id: <20200105202345.242125-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200105202345.242125-1-pablo@netfilter.org>
References: <20200105202345.242125-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The dying bit removes the conntrack entry if the netdev that owns this
flow is going down. Instead, use the teardown mechanism to push back the
flow to conntrack to let the classic software path decide what to do
with it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 5 -----
 net/netfilter/nf_flow_table_core.c    | 8 ++------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 67bbd7b3ad4a..00dfd770c0b9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -86,7 +86,6 @@ struct flow_offload_tuple_rhash {
 enum nf_flow_flags {
 	NF_FLOW_SNAT_BIT,
 	NF_FLOW_DNAT_BIT,
-	NF_FLOW_DYING_BIT,
 	NF_FLOW_TEARDOWN_BIT,
 	NF_FLOW_HW_BIT,
 	NF_FLOW_HW_DYING_BIT,
@@ -136,10 +135,6 @@ int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
 void flow_offload_teardown(struct flow_offload *flow);
-static inline void flow_offload_dead(struct flow_offload *flow)
-{
-	set_bit(NF_FLOW_DYING_BIT, &flow->flags);
-}
 
 int nf_flow_snat_port(const struct flow_offload *flow,
 		      struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4db29223e176..9dd282cbdc65 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -182,8 +182,6 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	if (test_bit(NF_FLOW_DYING_BIT, &flow->flags))
-		nf_ct_delete(flow->ct, 0, 0);
 	nf_ct_put(flow->ct);
 	kfree_rcu(flow, rcu_head);
 }
@@ -300,8 +298,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	if (test_bit(NF_FLOW_DYING_BIT, &flow->flags) ||
-	    test_bit(NF_FLOW_TEARDOWN_BIT, &flow->flags))
+	if (test_bit(NF_FLOW_TEARDOWN_BIT, &flow->flags))
 		return NULL;
 
 	if (unlikely(nf_ct_is_dying(flow->ct)))
@@ -353,7 +350,6 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 		nf_flow_offload_stats(flow_table, flow);
 
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
-	    test_bit(NF_FLOW_DYING_BIT, &flow->flags) ||
 	    test_bit(NF_FLOW_TEARDOWN_BIT, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW_BIT, &flow->flags)) {
 			if (!test_bit(NF_FLOW_HW_DYING_BIT, &flow->flags))
@@ -526,7 +522,7 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
 	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
 	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
-		flow_offload_dead(flow);
+		flow_offload_teardown(flow);
 }
 
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-- 
2.11.0

