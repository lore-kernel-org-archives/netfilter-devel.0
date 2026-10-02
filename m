Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABFF21A457;
	Fri,  2 Oct 2026 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790915597; cv=none; b=Y6cX5rs47CHVThAELur7qykdtuoAH9JacXQ+y59/pMuTM1NAz1wIiZbo/zT+d6OeexJvqqwQ6TcwDwvNgRY7z8q3Go6eoKomZCDw3lTT3T6x523Q593waaZ9v3d6E6ZhXHe5Kf4FJXSfeNdMMlptUSEuuXn7UDpkWDHi9285u8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790915597; c=relaxed/simple;
	bh=9LNfvW8DQMUknlb/lG/9lxmKsQuXnu/5WwsR9rsisMA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=nXDUVK8x3490fBy7+6jmrQjbzTsR2G2PJftcTAU4N6EeaJB92UsyaQ16C6VmrqLldqBQWxZ0sgjBNEbfjCRCQJYqhs0kN2lBTDYVfk3KhR42en/JxAlLV0N6GCk07PVtaMmpL88y5wp2Sots9bAosqeRYAB9rgP17zfn5FiKnVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=S3OdndIW; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="S3OdndIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790915589; bh=EB2J6eVL7vHfJirKa9hAYAOnqQs4/wBWOg7RLq9ctKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3OdndIWheazN8BFYPNFAEgrQFL5jcEvuzoyX/JtxJXEj+7mQE5trC961YPDyO092
	 VVIgToxhfvUOgoWegi5ad8Z7blA4nx0GBQD7zUSf3AgTfXK0xndFFA5tEefZ1hsEMa
	 2K5CjPHB/GCFVVOwmIm9CYF8msCTeFfarB8dy6Ng=
Received: from localhost.localdomain ([182.239.119.53])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 6579C811; Fri, 02 Oct 2026 12:25:23 +0800
X-QQ-mid: xmsmtpt1790915123tqpcn1qjm
Message-ID: <tencent_3EF2E566E214C1068698C581DE374E1E3C09@qq.com>
X-QQ-XMAILINFO: MpqzBLgWqqkewDs+O/hpfYDbqJLbHuvaqF6+R9G/Eqv05J7l3Joipq4Des5xq2
	 HtJRkne2LWLCfkoEtT02hBy6vxpfn3haxTzMSLapVUGqJ/fOi9Ai4MUboghzL8bpkAQDoqgzMDjg
	 nMN1TcHGJ7dvqmIslpHOodDoIF+D278IV+P/lrL5Hkk2T85VRrqFh2OliSRRhnTeAbgF6WlVu+g7
	 4bEWgvB/x2kKKxAO0Ig4iNdrcuAGXPia0Bcomm8qFfiF5r3kIqFoLNicfoeGCdLUaCUJ888ds+Fh
	 qrToMRR4IM1KQWjUMXRMDpG4iW3eKqOncR/GCKmeoJ7KmfKYgH06zzO9OFUHh6iicEqYLblybxkU
	 UcOlxqlfmvTXolkwvnggSthSzBRHpTYzCBbwSWQR9NAplQsoYu61w4/98jPUxB/y2DK3I1+Y3Ykz
	 jovvszeRS5PU2TJ15irEwCI5s7FWdFHokrLGVI3o+Oid1LbTCLgo7pO8cPMgvvYgKJzCjiWBpNFz
	 QbAPyfW1+Xxumvla1Fy4Sissxq1xAYRTjTxRnvPHj9TWrMYIb3rZbAOXm5Lp3f8lfYTe+uWuAwci
	 giD7fFSSJzUUbVsnzTXXcO80TtDwMpFJ7r+McsXwnexFAusE/DGz4rb54JQBRlMbD5mIxLzDGvK7
	 N2EnDIRo7W45SAjQa/2q+YiMcdvSgg4920fKicOW77uP5Wu06Wu0/ybgsV9TfgHd46MnLHUFgwS0
	 cWOp8f0t0VGbDnLcmcyIslgvGUspAfAc5vKF6TdgV3q9TKnt4DhwUvCXrUTVwjWDtHuZVZHKwJR+
	 J9OkqziPTHn4LjPMXFBjGdd7NxcIUwdHRizoKSBQqqBIKtz5biEM37FIHxwEBJaQNMvQI84RwOIg
	 tvoZ7/tO20H7jT9S/hD/yPfxCqdj9yZCCEexWEEfhc91q30KSIJqNrOGQrpj3NosIfGLNpAowtJD
	 gcNJ+MtKskoHybizSZCkl5F2GbiRE870UzN5u1RsfrTyVJOtuoGZwOUUrAPyeC/xSMO1PeQ6RmsK
	 zDDBFEMX/XAvHuk6L799JsqaXqW5nNMShiTVrzg0/aB8jrb5ZaSmGg+Nj3goKqWzG8mALXSID6xz
	 jnhFJq
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1 1/2] netfilter: nf_tables: allow to create netdev chain without device
Date: Fri,  2 Oct 2026 12:25:08 +0800
X-OQ-MSGID: <20261002042509.711-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <ar4d_JbuojZJuazs@chamomile>
References: <ar4d_JbuojZJuazs@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Relax netdev chain creation to allow for loading the ruleset, then
adding/deleting devices at a later stage. Hardware offload does not
support for this feature yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ma Xinmeng <1564938642@qq.com>

This is a 6.1 backport of upstream commit 207296f1a03b; the hunk for
nft_delchain_hook() is dropped since that function is not present in 6.1.
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 96b0638c2..18aa388d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2180,7 +2180,7 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_netdev(struct net *net,
 				  struct nlattr *tb[],
-				  struct list_head *hook_list)
+				  struct list_head *hook_list, u32 flags)
 {
 	struct nft_hook *hook;
 	int err;
@@ -2197,19 +2197,20 @@ static int nft_chain_parse_netdev(struct net *net,
 		if (err < 0)
 			return err;
 
-		if (list_empty(hook_list))
-			return -EINVAL;
-	} else {
-		return -EINVAL;
 	}
 
+	if (flags & NFT_CHAIN_HW_OFFLOAD &&
+	    list_empty(hook_list))
+		return -EINVAL;
+
 	return 0;
 }
 
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				struct netlink_ext_ack *extack, bool autoload)
+				struct netlink_ext_ack *extack, bool autoload,
+				u32 flags)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -2261,7 +2262,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, flags);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -2409,7 +2410,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			return -EOPNOTSUPP;
 
 		err = nft_chain_parse_hook(net, nla, &hook, family, extack,
-					   true);
+					   true, flags);
 		if (err < 0)
 			return err;
 
@@ -2574,7 +2575,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EEXIST;
 		}
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   extack, false);
+					   extack, false, flags);
 		if (err < 0)
 			return err;
 
@@ -2795,6 +2796,7 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
+
 static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
-- 
2.43.0

