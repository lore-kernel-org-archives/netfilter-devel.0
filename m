Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EAF7EF06
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.212.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715176719; cv=none; b=VtFK1rjn05I4+TmsBkHfmTn4uswKiZN5UOAPKdwIPk5X4JJTXrdDaGCBEgG0OulYX2JmUwe0Y8oI4oi4TkVELoUDVknNdH92wZ695KwYlwnCx3+9MLQg/prcqcxETCrL9GbbPGpIpW3gFsq2qLeuKpE9jEU56zK5KaoLI7klQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715176719; c=relaxed/simple;
	bh=ytSuehV98R+PfsQ8j8OVXcElVjdw++WvB542hUcgdPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0w5IUmC1nErSrOWeXRVvpfiEsm7HEycKdvVBe+nMZaGjOH3N7m7l6iEqeny15sn3uZIg4kbgI/FAuxXbDPjp5Sd+6IEk3c3E3Fcdi77qEQOAjqAPG8nxcnHOOh1xafTXI3Xn0MI/FSci8qia5LvTExplqk3wX2y+60qDIiv0x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de; spf=pass smtp.mailfrom=sysmocom.de; arc=none smtp.client-ip=176.9.212.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sysmocom.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sysmocom.de
Received: from localhost (localhost [127.0.0.1])
	by mail.sysmocom.de (Postfix) with ESMTP id 8AE75C8A6F8;
	Wed,  8 May 2024 13:58:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
	by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9voc0yOfuEy8; Wed,  8 May 2024 13:58:26 +0000 (UTC)
Received: from my.box (i59F7ADA3.versanet.de [89.247.173.163])
	by mail.sysmocom.de (Postfix) with ESMTPSA id 53AA7C8A6F6;
	Wed,  8 May 2024 13:58:26 +0000 (UTC)
Date: Wed, 8 May 2024 15:58:25 +0200
From: Neels Hofmeyr <nhofmeyr@sysmocom.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables with thousands of chains is unreasonably slow
Message-ID: <ZjuFARvpfgHmX-D9@my.box>
References: <ZjjGOyXkmeudzzc5@my.box>
 <ZjqsBomPs2qWEi_5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjqsBomPs2qWEi_5@calendula>

On Wed, May 08, 2024 at 12:32:38AM +0200, Pablo Neira Ayuso wrote:
> Yes, a simple reproducer would be good to have.

ack, will send one soon.
How does that typically look, a shell script?

> You are focusing on the "set up / tear down thousands of GTP tunnels"
> problems in this email, correct?

A bit of context, the general interest came about from my job, working on
osmo-upf and osmo-hnbgw, but this is now shifting to a personal interest that
isn't necessarily backed by my employer.

I think the most narrow focus is this:

compare time taken adding
- the first chain
to
- the 1001st chain
to
- the 10001st chain.

My experience shows that each additional chain takes longer than the one
before.

Likewise, deleting one of 10000 chains takes significantly longer than deleting
one of 1000 chains, which in turn takes significantly longer than deleting one
of 10 chains in a table.

I suspect inefficiency in the very basic handling of chains per se, and not in
particular my type of chain (rewriting UDP packets). But for reference of what
kinds of chains I am using, you can look at this link:
> > https://gitea.osmocom.org/cellular-infrastructure/osmo-upf/src/commit/a21bcec358a5147deb15d156700279f52386a7d7/tests/nft-rule.vty

My aim here is a general approach: how efficient does nftables work for large
numbers of chains and rules?

- could we scale down use of temporary memory?
- could we more efficiently free temporary memory?
- could we do the freeing maintenance work *after* returning the results?

And the most important question I am asking here is: are things like this
already known issues or are we opening a new angle to things?

> In you scenario: Is there a nft_run_cmd_from_buffer() call for each
> new chain?

I tried batching of something like 400 chain additions, but it does not make
any significant difference.

> > Then I can also retrieve the counters in batches of 100, which might be more
> > efficient and better to coordinate with concurrent tasks.
> 
> This means, your existing approach is not batching updates?

Reconsidering, I'd rather not mix this aspect into this mail thread, my main
interest is in the quite general performance considerations above. (This is
referring to another use case, sorry for the confusion. That use case is about
retrieving counters from all chains in a rule set efficiently. fetching all at
once is slow, so fetching in batches might help. But let's ignore that aspect
for now).

> > - can we fix that? Is there some memory leak / unnecessary blow up happening
> >   that causes this apparent factor 1000 in effort?
> 
> tests regularly run valgrind and ASAN to ensure no memleaks.

Sorry, wrong word, I meant not really a memleak proper, but a sort of overkill
use of memory: given that all temporary allocations are properly cleaned up
later, it can still be a sort of "leak" if the nr of those allocations
explodes. For example, a rapid loop could maybe use a single allocation all
over instead of one per iteration, or some data tree need not necessarily be
copied for just some read-only access... that kind of thing in general.

~N
