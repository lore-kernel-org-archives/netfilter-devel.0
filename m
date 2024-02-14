Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B74813F003;
	Wed, 14 Feb 2024 23:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953914; cv=none; b=hV6lYuULfqJuaQFBYWuYNj88a/XFsCY4F/3xr6jYTGPJvKE2cIy+EunkGN0xirsbggxESrpcPyYEwUXnapv1C0BzZjAgfYRI+2TjV7P3pCfUrDktGfKL2jDCPVTZAI8UpEActcv3vj8Z3dqTjfMD4Z13Mngc+x31Uv/NMb8ZesY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953914; c=relaxed/simple;
	bh=8dtTVbE0a6Cprm4hprJjia4wUECu7eqKx0gGRCHYDdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IjXCCeGHtRh8pZWAFGUi5uwEdGcFc+JWRoW0zSCfVQtSLX++AzpltkES/WqEZ+wKuCEkW35t8KDaaW/CsBDMMSv2BmNZPFsHUzkVuqVvUR6eetZAJjN/jveBxjgZ0sCRcXrSMKZ7FewVu8C9MZB4EB59cnEEGQjWUS4zUpdDoE4=
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
Subject: [PATCH net 1/3] netfilter: nft_set_pipapo: fix missing : in kdoc
Date: Thu, 15 Feb 2024 00:38:16 +0100
Message-Id: <20240214233818.7946-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240214233818.7946-1-pablo@netfilter.org>
References: <20240214233818.7946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing : in kdoc field names.

Fixes: 8683f4b9950d ("nft_set_pipapo: Prepare for vectorised implementation: helpers")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index f59a0cd81105..3842c7341a9f 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -144,10 +144,10 @@ struct nft_pipapo_scratch {
 
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
- * @field_count		Amount of fields in set
+ * @field_count:	Amount of fields in set
  * @scratch:		Preallocated per-CPU maps for partial matching results
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
- * @rcu			Matching data is swapped on commits
+ * @rcu:		Matching data is swapped on commits
  * @f:			Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
-- 
2.30.2

