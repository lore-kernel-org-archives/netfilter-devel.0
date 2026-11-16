Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789459;
	b=tnmCwFJuqvQhymx05Fp+mdmG3hAf44Rbh8h0AQ88dNYOpV/k0WHsnC20Aw1YsD5JLK49
	 1RrS9wY3RQAn4midJFmvmwsaGeRO9XknjU5AQTA1S2F1fBXOEi3sfK5Zlp62b4OE0qncP
	 Q9LJn27ZB3R2E5XSmqqOQ2vtdpdesucFYkAjasocGbd9iPF38OcEjATbH4x6b6CO/gRqx
	 tXRzh/s4IeKTxMVwAJrFKEOL/qs7IPI4V0jmR2Cz3jibJ9WcDWB7iTdzS0infMnw7p483
	 c8n1pH4U/0tiTvWBkAJcZkjdU9hBS2zUM2c0UEzvQDQ4fyYAdY8widehhehSmjx1nXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789459;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=G5hjZTvrGud7PcokT7E8CDDyibAepFdA2U7Fg6l/D8c=;
	b=HtwP5MHHNA6OX4n4KKzBd8/6VDLlLT4pIuQlwYn3/OXa3utzsS7zv0tGLLw7YTJ09CaQ
	 3774dbtmJMZQBTh6UcwLU7walCLmqPS6Ogud1GfX3LBg1h7upJ4s6UT+sJetKa1NxLIbI
	 /sD1PADpASiLHuwEUQXN9ffuGcb7UetFGWOF0mGd0pC5bEYkSGGfaXvyBrG+3qIRoRs/D
	 n5PycaNd281H5wr6MB9eRzbevDq7+XVc/40qPGmz9H7ZH43l8ZRAfMhj7QCYW2vjuPNsu
	 izVICWU3Rtlhqk+Cp/8mOI4uRfSypRf5gLhE55cAtAfRbCMupDmcvjfUj9iUl0U/7Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=se+ty7DP;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07791606A31F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07791606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=se+ty7DP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789457;
	bh=G5hjZTvrGud7PcokT7E8CDDyibAepFdA2U7Fg6l/D8c=;
	h=From:To:Subject:Date:From;
	b=se+ty7DPfoy5ZIooJQANTS2W1hPa8uutO8suYaa07DSDkk2FUG8KoYaAij4bdJaUT
	 sQ3RI3ZeflOFDD/IisifboKTJ5vA70RiLBL2+xV5QlHbKtNSfsJ4wk87ZouaQEc+Ul
	 EMeVBcC1bNmjTbZ0HZBOMuaQl89FZEGXiKphcGVZtoRyQYyX31F1uhcp/YUMiGjYbG
	 yzT8/CFts0U3Tfnm6aJ16ACH1Be+XWg7hXCenehpymBo2LP7bWbHHggDXG/q6pbH4N
	 uwA4MPiQQLVRXGpLcDvK2T58oUumTFQ5pwtPVwuTVOS7iIgYBJ/G3ffx1YSIVo54co
	 7Gg4hADZPng3Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 01F3660076
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:36 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 1/7] netfilter: add NF_HOOK_OP_CONNTRACK and use it
Date: Mon, 16 Nov 2026 01:37:27 +0100
Message-ID: <20261116003733.2820132-1-pablo@netfilter.org>
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

