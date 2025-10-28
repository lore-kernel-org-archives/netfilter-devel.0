Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0789418C31
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 19:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761678621; cv=none; b=h8gTKsjTTx6FkhGRoChpNuEV3S6O0jIiCAzKE7pfnxRI8fbC/Jcynl79sPrP/XCqctOzycu8jIacVYJvXZHqVV9ubOQhivg330Ucn4ao3tXubSLdPjFVybDfFpUAcKzsxuu7lRool9uMraTxBZvW/FldDZ9T08pYSrZBHpgHcDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761678621; c=relaxed/simple;
	bh=UwbjeTsPb2EzPkTX74ALfnZf5SIVCzU66X/ULXTlDBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efuN3cZ+2Rq5jZuYrwKzcnWjNNjvtaeyeDMqqK6j5rMFMaDdFQs0CSIHHm/ZDdG+5j1r2IY+ocTHVsWYf/DrmPUj2qb0kDRghloYCPJsBk4bVcjsemzqhptqL73k0K1fVOf2trwKJqrVyXN9tS4QcJrY0c6eYYtKFv+tV8Z2AoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1856D61B21; Tue, 28 Oct 2025 20:10:15 +0100 (CET)
Date: Tue, 28 Oct 2025 20:10:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQEVF4mZ23ewPmUN@strlen.de>
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula>
 <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula>
 <aQD810keSBweNG66@strlen.de>
 <fdaccdd2-fce5-4224-9636-bf3366de2761@suse.de>
 <aQEMbKZUBms2bfuI@strlen.de>
 <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/28/25 7:33 PM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> >> We need this gc call, it is what fixes the use-case reported by the
> >> user. If the user is using this expression without a ct state new check,
> >> we must check if some connection closed already and update the
> >> connection count properly, then evaluate if the connection count greater
> >> than the limit for all the packets.
> > 
> > I don't think so.  AFAICS the NEW/!confirmed check is enough, a
> > midstream packet (established connection) isn't added anymore so 'ct
> > count' can't go over the budget.
> > 
> > If last real-add brought us over the budget, then it wasn't added
> > (we were over budget), so next packet of existing flow will still be
> > within budget.
> > 
> > Does that make sense to you?
> > 
> 
> It does for standard use case but not for "inverted" flag - the 
> expression will continue matching and letting packets pass even if count 
> is NOT over the limit anymore because the count is not being updated 
> until a new connection arrives.

I don't really see how.  Empty ruleset with single

'ct count over 3 reject'

... is broken flat out broken. I mean, whats that supposed to do?

1st connection comes in -> 1
2nd connection comes in -> 2
3rd connection comes in -> 3
4th connection comes in -> 4 -> rejects happen (for all matching _packets_!)

The extra gc doesn't change anything here except that when one
connection has closed this gets 'healed'.  But I argue that this is
nonsensical ruleset, given the connection has to time out (even fin/rst etc.
won't pass, so normal closing possible).

If we look at a better example:

ct state new ct count over 3 reject
(or same as before but with earlier 'ct state established accept'):

1st connection comes in -> 1
..
4th connection comes in -> 4 -> new connection attempt gets rejected

... some connection closes ...

-> next connection attempt passes, as one entry is reaped and replaced
with another one.

Can you describe a sane failing case?
It should be in a comment if we need to retain the else branch since I
can't come up with a single example of where its needed.
