Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC03B0AE7;
	Tue, 11 Aug 2026 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786486962; cv=none; b=ofOhgA61avk9Fezus7Kr8nsHguvH4J8OQVOkMh5iTjYrT8ceOQmTubfJVFh89CtVXuEYP5xT+23O6XYhzyCp+Dkewl/EjStOaEQCD+fBwbhUk3lYcA17zyi+5O0LrDGPpXl2a83vhqZVFxWV91tPB02rZzhgcJP0RQJ04zLbqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786486962; c=relaxed/simple;
	bh=YxU5cS6x9sXL3u3Ai+F0PrcdaDCYhJnvI60e1iBc6aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGbsxNiQmuz9TomWDFXIFGuYB5Vr/onjhNVVex5g8Zbq00kUpqUYbr0ZadksEuaI7N0FtJXS7oYjDye3RJ/Jvkd/1brN5lz4zgS1/SxGPERFQKK7iQ757BMVehwl6Zlpj2Lj6yU6qG6EwWXCWXr5eRh3ltmbMH/sYzWwdqwnGMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UQE8Dqks; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UQE8Dqks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786486956;
	bh=GhL6nZS/a2VgkGuANr8akt9q2sphUX9TAzT319swFjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UQE8Dqks5SblWuDmkHBEJzl06tZSH5lJl++YBeDkph1rO1ooYl85wWv/GzaaJlr7d
	 AxbrOXJXgoH9FssOEi7mQXwpIXMXioLrO6MRNciVOJ8GD37nxdBKmATi5qr+l5pVup
	 Unm4PuvHUoeWxm1EGvAgdXcroUC75tUlj25WDSVvN77pKQI7mRlj8Sf9wlgr7jkcbs
	 EgeP0YrUFfROoojNvmyMyB0f4Wez9vurHimHCvtJppO4ewOQBrOFx1Ev5uMh1leJcD
	 XQMcQRBZl6AOF9pKv+1prtmnXMyarKHtaKUk0aLET6xl3gmenlkUNACv/63/w6Jrst
	 0n0kOLrGwj1ug==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 98C4B60078;
	Wed, 12 Aug 2026 00:22:36 +0200 (CEST)
Date: Wed, 12 Aug 2026 00:22:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/13] Netfilter/IPVS fixes for net
Message-ID: <anugqXmnyKSMPl_w@chamomile>
References: <20260810190621.894119-1-pablo@netfilter.org>
 <20260811124434.76ab55d9@kernel.org>
 <anuEqSHXJtF9bqTi@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anuEqSHXJtF9bqTi@strlen.de>

On Tue, Aug 11, 2026 at 10:23:33PM +0200, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 10 Aug 2026 21:06:08 +0200 Pablo Neira Ayuso wrote:
> > > The following patchset contains Netfilter/IPVS fixes for net. Still
> > > large batch for this late -rc cycle but at least have of these fixes in
> > > this batch have been cooking for several weeks before:
> > 
> > Does any of the AI-detected issues seem concerning?
> > 
> > https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810190621.894119-4-pablo@netfilter.org
> 
> Only commenting on those patches that I worked on or commented during
> review:
> 
> Patch 6: [PATCH net 06/13] netfilter: nf_conntrack: defer invalid log until after unlock
> 
> Its fine.  This is for debugging.  We could restore the removed info if
> anyone needs it, I even was about to suggest to original author to
> simply remove the invalid logging but decided against it (since you can
> log the packet to userspace via nfnetlink).  I prefer the simpler
> version that doesn't snapshot data while under lock.
> 
> Patch 7: [PATCH net 07/13] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
> 
> Yes, one could have added this Fixes tag or Cc stable to the patch.
> Don't think this warrants a respin by itself.
> 
> Patch 12: [PATCH net 12/13] netfilter: ipset: fix list type element drift bug
> 
> Even if the ordering is "wrong", the patch that
> added it is ancient (even in RHEL7) so its long established behaviour.
> 
> ipset test suite also has test for this and those tests pass, so
> changing kernel behaviour will need to adjust (old..) test cases as
> well.

Patch 10: [PATCH net 10/13] netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path

This is known issue and I've been working on a patch to address what
sashiko reports, basically, in case hardware offload is enabled,
errors should also rollback to the previous state.

There seem to be a path with hardware offload indirect flow block that
is buggy because ENOMEM is propagated as EOPNOTSUPP.

I need to follow up.

Patch 11: [PATCH net 11/13] netfilter: flowtable: publish GC-visible tuple last

Sashiko indicates that this needs a follow up because hardware offload
can still trigger a race with GC.

This also needs a follow up.
