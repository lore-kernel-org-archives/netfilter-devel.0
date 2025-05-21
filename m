Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD31E47A8
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846014; cv=none; b=hW08CW2ceB2V9DcgvqAm7DffCAmblLYPbGTaZAq79SHlOhfkrAsZOwAhivL7Lyo+2LPLaOOs3eMwv2f5tCLG9Q5NYB7WSm51pMUxTLzRnrNsNvskR2VvYSvtgiccrM5pmel1UMc+Y7MDEjGlps04Q7UW+Fuf+r8Uokrgf28FFfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846014; c=relaxed/simple;
	bh=pLSGxk2Z+JLxIUqO8UI1I7qaoTcHn08qLSxi2+gdsUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgwWfiwoYY5hRkdfMUttNfs3ecepHztazy1qC7XB2Crwl0p/o3ldeYCAjEJifNwxsJ7Jo1sxrryz0IDIoDWtFBGa2gafPASOwE0w38VxuW+lbwqIQcCNq98r8AsWuIXCzCfnp7mvMi8TlpAd6cXvAw9WFMTe97xDrHnrHCcJCyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HyuM7NLQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HyuM7NLQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JSlN4eRiW2M9dMC2AV8vBH/FTyM2HO10kfv8I2vrqrc=; b=HyuM7NLQOlmahCYRSR+rQRxwIb
	ukHEGz0y+hjn4qrVxhv2PGJTJ1U8ZEgH6MdYuTansb/kxeSvDvv/pYw3O6L5Qf9wM//pHRnSP36WN
	x2sannqQ2b8l9ki6ajhuoTGyYQmzIhpO7dDPYVz/Dr6MLAfkXMyteehgEuFmkG+dradjNdnKPRtVG
	yyiLgQQ4zhqLFEhPvV16XCNms03EUkC6v5vnURMZny0KS5+ul4S2zQXHyQYuc/c7+ED6uIFWYGUWZ
	NuVE18+xN2KKE8f5BSsYbpCAzqyk8vjGxngyKGtfEeztN2/QaYdQT0PKbzQ/AmcpIlaEDH16mHS8p
	7SkFsBWA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHmaf-000000004Tv-0lVl;
	Wed, 21 May 2025 18:46:49 +0200
Date: Wed, 21 May 2025 18:46:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aC4DeRdqnSoBf17v@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aC0B8ZSp8qNzbPqR@calendula>
 <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>
 <aC32llhNc-j5j49-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC32llhNc-j5j49-@calendula>

On Wed, May 21, 2025 at 05:51:50PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, May 21, 2025 at 05:32:57PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, May 21, 2025 at 12:28:01AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > > 2) I wonder if nft_hook_find_ops()  will need a hashtable sooner or
> > >    later. With the wildcard, the number of devices could be significantly
> > >    large in this list lookup.
> > 
> > Maybe, yes. Is it useful to have a single flowtable for all virtual
> > functions (e.g.) on a hypervisor? Or would one rather have distinct
> > flowtables for each VM/container?
> [...]
> > Callers are:
> > 
> > - nft_{flowtable,netdev}_event(): Interface is added or removed
> > - nft_flow_offload_eval(): New flow being offloaded
> > - nft_offload_netdev_event(): Interface is removed
> > 
> > All these are "slow path" at least. I could try building a test case to
> > see how performance scales, but since we hit the function just once for
> > each new connection, I guess it's hard to get significant data out of
> > it.
> 
> This can be added later, not a deal breaker.

ACK.

> This is event path which might slow down adding new entries via
> rtnetlink maybe, but I would need to have a closer look.

We'd optimize for flowtables with many devices. The same system could
also have many flowtables with few devices each, then the hash table
adds to the overhead. A global table for all flowtables could serve
both. We could also have the same device in multiple chains, so each
hash table entry needs a list of ops pointers?

> [...]
> > > == netfilter: nf_tables: Add "notications" <-- typo: "notifications"
> > > 
> > > I suggest you add a new NFNLGRP_NFT_DEV group for these notifications,
> > > so NFNLGRP_NFTABLES is only used for control plane updates via
> > > nfnetlink API. In this case, these events are triggered by rtnetlink
> > > when a new device is registered and it matches the existing an
> > > existing device if I understood the rationale.
> > 
> > Yes, MSG_NEWDEV and MSG_DELDEV are triggered if a new device matches a
> > hook or if a hooked device is removed (or renamed, so the hook won't
> > match anymore).
> > 
> > Having a distinct NFNLGRP for them requires a new 'nft monitor' mode,
> > right? So we can't have a single monitor process for ruleset changes and
> > these device events. Should not be a problem, though.
> 
> Having a different group allows to filter out events you might not
> care about, it is a simple netlink event filtering facility.
> 
> I think this feature is for debugging purpose only, correct? So a
> separated group should be fine. IIUC, this event does not modify the
> ruleset, it only tells us a hook for a matching device is being
> registered.

Yes, you're right. Strictly speaking, these events are different from
NFNLGRP_NFTABLES as they don't indicate a ruleset change. Their actual
purpose is to satisfy the requirement of hook reg/unreg being visible to
user space. :)

nft monitor needs some work, though: Right now it's in trace or !trace
mode depending on whether NFT_MSG_TRACE is present in monitor_flags. Now
there will be a third modus operandi. OK, we could hide that internally
and enable the new group automatically if not tracing, then add a
'hooks' keyword so users may 'nft monitor (new|destroy) hooks'.

Cheers, Phil
