Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F4818A931
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 22:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736635538; cv=none; b=jJr+ZFEb8Pez6GzL5AV3WKZTjLNyoE7sbE47YGI5V5im6lAqvHcWfZ6OPuRebmpUbyVYdQFoEGPIR3ohb84/rOIQ6EGx0WMjEbISBx5lQrnKSacgyhbN8hmxymvoXGAhzsk93obqtA4KP29gAewUzHmC7ehYSo8zUWuBc5AibPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736635538; c=relaxed/simple;
	bh=RFvhU1jTbVFUjriXXRs5QL/sXrcDuw2SNqtDmIvBROg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKwwK1PJP61R7FZdYTQC46pt2D9lP5HuD/woYt06yURyJ36Jo6ZChhFG7mCgef9x9/rmXheAdvRvWJKIT5IRLSl/lZkRWP0V+m6vwzBgLoz1KysVCDN4NuX0aF0PZ6e3Qq3mgh67IYNnJsipEPArrtjoGXsFE7s9rBPg8jdJ5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Sat, 11 Jan 2025 23:45:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, linux@slavino.sk
Subject: Re: [PATCH nft] parser_bison: simplify syntax to list all sets in
 table
Message-ID: <Z4L0g6aZz9EzxTop@calendula>
References: <20250111143757.65308-1-pablo@netfilter.org>
 <20250111162445.GC14912@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250111162445.GC14912@breakpoint.cc>

On Sat, Jan 11, 2025 at 05:24:45PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Revisit f99ccda252fa ("parser: allow listing sets in one table") to add
> > an alias to list all sets in a given table, eg.
> 
> [..]
> 
> > diff --git a/src/parser_bison.y b/src/parser_bison.y
> > index c8714812532d..ac8de398f8a7 100644
> > --- a/src/parser_bison.y
> > +++ b/src/parser_bison.y
> > @@ -1590,8 +1590,13 @@ list_cmd		:	TABLE		table_spec
> >  			{
> >  				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
> >  			}
> > +			|	SETS		table_spec
> > +			{
> > +				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
> > +			}
> >  			|	SETS		TABLE	table_spec
> >  			{
> > +				/* alias of previous rule. */
> >  				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$3, &@$, NULL);
> >  			}
> 
> I have concerns wrt. to ever expanding list of aliases, it causes divergence as
> to what is allowed:
> 
> <keyword>
> <keyword> inet
> <keyword> inet foo
> <keyword> table inet foo
> 
> In some cases, all of these work  (4 being aliased to 3).
> In others, e.g. "counters" or "quotas" "inet foo" won't work.
> 
> It would be good to at least be consistent.  What about this?
> 
> It would be good to compact it further, this is all because of
> copypastry +slow divergence on later addendums to command subsets.

Consolidating aliases is indeed better approach, please go ahead
submit this patch.

Thanks.
