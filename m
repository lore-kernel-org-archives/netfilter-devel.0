Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAB81487FF;
	Thu, 27 Jun 2024 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487642; cv=none; b=SqfjNTQg2uE3VtnHyFrLR/rDKEp8iHDoQGOm9YVfxmlMx5nT3IMkJUanICmQLvOlqQrl7QEB7NcGijRbvnlWDGO9PV65VjV4XKdLC/AFzo+nzyfFnWVztlqzZcYgeo92unccREqYHu4FVMC47L9CU3sXJQJ07duTakqtmIXOdSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487642; c=relaxed/simple;
	bh=NHsYB2rHAUp/AEAcYFzmeaz/DJ6Y6n+OgYC4uvZodsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHusB2Mqg7vqWHQ8ygJSltGOQ5gHaC6pdw0irFtwBATruJNeAOyHvWRebkvad1rW/96dIl7enpMl1iSkauJDvbvrazbMV7bSrvRF4w49MIdC5rsxy6ET8GLbYfw9PDCjs1mniyKj+zNc+i2BkpQpohrPNXLpaSUpZAKF0A3QQoQ=
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
Subject: [PATCH nf-next 03/19] netfilter: nf_tables: compact chain+ft transaction objects
Date: Thu, 27 Jun 2024 13:26:57 +0200
Message-Id: <20240627112713.4846-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Cover holes to reduce both structures by 8 byte.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f72448095833..1f0607b671ac 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1687,10 +1687,10 @@ struct nft_trans_set {
 struct nft_trans_chain {
 	struct nft_trans_binding	nft_trans_binding;
 	struct nft_chain		*chain;
-	bool				update;
 	char				*name;
 	struct nft_stats __percpu	*stats;
 	u8				policy;
+	bool				update;
 	bool				bound;
 	u32				chain_id;
 	struct nft_base_chain		*basechain;
@@ -1763,9 +1763,9 @@ struct nft_trans_obj {
 struct nft_trans_flowtable {
 	struct nft_trans		nft_trans;
 	struct nft_flowtable		*flowtable;
-	bool				update;
 	struct list_head		hook_list;
 	u32				flags;
+	bool				update;
 };
 
 #define nft_trans_container_flowtable(t)		\
-- 
2.30.2

