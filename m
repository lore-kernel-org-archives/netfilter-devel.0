Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DC8C17442
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 13:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F101222CD
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 13:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKMNIO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:08:14 -0500
Received: from correo.us.es ([193.147.175.20]:33752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfKMNIO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 08:08:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D362B1694C1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2019 14:08:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5E2AB7FFE
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2019 14:08:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA8DEB7FF2; Wed, 13 Nov 2019 14:08:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95140DA3A9;
        Wed, 13 Nov 2019 14:08:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 Nov 2019 14:08:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 60C4742EE38E;
        Wed, 13 Nov 2019 14:08:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ozsh@mellanox.com, paulb@mellanox.com
Subject: [PATCH nf-next 2/2] netfilter: nf_flow_table_offload: add IPv6 support
Date:   Wed, 13 Nov 2019 14:08:01 +0100
Message-Id: <20191113130801.27288-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191113130801.27288-1-pablo@netfilter.org>
References: <20191113130801.27288-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add nf_flow_rule_route_ipv6() and use it from the IPv6 and the inet
flowtable type definitions. Rename the nf_flow_rule_route() function to
nf_flow_rule_route_ipv4().

Adjust maximum number of actions, which now becomes 16 to leave
sufficient room for the IPv6 address mangling for NAT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h   |   9 ++-
 net/ipv4/netfilter/nf_flow_table_ipv4.c |   2 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c |   2 +-
 net/netfilter/nf_flow_table_inet.c      |  25 +++++++-
 net/netfilter/nf_flow_table_offload.c   | 100 ++++++++++++++++++++++++++++++--
 5 files changed, 127 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index eea66de328d3..f0897b3c97fb 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -163,9 +163,12 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
-int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
-		       enum flow_offload_tuple_dir dir,
-		       struct nf_flow_rule *flow_rule);
+int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+			    enum flow_offload_tuple_dir dir,
+			    struct nf_flow_rule *flow_rule);
+int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+			    enum flow_offload_tuple_dir dir,
+			    struct nf_flow_rule *flow_rule);
 
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index 168b72e18be0..e32e41b99f0f 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -10,7 +10,7 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
-	.action		= nf_flow_rule_route,
+	.action		= nf_flow_rule_route_ipv4,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index f069bc0dc056..a8566ee12e83 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -11,7 +11,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
-	.action		= nf_flow_rule_route,
+	.action		= nf_flow_rule_route_ipv6,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index bfb910b874ce..88bedf1ff1ae 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -21,11 +21,34 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
+static int nf_flow_rule_route_inet(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct nf_flow_rule *flow_rule)
+{
+	const struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
+	int err;
+
+	switch (flow_tuple->l3proto) {
+	case NFPROTO_IPV4:
+		err = nf_flow_rule_route_ipv4(net, flow, dir, flow_rule);
+		break;
+	case NFPROTO_IPV6:
+		err = nf_flow_rule_route_ipv6(net, flow, dir, flow_rule);
+		break;
+	default:
+		err = -1;
+		break;
+	}
+
+	return err;
+}
+
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
 	.setup		= nf_flow_table_offload_setup,
-	.action		= nf_flow_rule_route,
+	.action		= nf_flow_rule_route_inet,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b9f669c80713..a14932748bcf 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -236,6 +236,71 @@ static void flow_offload_ipv4_dnat(struct net *net,
 			    (u8 *)&addr, (u8 *)&mask);
 }
 
+static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
+				     unsigned int offset,
+				     u8 *addr, u8 *mask)
+{
+	struct flow_action_entry *entry;
+	int i;
+
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32)) {
+		entry = flow_action_entry_next(flow_rule);
+		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
+				    offset + i,
+				    &addr[i], mask);
+	}
+}
+
+static void flow_offload_ipv6_snat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct nf_flow_rule *flow_rule)
+{
+	u32 mask = ~htonl(0xffffffff);
+	const u8 *addr;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v6.s6_addr;
+		offset = offsetof(struct ipv6hdr, saddr);
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6.s6_addr;
+		offset = offsetof(struct ipv6hdr, daddr);
+		break;
+	default:
+		return;
+	}
+
+	flow_offload_ipv6_mangle(flow_rule, offset, (u8 *)addr, (u8 *)&mask);
+}
+
+static void flow_offload_ipv6_dnat(struct net *net,
+				   const struct flow_offload *flow,
+				   enum flow_offload_tuple_dir dir,
+				   struct nf_flow_rule *flow_rule)
+{
+	u32 mask = ~htonl(0xffffffff);
+	const u8 *addr;
+	u32 offset;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v6.s6_addr;
+		offset = offsetof(struct ipv6hdr, daddr);
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6.s6_addr;
+		offset = offsetof(struct ipv6hdr, saddr);
+		break;
+	default:
+		return;
+	}
+
+	flow_offload_ipv6_mangle(flow_rule, offset, (u8 *)addr, (u8 *)&mask);
+}
+
 static int flow_offload_l4proto(const struct flow_offload *flow)
 {
 	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
@@ -342,9 +407,9 @@ static void flow_offload_redirect(const struct flow_offload *flow,
 	dev_hold(rt->dst.dev);
 }
 
-int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
-		       enum flow_offload_tuple_dir dir,
-		       struct nf_flow_rule *flow_rule)
+int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+			    enum flow_offload_tuple_dir dir,
+			    struct nf_flow_rule *flow_rule)
 {
 	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
@@ -366,7 +431,32 @@ int nf_flow_rule_route(struct net *net, const struct flow_offload *flow,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nf_flow_rule_route);
+EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv4);
+
+int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+			    enum flow_offload_tuple_dir dir,
+			    struct nf_flow_rule *flow_rule)
+{
+	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
+	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
+		return -1;
+
+	if (flow->flags & FLOW_OFFLOAD_SNAT) {
+		flow_offload_ipv6_snat(net, flow, dir, flow_rule);
+		flow_offload_port_snat(net, flow, dir, flow_rule);
+	}
+	if (flow->flags & FLOW_OFFLOAD_DNAT) {
+		flow_offload_ipv6_dnat(net, flow, dir, flow_rule);
+		flow_offload_port_dnat(net, flow, dir, flow_rule);
+	}
+
+	flow_offload_redirect(flow, dir, flow_rule);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv6);
+
+#define NF_FLOW_RULE_ACTION_MAX	16
 
 static struct nf_flow_rule *
 nf_flow_offload_rule_alloc(struct net *net,
@@ -383,7 +473,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 	if (!flow_rule)
 		goto err_flow;
 
-	flow_rule->rule = flow_rule_alloc(10);
+	flow_rule->rule = flow_rule_alloc(NF_FLOW_RULE_ACTION_MAX);
 	if (!flow_rule->rule)
 		goto err_flow_rule;
 
-- 
2.11.0

