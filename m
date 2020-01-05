Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF8CC33C8C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 22:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73EFD2072C
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 22:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgAEWEw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 17:04:52 -0500
Received: from correo.us.es ([193.147.175.20]:41252 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEWEw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 17:04:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67733120827
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57F92DA702
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D8D2DA701; Sun,  5 Jan 2020 23:04:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F989DA709
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Jan 2020 23:04:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0C80941E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jan 2020 23:04:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 3/3] netfilter: flowtable: use atomic bitwise operations for flow flags
Date:   Sun,  5 Jan 2020 23:04:41 +0100
Message-Id: <20200105220441.276512-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200105220441.276512-1-pablo@netfilter.org>
References: <20200105220441.276512-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Originally, all flow flag bits were set on only from the workqueue. With
the introduction of the flow teardown state and hardware offload this is
no longer true. Let's be safe and use atomic bitwise operation to
operation with flow flags.

Fixes: 59c466dd68e7 ("netfilter: nf_flow_table: add a new flow state for tearing down offloading")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebased on top of the new patch dependencies.

 include/net/netfilter/nf_flow_table.h | 16 +++++++++-------
 net/netfilter/nf_flow_table_core.c    | 20 ++++++++++----------
 net/netfilter/nf_flow_table_ip.c      |  8 ++++----
 net/netfilter/nf_flow_table_offload.c | 20 ++++++++++----------
 4 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7109904dd2ed..2cec51243c6e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -83,12 +83,14 @@ struct flow_offload_tuple_rhash {
 	struct flow_offload_tuple	tuple;
 };
 
-#define FLOW_OFFLOAD_SNAT	0x1
-#define FLOW_OFFLOAD_DNAT	0x2
-#define FLOW_OFFLOAD_TEARDOWN	0x8
-#define FLOW_OFFLOAD_HW		0x10
-#define FLOW_OFFLOAD_HW_DYING	0x20
-#define FLOW_OFFLOAD_HW_DEAD	0x40
+enum nf_flow_flags {
+	NF_FLOW_SNAT,
+	NF_FLOW_DNAT,
+	NF_FLOW_TEARDOWN,
+	NF_FLOW_HW,
+	NF_FLOW_HW_DYING,
+	NF_FLOW_HW_DEAD,
+};
 
 enum flow_offload_type {
 	NF_FLOW_OFFLOAD_UNSPEC	= 0,
@@ -98,7 +100,7 @@ enum flow_offload_type {
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
-	u16					flags;
+	unsigned long				flags;
 	u16					type;
 	u32					timeout;
 	struct rcu_head				rcu_head;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a9ed93a9e007..9f134f44d139 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -61,9 +61,9 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
-		flow->flags |= FLOW_OFFLOAD_SNAT;
+		__set_bit(NF_FLOW_SNAT, &flow->flags);
 	if (ct->status & IPS_DST_NAT)
-		flow->flags |= FLOW_OFFLOAD_DNAT;
+		__set_bit(NF_FLOW_DNAT, &flow->flags);
 
 	return flow;
 
@@ -269,7 +269,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(flow->ct);
-	else if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
+	else if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
 		flow_offload_fixup_ct_timeout(flow->ct);
 
 	flow_offload_free(flow);
@@ -277,7 +277,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
-	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
+	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	flow_offload_fixup_ct_state(flow->ct);
 }
@@ -298,7 +298,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
 		return NULL;
 
 	if (unlikely(nf_ct_is_dying(flow->ct)))
@@ -347,16 +347,16 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 	struct nf_flowtable *flow_table = data;
 
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
-	    (flow->flags & FLOW_OFFLOAD_TEARDOWN)) {
-		if (flow->flags & FLOW_OFFLOAD_HW) {
-			if (!(flow->flags & FLOW_OFFLOAD_HW_DYING))
+	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		if (test_bit(NF_FLOW_HW, &flow->flags)) {
+			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
 				nf_flow_offload_del(flow_table, flow);
-			else if (flow->flags & FLOW_OFFLOAD_HW_DEAD)
+			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
 				flow_offload_del(flow_table, flow);
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
-	} else if (flow->flags & FLOW_OFFLOAD_HW) {
+	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
 	}
 }
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 7ea2ddc2aa93..f4ccb5f5008b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -144,11 +144,11 @@ static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 {
 	struct iphdr *iph = ip_hdr(skb);
 
-	if (flow->flags & FLOW_OFFLOAD_SNAT &&
+	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
 	     nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0))
 		return -1;
-	if (flow->flags & FLOW_OFFLOAD_DNAT &&
+	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
 	     nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0))
 		return -1;
@@ -414,11 +414,11 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 	struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	unsigned int thoff = sizeof(*ip6h);
 
-	if (flow->flags & FLOW_OFFLOAD_SNAT &&
+	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
 	     nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
 		return -1;
-	if (flow->flags & FLOW_OFFLOAD_DNAT &&
+	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
 	     nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
 		return -1;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ebf0b92c0196..6200de9d3c71 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -444,16 +444,16 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
-	if (flow->flags & FLOW_OFFLOAD_SNAT) {
+	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
 		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
 		flow_offload_port_snat(net, flow, dir, flow_rule);
 	}
-	if (flow->flags & FLOW_OFFLOAD_DNAT) {
+	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
 		flow_offload_ipv4_dnat(net, flow, dir, flow_rule);
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
-	if (flow->flags & FLOW_OFFLOAD_SNAT ||
-	    flow->flags & FLOW_OFFLOAD_DNAT)
+	if (test_bit(NF_FLOW_SNAT, &flow->flags) ||
+	    test_bit(NF_FLOW_DNAT, &flow->flags))
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
 	flow_offload_redirect(flow, dir, flow_rule);
@@ -470,11 +470,11 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
 
-	if (flow->flags & FLOW_OFFLOAD_SNAT) {
+	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
 		flow_offload_ipv6_snat(net, flow, dir, flow_rule);
 		flow_offload_port_snat(net, flow, dir, flow_rule);
 	}
-	if (flow->flags & FLOW_OFFLOAD_DNAT) {
+	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
 		flow_offload_ipv6_dnat(net, flow, dir, flow_rule);
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
@@ -630,7 +630,7 @@ static void flow_offload_tuple_del(struct flow_offload_work *offload,
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
 		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
 
-	offload->flow->flags |= FLOW_OFFLOAD_HW_DEAD;
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static int flow_offload_rule_add(struct flow_offload_work *offload,
@@ -717,7 +717,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 		case FLOW_CLS_REPLACE:
 			ret = flow_offload_work_add(offload);
 			if (ret < 0)
-				offload->flow->flags &= ~FLOW_OFFLOAD_HW;
+				__clear_bit(NF_FLOW_HW, &offload->flow->flags);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
@@ -770,7 +770,7 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
-	flow->flags |= FLOW_OFFLOAD_HW;
+	__set_bit(NF_FLOW_HW, &flow->flags);
 	flow_offload_queue_work(offload);
 }
 
@@ -783,7 +783,7 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
-	flow->flags |= FLOW_OFFLOAD_HW_DYING;
+	set_bit(NF_FLOW_HW_DYING, &flow->flags);
 	flow_offload_queue_work(offload);
 }
 
-- 
2.11.0

