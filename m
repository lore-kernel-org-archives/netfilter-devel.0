Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C9E1B9844;
	Thu,  5 Sep 2024 23:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578979; cv=none; b=FZo8E1h+CJiwUHE/rLoTiQcc3WY+VOTlYLmBnTMCwLdr54Vz+rwAbW9wsP6LWXWQdkFNHIu+MX0dj6+Fo2ai3+fRQHBefvPudK0BO/HtOmaEMkiDPNwlW3iSTRyKCHiPfknWkBZUpMvJxOGCeoRNEAXDA41+vzyyLKnfXZVIiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578979; c=relaxed/simple;
	bh=PxBUKEM5NAJ8cwn/m5HVoFsc34Kcmj/55bC2vkemNOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a8PxKe/74blA+YBA+/7Xrb8yekjWwGByJ7Wk+bOycpkKjiB5UeBXDiLUZEFiDm2VYO3sxufjU1JNzWBXhNz74vn7kqPJzIJ9rhXAU42v8nCFZq9ZAxNGVl7zZy7BTNR+52+Yyeu0RTYBhTmuORbD7Odkfs7IEUhi+yCBS3H8CbU=
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
Subject: [PATCH net-next 07/16] netfilter: nf_tables: Add missing Kernel doc
Date: Fri,  6 Sep 2024 01:29:11 +0200
Message-Id: <20240905232920.5481-8-pablo@netfilter.org>
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

- Add missing documentation of struct field and enum items.
- Add missing documentation of function parameter.

Flagged by ./scripts/kernel-doc -none.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 include/net/netfilter/nf_tproxy.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 02626ad17e99..c302b396e1a7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -209,6 +209,7 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
  *	@family: protocol family
  *	@level: depth of the chains
  *	@report: notify via unicast netlink message
+ *	@reg_inited: bitmap of initialised registers
  */
 struct nft_ctx {
 	struct net			*net;
@@ -313,6 +314,7 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
 /**
  * enum nft_iter_type - nftables set iterator type
  *
+ * @NFT_ITER_UNSPEC: unspecified, to catch errors
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
  */
diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index faa108b1ba67..5adf6fda11e8 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -36,6 +36,7 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr);
 
 /**
  * nf_tproxy_handle_time_wait4 - handle IPv4 TCP TIME_WAIT reopen redirections
+ * @net:	The network namespace.
  * @skb:	The skb being processed.
  * @laddr:	IPv4 address to redirect to or zero.
  * @lport:	TCP port to redirect to or zero.
-- 
2.30.2

