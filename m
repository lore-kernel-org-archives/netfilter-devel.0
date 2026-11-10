Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316012;
	b=spurL9Vnr6vkTTjjIUbnRrmzSr0x8rgLD2Pv2hsXM0ce3begg23K0IkiXaeY6FRd6tkX
	 c5ak/BlcJpwatzIl06Xtfp53cjhwjSTL0tFzxwNYSOuEx9WBMBcPCWo7K8E29Eo6o9tDT
	 gQOeOkNh85Bcxqqe3HcrlAglGktDSBL2ZD3eVHptYAI/2x71xtwbdXvsRuiywP/Tg57G/
	 IjoEnbuiywcpOvYuQz9DzQAcuO1C+r9gOs2vFvLnb7LUBhDtFv67DShnDomW0bfliCLuR
	 gVxdroimIyrBFvUL8NthKBtx7PqcdHNonSiodAWyIwFiisuXPcmY82gDByEd3P6a/ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316012;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=SX8ErgLcg/e5NiKcTvFnZfFSMf7vPFDDaqo6PmVKPf8=;
	b=hbXW3xjyxIX9KdwQhWQm03M0EohLnJp2WJabcMAVFqD4t3CBs4HxhChz/x0g+XDPLyfW
	 u9gGFksNc7dEJIuftSkhYSSuEHjHVbNsFmAdq2+H/2qTIObv+Gl0llayDWhpMILzMs7QB
	 RuVKspSO+g5azJQZiAehpWTzKCrxVs5fv4mtOqIWvqxoooozxinBDcB1va0jiCnLqYspi
	 WbLEBhOQ+CNdbKOX1/BHdmLDgS1KNK2vvAfbYakH4j8hXrd94lKzeqJgrVriLoo/n8y00
	 YO0rGIBB+8ppwqA7ms7h5egwuJL3ZUMShqSqnAixkE+Tz+BV8wpjE9XsFYa/rWEVGHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rGbQrzDg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F36606BFCD
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:06:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F36606BFCD
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rGbQrzDg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316001;
	bh=SX8ErgLcg/e5NiKcTvFnZfFSMf7vPFDDaqo6PmVKPf8=;
	h=From:To:Subject:Date:From;
	b=rGbQrzDgHeUOSlTxg7646qc/ElDG1C1wdpWa+3E3uIYlL6Yj7eXQhaQRDWogEutV+
	 2LaxhcKfee4ksrqwCU4/G+52OaJxOWZb4+A30Rh3INUhM4FoGIeCjcCapFdhIJo++D
	 OrBtBL2lDlUZsmvtivvheWd19zyOpKeT5XvHWblCHWR8BsyaE23ze9i3HBq4kZAkSt
	 3ynDD4R24/UUXiX+BgXsM7DwCmhzdgKU56Li9XLCRMqlSyWwicjpA/Uu5NPxPb67zv
	 dHobr5LZAyeooZl3xLkUJFU59w9r4cxw1M/6vrkHym5Hldme03sOseZaPogMyjSGmK
	 u/e4VL/3d0Oog==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 58345604F1
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:06:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 1/5] netfilter: add NF_HOOK_OP_CONNTRACK and use it
Date: Tue, 10 Nov 2026 14:06:33 +0100
Message-ID: <20261110130637.1832292-1-pablo@netfilter.org>
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
v5: handle new hook type as undefined in nfnetlink_hook.

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

