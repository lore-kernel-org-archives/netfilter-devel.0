Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F6D31A7E4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777990507; cv=none; b=ZttPJQcxb5pq5obUKcSOrMjomTlPbluGzUZZ9vP9yaWhhtqNsAhUiGEDdXeRyPm/QZycjQfSLizFmj2/yGqDhK9TJnE2jqsl2Snb0XRwDRZAPAp0HP1b8iX/OjRH+/dgWjo2lWo01azGlmT9P2DnGG/E331NtGFaFCS8cLUD/HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777990507; c=relaxed/simple;
	bh=A+m0qZdxXLF74s9Z/G2pLQ5dpHtXfgscpGpXxg5uOK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXuaMnR2BT2cqKuES+qWIc4/fDZUY8r2gRcqF7Z/fa83iSeXyizZuISCtbUJoL8VQF9fd7DlnrNAm651G+D0DYRsPSdssmOB5LOXgoHV5GO6SqPYvpH900/AlJXW7f9NZTGHGpwowwr1hVp1jb9n/PVxc9SiLyHx8dxjlzfzobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kDhxeVZJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kDhxeVZJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=titpixvVHHI8OHi0D1L9PcJOYsYYHRqEaB8NQNLI6OE=; b=kDhxeVZJ+EdKyBfmHyJ4s3AdpO
	cPy55QvfIbokEx39rhIzgA+xQvLgbeREBSOv1ZtatUTk04TTLk4uCxgTqZHb6mEfVBIWnEawIN2sf
	/3mWRFV/zYpffcSs2jXSm6uKVPWHURF29Ye/zXuLJx8zZSjrvxZodRQjsQEUsmBX3NFWSTZ6Jbvlr
	IfduNLUoXd2nNzb54s1BK/eeaabsJ/juCpYfZ9m+19eWnhwKBZ5xOmPu+Y7XTchO2B/aucLAOSUoA
	8LJlWEd3FvDB4U1Md3jAHqX0/rEZfCiY2pxsWbs/JTkb0p6rmnFF1q3MWx7xLeX9j9VRieH8JTERw
	rNbRwsMA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wKGY4-000000005as-1SBW;
	Tue, 05 May 2026 16:14:56 +0200
Date: Tue, 5 May 2026 16:14:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] scanner: enable verdicts in rate scope too
Message-ID: <afn7YBi361kCLOcY@orbyte.nwl.cc>
References: <20260505103739.25949-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505103739.25949-1-fw@strlen.de>

Hi,

On Tue, May 05, 2026 at 12:37:30PM +0200, Florian Westphal wrote:
> Blamed commit added first use of exclusive start conditions in the
> nftables parser.
> 
> Inclusive start conditions extend the grammar:
>  - token NEW_COND will start to match in scanner.l
>  - all other known tokens remain valid
>  - bison calls back into scanner.l (via scanner_pop_start_cond())
>    when it has parsed a complete rule.
> 
> Exclusive start conditions work in the same way, but with a slight
> difference: Once we enter SCANSTATE_RATE, ALL OTHER tokens that are
> not SCANSTATE_RATE or tagged as <*>, will stop matching.
> 
> This was done to allow something like 1 mbytes/second get handled
> via NUM MBYTES SLASH SECOND rather than STRING (which is no longer
> in scope).
> 
> This is a problem: in nftables, there is no end-token for
> the 'rate' keyword.  The scanstate is popped the same way as for
> the inclusive start conditions.  But flex is greedy.  By the time
> we call scanner_pop_start_cond(), next token has already been parsed
> according to RATE rules.

Oh crap, sorry for the mess. Looks like I relied too much on 'make
check' instead of verifying Bison's lookahead doesn't break it.

> This breaks following rule:
>   nft add rule .. limit rate over 1 mbytes/second drop
>   Error: syntax error, unexpected junk
>   expected any of: end of file, newline, semicolon, [..] drop, continue ...
> 
> Problem is that flex parsed 'd'(rop) while in SCANSTATE_RATE.

Yes, this is the '<*>. { return JUNK; }' rule which catches invalid
input.

> There is no good solution for this problem (aside from altering the
> grammar to be explicitly scoped, e.g. limit rate { over ... }

Not an option, right?

> Another alternative might be to add some string-alike catchall rule to
> <SCANSTATE_RATE> in scanner.l and use that to pop state + rescan via
> yyless(0).  But it feels even more gross than this.

I tested this using the following in scanner.l:

-<*>.                   { return JUNK; }
+<SCANSTATE_RATE>.      { scanner_pop_start_cond(yyscanner, SCANSTATE_RATE); yyless(0); }
+.                      { return JUNK; }

It causes "start-condition stack underflow" with below sample rule, so I
also had to turn 'close_scope_rate' into a NOP in parser_bison.y. Is
this implicit scan state dropping upon reading junk OK? Should we follow
that path with exclusive start conditions?

> Technially we'd have to <*> a lot more keywords, e.g.
> 
>  rate over 1 mbytes/second ip saddr 1.2.3.4
> 
> is valid (or should be).  Its not allowed anymore either.
> It makes a bit less sense to add expressions after a rate limiter, however.

Explicitly marking "global" tokens as such could be regarded syntactic
sugar for further attempts at reducing tokens accepted in global scope.
If you think that's fine, I'll prepare a patch (and an excessive test
case, I guess).

Cheers, Phil
