Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA51C43461
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 07:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0231E61003
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 07:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhDAHuS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:50:18 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:17817 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbhDAHuQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 03:50:16 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 73976E02B19;
        Thu,  1 Apr 2021 15:50:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: flowtable: add vlan match offload support
Date:   Thu,  1 Apr 2021 15:50:10 +0800
Message-Id: <1617263411-3244-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGR9LH0pNSk5PTBhKVkpNSkxJTUhPSkpOS0NVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBw6Kio*Hj06DwgONj1JOTUt
        MRAwCiFVSlVKTUpMSU1IT0pKQ0tJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDTU43Bg++
X-HM-Tid: 0a788c69411b20bdkuqy73976e02b19
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch support vlan_id, vlan_priority and vlan_proto match
for flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_offload.c | 39 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4d991c1..b36b553a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -21,6 +21,8 @@ struct nf_flow_key {
 	struct flow_dissector_key_control		control;
 	struct flow_dissector_key_control		enc_control;
 	struct flow_dissector_key_basic			basic;
+	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_vlan			cvlan;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 7d0d128..ee882127 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -78,6 +78,18 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
 	match->dissector.used_keys |= enc_keys;
 }
 
+static void nf_flow_rule_vlan_match(struct flow_dissector_key_vlan *key,
+				    struct flow_dissector_key_vlan *mask,
+				    u16 vlan_id, __be16 n_proto)
+{
+	key->vlan_id = vlan_id & VLAN_VID_MASK;
+	mask->vlan_id = VLAN_VID_MASK;
+	key->vlan_priority = (vlan_id & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	mask->vlan_priority = 0x7;
+	key->vlan_tpid = n_proto;
+	mask->vlan_tpid = 0xffff;
+}
+
 static int nf_flow_rule_match(struct nf_flow_match *match,
 			      const struct flow_offload_tuple *tuple,
 			      struct dst_entry *other_dst)
@@ -85,6 +97,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
 	struct ip_tunnel_info *tun_info;
+	bool vlan_encap = false;
 
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
@@ -126,6 +139,32 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	match->dissector.used_keys |= BIT(key->control.addr_type);
 	mask->basic.n_proto = 0xffff;
 
+	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
+	    tuple->encap[0].proto == htons(ETH_P_8021Q)) {
+		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN, vlan);
+		nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
+					tuple->encap[0].id,
+					key->basic.n_proto);
+		vlan_encap = true;
+	}
+
+	if (tuple->encap_num > 1 && !(tuple->in_vlan_ingress & BIT(1)) &&
+	    tuple->encap[1].proto == htons(ETH_P_8021Q)) {
+		if (vlan_encap) {
+			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CVLAN,
+					  cvlan);
+			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
+						tuple->encap[1].id,
+						key->basic.n_proto);
+		} else {
+			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
+					  vlan);
+			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
+						tuple->encap[1].id,
+						key->basic.n_proto);
+		}
+	}
+
 	switch (tuple->l4proto) {
 	case IPPROTO_TCP:
 		key->tcp.flags = 0;
-- 
1.8.3.1

