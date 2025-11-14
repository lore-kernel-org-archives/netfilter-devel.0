Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C0B1E505
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763127413; cv=none; b=B8JkPksRUdZZrxdROz6xkfArPdyphcPN9SW0oou7o35Js5FzHlfU7GOw9ULnxgOzMUBjgPJq8bZE7oVBSsBQlSeIXATsTffiV8nC4ay9+c04+ufHEiyyKEBCKeuFB796vo/24e/cJdnBGqg77AvRiityQCrn4aWdWQ5vnZrFtSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763127413; c=relaxed/simple;
	bh=2DLl8WUCKsjwzmeD+vKK3Gm0cjNcNOLhgxKPkO+bYR4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNGzRo0h6zZgU9VWwF9f8qtJSNIVRoDXJo1C9giAqgYqOK3hf9xosfoB4aVLvN0fsF+z2At90YGXHfR5AjcjN6wSSp7hg8RPNZhKILo4RZSzD5A4ukbD5NfAYp+lXSLhOETYsvPLUBzHIymWK6XhMtfZq0ESK5oVK9D/uuJpXwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F4175604E7; Fri, 14 Nov 2025 14:36:42 +0100 (CET)
Date: Fri, 14 Nov 2025 14:36:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
Message-ID: <aRcwa_ZsBrvKFEci@strlen.de>
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
 <aRcnt9F7N5WiV-zi@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRcnt9F7N5WiV-zi@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > +/* Mask for flags that affect expression parsing context */
> > +#define CTX_F_EXPR_MASK	(CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_DTYPE | \
> > +			 CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | \
> > +			 CTX_F_CONCAT)
> 
> Maybe define as 'UINT32_MAX & ~(CTX_F_COLLAPSED | CTX_F_IMPLICIT)'
> instead?

> >  struct json_ctx {
> >  	struct nft_ctx *nft;
> > @@ -1725,10 +1731,14 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
> >  		return NULL;
> >  
> >  	for (i = 0; i < array_size(cb_tbl); i++) {
> > +		uint32_t expr_flags;
> > +
> >  		if (strcmp(type, cb_tbl[i].name))
> >  			continue;
> >  
> > -		if ((cb_tbl[i].flags & ctx->flags) != ctx->flags) {
> > +		/* Only check expression context flags, not command-level flags */
> > +		expr_flags = ctx->flags & CTX_F_EXPR_MASK;
> > +		if ((cb_tbl[i].flags & expr_flags) != expr_flags) {

So when adding CTX_F_BLA as new expr flag, one has to rember to add it
to CTX_F_EXPR_MASK.  Given that I concur with Phil.

> >  	rule = rule_alloc(int_loc, NULL);
> >  
> >  	json_unpack(root, "{s:s}", "comment", &comment);
> > @@ -4352,8 +4374,21 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
> >  
> >  		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
> >  	}
> > -	/* to accept 'list ruleset' output 1:1, try add command */
> > -	return json_parse_cmd_add(ctx, root, CMD_ADD);
> > +	/* to accept 'list ruleset' output 1:1, try add command
> > +	 * Mark as implicit to distinguish from explicit add commands.
> > +	 * This allows explicit {"add": {"rule": ...}} to use handle for positioning
> > +	 * while implicit {"rule": ...} (export format) ignores handles.
> > +	 */
> > +	{
> > +		uint32_t old_flags = ctx->flags;
> > +		struct cmd *cmd;
> > +
> > +		ctx->flags |= CTX_F_IMPLICIT;
> > +		cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
> > +		ctx->flags = old_flags;
> > +
> > +		return cmd;
> > +	}
> 
> This use of nested blocks is uncommon in this project. I suggest to
> either introduce a wrapper function or declare the two variables at the
> start of the function's body.

Right, as json_parse_cmd() is small I would go for the latter.

> > +# Verify all objects were created
> > +$NFT list ruleset > /dev/null || { echo "Failed to list ruleset after add operations"; exit 1; }
> 
> This command does not do what the comment says. To verify object
> creation, either use a series of 'nft list table/chain/set/...' commands
> or compare against a stored ruleset dump. See
> tests/shell/testcases/cache/0010_implicit_chain_0 for a simple example.

Yes, please use stored dump and let the test wrapper validate this if
possible.  I understand this can't work when the script has to validate
intermediate states too, but the last expected state canand should be
handled via dump.  More dumps also enhance fuzzer coverage since the
dumps are used for the initial input pool.

Also run "tools/check-tree.sh" and make sure it doesn't result in new
errors with the new test case.

If you like you can also split the actual patch and the test cases in
multiple patches, but thats up to you.
