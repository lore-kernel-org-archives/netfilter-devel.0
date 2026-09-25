Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC7446C837;
	Fri, 25 Sep 2026 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324625; cv=none; b=FSzWxwDjdUtohR+mNmyaiOStGsUTP5IFqD3xExPdkQ231s/274/gtTKwK+7K1+th/MCYmVFrWrzmOer0aqheBMEgopPluDkkfQxG1zCEZDWkSsz8TmUBVrJcSXSLHsvOQNRNtX8fMqnyhzPhGnqm3CaTcqGtKAYZTuzv1an04W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324625; c=relaxed/simple;
	bh=d8gttQ0GtmQGGwVP2ciaFpjb9WXqhknmFSKQN+Fp4Mk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cNxc/IG2Yp9Y5sjVbQP1VdIlxkPTbvyqBa4b2eUUCycj42OkFB1FYNafnfc7Fjb6ZxTBlRpxXyi/D/Eh5RMDJeKKdGd28SRJHibNxJcWd8XZUXHD0gHmf2LSrCUJ7NbPVD8ublpNzdwkziRpcC/sZ0AoEXe0DNaZqe+F0GJExjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wJmyXoLk; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wJmyXoLk"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id E5127C13989;
	Fri, 25 Sep 2026 08:24:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 285216073B;
	Fri, 25 Sep 2026 08:23:34 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6E66610329545;
	Fri, 25 Sep 2026 10:23:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790324613; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=I6bEulLh7zAM0W47TqvOKsph6UiMIbIjYc+RQMMlt0A=;
	b=wJmyXoLk8gwi1g4wpdBBgI5nCK1sfzQlqavYNp2/Qv9agvf1lupCd7HuleHi/dg/kZ059n
	2C4rrzP2EnqjJ2CDzS0d4BucfS7wLS17kbDeyGI7G5zQxZAv3HhBokSpJmFiKNqfv1uEPQ
	Cc7G4UIusnTRcEokik2YTbUCeWG/cgJqEQyHHCRRDZ/nVD3AmfHofAb/U1Qtg5/4bsG5Z3
	MAsp/CDuLeCLvBcT3C3Gna0yzGVulgjm/Q7vMPM7lfWOg4KgJxLpBU/fEj84NFnpduSsPs
	R3gMe7n/3nem7QbikPVO3iXoNqh0o1iwSPWzDhxLB5xzph+ABJK+Cd86SQF1qA==
From: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Date: Fri, 25 Sep 2026 10:23:26 +0200
Subject: [PATCH 5.10.y 2/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-cve-2026-52988-5-10-v1-2-19be752e722b@bootlin.com>
References: <20260925-cve-2026-52988-5-10-v1-0-19be752e722b@bootlin.com>
In-Reply-To: <20260925-cve-2026-52988-5-10-v1-0-19be752e722b@bootlin.com>
To: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
 Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, 
 Joel Fernandes <joel@joelfernandes.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
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
Signed-off-by: Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e3f863c487f..63592c73a7a1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8797,8 +8797,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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

