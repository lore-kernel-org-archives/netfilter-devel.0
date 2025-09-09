Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F030E28D82A
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409482; cv=none; b=mdChshfPylEYibE5+bNQFH9C99SLk/4gZ+ABIRpmWttOX4Zk0A3QyjUaMkCKfPl8UrTvIhpE0bR322WG/Pwd5EPFo+hli9cdo/5+DaJhWwl4Gnu1yRAHDvmwH+of8rl3GMC5Y9n8BwIHG4d+eu5nNeaZTnyZ0vWpqPBh3gBwRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409482; c=relaxed/simple;
	bh=gYRoGS/3sF2wprdlXEo52E2SF603kIiqlHAI8Y50IME=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qbt6QKMh0X80PGoDXsv+r+GJEuu0hvDfH/YZryaknFH+4yR0+vkp4EaLjm/GPaFTkxj20HCmWIyRfMh69hGJsvKmja9vy4dCEsLPFnNnaS/TPgWV1dnzIzzD00mCQMxeDe9GBnwa1rwr0IFeozODDzBFpWLc3YTHSj/7CS4q/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I88TgZO0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OH51dhEu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I88TgZO0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OH51dhEu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F2EDD608E8; Tue,  9 Sep 2025 11:17:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757409470;
	bh=E+7pNfyMpqmQJM5yoy17rGzKpaEjxqCewnskUV+KnZc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=I88TgZO02PIMDyl9zaw2kA9JYDTKKBean6iaSNGtkD+ltckEj1YS4Pb8BNo5Kv8DK
	 1z+AGuVXARVIt/W8yxTqkl9u87U5M2uRvzevgE8ukajhIWJBlotKmonvWQknK1jI66
	 fUPqjPvtYbyHY1erCy6qKlcQ31CmVumof9ndZo1mjr6gUDi4ORu77Zg3SMOqosgwGd
	 3/KgWzID7Si14ljUiurrwRIOfvXhuoICTqaO/ihsCGw9cAFjtKcJ8e21TJFrFx3JpB
	 3UxqPth/PFYfeV0ataTrLs43WeeuvOieYJ34MVP9Vd1dtF8QcwsOaysTz4Eyfpj7Q3
	 Ol1CYCqFeV8fQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 19D84608E5;
	Tue,  9 Sep 2025 11:17:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757409469;
	bh=E+7pNfyMpqmQJM5yoy17rGzKpaEjxqCewnskUV+KnZc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=OH51dhEuTKfVyiEPMz/1RydCqyFO6a7TuMEbYaUEidDFHwgi+hGlhxpIbHAO5guXS
	 6IgXYfcQKTKhImK1N3y9jCbYaHpdiStyHtRruDDIZVmE1Ygl89Wa4qxRy4nZuFQwpF
	 ofwQENwA3Otkb+/L+TtuW48NzujP2ljebRbr/A1Kl4aTOx7yQxQQlnxNHWSS6YIIi3
	 8grM39PzVVqK8kqs5Ki4HE5SoxRuV/K6h6bd7yWfJl/NdLousriUCyAd73Ku2D5NPy
	 fOOUwJUJ6Yn/rkkZlIoeGbWWS2HXxBUlkEszB63ktEocmLIqL/17DSiVpt0VURj/y0
	 IR/L6Y9CAHTfQ==
Date: Tue, 9 Sep 2025 11:17:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/5] mnl: Allow for updating devices on existing inet
 ingress hook chains
Message-ID: <aL_wukm2NAeK5DGh@calendula>
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-4-phil@nwl.cc>
 <aL6v70HMECk3feny@calendula>
 <aL63bN5qs5ej_pTn@calendula>
 <aL9rXH0n2RIYeqzl@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aL9rXH0n2RIYeqzl@orbyte.nwl.cc>

On Tue, Sep 09, 2025 at 01:48:44AM +0200, Phil Sutter wrote:
> On Mon, Sep 08, 2025 at 01:01:00PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 08, 2025 at 12:29:03PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Aug 29, 2025 at 04:25:11PM +0200, Phil Sutter wrote:
> > > > Complete commit a66b5ad9540dd ("src: allow for updating devices on
> > > > existing netdev chain") in supporting inet family ingress hook chains as
> > > > well. The kernel does already but nft has to add a proper hooknum
> > > > attribute to pass the checks.
> > > > 
> > > > The hook.num field has to be initialized from hook.name using
> > > > str2hooknum(), which is part of chain evaluation. Calling
> > > > chain_evaluate() just for that purpose is a bit over the top, but the
> > > > hook name lookup may fail and performing chain evaluation for delete
> > > > command as well fits more into the code layout than duplicating parts of
> > > > it in mnl_nft_chain_del() or elsewhere. Just avoid the
> > > > chain_cache_find() call as its assert() triggers when deleting by
> > > > handle and also don't add to be deleted chains to cache.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  src/evaluate.c | 6 ++++--
> > > >  src/mnl.c      | 2 ++
> > > >  2 files changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/src/evaluate.c b/src/evaluate.c
> > > > index b7e4f71fdfbc9..db4ac18f1dc9f 100644
> > > > --- a/src/evaluate.c
> > > > +++ b/src/evaluate.c
> > > > @@ -5758,7 +5758,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
> > > >  		return table_not_found(ctx);
> > > >  
> > > >  	if (chain == NULL) {
> > > > -		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> > > > +		if (ctx->cmd->op != CMD_DELETE &&
> > > > +		    ctx->cmd->op != CMD_DESTROY &&
> > > > +		    !chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> > > >  			chain = chain_alloc();
> > > >  			handle_merge(&chain->handle, &ctx->cmd->handle);
> > > >  			chain_cache_add(chain, table);
> > > > @@ -6070,7 +6072,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
> > > >  		return 0;
> > > >  	case CMD_OBJ_CHAIN:
> > > >  		chain_del_cache(ctx, cmd);
> > > > -		return 0;
> > > > +		return chain_evaluate(ctx, cmd->chain);
> > > 
> > > Maybe fix this to perform chain_del_cache() after chain_evaluate()?
> 
> I agree, side-effects of reusing chain_evaluate() for deletion are not
> worth it.
> 
> > > ie.
> > > 
> > >                 if (chain_evaluate(ctx, cmd->chain) < 0)
> > >                         return -1;
> > > 
> > >                 chain_del_cache(ctx, cmd);
> > 
> > My suggestion won't work.
> > 
> > Maybe add a specific chain_del_evaluate(), see untested patch attached.
> 
> Since we only need a proper value in chain->hook.num, a more minimal
> version is fine:
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b7e4f71fdfbc9..8cecbe09de01c 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5992,6 +5992,22 @@ static void chain_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
>         chain_free(chain);
>  }
>  
> +static int chain_del_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
> +{
> +       struct chain *chain = cmd->chain;
> +
> +       if (chain && chain->flags & CHAIN_F_BASECHAIN && chain->hook.name) {
> +               chain->hook.num = str2hooknum(chain->handle.family,
> +                                             chain->hook.name);
> +               if (chain->hook.num == NF_INET_NUMHOOKS)
> +                       return __stmt_binary_error(ctx, &chain->hook.loc, NULL,
> +                                                  "The %s family does not support this hook",
> +                                                  family2str(chain->handle.family));
> +       }
> +       chain_del_cache(ctx, cmd);
> +       return 0;
> +}
> +
>  static void set_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
>  {
>         struct table *table;
> @@ -6069,8 +6085,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
>         case CMD_OBJ_RULE:
>                 return 0;
>         case CMD_OBJ_CHAIN:
> -               chain_del_cache(ctx, cmd);
> -               return 0;
> +               return chain_del_evaluate(ctx, cmd);
>         case CMD_OBJ_TABLE:
>                 table_del_cache(ctx, cmd);
>                 return 0;
> 
> Fine with you?

Yes, thanks!
