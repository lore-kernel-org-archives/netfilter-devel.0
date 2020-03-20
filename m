Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0555CC4332D
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 07:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9B42051A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 07:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCTHeY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 03:34:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32062 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgCTHeY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 03:34:24 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CA66A41CB1;
        Fri, 20 Mar 2020 15:34:17 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter:nf_flow_table: add HW stats type support in flowtable
Date:   Fri, 20 Mar 2020 15:34:17 +0800
Message-Id: <1584689657-17280-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0lLS0tLS0xNSUJIQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6Chw5Ezg1GhxDNk5MDh41
        Ey4wCRhVSlVKTkNPTUNCTU5MQk1JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxLSEs3Bg++
X-HM-Tid: 0a70f6dd37ee2086kuqyca66a41cb1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The hardware driver offload function will check the hw_stats_type
for the flow action. Add NFTA_FLOWTABLE_HW_STATS_TYPE attr to flowtable
to specify the type of HW stats.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_flow_table.h    |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  8 ++++++++
 net/netfilter/nf_flow_table_offload.c    | 11 ++++++++++-
 net/netfilter/nf_tables_api.c            | 31 +++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f523ea8..39e1d7e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -43,6 +43,7 @@ struct nf_flow_match {
 struct nf_flow_rule {
 	struct nf_flow_match	match;
 	struct flow_rule	*rule;
+	u8			hw_stats_type;
 };
 
 struct nf_flowtable_type {
@@ -72,6 +73,7 @@ struct nf_flowtable {
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
 	unsigned int			flags;
+	u8				hw_stats_type;
 	struct flow_block		flow_block;
 	struct mutex			flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c3d2d0..9e08c42 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -10,6 +10,12 @@
 #define NFT_USERDATA_MAXLEN	256
 #define NFT_OSF_MAXGENRELEN	16
 
+#define NFTA_HW_STATS_TYPE_IMMEDIATE (1 << 0)
+#define NFTA_HW_STATS_TYPE_DELAYED (1 << 1)
+
+#define NFTA_HW_STATS_TYPE_ANY (NFTA_HW_STATS_TYPE_IMMEDIATE | \
+			       NFTA_HW_STATS_TYPE_DELAYED)
+
 /**
  * enum nft_registers - nf_tables registers
  *
@@ -1560,6 +1566,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
+ * @NFTA_FLOWTABLE_HW_STATS_TYPE: hw_stats_type (NLA_BITFIELD32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1570,6 +1577,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
 	NFTA_FLOWTABLE_FLAGS,
+	NFTA_FLOWTABLE_HW_STATS_TYPE,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ad54931..60289a6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -165,8 +165,16 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
 	int i = flow_rule->rule->action.num_entries++;
+	struct flow_action_entry *entry;
+
+	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_ANY);
+	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
+	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
+
+	entry = &flow_rule->rule->action.entries[i];
+	entry->hw_stats_type = flow_rule->hw_stats_type;
 
-	return &flow_rule->rule->action.entries[i];
+	return entry;
 }
 
 static int flow_offload_eth_src(struct net *net,
@@ -602,6 +610,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 		goto err_flow_match;
 
 	flow_rule->rule->action.num_entries = 0;
+	flow_rule->hw_stats_type = flowtable->hw_stats_type;
 	if (flowtable->type->action(net, flow, dir, flow_rule) < 0)
 		goto err_flow_match;
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f92fb60..27bd6df 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -30,6 +30,7 @@
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
 static u64 table_handle;
+static const u32 nfta_hw_stats_type_allowed = NFTA_HW_STATS_TYPE_ANY;
 
 enum {
 	NFT_VALIDATE_SKIP	= 0,
@@ -6047,6 +6048,9 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type)
 	[NFTA_FLOWTABLE_HOOK]		= { .type = NLA_NESTED },
 	[NFTA_FLOWTABLE_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_FLOWTABLE_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_FLOWTABLE_HW_STATS_TYPE]	= { .type = NLA_BITFIELD32,
+					    .validation_data =
+						&nfta_hw_stats_type_allowed },
 };
 
 struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
@@ -6244,6 +6248,15 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
+static u8 nft_hw_stats_type(const struct nlattr *hw_stats_type_attr)
+{
+	struct nla_bitfield32 hw_stats_type_bf;
+
+	hw_stats_type_bf = nla_get_bitfield32(hw_stats_type_attr);
+
+	return hw_stats_type_bf.value;
+}
+
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -6251,6 +6264,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct netlink_ext_ack *extack)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	u8 hw_stats_type = NFTA_HW_STATS_TYPE_ANY;
 	const struct nf_flowtable_type *type;
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -6318,6 +6332,12 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 			goto err3;
 	}
 
+	if ((flowtable->data.flags & NF_FLOWTABLE_HW_OFFLOAD) &&
+	    nla[NFTA_FLOWTABLE_HW_STATS_TYPE])
+		hw_stats_type =
+			nft_hw_stats_type(nla[NFTA_FLOWTABLE_HW_STATS_TYPE]);
+	flowtable->data.hw_stats_type = hw_stats_type;
+
 	write_pnet(&flowtable->data.net, net);
 	flowtable->data.type = type;
 	err = type->init(&flowtable->data);
@@ -6439,6 +6459,17 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
 
+	if (flowtable->data.hw_stats_type != NFTA_HW_STATS_TYPE_ANY) {
+		struct nla_bitfield32 hw_stats_type = {
+			flowtable->data.hw_stats_type,
+			NFTA_HW_STATS_TYPE_ANY,
+		};
+
+		if (nla_put(skb, NFTA_FLOWTABLE_HW_STATS_TYPE,
+			    sizeof(hw_stats_type), &hw_stats_type))
+			goto nla_put_failure;
+	}
+
 	nest = nla_nest_start_noflag(skb, NFTA_FLOWTABLE_HOOK);
 	if (!nest)
 		goto nla_put_failure;
-- 
1.8.3.1

