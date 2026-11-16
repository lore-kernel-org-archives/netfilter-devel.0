Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826776;
	b=aUz0Bcq9DkBN4qx1gbdiAgMNjEr9P3rXMKZxU9sOEoG4yEr6qqUplvuGe7dpm3txKEoa
	 07wNMWPWYUCJKqKbNJlGaZdOjt/QAowH37u6twc83I4Gg29PXXqmeqK06O3dFbAO4/V25
	 jHPAikotYpPvI7BwwXUPjoyM2cKYC+uOpuDRIPkxPk0ExnbAtj+I+bRTVeDy085a+DYmU
	 vUykAkiLCA+J2CSdZM7tXQVgMpNpwVZT5mlthGIAlB7cK/gdckNWfAybQd0PwyhWM9oQB
	 LpbhI8U0H6ZFVts1gjl4uxP8pTo2wZHu12ggpopgHQhzAhPTP2GHvV3tOZMXHq4HuKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826776;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=S7oJzz20xqgaSoRkWetEZFKuZ1DaswyDzSF4tKTy5z8=;
	b=SsflLO/hrYkTfJCYyCHSi3G4P8dNFxgIY+6n5V/j7K4qtBvQN3IfDsHjEBfUvGIFUZmV
	 7wkc/k9B4+ew0rvuBW8bODy8whWk4h7g+xrNUKWUnLPScLdLufE7ipXXs1XqGnCa4TJqH
	 AsxR/8mnTE40BE5Qcmb1uZvPCKfcM+wrBXwPcvw1tvvIsSOSpwhqm5nAPjv9KJyLFC2DL
	 iLZaN7UHD5guxWDx192R8CLbBOVGyA7jSlFraHVi8hXh62ZlcArS0J0tTSny3EeLsugnN
	 NfBpqHvYhD8/I+s6mYke3d6bx5Um9fSvBEfQOD65EqirbF9C2eF3ntHbiQc2yFUA6QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kGmkL1JS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3752D606A32F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3752D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=kGmkL1JS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826774;
	bh=S7oJzz20xqgaSoRkWetEZFKuZ1DaswyDzSF4tKTy5z8=;
	h=From:To:Subject:Date:From;
	b=kGmkL1JSiVDRkdqGZE6qxYfZwCtIvj5tXKXOuBkfxeuBRcruDr6ZP5g9Y0+xHaDCg
	 2T9e4mVnkCh/AsXPhJ+RgcwRp7dMdAl9bqFDeMHWQY9vbq63xw0qnkAslseSWNqyFN
	 du7BVLDU9aQsNedV3cawcgBCdz4SwrP3FPqH2tg4Vex8VKLDHyY/Gt5VY2jVJHjRJE
	 9QeK8JS1Dtv9CfONKp0X65J/p0vf/xDVfdPDfdmajwuLXNJDyEkr45emyhZsRawq2z
	 upp6TdgquiQsDTvWu7Z/aOWWW6yhdjqWlKOZxUUr05BNiK58lFAtkarYRT5t78DDPy
	 iqviysrmFxz+g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 100806008E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:33 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 1/7] netfilter: add NF_HOOK_OP_CONNTRACK and use it
Date: Mon, 16 Nov 2026 11:59:25 +0100
Message-ID: <20261116105931.2866911-1-pablo@netfilter.org>
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
v9: no changes

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

