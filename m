Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839803FB055;
	Fri, 25 Sep 2026 08:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790323826; cv=none; b=XH88whmBsOSNw9EeKgfeAiTmhPOHhv6JAeGNQEklCnyPzgJ+XVi1HWFjlYPF2RvFU8EoNG1zdDO6Ic0PIZl/yTDYp9vRHrRhlzX5JDboH9IxMtHUhC/9H/PXSGlPUEAht4If3ploNkXlw5joPg0D9Us0SDSZVkUwdFA+ls28tpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790323826; c=relaxed/simple;
	bh=JBtqi47xjW5jw6HYpLUl4NOjIGr7ovsXixfFTQDIANY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gxxEVzTgrcEturWdmu0xvbmeXxCKplvZA6KhZ8nfNspyGvl4Bf85VX1wPKHupuoO4YFuDG8m2jJjTbsenPciG/TpreVbu/Pgome//axu0eqg3l71KcPPPSwsUX72sF+lvk6BCd7tTp1c71tQUgHCkD2HYQ8x1ezRszQmbNPCls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=cemjVJQC; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="cemjVJQC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 9B6AB4E41073;
	Fri, 25 Sep 2026 08:10:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6EA5A6073B;
	Fri, 25 Sep 2026 08:10:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 65F9F1032958E;
	Fri, 25 Sep 2026 10:10:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790323817; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=zUE9xZKqsUAstYApJyoePF/dQ1NQ6TflPa4SO6uluM0=;
	b=cemjVJQChGB1Sca+7UC18mM7YN6etFCyfAPCHqGC9e5RrDEAkXqdNZOJN8b8BYBDxkPSqr
	aAkMLFOMKac8WWp7SqXjedIp/8ix6M6Ekfh1uxKFrkNeUjiz1/M2gfM9XskqR8lb2yYW7M
	JA6/da4JyDgyx5nc1pIxlU8C44G+1+jEm0inzoxNEKdIoVEZj6zNxnyRpLwQl1TBdzpY/m
	FMWTToZYqXLPoLXMwDB5mbylL1nJGz5qJaYBtqe3nVKC2eyt9OSGgyrPrzta4ErgzAYUSx
	efT+JRF2Qi+UuB0My/VvyL6jmZwjWlgJByjK/Ga2GrBvHtr7DLT5fqzkNKodHQ==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Date: Fri, 25 Sep 2026 10:09:42 +0200
Subject: [PATCH 6.6.y 2/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-cve-2026-52988-6-6-v1-2-d5b30678ef66@bootlin.com>
References: <20260925-cve-2026-52988-6-6-v1-0-d5b30678ef66@bootlin.com>
In-Reply-To: <20260925-cve-2026-52988-6-6-v1-0-d5b30678ef66@bootlin.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: thomas.petazzoni@bootlin.com, rcu@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Last-TLS-Session-Version: TLSv1.3

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a6134e62dba2ea4f760b29d5226907f447c92400 ]

Publish new hooks in the list into the basechain/flowtable using
splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
while concurrent ruleset update is going on.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9053667e370..a1c701886fc1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10298,8 +10298,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(trans);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				list_splice_rcu(&nft_trans_chain_hooks(trans),
+						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(trans);
@@ -10439,8 +10439,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&trans->ctx,

-- 
2.55.0

