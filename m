Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157153A0E98;
	Wed,  4 Mar 2026 11:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772624979; cv=none; b=hblPEbkJ+zgma4+3e6vdTGo9vIwRLCtnbBo9qDs6G7g+R6Il6RhzQaIHSpuPqJ1xcTnTVhzxJLXXvTw/myvHolQCNyJ4/XpCx4lOTBWuJwB/PuudAkF8HYmxVUyYWnuW9YizbRnYH6oCOHSXEjUFu0DkFMM4LchhvkE5MTr9cZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772624979; c=relaxed/simple;
	bh=bkAPlfxtnZWDn9ZtMK68CXG0xVXHkPrjL43HSBcU664=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIuEKefedCfNgc3KsOuBy7CVoB17gy/1S1+M7j0KO9AUeEMrlx6LcxstHCx6pqL/I78rwxMCeGGomtdH3Au5ojWF2CjAuMufd9lZmUUyX8Nr8NTKyMmXhTVZujx75zMHz0hJaUfAZSG21uQm5za4IeMYT4BvkzS4Ga5/oprVFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 61AFB60492; Wed, 04 Mar 2026 12:49:34 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/14] ipv6: export fib6_lookup for nft_fib_ipv6
Date: Wed,  4 Mar 2026 12:49:08 +0100
Message-ID: <20260304114921.31042-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304114921.31042-1-fw@strlen.de>
References: <20260304114921.31042-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upcoming patch will call fib6_lookup from nft_fib_ipv6.  The EXPORT_SYMBOL is
added twice because there are two implementations of the function, one
is a small stub for MULTIPLE_TABLES=n, only one is compiled into the
kernel depending on .config settings.

Alternative to EXPORT_SYMBOL is to use an indirect call via the
ipv6_stub->fib6_lookup() indirection, but thats more expensive than the
direct call.

Also, nft_fib_ipv6 cannot be builtin if ipv6 is a module.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/fib6_rules.c | 3 +++
 net/ipv6/ip6_fib.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index fd5f7112a51f..e1b2b4fa6e18 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -92,6 +92,9 @@ int fib6_lookup(struct net *net, int oif, struct flowi6 *fl6,
 
 	return err;
 }
+#if IS_MODULE(CONFIG_NFT_FIB_IPV6)
+EXPORT_SYMBOL_GPL(fib6_lookup);
+#endif
 
 struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 				   const struct sk_buff *skb,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 9058e71241dc..a6e58a435735 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -342,6 +342,9 @@ int fib6_lookup(struct net *net, int oif, struct flowi6 *fl6,
 	return fib6_table_lookup(net, net->ipv6.fib6_main_tbl, oif, fl6,
 				 res, flags);
 }
+#if IS_MODULE(CONFIG_NFT_FIB_IPV6)
+EXPORT_SYMBOL_GPL(fib6_lookup);
+#endif
 
 static void __net_init fib6_tables_init(struct net *net)
 {
-- 
2.52.0

