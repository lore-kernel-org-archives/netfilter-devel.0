Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC48535202B;
	Sat, 20 Jun 2026 22:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994476; cv=none; b=BpQYzB+KFCWGoA1WHIdQSjCGPwpzXaZ+evnl2ViRs3cQFwKpbAgbiaDoOqvXwE9m4LbBqO2f3ghX7GXZnXfk35QHq+iXMmnnI3A1geFBXXPvsTs+hkcXPM1E/S2X7i43GH9atQzfZouIYe7TD935v4l+P0fMJgPMQFDB/agtzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994476; c=relaxed/simple;
	bh=xOTCz2eEKk1cNmAJIH8oJTHtpOcF4/qvEfuRtiRngUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KebBkQKpttAHIUjSE4fiQ7y9Fb7q1oiNxjGBh0h8BauNwZ40Nr3qpiTdBilKBv13zqXfA9LBu4NZTpLh57GkW8KYPf2jt1bcdvOtHtsFHqGSpoSJhp6Fp9kQBW9+KY9OAvSTR4Dd4FMqOvmlM9yI+Z7xX5JznyMOWMVIDlLAAsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bymyLQLT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bymyLQLT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 996D96019E;
	Sun, 21 Jun 2026 00:27:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994471;
	bh=6TS7DFy4fIY13Z9GYaoKRN4Y7nMyxSg/ESPd3aHpwMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bymyLQLTbMu7vYBQBTCFlDdqwt/8Bs9wiFqxnGcomgTUt4tnnWCotErpyIfmGEhlj
	 Qeg2ZkwIjqwyXl2qj5mXaiDovseqw8nlpBNFM1H5T5EPF4q3h1xaNILH5vzkVe79Ba
	 w/khYXIftjJLbQwmupCGcFoIOsJU5eYmvDzeFtVlinCj8CfOIe4vNrJuHUYJ5uX+TN
	 IftNqHKwJliIVFEh6qdiuBsyuLpKyTQobv+hAFMc/RGfhf+frTY/Yz5fpfTkQy5BAb
	 6VaUDOUembSw1Berqi+11QDOLwyQx2I2MfpwfB29MoYIuG+wlSQXyzFKHLG57996tV
	 MEQF1+GRpalQg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/14] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Sun, 21 Jun 2026 00:27:31 +0200
Message-ID: <20260620222738.112506-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Sashiko pointed out that kfree_rcu() was called before
rcu_assign_pointer() in handling the comment extension.
Fix the order so that rcu_assign_pointer() called first.

Fixes: b57b2d1fa53f ("netfilter: ipset: Prepare the ipset core to use RCU at set level")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3706b4a85a0f..a531b654b8d9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -351,8 +351,8 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 
 	if (unlikely(c)) {
 		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
 		rcu_assign_pointer(comment->c, NULL);
+		kfree_rcu(c, rcu);
 	}
 	if (!len)
 		return;
@@ -393,8 +393,8 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	if (unlikely(!c))
 		return;
 	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
+	kfree_rcu(c, rcu);
 }
 
 typedef void (*destroyer)(struct ip_set *, void *);
-- 
2.47.3

