Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789402;
	b=0zZZ2yzuVYC4xGkn+6HpgjB1yZIt+okWrYCB93oxeF2G5SfEV0rtzl+UgayZL7ANDDYR
	 uZk3RjxSZAGB1UKLWgWDHnfgvhK1LzfPYiKTgx46/fdSAcMRy68c6IbCSyH5CQ996l5fc
	 sqnLSzVfquSn5O5WimnOpkpDl+Zxcoi+WWvRfVfEJtU73R5f1NSSDf1Y4Dvuo7WjKo/7Q
	 gABU24CYlpmmxPOZ0WrwxYyuIyA22+dPcBvzMR+1eVp595VqyxKHsrw/1P1QYEKEYNYeH
	 Q/HznVeTn1LDVWEGLnVAwoywFOHIJe3OGShhsdU7EIOm+Xs/ngkgsR4KvmlVj+rlbMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789402;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=G5hjZTvrGud7PcokT7E8CDDyibAepFdA2U7Fg6l/D8c=;
	b=IlXrM7YPC5XCq+hN3DNKms9OI4ESQoFYP+dvaY61oJxiA+gLnD3wfbNVKzbYWFKg4NfJ
	 hXhspV2rHLWwsQ0R7YiCNXjhq7uwsvlCPEdPPMBNrMC3K5F/E5VgbWAoMNNzkB8Kzq+tr
	 /9hawZNwpTm1gS7j7yfoVqbEN00/XGkOwcLS8qMV+pye1RfVMiBYffLTqEd56I4AnoAP9
	 W7dp50/43AWn6hy7wNkV/nhFuGsq6yMykhjwZ6FeD8reMwzAhbpNXj4gmreJAZT16hv8K
	 L1YlXoOfbBnj3IoVO6lZTLT4QJH0nUKxdsseY14WYbjCwdrFVDvhBWmze7+G3KOv+Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=R48+Xpo6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E510606A332
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E510606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=R48+Xpo6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789399;
	bh=G5hjZTvrGud7PcokT7E8CDDyibAepFdA2U7Fg6l/D8c=;
	h=From:To:Subject:Date:From;
	b=R48+Xpo6qD+9l1VfSmHg6v+ADKDNYXKjR3YBPQHNbq/NniT3AcLqq53B5HFZ6gP8v
	 fzPq0H4SF2YmiK5Zc+BijRspglWJ3FplBniSLZotg0/U46CB9ABveaI80ZU/itfcOy
	 LdU0d1OEdNml2LE+VOn+tifApr0zQvlIlAAte3AnaVsAShX61scohBZmznOpO+45XY
	 Sm2iQGbRMw9LmihLQcrpy/Ycf56unKBeLY4BRym/WNQm85dLZHfSoMph3fLvMVi8zo
	 XkOP+n/wb6AzZwH649nxsvkWHM8Z2SKN/Z2oRv7BQ22JVdikCIKpuSM6h8lJJev2yF
	 fWs8fYttJt8eQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A631860076
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:36:39 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH,v8 1/7] netfilter: add NF_HOOK_OP_CONNTRACK and use it
Date: Mon, 16 Nov 2026 01:36:28 +0100
Message-ID: <20261116003634.2819957-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new NF_HOOK_OP_CONNTRACK to identify conntrack hooks, this allows
to identify these hooks from the kernel. This is not yet exposed through
to userspace via nfnetlink_hook.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: no changes

 include/linux/netfilter.h                  | 1 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 3 +++
 net/netfilter/nf_conntrack_proto.c         | 8 ++++++++
 net/netfilter/nfnetlink_hook.c             | 1 +
 4 files changed, 13 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc1414cd..66f048a12317 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -94,6 +94,7 @@ enum nf_hook_ops_type {
 	NF_HOOK_OP_BPF,
 	NF_HOOK_OP_NFT_FT,
 	NF_HOOK_OP_NAT,
+	NF_HOOK_OP_CONNTRACK,
 };
 
 struct nf_hook_ops {
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8c83dc05114b..ceffab8e5a7e 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -418,18 +418,21 @@ static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_ct_bridge_in,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_ct_bridge_post,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..94989c84abc7 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -243,24 +243,28 @@ static const struct nf_hook_ops ipv4_conntrack_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= ipv4_conntrack_local,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 
@@ -400,24 +404,28 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= ipv6_conntrack_local,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_LAST - 1,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 #endif
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index b05fd79397c5..959d7bfa556b 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -257,6 +257,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	case NF_HOOK_OP_NFT_FT:
 		ret = nfnl_hook_put_nft_ft_info(nlskb, ctx, seq, ops->priv);
 		break;
+	case NF_HOOK_OP_CONNTRACK:
 	case NF_HOOK_OP_UNDEFINED:
 		break;
 	default:
-- 
2.47.3

