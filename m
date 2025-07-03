Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A874A1E5711
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 11:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543139; cv=none; b=cWklWN97OPved4c9cT6MB6nfNZGqJEiafNSWy893P6Ji371/puj2NkxHAWlorMLFLLApyDXOKDPPVuJQPTBq69u5SXViG4lH4D0lz/RMQplwU1Bawch+o5nxkaU5VnEpkYVeAqdv1NTOs4XwKOexYG4h2yswPzbGkSCigIXA49Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543139; c=relaxed/simple;
	bh=BiOak/m1ZuP+G1YqrZvvKRQZrGNujNgSO4gCwEmA74s=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nc2UetbHTvesI81y4dnAKLs2TBhHBYcYjHDBtIeSEpYs+yTiXNcKIc/wmiazI9zADqnGm2NUO85Upo4miOO6YXju7yOIbRpuR6jQZQYFjsC6oL6T3d/plRqE/JmsgnhL/nDaMBy5OVXPt6VOsqQHTzHIG20qmge+XK2zGKU8vJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=l0iRqn/4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mzTyVAn0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="l0iRqn/4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mzTyVAn0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DA2446027A; Thu,  3 Jul 2025 13:35:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751542547;
	bh=ORYA2TDK7y8TKAWkx9fRM0LD7u2wpod9ZCQbFfK7MbM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=l0iRqn/4B48AK8BaTPvge8NwB2Y14f54xfk96sQPpBraKAnzMAAad44+gmXJOsg2l
	 qs7DH3R3t3//+XM8Eg50zXtPJfe+lRDs+rXMK9rIXwrt1jaz+49ALcbx9Cc4e5eDzm
	 As7943RCzZKhxhdUg2eTWTO0wbH6bRcWEbZa+jdwS18q1uf3CFnkNqcLe+rYvQYWAR
	 PuNU75jZ6AmpD5Dcfjbk6hdg1A0FaeTL/kw/S8guI/g6TccG3z+CIkhU5XUJBlJRVQ
	 MNA9d+g1UX52QJEmXs+2q4ys+U5snT7XztnBMVgyaZzCk7uM+ZX7CBWY97q4Pl/73O
	 618IxuPBV6m0g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7BD6B60275;
	Thu,  3 Jul 2025 13:35:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751542546;
	bh=ORYA2TDK7y8TKAWkx9fRM0LD7u2wpod9ZCQbFfK7MbM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=mzTyVAn0VTRS9h4lGx4oAhMlzg6Z8JReRLH+1jNa0mJDqcHwbwUR/IWdBK7zJV0wU
	 7EG0P26Xecq/qj+8s80EEj/i64h3KTuL3XIkzKadQY9DG9otc5R0+mgvXgQMhYJG4f
	 /bd4WvSmqID4pQdqOzz4xPPd+2nw5uYwMIMjLfpkgcvnt051io+3JJi3+EZoTV3ZI9
	 Ji9A/dAXZ7UXv13YVZFABlK5I9vi0AJkpzBNuF8Ri69CQSJDU4yGYg+8FhVKfWxALN
	 vFjqgBAkheTVQKdR1lmUcURmGa5cXiHlgf+LNRn2Cw0uMCDFDCPkkGZ4mYi5hjMBtx
	 rF4e1bAFFoFlw==
Date: Thu, 3 Jul 2025 13:35:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZrD0paQ6IUdnx2@calendula>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>

On Thu, Jul 03, 2025 at 12:21:17PM +0200, Phil Sutter wrote:
> Hi Florian,
> 
> On Thu, Jul 03, 2025 at 12:39:32AM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Require user space to set a flag upon flowtable or netdev-family chain
> > > creation explicitly relaxing the hook registration when it comes to
> > > non-existent interfaces. For the sake of simplicity, just restore error
> > > condition if a given hook does not find an interface to bind to, leave
> > > everyting else in place.
> > 
> > OK, but then this needs to go in via nf.git and:
> > 
> > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > 
> > tag.  We shouldn't introduce a "error" -> "no error" -> "error" semantic
> > change sequence in kernel releases, i.e. this change is urgent; its now
> > (before 6.16 release) or never.
> 
> Oh, right. So a decision whether this is feasible and if, how it should
> behave in detail, is urgent.

Downside is that this flag adds more complexity, since there will be
two paths to test (flag on/off).

> > > - A wildcard interface spec is accepted as long as at least a single
> > >   interface matches.
> > 
> > Is there a reason for this? Why are they handled differently?
> 
> I wasn't sure if it's "required" to prevent it as well or not. This
> patch was motivated by Pablo reporting users would not notice mis-typed
> interface names anymore and asking for whether introducing a feature
> flag for it was possible. So I went ahead to have something for a
> discussion.
>
> Actually, wildcards are not handled differently: If user specifies
> "eth123", kernel errors if no "eth123" exists and accepts otherwise. If
> user specifies "eth*", kernel errors if no interface with that prefix
> exists and accepts otherwise.
> 
> I don't know where to go with this. If the flag should turn interface
> specs name-based, its absence should fully restore the old behaviour (as
> you kindly summarized below). If it's just about the typo, this patch
> might be fine.

Another concern is having a lot of devices, this is now interating
linearly performing strcmp() to find matches from the control plane
(ie. maybe this slow down time to load ruleset?), IIRC you mentioned
this should not be an issue.

> > > - Dynamic unregistering and re-registering of vanishing/re-appearing
> > >   interfaces is still happening.
> > 
> > You mean, without the flag? AFAIU old behaviour is:
> > For netdev chains:
> > - auto-removal AND free of device basechain -> no reappearance
> > - -ENOENT error on chain add if device name doesn't exist
> > For flowtable:
> > - device is removed from the list (and list can become empty), flowtable
> >   stays 100%, just the device name disappears from the devices list.
> >   Doesn't reappear (auto re-added) either.
> > - -ENOENT error on flowtable add if even one device doesn't exist
> > 
> > Neither netdev nor flowtable support "foo*" wildcards.
> > 
> > nf.git:
> > - netdev basechain kept alive, no freeing, auto-reregister (becomes
> >   active again if device with same name reappears).
> >   No error if device name doesn't exists -> delayed auto-register
> >   instead, including multi-reg for "foo*" case.
> > - flowtable: same as old BUT device is auto-(re)added if same name
> >   (re)appears.
> > - No -ENOENT error on flowtable add, even if no single device existed
> > 
> > Full "foo*" support.
> > 
> > Now (this patch, without new flag):
> > - netdev basechain: same as above.
> >   But you do get an error if the device name did not exist.
> >   Unless it was for "foo*", thats accepted even if no match is found.
> 
> No, this patch has the kernel error also if it doesn't find a match for
> the wildcard. It merely asserts that the hook's ops_list is non-empty
> after nft_netdev_hook_alloc() (which did the search for matching
> interfaces) returns.
>
> >   AFAICS its a userspace/nft change, ie. the new flag is actually
> >   provided silently in the "foo*" case?
> > - flowtable: same as old BUT device is auto-(re)added if same name
> >   (re)appears.
> > - -ENOENT error on flowtable add if even one device doesn't exist
> >   Except "foo*" case, then its ok even if no match found.
> > 
> > Maybe add a table that explains the old/new/wanted (this patch) behaviours?
> > And an explanation/rationale for the new flag?
> > 
> > Is there a concern that users depend on old behaviour?
> > If so, why are we only concerned about the "add" behaviour but not the
> > auto-reregistering?
> > 
> > Is it to protect users from typos going unnoticed?
> > I could imagine "wlp0s20f1" getting misspelled occasionally...
> 
> Yes, that was the premise upon which I wrote the patch. I didn't intend
> to make the flag toggle between the old interface hooks and the new
> interface name hooks.

Mistyped name is another scenario this flag could help.

> > > Note that this flag is persistent, i.e. included in ruleset dumps. This
> > > effectively makes it "updatable": User space may create a "name-based"
> > > flowtable for a non-existent interface, then update the flowtable to
> > > drop the flag. What should happen then? Right now this is simply
> > > accepted, even though the flowtable still does not bind to an interface.
> > 
> > AFAIU:
> > If we accept off -> On, the flowtable should bind.
> > If we accept on -> off, then it looks we should continue to drop devices
> > from the list but just stop auto-readding?
> > 
> > If in doubt the flag should not be updateable (hard error), in
> > that case we can refine/relax later.
> 
> My statement above was probably a bit confusing: With non-persistent, I
> meant for the flag to be recognized upon chain/flowtable creation but
> not added to chain->flags or flowtable->data.flags.

If this flag is added, I won't allow for updates until such
possibility is carefully review, having all possible tricky scenarios
in mind.

I think it boils down to the extra complexity that this flag adds is
worth having or documenting the new behaviour is sufficient, assuming
the two issues that have been mentioned are not problematic.
