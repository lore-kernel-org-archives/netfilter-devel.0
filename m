Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3253363
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032564; cv=none; b=G5821aEDLc34XblnSMPqjSMeLfdtUBjr0PUGUhHWYG38XqRK+t7q1t1g6cW+KMWR7lRIU5Un1zXHZ5kP0Cx2tj6JXu2ACF9KY3O7zpL6ur8axbzzy7iLcwID7vAwB42X/dzOvddVDhIBRiAti6VVraFbfzVkNqkAXxcaP9jyhdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032564; c=relaxed/simple;
	bh=cyfJveTXf2n5YSnUZ6fPRgBhIh6oax1Nbn+FH43eeO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIMAkvqgNZnOxdiallDrNhhiHpjidVQu3Ba1Wx+nqf/mCChZ7nXcyUWGaNE4DTb7dVFV4w8XTm16T1JqYmLevTDyVRneDXWyVrzj/3sXjmP3hylMiSMPl6xImWxVGGFzyIXROEdRuOoGguFdT/NaWRPxxCtHg6bOHgWQvnY+yMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GQ8zS4Vw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GQ8zS4Vw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iP+iblIVmOTmSVSU8q6FhskaIw+2fVqoINwBB9DmNmY=; b=GQ8zS4VwDtm7LxagQu0zzGcwiY
	foMhrui1NFu+PF/q8MqeUpIrjA3adkbiNnQgPJmIyDJ3gX9DS6fQP5i/WE88AEkch7Z92/RyrAXcU
	vr0n/WuGINL8CGfhb5GMC2KXsaBXWoU1kFoVPA7wSCuy3eXQ1Y7sMgHxhLcrNtP/gN3NWzKkz4Fg3
	7p+DjH9rTxfNVlisPmlegYjtA1Vjf9R4hWcZ9Qg9nDlf0xQEiKZtwT/X0qVMySjmEt1ved5Ap+UIm
	pqgVPGU3zn+QGOX01+fr24b4yglCzxI05w3ZHZBTFlWBiNaGvHy/eJzy5aFDDdGDAemstl5vaQxWw
	rEqVAXrg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDQmz-0000000044R-1Ecj;
	Tue, 19 Nov 2024 17:09:17 +0100
Date: Tue, 19 Nov 2024 17:09:17 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Message-ID: <Zzy4LTNe4a4bepmX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
References: <20241023145730.16896-1-phil@nwl.cc>
 <Zzc3FV4FG8a6px7z@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzc3FV4FG8a6px7z@calendula>

Hi Pablo,

On Fri, Nov 15, 2024 at 12:57:09PM +0100, Pablo Neira Ayuso wrote:
> Sorry for slowness.

No worries!

> On Wed, Oct 23, 2024 at 04:57:23PM +0200, Phil Sutter wrote:
> > Changes since v5:
> > - Extract the initial set of patches making netdev hooks name-based as
> >   suggested by Florian.
> > - Drop Fixes: tag from patch 1: It is not correct (the pointless check
> >   existed before that commit already) and it is rather an optimization
> >   than fixing a bug.
> > 
> > This series makes netdev hooks store the interface name spec they were
> > created for and establishes this stored name as the key identifier. The
> > previous one which is the hook's 'ops.dev' pointer is thereby freed to
> > vanish, so a vanishing netdev no longer has to drag the hook along with
> > it. (Patches 2-4)
> > 
> > Furthermore, it aligns behaviour of netdev-family chains with that of
> > flowtables in situations of vanishing interfaces. When previously a
> > chain losing its last interface was torn down and deleted, it may now
> > remain in place (albeit with no remaining interfaces). (Patch 5)
> > 
> > Patch 6 is a cleanup following patch 5, patches 1 and 7 are independent
> > code simplifications.
> 
> Patch 1-4 can be integrated, they are relatively small.
> 
> Patches 5-6 will need a rebase due to my fix in that path.
> 
> Patch 7 is probably uncovering an issue with flowtable hardware
> offload support, because I suspect _UNBIND is not called from that
> path, I need to have a look.

Checking callers of nft_unregister_flowtable_net_hooks():

nf_tables_commit() calls it for DELFLOWTABLE, code-paths differ for
flowtable updates or complete deletions: With the latter,
nft_commit_release() calls nf_tables_flowtable_destroy() which does the
UNBIND. So if deleting individual interfaces from an offloaded flowtable
is supported, we may miss the UNBIND there.

__nf_tables_abort() calls it for NEWFLOWTABLE. The hooks should have
been bound by nf_tables_newflowtable() (or nft_flowtable_update(),
respectively) so this seems like missing UNBIND there.

Now about __nft_release_hook, I see:

nf_tables_pre_exit_net
-> __nft_release_hooks
  -> __nft_release_hook

Do we have to UNBIND at netns exit?

There is also:

nft_rcv_nl_event
-> __nft_release_hook

I don't see where hooks of flowtables in owner flag tables are unbound.

> I am inclined to postpone this batch to the next development cycle.

FWIW, the bugs are older than my trivial function elimination. But
indeed, the above needs more attention than the new feature.

Cheers, Phil
