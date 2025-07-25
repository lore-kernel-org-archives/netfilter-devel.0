Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E042F0058;
	Fri, 25 Jul 2025 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463051; cv=none; b=e/whI1yq4Nr6yOAlwVyvQw9jdrFTtKGAr+KGg0zCpadBjNt0K6k7sjCxhNF5F5tM/q18p40OM65u0EtV7waPNbMGJ5MCdBvpDBiC1E75B+UzLorUxtqfyeuijbjxO6urohSPpAKFDf0JerE5liEuQ5GQG1sJZmbLZlV6IRm679o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463051; c=relaxed/simple;
	bh=N8Bg1872AOCgjFnEEOYotM4tz4LKMTZV/gryExfZB1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KLLfoa5klHm3GDp14Y1NH8D5xS/BcKLA49O8h72HOrDhkJU9dzb1jjzdjHp0TdguogQQ9+DemHCxemdSw2iAZp3cii8mKfedB/Q7d8Zg7aeEJD8WNwZfaSEz5RKuysQT7Rd559qmqAFamogX5sKdYjgwZhsrjFWJ7rVKDt8bHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lT9KkuX+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L1RtSKgS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lT9KkuX+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L1RtSKgS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8BA1E6027B; Fri, 25 Jul 2025 19:04:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463048;
	bh=Dx1zkbdUb67O1Dmtys2GlneGIbkHy0eB/G9Dm3vlaBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT9KkuX+hOxgQ6yW+9vh+nim1sa4eJk3hLChURcCJBkTzgowqgOvd3R5pOaeobIeV
	 GlKAwh3fKKzvjHle7cuOUSNRfgDhy9AC1IyQaR2qSc4U0vRZ+gsKePbVygGfnh2z2l
	 TuAFQdE3+L+OTNFA5vWHo10m6j5c1WuplH5dK6jkRnAFFwX3fnon1NVzKNf3vwVoQN
	 QgEdf+BiL4+igBo+BWsjSE0JCh+ETuo9CTQWQF2pCCR5EL3WbDM5WBTUyUmas9ER+K
	 R/Qd884j1ti9zMO8owYKXPoOjVZ4LuhohkPWRkdkehh01/L0myFji2PjxhBG9PlF2g
	 egryIXjsE8AUw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 969BF60279;
	Fri, 25 Jul 2025 19:04:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463045;
	bh=Dx1zkbdUb67O1Dmtys2GlneGIbkHy0eB/G9Dm3vlaBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1RtSKgSYRrVith4Gi4cjmsUo+d5u/DAAOl0qZnmDwzDOVgsy1dMFwg5VBqCOR+Qk
	 eJFdP68Er0eXOQfXFrX+a4QLNAB4b2JOZdywDkSnYdFNdDQufY1x7GuSIqDSGty0db
	 qt1v+Jc4tX9gvhyXXwLZkg+V3W3M1U3TyKIhbivL1SerQhHq+lCQMFac90MPAi7ACc
	 ZayjbBK7h60zHfWGp6LVTYDpiEeUr2NReOiMtbdLQKq8AUyc1tX5pkqeuNfijxO99j
	 4YILtAdyiW+eKSOQnKRb/ShLomc8QdA2IoyEuidxkZPsmuU2az4PVL0EK81/26Kz3f
	 gkzJLfUGd674w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 10/19] netfilter: nfnetlink: New NFNLA_HOOK_INFO_DESC helper
Date: Fri, 25 Jul 2025 19:03:31 +0200
Message-Id: <20250725170340.21327-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Introduce a helper routine adding the nested attribute for use by a
second caller later.

Note how this introduces cancelling of 'nest2' for categorical reasons.
Since always followed by cancelling of the outer 'nest', it is
technically not needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 47 ++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index ade8ee1988b1..cd4056527ede 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -109,13 +109,30 @@ static int nfnl_hook_put_bpf_prog_info(struct sk_buff *nlskb,
 	return -EMSGSIZE;
 }
 
+static int nfnl_hook_put_nft_info_desc(struct sk_buff *nlskb, const char *tname,
+				       const char *name, u8 family)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
+	if (!nest ||
+	    nla_put_string(nlskb, NFNLA_CHAIN_TABLE, tname) ||
+	    nla_put_string(nlskb, NFNLA_CHAIN_NAME, name) ||
+	    nla_put_u8(nlskb, NFNLA_CHAIN_FAMILY, family)) {
+		nla_nest_cancel(nlskb, nest);
+		return -EMSGSIZE;
+	}
+	nla_nest_end(nlskb, nest);
+	return 0;
+}
+
 static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 					const struct nfnl_dump_hook_data *ctx,
 					unsigned int seq,
 					struct nft_chain *chain)
 {
 	struct net *net = sock_net(nlskb->sk);
-	struct nlattr *nest, *nest2;
+	struct nlattr *nest;
 	int ret = 0;
 
 	if (WARN_ON_ONCE(!chain))
@@ -128,29 +145,15 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 	if (!nest)
 		return -EMSGSIZE;
 
-	nest2 = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
-	if (!nest2)
-		goto cancel_nest;
-
-	ret = nla_put_string(nlskb, NFNLA_CHAIN_TABLE, chain->table->name);
-	if (ret)
-		goto cancel_nest;
-
-	ret = nla_put_string(nlskb, NFNLA_CHAIN_NAME, chain->name);
-	if (ret)
-		goto cancel_nest;
-
-	ret = nla_put_u8(nlskb, NFNLA_CHAIN_FAMILY, chain->table->family);
-	if (ret)
-		goto cancel_nest;
+	ret = nfnl_hook_put_nft_info_desc(nlskb, chain->table->name,
+					  chain->name, chain->table->family);
+	if (ret) {
+		nla_nest_cancel(nlskb, nest);
+		return ret;
+	}
 
-	nla_nest_end(nlskb, nest2);
 	nla_nest_end(nlskb, nest);
-	return ret;
-
-cancel_nest:
-	nla_nest_cancel(nlskb, nest);
-	return -EMSGSIZE;
+	return 0;
 }
 
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
-- 
2.30.2

