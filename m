Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860446EB79
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751544581; cv=none; b=lAY2FAEm6ug9U+HO0aZ1RlBHF/yMg9JKYqgFdFep70HkjYPtoj9MmjlvxsAvGRbJOAD/J99702uODtSMf0bxXn/E5MvvNAOMW0R/JCxtwbUV4Tkb4/Chi8KTAjicO1Y+ZAJ69Zy/YZmgyOlEge9wA+74DczCsFHYQ7LPhfxwgAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751544581; c=relaxed/simple;
	bh=y7iNNSor0VdlnrEv14pBAjbYZRVdfwS+MQRgBZ9cPAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHgfGM+wc5pGcb3GzxyIpNjRKFW9N0WB+P+gfLFoJbyH0FBZD99BKOM/vvVgOVoyZHSjIt3Bb98qBBewMouljLokpodifnSAr435RCFgTU/P14+JAJmqFZE5d1f4kmewR+5J9daahfmdvFh2oRK2j478QFBCDOjXG3cepbMcjxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 94545604A5; Thu,  3 Jul 2025 14:09:36 +0200 (CEST)
Date: Thu, 3 Jul 2025 14:09:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZzAAnDT6a1rdh-@strlen.de>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZrD0paQ6IUdnx2@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Oh, right. So a decision whether this is feasible and if, how it should
> > behave in detail, is urgent.
> 
> Downside is that this flag adds more complexity, since there will be
> two paths to test (flag on/off).

Right.

> Another concern is having a lot of devices, this is now interating
> linearly performing strcmp() to find matches from the control plane
> (ie. maybe this slow down time to load ruleset?), IIRC you mentioned
> this should not be an issue.

Can you suggest an alternative?

I see the following:

- revert to old behaviour (no search,
  lookup-by-name), and introduce a new netlink attribute for the 'wildcard
  name / full-search'.
  Since thats a big change this requires a revert in nf.git and then a
  followup change in nf-next to amend this.

- Only search if we have a wildcard.
  It should be enough to check, from nft_netdev_hook_alloc, if hook->ifname
  is null-terminated or not. If it is, lookup-by-name, else
  for_each_netdev search.

  Thats assuming that the netlink attributes are encoded as
  'eth\0' (4 bytes, no wildcard), vs 'eth' (3 bytes, wildcard).

> > Yes, that was the premise upon which I wrote the patch. I didn't intend
> > to make the flag toggle between the old interface hooks and the new
> > interface name hooks.
> 
> Mistyped name is another scenario this flag could help.

Regardless of this flag patch one could update nftables userspace to
display hints like we do for sets with the new '# count 42' comment
annotation.

Something that tells that the hook is subscribed for eth42 but currently
not active.

Same with flowtables, something that tells which devices are configured
(subscribed) and which devices are used (should likely still display
 ppp* and not list 4000k ppp1234 :-) ).

Phil, whats your take here?

From a quick glance there is currently no way for a user to tell if the
hook is active or not (except by adding a dummy counter rule).

> If this flag is added, I won't allow for updates until such
> possibility is carefully review, having all possible tricky scenarios
> in mind.

Makes sense to me.

> I think it boils down to the extra complexity that this flag adds is
> worth having or documenting the new behaviour is sufficient, assuming
> the two issues that have been mentioned are not problematic.

Yes.
