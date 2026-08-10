Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BE43B484;
	Mon, 10 Aug 2026 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388813; cv=none; b=AHq2llOzcToYrwQEA3U/AdylN58kumRl7SjlfXc5v2OJKtze0wjCmvSVOpY6pF4sN0FX0PL8pKIKbL0VyVy6UHPxX2OaBe621V7NR2KjvD+D/hwNBnOeZpWYXoEY04fe9AEpmnZvK82cEhQ5uPJ4S8aKdZ/GYziNe0yc5rA3EZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388813; c=relaxed/simple;
	bh=vm4zrQ8cBJ39uQvNCExo0wgd4eHJEkSGn4Xoojrip5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdU8WMpmmhjd1CCJPuLDfCsgBsGZqvrs6pc3x35NHvgQH+rLgjYd9/Ya9TpdXi9kJx/Ly6cKO5LEHsm4+zc5v0JDBoItChST/0KsRCxmFeLyA0Xx3OmdVQ+sx2GomQq4DMuwfvx52RFvUFJ6OAmsqVvnNfmw/uEjAzWxzTRpswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mwzHq48W; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mwzHq48W"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E04E601A2;
	Mon, 10 Aug 2026 21:06:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388810;
	bh=8jonHFW92Yd9hJqj5CLwavm35Ms9ujPKrAmOyl9eid4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwzHq48Wq8Hw0N6scOakRpxWdNUOQNhpT+Yj+Nw1wxJULF2TljTVToosPizMyHD2w
	 JeSoMSavaeolNsBMwVRZ3O2v84I6v1hPKO3f72kAi9VY5RzeqGqAZtSZu32buTO7uw
	 WlvzmSxs2aImOpRbaoM0W41bz4V31fagJhk4pNtsuk3Rwf12ofHc/rtEc/vI0CLZNB
	 41XGlQSBctayASjeu6HQLOfaJJPn8qUe7LqX043QZ0BWWyaggDex+3/2dZQHTFmi7l
	 EpIjGkUL1sor/GROomqAIuKSns7DfLnIZqjSfAiaLVNzeo22PmUvvWTJ7SO7V5S5SH
	 aR7m9zTGMsGtw==
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
Subject: [PATCH net 12/13] netfilter: ipset: fix list type element drift bug
Date: Mon, 10 Aug 2026 21:06:20 +0200
Message-ID: <20260810190621.894119-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index ca3ef9479e83..0bc2370773af 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,9 +301,12 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
-	else if (next)
+		return 0;
+	}
+
+	if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
 		list_add_rcu(&e->list, &prev->list);
-- 
2.47.3

