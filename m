Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324172040B0;
	Sun, 23 Mar 2025 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724578; cv=none; b=HPNrwz5so4w0iiSUpTyCk1k6y2Pd5F+e2zK/HPCS84N4VWSBC6QE0lkSUAra07rvZO6M/jNHNVv7OZNMjjzrCMs0nJMoZ5+0i5uEwvHhMd3YjrlGsh6G3tQ1rxaPluJYWAoG+qnH2c38hz3UPNLsehXGetyfN3Zi2dGl8RGTH5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724578; c=relaxed/simple;
	bh=7zwdiFHicc4iI3K/IKh0LCbUIX6GZibKN6q9zCdM/AM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DnDp1ElQ/Z6UgAsEQlEMzHlviLqqlCNweAMKDufzmNqmrO9QG/7Dd1ty9lmWWzK05nTJ/KgJhGtNCbpeBq0r5JKevoKnwYVz3OCS7iSXZnvSFbRpHBzPA6UWkR0X019aNso8G1cXCwgjzRUpIzxyVqRJTdhSHvF0Z2cz7cXITUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MCf5pBoy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HBiwCSLH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MCf5pBoy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HBiwCSLH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4AD716038E; Sun, 23 Mar 2025 11:09:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724575;
	bh=bK81nLzy0SkMf0Wl3kQXs8QOHc2xTpHZMZTdxV5LO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCf5pBoyvzR8uc8xrQQYm4hGB/lUiqDHT3sX4ZkBl86Z1i4X1VGOfHBP5/WWSxt7w
	 Fbra9jZLM3ZA5g85B+CDMcVVtOsW9DrHV8VL5aveucp1JuJFDkCHnP+8Kk7GW3taBZ
	 xsvmx0+rm6wwKg/Xm7AlfYXP8p4hhAOYrngXfeX8qsVJstJEizyutB6Z8btqjv8ZBO
	 4wNlRHKcenOnsbrag6+O0qeNufIDRVnte2MiLAgAOZfB8fhQGgDQqZm0IRqfhVuu+Y
	 HB2x6xV1L+LO57NoSOmrrPRaEX2E4RD+zmEr1CW38+O3f80bS7bJQrxcX+RxcrVX4k
	 OCTubj9S/P9FA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8847560385;
	Sun, 23 Mar 2025 11:09:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724569;
	bh=bK81nLzy0SkMf0Wl3kQXs8QOHc2xTpHZMZTdxV5LO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBiwCSLHFGssInLYyfyVCvOCohgQ8x4llQ/yVNE4SiGxMdPIfugswnLZKzlai8YgG
	 0ETnh8xGTOkl22WJVVVRY1PIvG+tcRkpGYqzPxonV0SwNDhv3F7Wh9So3gxisDwhlt
	 Ggg11xxffHCszlDOLfilr0+s0lwNldUnOzzP2cDYYsEkMt+kIzMY5BcNaQVfcNWIM3
	 mMWpn6YO7FWHYxUgy1m4MI1SS+stXq0ZstCvcMsVZlplxOseHz8p5Lm0Z/l9KnCVeJ
	 mxW38Abxv+uopV7lE20Ee9BLw9Dv/u77m0Q9V0fg8kTTtWAGLaxG722ZH+aNcSL+b/
	 ayUeBAXifGYoA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/7] netfilter: nfnetlink_queue: Initialize ctx to avoid memory allocation error
Date: Sun, 23 Mar 2025 11:09:19 +0100
Message-Id: <20250323100922.59983-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chenyuan Yang <chenyuan0y@gmail.com>

It is possible that ctx in nfqnl_build_packet_message() could be used
before it is properly initialize, which is only initialized
by nfqnl_get_sk_secctx().

This patch corrects this problem by initializing the lsmctx to a safe
value when it is declared.

This is similar to the commit 35fcac7a7c25
("audit: Initialize lsmctx to avoid memory allocation error").

Fixes: 2d470c778120 ("lsm: replace context+len with lsm_context")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5c913987901a..8b7b39d8a109 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -567,7 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsm_context ctx;
+	struct lsm_context ctx = { NULL, 0, 0 };
 	int seclen = 0;
 	ktime_t tstamp;
 
-- 
2.30.2

