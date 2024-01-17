Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC5D219F6;
	Wed, 17 Jan 2024 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507249; cv=none; b=lys8vs0vgkYlAFutZZs+oPxr8IkD0yX6o1ThLGr2THol43AgYXww7KTg9ah26kCB8GOatUytFIvTpRda8UF3rqbJTyB/pRIPcBmjrDo1y+dgXZqUiasxL4940Rc475yY+uE/GwLb3GIuzlGesjXVOsiYL/wlcLNzY1Tp8X1zTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507249; c=relaxed/simple;
	bh=v8brMQ+HpLj3Ea+P/82A97oHOrS/84rOO69N/UNUBUw=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=FlYaQ3ZTx4JgoGuz4BPcS5YqNPwlEVyIy+YTqIWx//ZWP2IHtPh75H3ZjLjHoCg/PlPKB6cEvu2LNlcmpQO6i7Xc77zrrlEkl3hqXE/5WGbaA03Y3fGAezzKX/cYVEiX/EIqNEYsuBiiIjoHk7UlDE6s+S0Hvsb2bv6gEFGI2Wg=
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
Subject: [PATCH net 02/14] netfilter: nf_tables: validate .maxattr at expression registration
Date: Wed, 17 Jan 2024 17:00:18 +0100
Message-Id: <20240117160030.140264-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240117160030.140264-1-pablo@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nft_expr_info allows to store up to NFT_EXPR_MAXATTR (16)
attributes when parsing netlink attributes.

Rise a warning in case there is ever a nft expression whose .maxattr
goes beyond this number of expressions, in such case, struct nft_expr_info
needs to be updated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a90a364f5be5..2548d7d56408 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2977,6 +2977,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (WARN_ON_ONCE(type->maxattr > NFT_EXPR_MAXATTR))
+		return -ENOMEM;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
-- 
2.30.2

