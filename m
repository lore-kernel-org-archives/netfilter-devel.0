Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA32652
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715186903; cv=none; b=MH8SLojQR32AmPinAvZIP2O68gE1eYldaT3r6xPXNkWXoL2XWSp4TLjCMEvua5AZ6k2C8cKe4Bn4P4PPM98ZGqAOxXyq7ZIgN8OhnMfNv25atfba4qpRddgZn3ml7pmV5ZzskMrIl/lXOQ0DAb6ewwHKB/pQF4y8HDHo1rDAUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715186903; c=relaxed/simple;
	bh=N1/ZMTqDYlcgPrcPwjhSZ+xe9rdh++Czq4FI9EKD0So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lp4doRUZxGbLu3fBtc/XWf4JVp74uqrymD1GC3HUSfbbsdPfDd8gEnMJKCWFOW9fHvor1Vwt+fpLwlIITbw2cYGsTu5F+4o2Pz9kO9RKJ7cJOGb/E+nWU9DZ/kTj9mG3WK/5bPBXJbsiDZj5QtJjtcopsd61t4Tp3MkC0WMuG9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 8 May 2024 18:48:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Neels Hofmeyr <nhofmeyr@sysmocom.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables with thousands of chains is unreasonably slow
Message-ID: <ZjuszktgQPikd50Y@calendula>
References: <ZjjGOyXkmeudzzc5@my.box>
 <ZjqsBomPs2qWEi_5@calendula>
 <ZjuFARvpfgHmX-D9@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZjuFARvpfgHmX-D9@my.box>

On Wed, May 08, 2024 at 03:58:25PM +0200, Neels Hofmeyr wrote:
> On Wed, May 08, 2024 at 12:32:38AM +0200, Pablo Neira Ayuso wrote:
> > Yes, a simple reproducer would be good to have.
> 
> ack, will send one soon.
> How does that typically look, a shell script?

That would be great, yes.

> > You are focusing on the "set up / tear down thousands of GTP tunnels"
> > problems in this email, correct?
> 
> A bit of context, the general interest came about from my job, working on
> osmo-upf and osmo-hnbgw, but this is now shifting to a personal interest that
> isn't necessarily backed by my employer.
> 
> I think the most narrow focus is this:
> 
> compare time taken adding
> - the first chain
> to
> - the 1001st chain
> to
> - the 10001st chain.
> 
> My experience shows that each additional chain takes longer than the one
> before.

I made this script, and I don't observe any variation in the numbers:

nft add table x
for ((i=0;i<4000;i++))
do
        time nft add chain x y$i
done

maybe your reproducer requires a map?

> Likewise, deleting one of 10000 chains takes significantly longer than deleting
> one of 1000 chains, which in turn takes significantly longer than deleting one
> of 10 chains in a table.
> 
> I suspect inefficiency in the very basic handling of chains per se, and not in
> particular my type of chain (rewriting UDP packets). But for reference of what
> kinds of chains I am using, you can look at this link:
> > > https://gitea.osmocom.org/cellular-infrastructure/osmo-upf/src/commit/a21bcec358a5147deb15d156700279f52386a7d7/tests/nft-rule.vty
> 
> My aim here is a general approach: how efficient does nftables work for large
> numbers of chains and rules?
> 
> - could we scale down use of temporary memory?
> - could we more efficiently free temporary memory?
> - could we do the freeing maintenance work *after* returning the results?

Shrinking memory consumption is possible, I suspect you see a frequent
cache fill up then tear down with your pattern.

> And the most important question I am asking here is: are things like this
> already known issues or are we opening a new angle to things?
> 
> > In you scenario: Is there a nft_run_cmd_from_buffer() call for each
> > new chain?
> 
> I tried batching of something like 400 chain additions, but it does not make
> any significant difference.
>
> > > Then I can also retrieve the counters in batches of 100, which might be more
> > > efficient and better to coordinate with concurrent tasks.
> > 
> > This means, your existing approach is not batching updates?
> 
> Reconsidering, I'd rather not mix this aspect into this mail thread, my main
> interest is in the quite general performance considerations above. (This is
> referring to another use case, sorry for the confusion. That use case is about
> retrieving counters from all chains in a rule set efficiently. fetching all at
> once is slow, so fetching in batches might help. But let's ignore that aspect
> for now).

OK.

> > > - can we fix that? Is there some memory leak / unnecessary blow up happening
> > >   that causes this apparent factor 1000 in effort?
> > 
> > tests regularly run valgrind and ASAN to ensure no memleaks.
> 
> Sorry, wrong word, I meant not really a memleak proper, but a sort of overkill
> use of memory: given that all temporary allocations are properly cleaned up
> later, it can still be a sort of "leak" if the nr of those allocations
> explodes. For example, a rapid loop could maybe use a single allocation all
> over instead of one per iteration, or some data tree need not necessarily be
> copied for just some read-only access... that kind of thing in general.

Set elements are particularly consuming more memory, it gets worse
with maps.

If this is a general concern about memory consumption, then I can take
a look at this globally, running existing tests and look at memory
consumption numbers.

I already have a few out-of-tree patches I need to revisit to shrink
memory consumption.
