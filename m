Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88446C4D1;
	Fri, 25 Sep 2026 07:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322772; cv=none; b=YsxAkMaojueX5yi+sWOxTAgU1VjwvMN3s9TF3LLc/0D4JBxz8FCXNhWgV6iSCRxaws6qD45e0FCuRuCBN39ms2gBK2OyyVxc1sIhEGx+untceHzf4lQ70KdZLU90tco/G/qxth6rtHEW6Zu6Un0T2SXOpKGD1Awsnc8CjOHrFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322772; c=relaxed/simple;
	bh=ibz27XYBaAFxUNumbAzcDyyA22yN8Zc/Rojw1RwxBFk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aUahgPF6m+WZQeozYxUFobWVcQgMTblKElevrMHYnK8Og15PP+kGFAySgnsuUDrfYiBA9Xjmj2/QmZaQZj+Eh98ilypA2p7eEEWnFN27iANjwE+wu4hxAkrr+4OERyP43xZSzGp+yQnRKGV6waTo7uVTVVGMkMEWYY5/MOfLd0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=0IVQWiyc; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="0IVQWiyc"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 3DE0D1A1020;
	Fri, 25 Sep 2026 07:52:47 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0927D6073B;
	Fri, 25 Sep 2026 07:52:47 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4C4EE10328D5A;
	Fri, 25 Sep 2026 09:52:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790322765; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=22U75mTzzosEAgcFx8xCc7z0LtCayh/RKopp5hJjudE=;
	b=0IVQWiyccbTJulwiIZC+uhogvjQG7e03JxxNX4zHouLy7kQF0KMtkza5sOrmltSclZ/QE8
	W1HoDm/ZQjvAItwRfCdVa8yViwWB8Ox+ORspG024hqFyzuqHL1lwznejuyuYpjynRUB/13
	CMjyFQtcTLsfqF17vu32I1mnN5r7nKznqsY/ht9+kle6SVpc4FXPBgeHVazaPiUuYly3DU
	27k5nqF6hHYuu/+eSAIumeuW6YZF3Py9Xnv7UP0v1DvpugJ3i8Wsaecrb5/7NIS2YlZG4e
	puB1dxq2DCpSR5/2vhi6gaDMpiNelAUOkxAwT+OaA4emBy7Y1jI9Pcq56AHImQ==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Date: Fri, 25 Sep 2026 09:52:24 +0200
Subject: [PATCH 6.18.y 2/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-cve-2026-52988-6-18-v1-2-680b24895415@bootlin.com>
References: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
In-Reply-To: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: miguel.gazquez@bootlin.com, thomas.petazzoni@bootlin.com, 
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, 
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
index a3a66b6268cd..fa1ee5024d58 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10863,8 +10863,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				list_splice_rcu(&nft_trans_chain_hooks(trans),
+						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
@@ -10993,8 +10993,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&ctx,

-- 
2.55.0

