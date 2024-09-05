Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE78E1B86C7;
	Thu,  5 Sep 2024 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578979; cv=none; b=Ty0OHjWszY/nEFroN/NxqdUW/VX/OVHaOSSnOyIBy4WqmC6ZAXPDT/mg/0hTLZSHzcmfnQsJklFjGpiC8pjU8FEixGT3wEy3hOdoOkqut6oJ/lcDpoAS26IQiyNqoBrZlFswWj/eig5XEQwRThpZZRAgB21Dc6/5W2kmkOyjyJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578979; c=relaxed/simple;
	bh=bYUDdtQ0QgSICq1nkb7wmSeaxZray+uJxbb12bAI6QI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gk1P3Psqeug/4OL0KQdWGQUS8eWriuQNtgfoIzJP7GZLfr/RKJ675LHRjORZYqhjjeYG/CkPOJ21HPRqTt5yJglEwY2TW8oDhkXku+AYMlDfb1p/k02/g+ETFtmK1hmto9arbg9jsLy1vy4k2p5y9rXayVFjrvZP1P0nukui0hA=
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
Subject: [PATCH net-next 06/16] netfilter: nf_tables: Correct spelling in nf_tables.h
Date: Fri,  6 Sep 2024 01:29:10 +0200
Message-Id: <20240905232920.5481-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

Correct spelling in nf_tables.h.
As reported by codespell.

Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7cd60ea7cdee..02626ad17e99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -687,7 +687,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	@NFT_SET_EXT_TIMEOUT: element timeout
  *	@NFT_SET_EXT_EXPIRATION: element expiration time
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
- *	@NFT_SET_EXT_EXPRESSIONS: expressions assiciated with the element
+ *	@NFT_SET_EXT_EXPRESSIONS: expressions associated with the element
  *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
  *	@NFT_SET_EXT_NUM: number of extension types
  */
-- 
2.30.2

