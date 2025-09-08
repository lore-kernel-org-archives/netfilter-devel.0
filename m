Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2122FA0ED
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 11:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757329268; cv=none; b=kqjwbxiX/car0HUjhdg20LiqvA/ZctWmS6rOnKzvaO0nZUZB2s8GXvpT+G7KBdZ4aK+EtBaTZ0vyVxzSECEF2f4JMsT6KoY952JJgC47fspX+DZynStUwdPxBOd6VMpiH12NBEd6Q9eA9z1hMfU4NhpHP5WkQFi1Wib6xnV4fxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757329268; c=relaxed/simple;
	bh=+yq5Z0jqszPO5o6Y8PTEs++I0TCXHSbMbXJhqggsaVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CkVTn+iV29YPSont6UgN+L7FfJ2UL9cWn/Kjr6HuSgDpYc0gKyqrBUYPf3EQzxDR078PgLKFNAPmT29KuplZIBb5yZdxfDG30qaMqXxvvvPWPOyS4aSaYg0iRzNVyB/VNLlplZKttRaWe0OBMK6rB6vU5DCRXpmQ7E7yqhoLzXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M9ZJ5UK0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sM8CjcHQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M9ZJ5UK0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sM8CjcHQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 70B29606E9; Mon,  8 Sep 2025 13:01:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757329264;
	bh=gNJmZScZzoYVKciVU6GkClt9NMbHDwIFuEK/euTsMaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9ZJ5UK0jixAitKvQ9LCcuNTLCWy+lZytCDO4byeQgo9L9yC3gx5Bl3LBGEna+wx9
	 elZwT3ogppo+zJvCIjPyJI6yoD/jLv0GLfYfcheE7UFV45raBO/1KIvhej0MQsZZ8O
	 HIlhL0b71X25CVvTcRZrdmApuIgWhr1XdCeukqJ+0RbatBMmWEvlpylV6N92PuSDQE
	 46yiFJrKTdqJ27DAFsfqoFzy7ElBgWmwwQ/FthXl94mCS/++oH16xQlgJL69ZO5EAq
	 L7mHGpB8FxkefyXzmFw3RrJRCQ6h9ZChIDF8fcsPl5IsV3bs9AeB/992QYaG6WXtDt
	 dNtyJSXAFZDcA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CF9506069D;
	Mon,  8 Sep 2025 13:01:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757329263;
	bh=gNJmZScZzoYVKciVU6GkClt9NMbHDwIFuEK/euTsMaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sM8CjcHQDuszmJLin69yX6v+1P6+inEjcLTdVRaY63afsrbnAIlSbY4cASAQhZ1eM
	 KVEDL/SJ/c/BS6MQWwzsrlTI1s9LFV7YKV/GU9PMAExZiXXUPphLZUUTH2vp46Suwr
	 0HK5qxe7xzSNl25OhISX16mfBsaDaRiSTT2/9hWh1zBrNAGmwniaSZSBsVL3sF6cVi
	 FFAc3YBxW7MeFnBcNUYMK1JmvuPmQ14ILMrlcVgrz6V+6dvJYZ0pnN96Kee39NrkAS
	 Wxf+x4XKEqTKnVoNZsypkEEqLAwuUrZ91QtTyjTx2rTuzi773HHgZhp8kaoQaYXaqP
	 i4SYTaRs4gLMQ==
Date: Mon, 8 Sep 2025 13:01:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/5] mnl: Allow for updating devices on existing inet
 ingress hook chains
Message-ID: <aL63bN5qs5ej_pTn@calendula>
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-4-phil@nwl.cc>
 <aL6v70HMECk3feny@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3cGxp0L7TTIr2QCx"
Content-Disposition: inline
In-Reply-To: <aL6v70HMECk3feny@calendula>


--3cGxp0L7TTIr2QCx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Sep 08, 2025 at 12:29:03PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 29, 2025 at 04:25:11PM +0200, Phil Sutter wrote:
> > Complete commit a66b5ad9540dd ("src: allow for updating devices on
> > existing netdev chain") in supporting inet family ingress hook chains as
> > well. The kernel does already but nft has to add a proper hooknum
> > attribute to pass the checks.
> > 
> > The hook.num field has to be initialized from hook.name using
> > str2hooknum(), which is part of chain evaluation. Calling
> > chain_evaluate() just for that purpose is a bit over the top, but the
> > hook name lookup may fail and performing chain evaluation for delete
> > command as well fits more into the code layout than duplicating parts of
> > it in mnl_nft_chain_del() or elsewhere. Just avoid the
> > chain_cache_find() call as its assert() triggers when deleting by
> > handle and also don't add to be deleted chains to cache.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/evaluate.c | 6 ++++--
> >  src/mnl.c      | 2 ++
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index b7e4f71fdfbc9..db4ac18f1dc9f 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -5758,7 +5758,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
> >  		return table_not_found(ctx);
> >  
> >  	if (chain == NULL) {
> > -		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> > +		if (ctx->cmd->op != CMD_DELETE &&
> > +		    ctx->cmd->op != CMD_DESTROY &&
> > +		    !chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> >  			chain = chain_alloc();
> >  			handle_merge(&chain->handle, &ctx->cmd->handle);
> >  			chain_cache_add(chain, table);
> > @@ -6070,7 +6072,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
> >  		return 0;
> >  	case CMD_OBJ_CHAIN:
> >  		chain_del_cache(ctx, cmd);
> > -		return 0;
> > +		return chain_evaluate(ctx, cmd->chain);
> 
> Maybe fix this to perform chain_del_cache() after chain_evaluate()?
> ie.
> 
>                 if (chain_evaluate(ctx, cmd->chain) < 0)
>                         return -1;
> 
>                 chain_del_cache(ctx, cmd);

My suggestion won't work.

Maybe add a specific chain_del_evaluate(), see untested patch attached.

--3cGxp0L7TTIr2QCx
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index d4971228b61f..7c72a453d0f3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5722,6 +5722,37 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	return NF_INET_NUMHOOKS;
 }
 
+static int chain_del_evaluate(struct eval_ctx *ctx, struct chain *chain)
+{
+	struct table *table;
+
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
+	if (table == NULL)
+		return table_not_found(ctx);
+
+	if (chain->dev_expr) {
+		if (!(chain->flags & CHAIN_F_BASECHAIN))
+			chain->flags |= CHAIN_F_BASECHAIN;
+
+		if (chain->handle.family == NFPROTO_NETDEV ||
+		    (chain->handle.family == NFPROTO_INET &&
+		     chain->hook.num == NF_INET_INGRESS)) {
+			if (chain->dev_expr &&
+			    !evaluate_device_expr(ctx, &chain->dev_expr))
+				return -1;
+		} else if (chain->dev_expr) {
+			return __stmt_binary_error(ctx, &chain->dev_expr->location, NULL,
+						   "This chain type cannot be bound to device");
+		}
+	}
+
+	chain_del_cache(ctx, cmd);
+
+	return 0;
+}
+
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;

--3cGxp0L7TTIr2QCx--
