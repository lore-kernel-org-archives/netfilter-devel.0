Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1287E30E0EC
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404462; cv=none; b=PUU6VFtfu1G38MTdfYrqP9pVUUAVuhjy2v8XV0dTl97Yea7jdCbauHomZwDZSnTkbvJCdJBh5uMLcy0mo41zkSgIWNWWbRFClQ8ww+//ouZ14J1E0ltmH7QxWYgtA6TLQ/Y61zon20vEvzwkhd8f/pw2pk0SDYpuJz0DOi7/54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404462; c=relaxed/simple;
	bh=xUggmyBFr/92f1UJugabLtcbEHluBrdcmCTCGOvbWgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDUB3z+40wNkkFQ/xWblBZjpBVG7+TOAZmMIUxy9IH0ZMYMmO9y3qdYow4CiFYPSMg4y9ocapIP5nb/EMVU55VyzP06VLNIaaMWcGLlhAzGa1VQsAz8dLh7OFo/JZIepjI4ZoDnhK9NLmkR7H5sftkTP9vuwd1u7h30VANeTneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pa+gU7qe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pa+gU7qe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g047MQeKf/dkdSk8E8uATML9hx6RzC5Z+qCNUjsbbWQ=; b=pa+gU7qekLDdUQvwQ2qVPs35ga
	8JJzJ4uRa3mmNANqsLCKKD8uAXWCrpc2M3lFxFl3YOzdFYz8odBv0ei99DgLJ5HwcE6dQzUmBEXqU
	Ln4h0I13YCSWFBtNBRHaicPH1S1PCjTmvBtcmLZbTgy7ZzcEOq9m5uJw9XADX97vx8/fHgPeelGy1
	C3FKMMHlUP6LGSPbYmqKpWd63dk6D1CgbVM7u55mFnkslfb8fs0wetlwz4JtbZaGrkjnvP6nEDp7U
	wZcDNegc28zFt6zPJIQmckEBPhxPx1t61dBEYksuOgwGVAdWGSCLvf455ayLQY5LJ9MJQBwswhvJy
	HP3kBU7A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vg2mY-000000005iJ-3nZP;
	Wed, 14 Jan 2026 16:27:38 +0100
Date: Wed, 14 Jan 2026 16:27:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
Message-ID: <aWe16oO_R-GwM_Af@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
 <aRcnt9F7N5WiV-zi@orbyte.nwl.cc>
 <aRcwa_ZsBrvKFEci@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRcwa_ZsBrvKFEci@strlen.de>

Alexandre, will you follow-up on this one? Feel free to ping me if
something is unclear or you're stuck somewhere - we're there to help if
needed!

Thanks, Phil

On Fri, Nov 14, 2025 at 02:36:43PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > +/* Mask for flags that affect expression parsing context */
> > > +#define CTX_F_EXPR_MASK	(CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_DTYPE | \
> > > +			 CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | \
> > > +			 CTX_F_CONCAT)
> > 
> > Maybe define as 'UINT32_MAX & ~(CTX_F_COLLAPSED | CTX_F_IMPLICIT)'
> > instead?
> 
> > >  struct json_ctx {
> > >  	struct nft_ctx *nft;
> > > @@ -1725,10 +1731,14 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
> > >  		return NULL;
> > >  
> > >  	for (i = 0; i < array_size(cb_tbl); i++) {
> > > +		uint32_t expr_flags;
> > > +
> > >  		if (strcmp(type, cb_tbl[i].name))
> > >  			continue;
> > >  
> > > -		if ((cb_tbl[i].flags & ctx->flags) != ctx->flags) {
> > > +		/* Only check expression context flags, not command-level flags */
> > > +		expr_flags = ctx->flags & CTX_F_EXPR_MASK;
> > > +		if ((cb_tbl[i].flags & expr_flags) != expr_flags) {
> 
> So when adding CTX_F_BLA as new expr flag, one has to rember to add it
> to CTX_F_EXPR_MASK.  Given that I concur with Phil.
> 
> > >  	rule = rule_alloc(int_loc, NULL);
> > >  
> > >  	json_unpack(root, "{s:s}", "comment", &comment);
> > > @@ -4352,8 +4374,21 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
> > >  
> > >  		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
> > >  	}
> > > -	/* to accept 'list ruleset' output 1:1, try add command */
> > > -	return json_parse_cmd_add(ctx, root, CMD_ADD);
> > > +	/* to accept 'list ruleset' output 1:1, try add command
> > > +	 * Mark as implicit to distinguish from explicit add commands.
> > > +	 * This allows explicit {"add": {"rule": ...}} to use handle for positioning
> > > +	 * while implicit {"rule": ...} (export format) ignores handles.
> > > +	 */
> > > +	{
> > > +		uint32_t old_flags = ctx->flags;
> > > +		struct cmd *cmd;
> > > +
> > > +		ctx->flags |= CTX_F_IMPLICIT;
> > > +		cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
> > > +		ctx->flags = old_flags;
> > > +
> > > +		return cmd;
> > > +	}
> > 
> > This use of nested blocks is uncommon in this project. I suggest to
> > either introduce a wrapper function or declare the two variables at the
> > start of the function's body.
> 
> Right, as json_parse_cmd() is small I would go for the latter.
> 
> > > +# Verify all objects were created
> > > +$NFT list ruleset > /dev/null || { echo "Failed to list ruleset after add operations"; exit 1; }
> > 
> > This command does not do what the comment says. To verify object
> > creation, either use a series of 'nft list table/chain/set/...' commands
> > or compare against a stored ruleset dump. See
> > tests/shell/testcases/cache/0010_implicit_chain_0 for a simple example.
> 
> Yes, please use stored dump and let the test wrapper validate this if
> possible.  I understand this can't work when the script has to validate
> intermediate states too, but the last expected state canand should be
> handled via dump.  More dumps also enhance fuzzer coverage since the
> dumps are used for the initial input pool.
> 
> Also run "tools/check-tree.sh" and make sure it doesn't result in new
> errors with the new test case.
> 
> If you like you can also split the actual patch and the test cases in
> multiple patches, but thats up to you.
> 
> 
