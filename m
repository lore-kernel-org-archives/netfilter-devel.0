Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF78F4AEFD;
	Sun, 12 May 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530493; cv=none; b=pAs+MynYTt58vIxJRT8TRiHsnXhfhYPhUByoS/QMhFGWe8Vb6MPaToj327KZLWgPVW86h3q6QA+85jPDnSG/CpCaTIQnH5biJkjFSCydGc0g1e9T3QOeAkAMuEK0LzoZXW3YKkjBAvWUjAWOX9WtgtouISsWSXBx2TfoUPD2kCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530493; c=relaxed/simple;
	bh=Pq7LDsBtPJodAdqmyRfmsGifSzDCUsjV0ORWBfpmM6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VgtKPgNtERp5utfo300/UMW7o7MuDT2fnb+WQJCdN1PrM+pWxJlUZW6eJ270BNseGKOw4yWtSqwP5Elt8jKpqdwfXgKPyzxsu9MfOgnCrohUgcNuUtdMPO1ALF5RMVXxHKyrj2u+7JeoqPs9loqwjayF2mnTnEjeqgG+JEQiar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 07/17] netfilter: conntrack: remove flowtable early-drop test
Date: Sun, 12 May 2024 18:14:26 +0200
Message-Id: <20240512161436.168973-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Not sure why this special case exists.  Early drop logic
(which kicks in when conntrack table is full) should be independent
of flowtable offload and only consider assured bit (i.e., two-way
traffic was seen).

flowtable entries hold a reference to the conntrack entry (struct
nf_conn) that has been offloaded. The conntrack use count is not
decremented until after the entry is free'd.

This change therefore will not result in exceeding the conntrack table
limit.  It does allow early-drop of tcp flows even when they've been
offloaded, but only if they have been offloaded before syn-ack was
received or after at least one peer has sent a fin.

Currently 'fin' packet reception already stops offloading, so this
should not impact offloading either.

Cc: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6102dc09cdd3..7ac20750c127 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1440,8 +1440,6 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	const struct nf_conntrack_l4proto *l4proto;
 	u8 protonum = nf_ct_protonum(ct);
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status) && protonum != IPPROTO_UDP)
-		return false;
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-- 
2.30.2

