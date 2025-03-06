Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3141A08A6;
	Thu,  6 Mar 2025 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275302; cv=none; b=Xoa6UjMfYP4O4U+vzHTLxb54b/lVsp67in8iTcgbj8mFXEjYpt+niPVM9kE59vFSNW0OiWvj4RSUM3PEHFOC35W38TYkoeq51reIiO7o3zYG/xfdb8Dqg6bjU6RCguZq+PgsicGrClAdLZgNSMhhx7bphe0JoyYN4763OZmqUzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275302; c=relaxed/simple;
	bh=3eBta4NdUVZpRQY7Rd3tvYxIeT60lB9yGt8iGAOE7UE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I3gYWzkC9A0T3S0j0s+DZ6/mrI81X7ZMwn0xYAxVacQ0tmvme6Qk2aTgtO2fte4ogPf2w16DRhZHYUPuIZ7lmHsstRGCAmRdmSaPqgSXW/q+njkv0fZcnc95B3vcy6qWec8koq/uCXt5fE0e/rgrid5G28BssA5tuRELC7LT3x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XqVnGBrV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DuoMAnnd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XqVnGBrV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DuoMAnnd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DDC1560303; Thu,  6 Mar 2025 16:34:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275295;
	bh=AUsdUETtDieRadQMe+F2JvPGgnSvRnKzF1g3M1QVQD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqVnGBrVjCX+1ihlLNuRlTLc/9CYNByPnwaxx5Qabg4pc3G4yGenBgVM6Rcjii2ID
	 2m9xGL5Dbe7KCyT9Q+NOQoPEvsfsdxnjqOpn54ZvKtOfvc9fjYc/d1SWQmfKb8NpZb
	 2GLJAmZxAb7BekXJwIh0CS4iKDyGl7ZrG2DVbBYUPCsMCeiWcxeNa1thG+hHSmPaqS
	 GmUVKXQpCXi/II4yCOnEGPd06i+X6m+vZ0XHNTaFsi/HeJO4ZH9fp8tlmLYjuO7tYE
	 oCMHB5durRErkh0N4VqBUb6PUQISrIaDR1tlN45s15f7K9nCVE2n4jjattrLGU1I0B
	 mEE4/Uky4tvxA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DC2E860307;
	Thu,  6 Mar 2025 16:34:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275293;
	bh=AUsdUETtDieRadQMe+F2JvPGgnSvRnKzF1g3M1QVQD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuoMAnndoZP/7x6XZoK0Czte1bWmUCS1lCrv2iLMPIz4gnxEchZR7vh6RxJ4GaC0s
	 SYIssdQfkW3TwVcySUvTQ0akjIOFEa/FvC4tW2ckh5lZPpcG+ZiXAvLWqBH5MDDF/j
	 4ovNN1afCD6+pfxI2mZy9nAOab2tq8Ia/xeMymyjiMbWtq8jP1p5ixRrBq0vAWWZqC
	 nRBDScMzTqwwyQ7ZwyopxwKylBLkGAETRA9tkzFHUi8wt3j+iRctCBqLHoKjSy/cuX
	 cI1F8KKBzYQ06Mp/GzFpaR9E48htQBLXH6KADT6AlHXTHmF/5N0jGVdS63HrJUnBj3
	 nrRcRMgmQMRvQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/3] netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around
Date: Thu,  6 Mar 2025 16:34:45 +0100
Message-Id: <20250306153446.46712-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250306153446.46712-1-pablo@netfilter.org>
References: <20250306153446.46712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nicklas Bo Jensen <njensen@akamai.com>

nf_conncount is supposed to skip garbage collection if it has already
run garbage collection in the same jiffy. Unfortunately, this is broken
when jiffies wrap around which this patch fixes.

The problem is that last_gc in the nf_conncount_list struct is an u32,
but jiffies is an unsigned long which is 8 bytes on my systems. When
those two are compared it only works until last_gc wraps around.

See bug report: https://bugzilla.netfilter.org/show_bug.cgi?id=1778
for more details.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Nicklas Bo Jensen <njensen@akamai.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4890af4dc263..ebe38ed2e6f4 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,7 +132,7 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
-	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
 
 	/* check the saved connections */
@@ -234,7 +234,7 @@ bool nf_conncount_gc_list(struct net *net,
 	bool ret = false;
 
 	/* don't bother if we just did GC */
-	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
 	/* don't bother if other cpu is already doing GC */
-- 
2.30.2

