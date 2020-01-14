Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645B0C33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D3E222C4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgANKAp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:00:45 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57025 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANKAo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 05:00:44 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D3F6841908;
        Tue, 14 Jan 2020 18:00:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 3/4] netfilter: flowtable: add tunnel match offload support
Date:   Tue, 14 Jan 2020 18:00:39 +0800
Message-Id: <1578996040-6413-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
References: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJCS0tLS0tLQk5ITUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NyI6PDo*TTg#LDIqFjdJGFZP
        M04KCTBVSlVKTkxDQkJNS09LQkxLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5NTkk3Bg++
X-HM-Tid: 0a6fa37f84b02086kuqyd3f6841908
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
tunnel_dst match for flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 67 +++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b4570fc..f38378a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -27,11 +27,17 @@ struct flow_offload_work {
 struct nf_flow_key {
 	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
+	struct flow_dissector_key_control               enc_control;
 	struct flow_dissector_key_basic			basic;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
 	};
+	struct flow_dissector_key_keyid			enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs	enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs	enc_ipv6;
+	};
 	struct flow_dissector_key_tcp			tcp;
 	struct flow_dissector_key_ports			tp;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
@@ -51,11 +57,61 @@ struct nf_flow_rule {
 	(__match)->dissector.offset[__type] =		\
 		offsetof(struct nf_flow_key, __field)
 
+static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
+				   struct ip_tunnel_info *tun_info)
+{
+	struct nf_flow_key *mask = &match->mask;
+	struct nf_flow_key *key = &match->key;
+	unsigned int enc_keys;
+
+	if (!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX))
+		return;
+
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
+	key->enc_key_id.keyid = tunnel_id_to_key32(tun_info->key.tun_id);
+	mask->enc_key_id.keyid = 0xffffffff;
+	enc_keys = BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		   BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL);
+
+	if (ip_tunnel_info_af(tun_info) == AF_INET) {
+		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
+				  enc_ipv4);
+		key->enc_ipv4.src = tun_info->key.u.ipv4.dst;
+		key->enc_ipv4.dst = tun_info->key.u.ipv4.src;
+		if (key->enc_ipv4.src)
+			mask->enc_ipv4.src = 0xffffffff;
+		if (key->enc_ipv4.dst)
+			mask->enc_ipv4.dst = 0xffffffff;
+		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	} else {
+		memcpy(&key->enc_ipv6.src, &tun_info->key.u.ipv6.dst,
+		       sizeof(struct in6_addr));
+		memcpy(&key->enc_ipv6.dst, &tun_info->key.u.ipv6.src,
+		       sizeof(struct in6_addr));
+		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
+			   sizeof(struct in6_addr)))
+			memset(&key->enc_ipv6.src, 0xff,
+			       sizeof(struct in6_addr));
+		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
+			   sizeof(struct in6_addr)))
+			memset(&key->enc_ipv6.dst, 0xff,
+			       sizeof(struct in6_addr));
+		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	}
+
+	match->dissector.used_keys |= enc_keys;
+}
+
 static int nf_flow_rule_match(struct nf_flow_match *match,
-			      const struct flow_offload_tuple *tuple)
+			      const struct flow_offload_tuple *tuple,
+			      struct dst_entry *other_dst)
 {
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
+	struct ip_tunnel_info *tun_info;
 
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
@@ -65,6 +121,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	if (other_dst->lwtstate) {
+		tun_info = lwt_tun_info(other_dst->lwtstate);
+		nf_flow_rule_lwt_match(match, tun_info);
+	}
+
 	key->meta.ingress_ifindex = tuple->iifidx;
 	mask->meta.ingress_ifindex = 0xffffffff;
 
@@ -503,6 +564,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 	const struct flow_offload *flow = offload->flow;
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
+	struct dst_entry *other_dst;
 	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
@@ -518,7 +580,8 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 	flow_rule->rule->match.key = &flow_rule->match.key;
 
 	tuple = &flow->tuplehash[dir].tuple;
-	err = nf_flow_rule_match(&flow_rule->match, tuple);
+	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
+	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
 	if (err < 0)
 		goto err_flow_match;
 
-- 
1.8.3.1

