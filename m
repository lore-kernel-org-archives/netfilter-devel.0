Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7021D5142
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751545561; cv=none; b=djDRsd4iF3ZYu6OG1pk+WrERO3hH32Y/lZqm37TrJ7+ImDETn6K4VR+J0IkB4Aw0GPZ86z/Y1YSv6cf/2P7TZLKruRhS5Hpqv4T76HnC4u/NBQII68w+BZEopWCCXestMR8KBM7t6D10rpm1ybZ940pB7SU6c0KRfscoAX7eUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751545561; c=relaxed/simple;
	bh=3jD4LGwBNvDDVwdhei+JYOehUIBKSESWqsvTWBPHyPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sVwyfR9gfaplo4e1MDl+xI9p/S70ZZeo3ncBouJCstZUIb8QwpBegcY556pUKdni759u9htV+gHqrpKMyx0Ue74GxzZeLuDwQDLjSEPiFwYAvS+Aqcdna4mjyJ7ZBst1Lsa2zfezQ3v1Mdj8lCMCVufUKloCoK/dgtLsVsPSjlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LbVUBjf5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LbVUBjf5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r4O+2Pdzt6h1c8Mp0YzajCtHG9Ie0R+uLyNNhD7TlUg=; b=LbVUBjf5iw5KErsMkM6w6sOgQQ
	75kErT2oUfSYNYqhD8pGdhiBtpKzXW+EHj4wVeeFJxGv+PfjJ1sIMUUoksmH4hTwXMiV9vSLgM235
	nWxXWZ2ouJrqUpSHAo3gMv2Hk+nKLDYS9cd6T1AzwtrP6FO2COv7I3T/r2XCvukQADylt2ZTAzbxD
	lxcU3ye8P3vrq3sAkqTGDAvTBwlypUxSEJVx96WHhyfXRtNH4RupQzbrlyPVTGt3i8tZkAkmG9RH4
	orqPMD/TrQ6wkrpal8nvsoByyYGmaqzzrGX8C1f7mPS26+Qc6lNX3WBGMenYV57TH50SlSRQXEyKo
	wsZOJYDg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXJ0m-0000000085e-10XM;
	Thu, 03 Jul 2025 14:25:56 +0200
Date: Thu, 3 Jul 2025 14:25:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
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

Hi Pablo,

On Thu, Jul 03, 2025 at 01:35:43PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 03, 2025 at 12:21:17PM +0200, Phil Sutter wrote:
> > On Thu, Jul 03, 2025 at 12:39:32AM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > Require user space to set a flag upon flowtable or netdev-family chain
> > > > creation explicitly relaxing the hook registration when it comes to
> > > > non-existent interfaces. For the sake of simplicity, just restore error
> > > > condition if a given hook does not find an interface to bind to, leave
> > > > everyting else in place.
> > > 
> > > OK, but then this needs to go in via nf.git and:
> > > 
> > > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > > 
> > > tag.  We shouldn't introduce a "error" -> "no error" -> "error" semantic
> > > change sequence in kernel releases, i.e. this change is urgent; its now
> > > (before 6.16 release) or never.
> > 
> > Oh, right. So a decision whether this is feasible and if, how it should
> > behave in detail, is urgent.
> 
> Downside is that this flag adds more complexity, since there will be
> two paths to test (flag on/off).

Indeed, but depending on the flag's scope we may get by with just a
shell test case to cover the "accept with no matching interface"
behaviour.

> > > > - A wildcard interface spec is accepted as long as at least a single
> > > >   interface matches.
> > > 
> > > Is there a reason for this? Why are they handled differently?
> > 
> > I wasn't sure if it's "required" to prevent it as well or not. This
> > patch was motivated by Pablo reporting users would not notice mis-typed
> > interface names anymore and asking for whether introducing a feature
> > flag for it was possible. So I went ahead to have something for a
> > discussion.
> >
> > Actually, wildcards are not handled differently: If user specifies
> > "eth123", kernel errors if no "eth123" exists and accepts otherwise. If
> > user specifies "eth*", kernel errors if no interface with that prefix
> > exists and accepts otherwise.
> > 
> > I don't know where to go with this. If the flag should turn interface
> > specs name-based, its absence should fully restore the old behaviour (as
> > you kindly summarized below). If it's just about the typo, this patch
> > might be fine.
> 
> Another concern is having a lot of devices, this is now interating
> linearly performing strcmp() to find matches from the control plane
> (ie. maybe this slow down time to load ruleset?), IIRC you mentioned
> this should not be an issue.

I did not measure a significant slowdown even with a wildcard interface
spec matching 10k interfaces, neither for flowtable or chain creation or
chain deletion. The only impacted action is flowtable deletion, I
suspect nf_flowtable_by_dev_remove() to cause the slowdown.

I don't think we need a feature flag for this though, users may simply
not use wildcard interface specs to avoid it.

> > > > - Dynamic unregistering and re-registering of vanishing/re-appearing
> > > >   interfaces is still happening.
> > > 
> > > You mean, without the flag? AFAIU old behaviour is:
> > > For netdev chains:
> > > - auto-removal AND free of device basechain -> no reappearance
> > > - -ENOENT error on chain add if device name doesn't exist
> > > For flowtable:
> > > - device is removed from the list (and list can become empty), flowtable
> > >   stays 100%, just the device name disappears from the devices list.
> > >   Doesn't reappear (auto re-added) either.
> > > - -ENOENT error on flowtable add if even one device doesn't exist
> > > 
> > > Neither netdev nor flowtable support "foo*" wildcards.
> > > 
> > > nf.git:
> > > - netdev basechain kept alive, no freeing, auto-reregister (becomes
> > >   active again if device with same name reappears).
> > >   No error if device name doesn't exists -> delayed auto-register
> > >   instead, including multi-reg for "foo*" case.
> > > - flowtable: same as old BUT device is auto-(re)added if same name
> > >   (re)appears.
> > > - No -ENOENT error on flowtable add, even if no single device existed
> > > 
> > > Full "foo*" support.
> > > 
> > > Now (this patch, without new flag):
> > > - netdev basechain: same as above.
> > >   But you do get an error if the device name did not exist.
> > >   Unless it was for "foo*", thats accepted even if no match is found.
> > 
> > No, this patch has the kernel error also if it doesn't find a match for
> > the wildcard. It merely asserts that the hook's ops_list is non-empty
> > after nft_netdev_hook_alloc() (which did the search for matching
> > interfaces) returns.
> >
> > >   AFAICS its a userspace/nft change, ie. the new flag is actually
> > >   provided silently in the "foo*" case?
> > > - flowtable: same as old BUT device is auto-(re)added if same name
> > >   (re)appears.
> > > - -ENOENT error on flowtable add if even one device doesn't exist
> > >   Except "foo*" case, then its ok even if no match found.
> > > 
> > > Maybe add a table that explains the old/new/wanted (this patch) behaviours?
> > > And an explanation/rationale for the new flag?
> > > 
> > > Is there a concern that users depend on old behaviour?
> > > If so, why are we only concerned about the "add" behaviour but not the
> > > auto-reregistering?
> > > 
> > > Is it to protect users from typos going unnoticed?
> > > I could imagine "wlp0s20f1" getting misspelled occasionally...
> > 
> > Yes, that was the premise upon which I wrote the patch. I didn't intend
> > to make the flag toggle between the old interface hooks and the new
> > interface name hooks.
> 
> Mistyped name is another scenario this flag could help.

It's the only one I had in mind.

> > > > Note that this flag is persistent, i.e. included in ruleset dumps. This
> > > > effectively makes it "updatable": User space may create a "name-based"
> > > > flowtable for a non-existent interface, then update the flowtable to
> > > > drop the flag. What should happen then? Right now this is simply
> > > > accepted, even though the flowtable still does not bind to an interface.
> > > 
> > > AFAIU:
> > > If we accept off -> On, the flowtable should bind.
> > > If we accept on -> off, then it looks we should continue to drop devices
> > > from the list but just stop auto-readding?
> > > 
> > > If in doubt the flag should not be updateable (hard error), in
> > > that case we can refine/relax later.
> > 
> > My statement above was probably a bit confusing: With non-persistent, I
> > meant for the flag to be recognized upon chain/flowtable creation but
> > not added to chain->flags or flowtable->data.flags.
> 
> If this flag is added, I won't allow for updates until such
> possibility is carefully review, having all possible tricky scenarios
> in mind.
> 
> I think it boils down to the extra complexity that this flag adds is
> worth having or documenting the new behaviour is sufficient, assuming
> the two issues that have been mentioned are not problematic.

The two issues being typos and performance issues? If so, performance
should not be an issue (merely flowtable deletion slows down, but that
may be something we might optimize away). Typos are something I
personally wouldn't care about as I find it similar to mis-typing an IP
address or RHS to an iifname match. If transparency of behaviour is a
concern, I'd rather implement GETDEV message type and enable user space
to print the list of currently bound interfaces (though it's partially
redundant, 'nft list hooks' helps there although it does not show which
flowtable/chain "owns" the hook).

Cheers, Phil
