Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638CB1D8E10
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862194; cv=none; b=DbKCbA2gVsbxFci6knmYW3nI/6oWpimZd1qwxdaebTvpLz7sXdwwnanAttFGN7hFbhpqg3zU94HFDlMhgyxlx1lFay83t12EJ0773+Q0eKAK5EkdECRrDIh75Y0qyXwU3mfPJ5y22+v6s3hZ9rHoSRoVWza0TUzOCz5gb0Whe40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862194; c=relaxed/simple;
	bh=tvBpiwHuj3BxZghpbpmhk8E40bUHtp1p5bRZgZawN9g=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlf/QhPW2rCSVVPuSwXD3WuQUu9O97KynER28xfgorrQLTJNjpQBOlbxHAdsvw+O/PCTwuA/p91Q60/HZFOKJDsDDFD5lRsFWFqnvOmwDPd3l59msUpoV41ZFXSH6eGUM50dOW2flKFYtpv2h6ReMNJ+3LyRtv6B8jmTEg7OK8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36464 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t4KB0-007pGn-Uq; Fri, 25 Oct 2024 15:16:29 +0200
Date: Fri, 25 Oct 2024 15:16:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Matthieu Baerts <matttbe@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <ZxuaKpavQuIMIRC8@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
 <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
 <20241025092356.GA11843@breakpoint.cc>
 <Zxto-TvgUAa1p9N9@orbyte.nwl.cc>
 <ZxtyZ8-jVGuGCU2K@calendula>
 <Zxt5Q16q1M3idZV3@orbyte.nwl.cc>
 <ZxuEXQe3j8rH_3c5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5bul5KrhXaosgpen"
Content-Disposition: inline
In-Reply-To: <ZxuEXQe3j8rH_3c5@calendula>
X-Spam-Score: -1.8 (-)


--5bul5KrhXaosgpen
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Oct 25, 2024 at 01:43:28PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 25, 2024 at 12:56:03PM +0200, Phil Sutter wrote:
[...]
> > We would not change behaviour in stable this way, also not the worst
> > thing to do. Your call!
> 
> I am still exploring how ugly this fix looks, you will see get to know.

This is a quick preview, compile-tested only at this stage.

--5bul5KrhXaosgpen
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="candidate-fix.patch"

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 91ae20cb7648..8dd8e278843d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1120,6 +1120,7 @@ struct nft_chain {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	struct rcu_head			rcu_head;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
@@ -1282,6 +1283,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	possible_net_t			net;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a24fe62650a7..762879187edb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1495,6 +1495,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
 	INIT_LIST_HEAD(&table->flowtables);
+	write_pnet(&table->net, net);
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++nft_net->table_handle;
@@ -11430,22 +11431,39 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-int __nft_release_basechain(struct nft_ctx *ctx)
+static void __nft_release_basechain_rcu(struct rcu_head *head)
 {
+	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
 	struct nft_rule *rule, *nr;
+	struct nft_ctx ctx = {
+		.family	= chain->table->family,
+		.net	= read_pnet(&chain->table->net),
+	};
+
+	list_for_each_entry_safe(rule, nr, &chain->rules, list) {
+		list_del(&rule->list);
+		nf_tables_rule_release(&ctx, rule);
+	}
+	nf_tables_chain_destroy(chain);
+	put_net(ctx.net);
+}
+
+int __nft_release_basechain(struct nft_ctx *ctx)
+{
+	struct nft_rule *rule;
 
 	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
 		return 0;
 
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
+	list_for_each_entry(rule, &ctx->chain->rules, list)
 		nft_use_dec(&ctx->chain->use);
-		nf_tables_rule_release(ctx, rule);
-	}
+
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx->chain);
+	get_net(ctx->net);
+
+	call_rcu(&ctx->chain->rcu_head, __nft_release_basechain_rcu);
 
 	return 0;
 }

--5bul5KrhXaosgpen--
