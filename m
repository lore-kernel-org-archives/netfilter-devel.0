Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2391CAB3
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757375329; cv=none; b=QOcCgd9K5laF68SaPvxUB9RaFaFHGc+8PiUqPftA6pFr19YYV101sawvqoA2jxZtvholVk5bU7JRkvgfIfm6ux5PQhbX81K56+CGagpiS03/qUNiePkyJEDVQ6AkGbCdbNLfzsXXBZst0GVh5SY6pO4ovmEOFZMAZJtH5gd0tGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757375329; c=relaxed/simple;
	bh=GBGYc/sN7ptwIfhJcBlle/unOW70NibtMzDhtlBdxR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgN61Szhn65QG1FxVaUKukaUq3aHFZEdzpznVSOYdis/Ow+hvIuxzN/SrUZYy8PdAQKiG8rQhMYOKfQ+bCsp09f9JICn5cnQ4YuwRkT9Y/NyeUV4Erk4hkdMlXyplkjrgKD7Q35HsSsL6AT2252kOSp7wF1NqChNU929Lsfv2/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qHFnXE5Z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qHFnXE5Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DxQceq06cuyzTXFoT1DTrQXLG/pzpqAE05OTOXQkW34=; b=qHFnXE5ZHaVKwQO7OeNtQPqvry
	7yywwFBEXv7Ksl4v3GrOhcnDIjbsNYjHZ3Slmyqyc9RS4Q3Zmmb5s+8jdLpwlPyfglJT6riZVDRqw
	o/1oMQUaRTZwc8RvzNMowlDepO1Z7K5TF5/CS31DfiF0fNJdxjwGHHhHIolg15X9thZkVcU4GIgFP
	ag7DON4gCVtRijtMMBVqps1rBaI00WLARv+efvkUkQG482tN8khFNBdpUd8ExUnNwJeyjg6gzAZLH
	ZwVHC6HQvErvewdUKXap4ilOMzjI6AA4nrYkhZ4BnR5U0DhnAOO6wV8PEG66lFphioSua3gx5NmFk
	9ztkVIAA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uvlbI-000000006U6-25Pj;
	Tue, 09 Sep 2025 01:48:44 +0200
Date: Tue, 9 Sep 2025 01:48:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/5] mnl: Allow for updating devices on existing inet
 ingress hook chains
Message-ID: <aL9rXH0n2RIYeqzl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-4-phil@nwl.cc>
 <aL6v70HMECk3feny@calendula>
 <aL63bN5qs5ej_pTn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL63bN5qs5ej_pTn@calendula>

On Mon, Sep 08, 2025 at 01:01:00PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 08, 2025 at 12:29:03PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 29, 2025 at 04:25:11PM +0200, Phil Sutter wrote:
> > > Complete commit a66b5ad9540dd ("src: allow for updating devices on
> > > existing netdev chain") in supporting inet family ingress hook chains as
> > > well. The kernel does already but nft has to add a proper hooknum
> > > attribute to pass the checks.
> > > 
> > > The hook.num field has to be initialized from hook.name using
> > > str2hooknum(), which is part of chain evaluation. Calling
> > > chain_evaluate() just for that purpose is a bit over the top, but the
> > > hook name lookup may fail and performing chain evaluation for delete
> > > command as well fits more into the code layout than duplicating parts of
> > > it in mnl_nft_chain_del() or elsewhere. Just avoid the
> > > chain_cache_find() call as its assert() triggers when deleting by
> > > handle and also don't add to be deleted chains to cache.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/evaluate.c | 6 ++++--
> > >  src/mnl.c      | 2 ++
> > >  2 files changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/src/evaluate.c b/src/evaluate.c
> > > index b7e4f71fdfbc9..db4ac18f1dc9f 100644
> > > --- a/src/evaluate.c
> > > +++ b/src/evaluate.c
> > > @@ -5758,7 +5758,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
> > >  		return table_not_found(ctx);
> > >  
> > >  	if (chain == NULL) {
> > > -		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> > > +		if (ctx->cmd->op != CMD_DELETE &&
> > > +		    ctx->cmd->op != CMD_DESTROY &&
> > > +		    !chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> > >  			chain = chain_alloc();
> > >  			handle_merge(&chain->handle, &ctx->cmd->handle);
> > >  			chain_cache_add(chain, table);
> > > @@ -6070,7 +6072,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
> > >  		return 0;
> > >  	case CMD_OBJ_CHAIN:
> > >  		chain_del_cache(ctx, cmd);
> > > -		return 0;
> > > +		return chain_evaluate(ctx, cmd->chain);
> > 
> > Maybe fix this to perform chain_del_cache() after chain_evaluate()?

I agree, side-effects of reusing chain_evaluate() for deletion are not
worth it.

> > ie.
> > 
> >                 if (chain_evaluate(ctx, cmd->chain) < 0)
> >                         return -1;
> > 
> >                 chain_del_cache(ctx, cmd);
> 
> My suggestion won't work.
> 
> Maybe add a specific chain_del_evaluate(), see untested patch attached.

Since we only need a proper value in chain->hook.num, a more minimal
version is fine:

diff --git a/src/evaluate.c b/src/evaluate.c
index b7e4f71fdfbc9..8cecbe09de01c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5992,6 +5992,22 @@ static void chain_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
        chain_free(chain);
 }
 
+static int chain_del_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
+{
+       struct chain *chain = cmd->chain;
+
+       if (chain && chain->flags & CHAIN_F_BASECHAIN && chain->hook.name) {
+               chain->hook.num = str2hooknum(chain->handle.family,
+                                             chain->hook.name);
+               if (chain->hook.num == NF_INET_NUMHOOKS)
+                       return __stmt_binary_error(ctx, &chain->hook.loc, NULL,
+                                                  "The %s family does not support this hook",
+                                                  family2str(chain->handle.family));
+       }
+       chain_del_cache(ctx, cmd);
+       return 0;
+}
+
 static void set_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 {
        struct table *table;
@@ -6069,8 +6085,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
        case CMD_OBJ_RULE:
                return 0;
        case CMD_OBJ_CHAIN:
-               chain_del_cache(ctx, cmd);
-               return 0;
+               return chain_del_evaluate(ctx, cmd);
        case CMD_OBJ_TABLE:
                table_del_cache(ctx, cmd);
                return 0;

Fine with you?

Cheers, Phil
