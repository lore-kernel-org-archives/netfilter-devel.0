Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D2A46F489;
	Fri, 11 Sep 2026 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116302; cv=none; b=ikDi+CGYZZxEHstFFFThdHM4b101r9TxKF+paet8PdX2koCgCsVQWAyZ1YAEaDmapiF16go4OCezewrmrffSJpVMF5n0jEuWc/D+ri+NlTTXWNoMGjqzkPhopSfCFpP1t3ZEHdmfFBls8QtEmrtwHK41X+gw01gTKjkDJ6uxslE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116302; c=relaxed/simple;
	bh=HOG7vXyP9TvbaEU2QMdlIPAbpFtfj2MeGaWqzCVnLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmArimPRZrqkfesgeBewCnrOqpB6eDhkDGGfJyKQ9vUuMyE+NCzrJs+yh6kNrbAqBTfXFiu7loeisNHQzbbIwo1N63zwi96yILZr17Di3k3JvrjFtSilWGDdkM91vxgefBBAIFREwbIg51FgvXsClHJ5pAsWF+UH/wzJf7YegCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YD9FtfjQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YD9FtfjQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116294;
	bh=Dt+b3F30XTIFWIWCiuPKcQC6WUJb5AnyCKmdwyFNztc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD9FtfjQlIIg49Hax+Ngnt7mfseks00WuSJz4IpEsa5hbJ5/bTpWS3B3SwsFkBHTB
	 JxJW0t4HS0i45/iGfkn43IjP19iXbA6nmQ4FCq+G8kgsgJB3ydB1cZ70JFM5Cgse2H
	 URUUyRWq4PV5hOp1898bB25EiRuCAcLdv7pubZF5a0RvdBuJFmQkrYEZGp2RMklom+
	 YzpIpzuMfuTycfSzrfXO1qQ1PTCCWEiwGOPNEfIucJg98epSd4bxRE1klVJK+lqsDd
	 87SrUe83naTYWkXlNseXaIXWfzex0kOQQ0DLexMazzE+GxgFatsQ4yZ7DC+w9LuqzU
	 HSJArf2JNr61Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 845EA603E6;
	Fri, 11 Sep 2026 10:44:53 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 7/8] netfilter: nat: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:36 +0200
Message-ID: <20260911084437.1838161-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate the internal nat hook via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..09cc5b8fd6af 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1204,14 +1204,15 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops),
+					GFP_KERNEL_ACCOUNT);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
 		}
 
 		for (i = 0; i < ops_count; i++) {
-			priv = kzalloc_obj(*priv);
+			priv = kzalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 			if (priv) {
 				nat_ops[i].priv = priv;
 				continue;
-- 
2.47.3

