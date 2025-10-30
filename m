Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843E886347;
	Thu, 30 Oct 2025 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761826808; cv=none; b=d9SApsGECDwY8+bK7Q+DbHuvYoMJVSvO4nd2+YEUWZpdR+0JtiTzeVN4EEcX3yYlnpv9xTpK0XzyszkdUO291F5FvPgDAdBZuRWCUA9dEQaHsf+6R0tplrmxfFxPuRM2wPgicQxChSzSsGSlYb+QrY63S01ABboj7MvSKee9dqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761826808; c=relaxed/simple;
	bh=v14TvLeTXJC3tKmV8PXnxdxhW73FR08gOZq0qf2eERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Paid1CKwDk65jW+zIEQ8w/96eKfJIk7EkijEGi0lRFkdLbKRrRzQiZV+yLID4VW9zOhfz8NJEHiBh08SgX3/TOgk14oCNW+5h6zUJYVqi6aZzaXBqCRU6fL3r2iyERUVPSQxn9NDg85skeUg8eq6zIYZUmeZjmrTzWKjaEcart4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B11FE6020C; Thu, 30 Oct 2025 13:20:03 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 1/3] netfilter: nf_tables: use C99 struct initializer for nft_set_iter
Date: Thu, 30 Oct 2025 13:19:52 +0100
Message-ID: <20251030121954.29175-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251030121954.29175-1-fw@strlen.de>
References: <20251030121954.29175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Use C99 struct initializer for nft_set_iter, simplifying the code and
preventing future errors due to uninitialized fields if new fields are
added to the struct.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++------------------
 net/netfilter/nft_lookup.c    | 13 +++++--------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..f3de2f9bbebf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5770,7 +5770,11 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
 	struct nft_set_binding *i;
-	struct nft_set_iter iter;
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
+		.fn		= nf_tables_bind_check_setelem,
+	};
 
 	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
@@ -5785,13 +5789,6 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 				goto bind;
 		}
 
-		iter.genmask	= nft_genmask_next(ctx->net);
-		iter.type	= NFT_ITER_UPDATE;
-		iter.skip 	= 0;
-		iter.count	= 0;
-		iter.err	= 0;
-		iter.fn		= nf_tables_bind_check_setelem;
-
 		set->ops->walk(ctx, set, &iter);
 		if (!iter.err)
 			iter.err = nft_set_catchall_bind_check(ctx, set);
@@ -6195,7 +6192,17 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct nft_set *set;
-	struct nft_set_dump_args args;
+	struct nft_set_dump_args args = {
+		.cb = cb,
+		.skb = skb,
+		.reset = dump_ctx->reset,
+		.iter = {
+			.genmask = nft_genmask_cur(net),
+			.type = NFT_ITER_READ,
+			.skip = cb->args[0],
+			.fn = nf_tables_dump_setelem,
+		},
+	};
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
@@ -6246,15 +6253,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	args.cb			= cb;
-	args.skb		= skb;
-	args.reset		= dump_ctx->reset;
-	args.iter.genmask	= nft_genmask_cur(net);
-	args.iter.type		= NFT_ITER_READ;
-	args.iter.skip		= cb->args[0];
-	args.iter.count		= 0;
-	args.iter.err		= 0;
-	args.iter.fn		= nf_tables_dump_setelem;
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 58c5b14889c4..fc2d7c5d83c8 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -246,19 +246,16 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
-	struct nft_set_iter iter;
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
+		.fn		= nft_setelem_validate,
+	};
 
 	if (!(priv->set->flags & NFT_SET_MAP) ||
 	    priv->set->dtype != NFT_DATA_VERDICT)
 		return 0;
 
-	iter.genmask	= nft_genmask_next(ctx->net);
-	iter.type	= NFT_ITER_UPDATE;
-	iter.skip	= 0;
-	iter.count	= 0;
-	iter.err	= 0;
-	iter.fn		= nft_setelem_validate;
-
 	priv->set->ops->walk(ctx, priv->set, &iter);
 	if (!iter.err)
 		iter.err = nft_set_catchall_validate(ctx, priv->set);
-- 
2.51.0

